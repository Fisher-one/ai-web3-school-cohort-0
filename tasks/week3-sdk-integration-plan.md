# Sponsor SDK / API Integration Plan

> Week 3｜Sponsor Workshop（30 pts）
> Deadline：2026/6/7 23:59

---

## 接入的 Sponsor SDK / API

**Cobo Agentic Wallet（CAW）**

---

## 接什么

| 组件 | 用途 |
|------|------|
| `caw` CLI | 创建和管理 Agent Wallet、配置 Pact |
| CAW SDK（Python） | Agent 代码内调用：签名、广播交易、查询 Pact 状态 |
| Cobo Portal | Pact 配置 UI，设置白名单 + 金额上限 |

---

## 怎么接（实际集成步骤）

### Step 1：安装 caw CLI + 初始化

```bash
pip install cobo-caw
caw init --network sepolia
# 输出：Agent Wallet 地址 0x74aae83c8bf22c72a9246b33fc793f20af79e64b
```

### Step 2：配置 Pact（通过 Cobo Portal）

```
白名单地址：
  - Worker 8081: 0x...(DefiLlama TVL Worker)
  - Worker 8082: 0x...(DefiLlama Yields Worker)
  - Worker 8083: 0x...(CoinGecko Worker)

单次最大金额：0.005 SETH
总交易次数：100
有效期：30 天
```

### Step 3：Agent 代码内调用 CAW

```python
# agent/tools.py
from caw import CAWClient

caw = CAWClient(wallet_address=os.getenv("AGENT_WALLET_ADDRESS"))

def hire_worker(worker_address: str, amount_eth: float, tx_purpose: str) -> str:
    """在 CAW Pact 范围内向 Worker 支付"""
    try:
        tx_hash = caw.transfer(
            to=worker_address,
            amount_wei=int(amount_eth * 1e18),
            note=tx_purpose
        )
        return tx_hash
    except CAWPactViolation as e:
        # Pact 越权：白名单或金额限制
        return f"REJECTED: {e}"
```

### Step 4：x402 支付验证闭环

```python
# 完整支付触发流程
response = requests.get(worker_url)
if response.status_code == 429:
    payment_info = response.json()
    tx_hash = hire_worker(
        worker_address=payment_info["payment_address"],
        amount_eth=payment_info["amount"],
        tx_purpose=f"Data purchase from {worker_url}"
    )
    # 重发带支付证明的请求
    response = requests.get(
        worker_url,
        headers={"X-Payment-Proof": tx_hash}
    )
```

---

## Week 4 能否做完

**已完成（Week 3）：**
- ✅ CAW CLI 安装和 Agent Wallet 初始化
- ✅ Pact 配置（测试版）
- ✅ `hire_worker()` 函数实现（`agent/tools.py`）
- ✅ 429 触发 → CAW 支付 → 重发 完整链路
- ✅ 链上 tx 验证：`0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`

**Week 4 补充：**
- [ ] 完善 CAW Pact 越权测试（验证白名单限制有效）
- [ ] 在 README 中写清 CAW 接入的完整步骤
- [ ] Demo 视频中展示 Pact 约束生效的过程

---

## Fallback（如果 CAW 不通）

当前已有真实链上 tx 记录，即使 demo 时 CAW API 不稳定，可以：
1. 展示已有的 tx hash 和链上记录
2. 展示代码中的 CAW 集成逻辑
3. 重点讲 Pact 约束的设计意图，而不是实时演示

**接不通的概率：** 低（Week 3 已经验证链路完整）

---

## 接入 CAW 的核心工程决策

### 为什么选 CAW 而不是直接用私钥

| 方案 | 问题 |
|------|------|
| EOA 私钥存环境变量 | 私钥一旦泄露，Agent 可以转走所有资金 |
| approve + transferFrom | 权限边界在代码里，可被 prompt injection 绕过 |
| **CAW Pact** | 权限约束在合约层，代码层的绕过无法突破 Pact |

### x402 vs 直接调用 Stripe

| 方案 | 问题 |
|------|------|
| Stripe | 需要账户、KYC、法币结算，Agent 无法「自主」持有账户 |
| **x402 / 429** | 无需账户，只需钱包地址，Agent 天然可以「持有」 |

---

*完成日期：2026-06-06*
