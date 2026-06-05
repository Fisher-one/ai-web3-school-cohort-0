# Hackathon Direction Card

> Week 3 任务｜最低完成路径（20 pts）
> Deadline：2026/6/7 23:59

---

## 参赛赛道

**Cobo Agentic Wallet Track**
主方向：Wallet / Permission / Safe Execution

---

## 项目名

**Chain Research Agent with Guarded Payments**

*链上数据调研 Agent，具备权限边界控制和可审计自主支付能力*

---

## 目标用户

| 用户类型 | 真实需求 |
|---------|---------|
| DeFi 用户 / 投资者 | 定期获取链上数据（DEX 交易量、流动性、协议收益），不想手动查多个数据源 |
| Go 后端开发者转型 Web3 | 用熟悉的工程思路（Policy 引擎、审计日志）切入 AI × Web3，需要一个可参考的最小样例 |

---

## 要解决的问题

**Agent 如何在「明确授权、预算控制、可审计记录」下完成自主链上支付，而不是简单地「自动付款」。**

当前的痛点：
- EOA 账户：每笔交易都要手动签名，Agent 无法自主执行任何支付
- 没有权限边界的 Agent：一旦被 prompt injection 攻击，可以执行任意链上操作
- x402 支付没有配套的预算控制和审计：付了钱但没有可验证的记录

---

## 最小功能（MVP）

| 功能 | 说明 |
|------|------|
| 自然语言接收任务 | 用户描述需求，Agent 理解并拆解 |
| 链上公开数据查询 | 直接读取合约事件，免费 |
| x402 付费 API 自主支付 | 识别 402 响应，在 CAW Pact 范围内完成支付，无需用户手动签名 |
| CAW Pact 权限控制 | 金额上限 + 白名单地址 + 时间窗口，超出自动拒绝 |
| 数据签名验证 | 验证 API 返回数据来源真实性 |
| 可审计执行日志 | tx hash + 数据 hash + 时间戳，可事后验证 |

**不在 MVP 范围内**：Escrow 合约、报告质量自动评估、多 Agent 协作

---

## 技术路径

```
用户（自然语言）
    ↓
Agent（Go / Python）
    ├─ 链上数据：直接 RPC 读取
    └─ 付费数据：x402 协议
                    ↓
             CAW Pact 检查
             （金额 / 地址 / 时间窗口）
                    ↓
             Sepolia 测试网链上结算
                    ↓
             审计日志归档
```

**技术栈**：
- Agent 层：Python（现有 note-qa-agent 基础）或 Go（后端优势）
- x402 服务端：Go HTTP 中间件
- 钱包层：Cobo CAW SDK + ERC-4337 智能账户
- 测试网：Sepolia
- 身份：ERC-8004 Agent 声明

---

## 主要风险

| 风险 | 缓解方式 |
|------|---------|
| Prompt Injection → 链上操作 | CAW Policy 确定性拦截，不依赖 AI 判断 |
| 付费 API 收款不交付 | 当前无 Escrow，MVP 阶段接受此风险，记录为已知局限 |
| CAW SDK 接入复杂度超预期 | 先用 mock Pact 跑通流程，再替换真实 SDK |
| 测试网资金不足 | 提前申请 Sepolia 测试币 |

---

## Week 3 执行计划

| 阶段 | 目标 | 预计完成 |
|------|------|---------|
| Day 1-2 | 搭建 x402 服务端（Go mock），本地跑通 402 → 支付 → 返回数据流程 | 6/3-6/4 |
| Day 3-4 | 接入 Cobo CAW SDK，配置测试 Pact，测试网完成真实支付 | 6/5-6/6 |
| Day 5 | 整理 demo，补充审计日志，准备提交材料 | 6/7 |

---

## 相关产出（Week 2 已完成）

- [问题地图与主方向选择](./week2-problem-map.md)
- [Agent 链上动作权限策略](./week2-agent-permission-policy.md)
- [最小支付与商业流程拆解](./week2-payment-commerce-flow.md)
- [x402 + CAW 自主支付闭环架构设计](./week2-x402-caw-architecture.md)
- [Week 2 总交付 Proposal](./week2-proposal.md)

---

*完成日期：2026-06-03*
