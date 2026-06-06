# 深度研究包

> Week 3｜加分挑战（30 pts）
> Deadline：2026/6/7 23:59

---

## 主方向：Agentic Economy × Agent-to-Agent 资源采购

围绕 3 个核心协议 / SDK / 机制深度研究：
1. **Cobo Agentic Wallet（CAW）Pact 机制**
2. **x402 / HTTP 402 付费协议**
3. **ERC-4337 账户抽象与 Session Key**

---

## 1. Cobo Agentic Wallet（CAW）Pact 机制

### 解决什么问题

EOA（普通私钥钱包）给 Agent 用有一个根本矛盾：要么 Agent 没有私钥（每次都要用户签名，失去「自主性」），要么 Agent 有私钥（全权限，没有边界）。

CAW Pact 解决的是：**让 Agent 有「受限的自主权」**——用户设置一次 Pact，Agent 在 Pact 边界内自主执行，超出边界自动拒绝。

### 边界是什么

Pact 不是万能的：
- Pact 约束的是「能做什么」（白名单地址、金额上限），不是「该不该做」（这仍然由 Agent 的 LLM 判断）
- 如果用户配置了「付给任何地址 100 USDC 以内都行」，Pact 无法阻止 Agent 做无意义的转账
- Pact 的粒度取决于用户配置——配置粗糙的 Pact 保护能力很弱

### 还缺什么

**动态白名单**：当前 Pact 需要提前写死收款地址。真正的 Agent 经济需要「动态发现 → 动态授权」：Agent 发现一个新服务，Pact 能根据某个注册表（如链上的 Worker Registry）动态允许付款给已认证的地址。

**Pact 版本管理**：用户修改 Pact 时，历史 tx 是按旧 Pact 还是新 Pact 验证？需要清晰的版本语义。

**数据交付的 Escrow**：Pact 只管「付款成功」，不管「交付成功」。Agent 付款后 Worker 不交付数据，Pact 没有内置的仲裁机制。

---

## 2. x402 / HTTP 402 付费协议

### 解决什么问题

HTTP 402 本来是「预留支付状态码」，从未被广泛使用。x402 协议赋予它具体语义：

```
Client → Server: GET /data
Server → Client: 402 Payment Required
                 { "payment_address": "0x...", "amount": "0.001 ETH" }
Client → (blockchain) → 链上付款 → tx_hash
Client → Server: GET /data
                 X-Payment-Proof: tx_hash
Server → Client: 200 OK + data
```

解决的是：**机器对机器（M2M）的按次付费场景**。不需要账户注册、KYC、信用卡，只需要钱包地址。

### 边界是什么

- **无 Escrow**：付款不保证交付。服务方收到钱可以不返回数据，协议本身没有约束。
- **tx 确认延迟**：链上 tx 需要时间确认，服务方需要决定「等几个块才认为付款有效」。等太少（安全性差）、等太多（用户体验差）。
- **高频小额效率**：每次请求都发一笔链上 tx 的 gas 成本可能超过数据价值。需要 payment channel 或 L2 方案。

### 还缺什么

**Session 机制**：当前每次 tx 都独立。理想方案是「付一次开 session，session 内多次访问」，但需要服务方维护 session 状态。

**标准化错误格式**：402 响应格式目前没有统一标准，不同实现不兼容。

**与 Pact 的结合**：x402 告诉 Agent「该付多少给谁」，Pact 决定「能不能付」。两者组合才是完整的受控自主支付方案——这正是本项目的核心设计。

---

## 3. ERC-4337 账户抽象与 Session Key

### 解决什么问题

ERC-4337 把「签名验证逻辑」从协议层移到「智能账户合约」里。好处：
- 账户可以自定义签名方案（不必是 ECDSA）
- 可以批量交易、Gas 代付
- **Session Key**：用户可以授权一个「临时密钥」，只在特定范围内有效，到期自动失效

### 边界是什么

- Session Key 是「账户级」授权：授权给 Session Key 就是授权给持有者在允许范围内做任何该账户允许的操作。
- CAW Pact 是「任务级」授权：比 Session Key 粒度更细——同一个 Agent，不同任务可以有不同 Pact 约束。
- ERC-4337 本身不解决「该不该执行」的问题，只解决「能不能执行」——这个区别对 AI Agent 场景非常关键（AI 判断是否执行，合约保证执行边界）。

### 还缺什么

**AI Agent 专用的权限原语**：当前的 Session Key / Policy 系统是为「有限授权的人类」设计的，不是为「AI Agent 的不确定性」设计的。AI 可能做出人类不会做的奇怪决策，需要「语义级」的权限约束（如「只付给真正的数据服务商」，而不仅仅是「只付给白名单地址」）。

**跨链权限同步**：如果 Agent 在 L1 有 Pact，在 L2 操作时如何继承权限约束？目前需要在每条链单独配置。

---

## 研究来源

- Cobo 官方文档：https://www.cobo.com/products/agentic-wallet
- x402 协议设计：Coinbase 的 x402 GitHub
- ERC-4337 官方规范：https://eips.ethereum.org/EIPS/eip-4337
- Cobo 5/26 直播笔记（个人整理）
- 实际代码验证：https://github.com/Fisher-one/chain-research-agent

---

*完成日期：2026-06-06*
