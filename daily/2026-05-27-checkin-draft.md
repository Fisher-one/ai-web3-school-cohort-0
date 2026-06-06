## 打卡内容草稿 — 2026-05-27

**Day 9 打卡｜Machine Payment 章节复盘 + Agent Wallet 串联**

昨天读了 Agent Wallet，今天把 Machine Payment 也过完了。跟 Agent 试了 explain-back 的方法——合上书凭记忆讲，讲不清楚的就是没真懂的。

---

**Machine Payment 8 个节点，用自己的话过一遍**

**Stablecoin Payment**
最基础的稳定币支付，USDC/USDT 转账，没啥说的。

**Budget**
给 Agent 的钱包加额度上限——每天最多花多少、单笔上限、只能调哪些合约。不是「让 Agent 随便花」，是「在这个范围内随便花」。

**Quote**
不是 Agent 自己拼的价格，是服务方签过名的报价。Agent 拿到后验证签名确认没被篡改。类似后端拿到签过的 JWT 才放行，不能自己伪造 token。

**Payment Intent**
用户签过字的支付承诺。Quote 是卖家报价，Payment Intent 是买家说「好，我同意付」。链上合约看到 Intent 就知道这笔钱被授权了，直接执行不用再问用户。

**x402**
之前没搞懂，今天重新理解了。HTTP 402 是「这页要钱」，x402 是它的 Web3 实现。Agent 访问网页 → 对方返回 402 + 支付要求 → Agent 检查 Budget/Policy 判断能不能付 → 链上转账 → 拿收据 → 带收据重新请求 → 拿到内容。跟 Agent Wallet 接上：Budget 管能不能付，Policy 管付给谁。

**MPP（Machine Payment Protocol）**
两个自动化系统之间直接谈钱结算，中间没有人类点确认。类似后端 service-to-service gRPC 调用，不会每次调接口都弹个登录。

**Subscription**
就是自动续费，跟 Netflix 月费一个意思。不是存信用卡号，是链上合约按设定周期自动划钱，随时能取消。

**Micropayment**
极小额按次支付。0.001 USDC 调一次 API，传统支付系统手续费比金额还高所以做不到。L2 gas 低让这事变得可行。

---

**今天踩的坑**

读 Machine Payment 的时候 8 个节点当独立概念看，没串起来。Agent 帮我理了：Stablecoin → Budget → Quote → Payment Intent 是一条授权链，x402/MPP/Subscription/Micropayment 是四种支付场景的分叉。

x402 之前完全理解错了，Subscription 和 Micropayment 也搞混了。但 explain-back 让这些问题直接暴露出来，当场补上了。

---

**Agent Wallet + Machine Payment 串联**

```
Agent 想花钱 → Budget 查额度 → Policy 查规则
  → Quote 拿服务方报价 → Payment Intent 用户签承诺
    → Guard 最后拦截检查 → 链上执行 → Receipt 留凭证
```

Agent Wallet 管「能做什么」，Machine Payment 管「能花多少」。两条线在 Guard 那里汇合——做了什么事、花了多少钱，最后都要对得上。

---

**还没做**

- 问题地图今天没写，明天优先
- Agent Identity + AI Security 还没读
- 今晚 Neo-Cypherpunk 讲座（还没听）

---

**链接**

- Handbook Agent Wallet：https://aiweb3.school/zh/handbook/bridge/agent-wallet/
- Handbook Machine Payment：https://aiweb3.school/zh/handbook/bridge/machine-payment/
- WCB 打卡：https://web3career.build/zh/programs/AI-Web3-School#tab=learning
