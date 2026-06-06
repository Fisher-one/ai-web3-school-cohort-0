# Cobo 赛道对齐任务

> Week 3｜Sponsor Workshop（30 pts）
> Deadline：2026/6/7 23:59

---

## 赛道选择

**Cobo｜Agentic Economy × Cobo Agentic Wallet**

项目：**Chain Research Agent with Guarded Payments**
仓库：https://github.com/Fisher-one/chain-research-agent

---

## 项目如何对齐 Cobo 赛道

### 核心命题

> AI Agent 如何在**可控边界内**持有钱包、管理预算、执行支付 / 交易 / 资源采购，并如何记录风险边界。

本项目是这个命题的最小完整实现。

---

## 一、Agent 如何持有钱包

**实现方式：**
- Orchestrator Agent 通过 CAW（Cobo Agentic Wallet）持有独立的 Sepolia 测试网钱包
- Agent Wallet 地址：`0x74aae83c8bf22c72a9246b33fc793f20af79e64b`
- 钱包不由用户直接控制，也不需要用户参与每一笔签名

**为什么这是关键设计点：**

传统 EOA 方案要求用户为每笔交易手动签名，Agent 无法真正「自主执行」。CAW 允许用户一次性配置授权边界（Pact），之后 Agent 在边界内自主操作，边界外自动拒绝。

这使得 Agent 变成了「有钱包的自主经济参与者」，而不是「代用户操作的工具」。

---

## 二、Agent 如何管理预算

**CAW Pact 约束：**
- 每次支付金额上限
- 白名单收款地址（只付给已注册的 Data Worker）
- 最大交易次数限制

**运行时决策：**
- Agent 发现多个 Data Worker 并看到各自定价：
  - Worker 8081（DefiLlama Protocols）：0.001 SETH
  - Worker 8082（DefiLlama Yields）：0.0015 SETH
  - Worker 8083（CoinGecko 价格）：0.002 SETH
- LLM 根据用户需求推理选择性价比最优的 Worker
- 选定后，CAW 在 Pact 范围内自主完成支付，不需要用户确认

**预算控制的实质：**

Agent 的消费决策（买哪个 Worker）由 LLM 做，但「能不能买」「最多花多少」由 Pact 决定。两层分离：AI 管选择，合约层管边界。

---

## 三、Agent 如何执行支付 / 资源采购

**完整支付链路：**

```
1. 用户输入自然语言任务（如「分析 Ethereum DeFi 生态」）
2. Orchestrator 调用 list_data_workers() → GET /catalog（真实 HTTP 探测）
3. 发现 3 个 Worker，LLM 推理选择最优组合
4. 向选定 Worker 发起数据请求
5. Worker 返回 429（超出免费额度），携带收款地址 + 金额
6. CAW 在 Pact 授权范围内自主签名，广播到 Sepolia
7. 带 X-Payment-Proof: tx_hash 重发请求
8. Worker 验证 tx hash → 返回真实 API 数据
9. Agent 生成结构化分析报告，附支付摘要（tx hash + 金额 + Worker 地址）
```

**链上记录：**
- CAW spike tx：`0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`
- 所有支付记录附在报告页脚，可在 Etherscan Sepolia 验证

---

## 四、如何记录风险边界

**已知风险 + 当前处理：**

| 风险 | 当前状态 | 记录位置 |
|------|---------|---------|
| **合法浪费攻击** | 攻击者让 Agent 反复触发支付买无用数据，每次都在 Pact 范围内 | 已知漏洞，rate limit + tx_count 是第一道防线 |
| **Sybil attack** | 攻击者注册大量 Worker，刷低价吸引 Agent 付款但返回垃圾数据 | 已知漏洞，需 reputation 层，MVP 阶段接受 |
| **Pact 越权** | Agent 尝试付给未在白名单的地址 | CAW 自动拒绝，不依赖 AI 判断 |
| **x402 数据伪造** | Worker 收款后返回假数据 | MVP 阶段：依赖来源可信度；长期方案：数据签名 |

**为什么 CAW Pact 比 EOA 更安全：**

EOA 方案的权限边界在 Agent 代码里——一旦 prompt injection 绕过代码逻辑，Agent 可以付给任意地址任意金额。CAW Pact 的约束在合约层，代码层的绕过无法影响链上执行。这是信任边界位置的本质差异。

---

## 五、A2A 经济模型

本项目实现了最小完整的 Agent-to-Agent 经济闭环：

```
发现  ✅  list_data_workers() → GET /catalog（真实 HTTP 探测，无静态字典）
比价  ✅  LLM 自己推理选哪个 Worker（过程透明可见）
采购  ✅  hire_worker() → CAW Pact + 链上支付
交付  ✅  x402 验证 + 真实 API 数据返回
审计  ✅  tx hash + 报告页脚 + 链上可查
```

每个 Worker 都持有独立收款钱包，验证付款后交付数据——这不是「Agent 调用 API」，而是「两个 Agent 之间的经济协商和结算」。

---

## 相关代码文件

- [`agent/main.py`](https://github.com/Fisher-one/chain-research-agent/blob/main/agent/main.py) — Orchestrator Agent 主逻辑
- [`agent/registry.py`](https://github.com/Fisher-one/chain-research-agent/blob/main/agent/registry.py) — Worker 服务发现（HTTP 探测）
- [`agent/tools.py`](https://github.com/Fisher-one/chain-research-agent/blob/main/agent/tools.py) — `list_data_workers()` + `hire_worker()`
- [`server/main.go`](https://github.com/Fisher-one/chain-research-agent/blob/main/server/main.go) — Data Worker（x402 + 限速 + 数据交付）
- [`start-workers.sh`](https://github.com/Fisher-one/chain-research-agent/blob/main/start-workers.sh) — 一键启动三个 Worker

---

*完成日期：2026-06-06*
