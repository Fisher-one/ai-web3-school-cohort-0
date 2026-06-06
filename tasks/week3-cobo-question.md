# 给 Cobo / Z.AI 的问题

> Week 3｜赞助方问题收集（5 pts）
> Deadline：2026/6/7 23:59

---

赞助方：Cobo

问题：CAW Pact 是否支持基于链上注册表的动态白名单？

背景 / 卡点：
我的项目（Chain Research Agent）通过 HTTP 探测动态发现 Data Worker，Worker 的收款地址在运行时才知道。当前 Pact 要求提前写死白名单地址。如果新发现一个 Worker，用户必须重新配置 Pact，这与「Agent 自主发现和采购服务」的目标矛盾。

理想方案是：Pact 允许「付款给任何链上 Worker Registry 中已注册的地址」，而不是具体的地址列表。

希望分享会回答什么：
1. 当前 Pact 支持哪些类型的地址约束（静态地址 / 合约调用结果 / 其他）？
2. 有没有推荐的工程 workaround 支持「动态发现 Worker → 无需重新配置 Pact 就能付款」这个场景？
3. 未来版本的 Pact 是否计划支持更灵活的权限策略（如基于链上注册表的动态授权）？

---

*完成日期：2026-06-06*
