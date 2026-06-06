# Proposal Memo

> Week 3｜推荐完成（20 pts）
> Deadline：2026/6/7 23:59

---

## 项目名

**Chain Research Agent with Guarded Payments**

链上数据调研 Agent，具备权限边界控制和可审计自主支付能力

**GitHub：** https://github.com/Fisher-one/chain-research-agent
**赛道：** Cobo Agentic Wallet Track

---

## 目标用户

| 用户 | 痛点 | 本项目如何解决 |
|------|------|--------------|
| DeFi 投资者 / 研究员 | 需要跨多个数据源（TVL、APY、价格）做综合研究，手动查询效率低 | Agent 自主发现数据服务、比价、付款、汇总，一句话拿到完整报告 |
| AI Agent 开发者 | 想让 Agent 能自主采购数据服务，但不知道如何做安全的链上支付 | 提供「发现 → 比价 → 采购 → 交付」的完整参考实现 |

---

## 真实场景

用户说：「帮我分析 Ethereum DeFi 生态：TVL 趋势、主要协议收益率、以太坊和 USDC 现价。」

Agent 做：
1. 发现三个 Data Worker（各自提供不同数据）
2. LLM 推理决定全部采购（因为需求覆盖三个数据维度）
3. 在用户预设的 CAW Pact 范围内，自主完成三笔链上支付（合计 0.0045 SETH）
4. 验证付款、取回真实数据、生成 Markdown 报告
5. 报告页脚附链上 tx hash，用户可在 Etherscan 验证每一笔支出

全程用户只配置了一次 Pact，之后无需参与。

---

## 最小功能（MVP — 已实现）

| 功能 | 实现状态 |
|------|---------|
| 自然语言接收任务 | ✅ |
| HTTP 探测服务发现（无 mock） | ✅ |
| LLM 推理比价选 Worker | ✅ |
| 429 触发 CAW 链上支付 | ✅ |
| x402 验证 + 数据交付 | ✅ |
| 结构化报告 + 支付摘要页脚 | ✅ |
| Sepolia 链上 tx 记录 | ✅ |

---

## 验证方式

**当前已有：**
- CAW spike tx：`0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`（Sepolia）
- Agent Wallet：`0x74aae83c8bf22c72a9246b33fc793f20af79e64b`

**Week 4 补充：**
- Demo 视频（3-5 分钟）：展示完整链路 + 链上 tx 验证
- README 完整版（含架构图、运行方式）

**成功标准：** 用户输入自然语言 → Agent 自主完成支付 → 链上可查 → 收到数据报告

---

## 风险边界

| 风险 | 当前处理 | 备注 |
|------|---------|------|
| Prompt Injection → 越权支付 | CAW Pact 合约层拦截，不依赖 AI 判断 | 核心安全保证 |
| 合法浪费攻击 | rate limit + tx_count 一阶防线 | 已知漏洞，已记录 |
| Sybil attack（假 Worker） | 暂无 reputation 层 | MVP 已知局限 |
| x402 服务方不交付 | 无 Escrow，接受此风险 | 记录在 README |
| LLM 选 Worker 出错 | 人工可复查推理过程 | 过程透明 |

---

## 可能的扩展赛道

本项目核心模型（Agent + CAW Pact + A2A 支付）独立于具体数据场景，可以扩展到：
- DeFi 套利 Agent（发现 → 采购价格数据 → 执行套利）
- 去中心化数据市场（任何人部署 Worker 提供数据服务）
- Agent 算力采购（按次购买计算资源）

---

## 关键论点（评委问答准备）

**「Go server 不是 Agent，只是 API」？**
→ 它持有独立钱包、自主验证付款、没有中间人、可以拒绝未付款的请求。和调用 Stripe API 的本质区别是：它是经济参与者，不是被调用的工具。

**「为什么不用 approve + transferFrom」？**
→ 信任边界位置不同。EOA 或 approve 方案的约束在 Agent 代码里，可以被 prompt injection 绕过。CAW Pact 的约束在合约层，绕过代码也无法突破。

---

*完成日期：2026-06-06*
