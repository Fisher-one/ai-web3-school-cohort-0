# 完整 Week 4 Ready Pack

> Week 3｜加分挑战（40 pts）
> Deadline：2026/6/7 23:59

---

## 项目：Chain Research Agent with Guarded Payments

**GitHub：** https://github.com/Fisher-one/chain-research-agent
**赛道：** Cobo Agentic Wallet Track
**链上记录：** tx `0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`（Sepolia）

---

## Pack 组成

本文档是所有 Week 3 交付物的汇总索引，每个模块独立完整，可单独查阅。

---

### 1. Hackathon Direction Card ✅

→ 见 [`week3-hackathon-direction-card.md`](./week3-hackathon-direction-card.md)

**要点：**
- 赛道：Cobo Agentic Wallet
- 问题：Agent 如何在可控边界内自主完成链上支付
- 目标用户：DeFi 研究者 + AI Agent 开发者

---

### 2. Proposal Memo ✅

→ 见 [`week3-proposal-memo.md`](./week3-proposal-memo.md)

**要点：**
- 目标用户 + 真实场景 + MVP 功能清单（已全部实现）
- 验证方式：链上 tx hash + Demo 视频
- 风险边界：已知漏洞（合法浪费攻击、Sybil attack）清单
- 评委问答关键论点

---

### 3. Repo Skeleton ✅

→ https://github.com/Fisher-one/chain-research-agent

**当前目录结构：**
```
chain-research-agent/
├── agent/
│   ├── main.py          # Orchestrator Agent 主逻辑
│   ├── registry.py      # Worker 服务发现（HTTP 探测）
│   ├── tools.py         # list_data_workers() + hire_worker()
│   └── requirements.txt
├── server/
│   ├── main.go          # Data Worker（x402 + 限速 + 数据交付）
│   └── server/          # 三个 Worker 的具体实现
├── start-workers.sh     # 一键启动三个 Worker
└── README.md
```

**最新 commit：** `deac00f` feat: real multi-worker discovery — no mock data

---

### 4. Sprint Plan ✅

→ 见 [`week3-sprint-plan.md`](./week3-sprint-plan.md)

**Week 4 日程：**

| 日期 | 主要任务 | 产出 |
|------|---------|------|
| 6/9（周一） | 边界 case 测试 + README 初稿 | 测试截图 + README 草稿 |
| 6/10（周二） | 架构图 + 已知漏洞文档 | 最终版架构图 PNG |
| 6/11（周三） | Demo 视频脚本 + 录制 | 视频草稿 |
| 6/12（周四） | README 终稿 + 视频剪辑 | 最终交付物 |
| 6/13（周五）上午 | 提交 | GitHub + 视频 + tx hash |

---

### 5. Risk Memo ✅

→ 见 [`week3-risk-memo.md`](./week3-risk-memo.md)

**核心风险清单：**
- 合法浪费攻击（中风险，有第一道防线）
- Sybil attack（中风险，MVP 接受）
- LLM 推理错误选 Worker（低风险）
- Demo 环境不稳定（低风险，有 fallback）

**Week 4 Fallback Plan：**
- CAW 不可用 → 用已有 tx hash 演示
- LLM 限速 → 换 Ollama
- 数据 API 限速 → 用 mock
- 视频质量差 → 用截图 + GIF

---

### 6. Sponsor / Mentor 问题清单 ✅

→ 见 [`week3-sponsor-questions.md`](./week3-sponsor-questions.md)

**三个核心问题：**
1. CAW Pact 是否支持动态白名单（解决「发现 Worker → 授权付款」的问题）
2. x402 tx hash 重放攻击防护（Worker 如何标记「已消费」的 tx）
3. 项目 pitch 的最大弱点（从评委视角看）

---

### 7. 额外完成的 Week 3 交付物

以下是 Pack 要求之外额外完成的：

| 文档 | 说明 |
|------|------|
| [`week3-cobo-alignment.md`](./week3-cobo-alignment.md) | Cobo 赛道对齐任务（30pts） |
| [`week3-tech-validation-plan.md`](./week3-tech-validation-plan.md) | 技术验证计划（30pts） |
| [`week3-flow-diagram.md`](./week3-flow-diagram.md) | 项目流程图（30pts） |
| [`week3-deep-research.md`](./week3-deep-research.md) | 深度研究包（30pts）—— CAW Pact + x402 + ERC-4337 |
| [`week3-sdk-integration-plan.md`](./week3-sdk-integration-plan.md) | SDK 接入计划（30pts） |
| [`week3-workshop-notes.md`](./week3-workshop-notes.md) | Workshop 笔记（20pts） |
| [`week3-scope-review.md`](./week3-scope-review.md) | Scope Review（20pts） |
| [`week3-week12-gap.md`](./week3-week12-gap.md) | Week 1-2 缺口诊断（10pts） |

---

## 当前项目架构（一句话概括）

**方向 01（发现 + 比价）+ 方向 03（采购 + 交付）同时满足，有完整链上记录：**

```
发现  ✅  list_data_workers() → GET /catalog（真实 HTTP 探测，无 mock）
比价  ✅  LLM 自己推理选哪个 Worker（过程透明可见）
采购  ✅  hire_worker() → CAW Pact + Sepolia 链上支付
交付  ✅  x402 验证 + 真实 DefiLlama / CoinGecko 数据返回
审计  ✅  tx hash + 报告页脚 + 链上可查
```

---

*完成日期：2026-06-06*
