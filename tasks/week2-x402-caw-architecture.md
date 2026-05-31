# x402 Paywall + CAW Agent 自主支付闭环：架构设计

> Week 2 进阶实践任务（40 pts）
> 本文提交架构图、伪代码、交互流程和关键接口说明。真实 demo 为 Week 3 延伸目标。

---

## 一、系统概述

### 场景

用户委托 Agent 查询 Dune Analytics 上的链上数据。Dune 的 API 受 x402 保护（按次收费 5 USDC）。Agent 通过 Cobo CAW 在预设 Pact 范围内自主完成支付，获取数据后生成报告返回给用户。

### 三个核心组件

```
┌─────────────────────────────────────────────────────────┐
│                      用户                                │
│  下达任务 + 设定预算（通过 CAW 配置 Pact）               │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│               Chain Research Agent（消费方）             │
│  - 接收用户任务                                          │
│  - 调用 Dune API → 收到 402 → 触发支付流程              │
│  - 通过 CAW SDK 完成支付                                 │
│  - 验证数据 → 生成报告 → 返回用户                        │
└────────────┬───────────────────────────┬────────────────┘
             │                           │
             ▼                           ▼
┌────────────────────────┐  ┌───────────────────────────┐
│  Dune Analytics API    │  │     Cobo CAW              │
│  （服务提供方）         │  │  （支付 + 权限控制层）     │
│  - 受 x402 保护        │  │  - Pact 定义预算边界       │
│  - 返回付款要求         │  │  - Policy 检查            │
│  - 验证付款证明         │  │  - 链上结算               │
│  - 返回数据 + 签名      │  │  - 审计日志               │
└────────────────────────┘  └───────────────────────────┘
```

---

## 二、完整交互流程

```
用户
 │ 1. 配置 CAW Pact（一次性人工确认）
 │    - 预算：本次任务 ≤ 10 USDC
 │    - 可调用合约：Dune 收款地址白名单
 │    - 时间窗口：24 小时内有效
 │    - 频率：最多 3 次支付
 │
 │ 2. 下达任务："查 Uniswap/Curve 过去 7 天交易量对比"
 ↓
Agent
 │ 3. 尝试调用 Dune API
 │    GET https://api.dune.com/api/v1/query/xxx/results
 │
 ↓
Dune API
 │ 4. 返回 402 Payment Required
 │    HTTP 402
 │    {
 │      "x402Version": 1,
 │      "accepts": [{
 │        "scheme": "exact",
 │        "network": "base",
 │        "maxAmountRequired": "5000000",  // 5 USDC (6 decimals)
 │        "asset": "0xUSDC...",
 │        "payTo": "0xDune...",
 │        "description": "Dune Analytics query - 7d DEX volume"
 │      }]
 │    }
 ↓
Agent
 │ 5. 解析付款要求，调用 CAW SDK 请求支付
 │    caw.requestPayment({
 │      amount: "5 USDC",
 │      recipient: "0xDune...",
 │      reason: "Dune API query fee",
 │      pactId: "task-20260531-001"
 │    })
 ↓
CAW（Pact 检查）
 │ 6. 验证本次支付是否符合 Pact 定义
 │    ✓ 金额 5U ≤ 预算上限 10U
 │    ✓ 收款地址在白名单
 │    ✓ Pact 时间窗口有效
 │    ✓ 今日支付次数 1/3
 │    → 自动批准，发起链上转账
 │
 │ 7. 链上结算（Base 网络）
 │    USDC.transfer(0xDune..., 5_000_000)
 │    → tx hash: 0xabc...
 │    → 写入 CAW 审计日志
 ↓
Agent
 │ 8. 带付款证明重新请求 Dune API
 │    GET https://api.dune.com/api/v1/query/xxx/results
 │    Header: X-PAYMENT: <payment-payload>
 │            X-PAYMENT-RESPONSE: <signed-receipt>
 ↓
Dune API
 │ 9. 验证付款证明 → 返回数据 + 数字签名
 │    {
 │      "data": [...],
 │      "signature": "0xDuneSignature...",
 │      "dataHash": "0xhash..."
 │    }
 ↓
Agent
 │ 10. 验证数据签名
 │     verify(data, signature, DunePublicKey) → ✓
 │
 │ 11. 生成分析报告
 │
 │ 12. 返回报告给用户
 │     + 附上执行摘要：tx hash / 花费 / 数据来源证明
 ↓
用户
     13. 人工验收报告质量
```

---

## 三、关键接口说明

### 3.1 x402 服务端（Dune 侧）

```go
// x402 响应格式（服务端实现）
type PaymentRequired struct {
    X402Version int              `json:"x402Version"`
    Accepts     []PaymentOption  `json:"accepts"`
    Error       string           `json:"error,omitempty"`
}

type PaymentOption struct {
    Scheme            string `json:"scheme"`           // "exact"
    Network           string `json:"network"`          // "base"
    MaxAmountRequired string `json:"maxAmountRequired"` // USDC amount (6 decimals)
    Asset             string `json:"asset"`            // USDC contract address
    PayTo             string `json:"payTo"`            // Dune 收款地址
    Description       string `json:"description"`
}

// 服务端中间件：拦截未付款请求
func X402Middleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        paymentHeader := r.Header.Get("X-PAYMENT")
        if paymentHeader == "" {
            // 未携带付款证明 → 返回 402
            w.WriteHeader(402)
            json.NewEncoder(w).Encode(PaymentRequired{
                X402Version: 1,
                Accepts: []PaymentOption{{
                    Scheme:            "exact",
                    Network:           "base",
                    MaxAmountRequired: "5000000",
                    Asset:             USDC_ADDRESS,
                    PayTo:             DUNE_PAYMENT_ADDRESS,
                    Description:       "Dune Analytics API query fee",
                }},
            })
            return
        }
        // 验证付款证明
        if !verifyPayment(paymentHeader) {
            http.Error(w, "Invalid payment", 402)
            return
        }
        next.ServeHTTP(w, r)
    })
}
```

### 3.2 CAW Pact 配置（用户侧，一次性人工确认）

```json
{
  "pactId": "task-20260531-001",
  "description": "Dune Analytics 数据查询授权",
  "owner": "0xFisher...",
  "budget": {
    "maxAmount": "10000000",
    "asset": "USDC",
    "network": "base"
  },
  "allowedRecipients": [
    "0xDune..."
  ],
  "maxTransactions": 3,
  "timeWindow": {
    "start": "2026-05-31T00:00:00Z",
    "end": "2026-06-01T00:00:00Z"
  },
  "forbiddenActions": [
    "contract_deployment",
    "approve_unlimited",
    "governance_vote"
  ]
}
```

### 3.3 Agent 支付调用（消费方伪代码）

```python
import httpx
from caw_sdk import CAWClient

caw = CAWClient(pact_id="task-20260531-001")

def fetch_dune_data(query_id: str) -> dict:
    # 第一次请求
    response = httpx.get(f"https://api.dune.com/api/v1/query/{query_id}/results")

    if response.status_code == 402:
        payment_required = response.json()

        # 解析付款要求
        option = payment_required["accepts"][0]

        # 请求 CAW 在 Pact 范围内完成支付
        payment_result = caw.pay(
            amount=option["maxAmountRequired"],
            asset=option["asset"],
            recipient=option["payTo"],
            network=option["network"],
            reason=option["description"]
        )

        if not payment_result.success:
            raise Exception(f"支付失败：{payment_result.error}")

        # 带付款证明重新请求
        response = httpx.get(
            f"https://api.dune.com/api/v1/query/{query_id}/results",
            headers={
                "X-PAYMENT": payment_result.payment_payload,
                "X-PAYMENT-RESPONSE": payment_result.signed_receipt
            }
        )

    data = response.json()

    # 验证数据签名
    if not verify_signature(data["data"], data["signature"], DUNE_PUBLIC_KEY):
        raise Exception("数据签名验证失败，拒绝使用")

    return data
```

### 3.4 CAW 审计日志格式

```json
{
  "auditId": "audit-20260531-001",
  "pactId": "task-20260531-001",
  "timestamp": "2026-05-31T10:23:45Z",
  "action": "payment_executed",
  "details": {
    "amount": "5000000",
    "asset": "USDC",
    "network": "base",
    "recipient": "0xDune...",
    "txHash": "0xabc...",
    "reason": "Dune Analytics API query fee",
    "policyChecks": {
      "amountWithinBudget": true,
      "recipientWhitelisted": true,
      "withinTimeWindow": true,
      "transactionCountOk": true
    }
  },
  "result": "success"
}
```

---

## 四、CAW Pact vs 直接 Session Key 的区别

| 维度 | Session Key（通用） | CAW Pact（本设计） |
|------|-------------------|--------------------|
| 授权粒度 | 账户级别，长期有效 | 任务级别，任务结束即失效 |
| 预算绑定 | 全局日限额 | 单次任务上限，更精确 |
| 时间窗口 | 固定过期时间 | 任务开始到结束 |
| 审计记录 | 链上 tx 记录 | 结构化审计日志 + 链上记录 |
| 适合场景 | 日常小额高频 | 特定任务，需要完整追溯 |

**核心差异**：Session Key 是「给 Agent 一个长期通行证」，Pact 是「给 Agent 一张单次任务入场券」。Pact 到期自动失效，不需要用户主动撤销。

---

## 五、风险边界

### 当前设计解决了什么

- ✅ 预算控制：Pact 定义单次任务上限，超出自动拒绝
- ✅ 地址白名单：只能向预核实的 Dune 地址转账
- ✅ 时间窗口：24 小时后 Pact 自动失效
- ✅ 可审计记录：每笔支付有结构化日志 + 链上 tx hash
- ✅ 数据真实性：签名验证确认数据来自 Dune

### 当前设计没有解决的

- ❌ Dune 收款后不返回数据：无自动退款，需链下处理
- ❌ 数据质量：签名只证明来源，不证明内容准确
- ❌ Dune 公钥来源：公钥本身需要独立可信渠道获取
- ❌ 网络中断导致支付成功但响应丢失：需要重试和幂等设计

### 下一步（Week 3 延伸目标）

- 用 Go 实现 x402 服务端中间件（复用 Go 后端经验）
- 接入 Cobo CAW SDK，在测试网跑通支付闭环
- 加入 Escrow 合约处理「付款后服务不交付」的场景

---

## 六、一句话总结

> x402 解决「怎么触发付款」，CAW Pact 解决「谁能在什么范围内付」，两者组合才构成完整的 agent 自主支付闭环——不是自动付款，而是在授权边界内的自动执行。

---

*完成日期：2026-05-31*
