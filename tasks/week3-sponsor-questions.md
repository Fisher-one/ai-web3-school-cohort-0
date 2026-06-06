# Sponsor / Mentor 问题清单

> Week 3｜推荐完成（20 pts）
> Deadline：2026/6/7 23:59

---

## 项目背景

**Chain Research Agent with Guarded Payments**
赛道：Cobo Agentic Wallet Track
核心问题：Agent 如何在可控边界内自主完成链上支付和资源采购

已完成：三 Worker 服务发现 + CAW 支付 + x402 数据交付
链上记录：tx `0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`（Sepolia）

---

## 问题 1：面向 Cobo 团队

**问题：** CAW Pact 目前支持哪种粒度的「白名单」约束？

**背景：**
我的项目里，Orchestrator Agent 通过服务发现动态找到 Data Worker，每个 Worker 的收款地址在运行时才知道。如果 Pact 要求提前写死白名单地址，就无法支持动态发现的 Worker。

我想知道：
1. 是否支持「地址范围」或「动态白名单」（如允许付给一组由链上注册表认证的地址）？
2. 如果 Pact 只支持静态白名单，有没有推荐的工程 workaround？
3. 未来版本的 Pact 是否计划支持更动态的权限策略？

**希望回答什么：** 帮助我设计一个「真正支持动态 Worker 发现 + 受控支付」的 Pact 策略，而不是每次发现新 Worker 都要用户重新配置 Pact。

---

## 问题 2：面向 Cobo 团队

**问题：** x402 支付验证的安全性：Worker 如何防止 tx hash 被重放？

**背景：**
当前设计中，Orchestrator 支付后带 `X-Payment-Proof: tx_hash` 重发请求，Worker 查询 Sepolia 确认收款。

但存在一个漏洞：同一个 tx hash 可以被重复使用（只要 Worker 没有记录「这个 tx 已用过」）。Worker 在什么时机应该标记 tx 为「已消费」？如果 Worker 重启，这个记录会丢失吗？

**希望回答什么：** 生产级 x402 Worker 如何防止 tx hash 重放攻击，CAW 在这里有什么内置机制还是需要 Worker 自己维护？

---

## 问题 3：面向 Mentor / 助教

**问题：** 「Agent 能自主采购资源」这个 Hackathon pitch 的最大弱点是什么？

**背景：**
我已经预想到以下几个评委挑战：
- 「Go server 不是真正的 Agent」→ 我的论点：持有独立钱包 + 自主验证是经济身份的充分条件
- 「合法浪费攻击」→ 我的论点：rate limit 是第一道防线，已知漏洞，有路线图
- 「x402 生态不成立」→ 我的论点：CAW Pact 信任边界模型独立于支付层

但我可能有盲点——**从评委视角看，最容易被质疑的论点是哪个？** 怎么加固？

---

*完成日期：2026-06-06*
