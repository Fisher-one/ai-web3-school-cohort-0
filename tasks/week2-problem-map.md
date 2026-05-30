# AI × Web3 问题地图与主方向选择

> Week 2 方向研究任务 | 20 pts

---

## 一、问题地图（5 个方向）

| 方向 | AI 作用 | Web3 机制 | 为什么必须两者结合 |
|------|---------|-----------|-------------------|
| **Wallet / Permission** ⭐ | Agent 生成交易方案、判断风险等级、解释「为什么该花这笔钱」 | Session Key + Policy + Guard + Simulation + Safe 多签 | AI 管不了私钥安全性，Web3 管不了「什么情况下该花」的判断逻辑。权限边界需要两层协作 |
| **Payment / Commerce** | Agent 比价、选服务方、判断交付质量、决定是否自动续费 | Quote（签名报价）+ Budget（额度上限）+ Payment Intent（用户签字承诺）+ x402/MPP | AI 做消费决策但付钱必须走链上不可逆交易，Web3 管转账但不知道「该不该付这笔」 |
| **Identity / Reputation** | Agent 需要被其他 Agent / 服务识别和信任 | ERC-8004 + 链上身份声明 + 可验证凭证 | AI 可以声称「我是 Fisher 的 Agent」，但链上需要密码学可验证的证据，不能靠嘴说 |
| **Security / Privacy** | Agent 可能被 prompt 注入诱导签名、工具返回值被伪造 | Guard（确定性拦截）+ Simulation（预演）+ Revocation（紧急撤销） | AI 的幻觉风险 × 链上交易不可逆 = 必须在执行前做确定性拦截，不能靠 AI 自己判断自己 |
| **Dev Tooling / Workflow** | Agent 编排多步链上操作、处理异常和重试 | MCP + Web3 Tool Use + Safe SDK + 链上上下文 | 工具链质量决定 Agent 执行可靠性——AI 管策略和编排，Web3 管执行和验证 |

---

## 二、两个方向的深入分析

### 方向 1：Wallet / Permission（为什么不是纯 AI / 纯 Web3）

**不是纯 AI 问题，因为：**
- AI 能生成交易方案、判断风险，但它不能保管私钥——私钥泄露是 AI 解决不了的安全边界问题
- 权限的「能不能撤销」「时间窗口多长」是链上机制决定的，不是 AI 推理能替代的

**不是纯 Web3 问题，因为：**
- 纯 Web3 的权限模型（多签、时间锁）是二元的——要么能转要么不能转，缺乏「什么情况下该转」的语义判断层
- 一个 Agent 面对 50 个待签交易时，Web3 本身无法判断哪个是正常的、哪个是钓鱼——这需要 AI 做上下文理解

**结合点：** AI 提供「该不该做」的判断层，Web3 提供「能不能做」的执行层，Guard 是两层之间的翻译器。

**这个方向让我想清楚的一件事：**

用智能账户订阅 X Premium 的时候，最开始只想到「限制金额——10U 以内不需要确认」。但往深想就不够用了：攻击者可以在上限内小额多笔把钱刷走，所以需要**频率限制**；Agent 可能从被篡改的页面拿到错误地址，所以需要**收款地址白名单**；支付处理商可能更新地址，所以白名单需要**有效期**强制定期核实。

Session Key 的四个限制维度（金额 / 频率 / 地址 / 有效期）不是一开始就想到的，是一步步逼出来的。

还有一个更根本的问题：**白名单地址可不可以让 Agent 自动填？** 最直觉的想法是让 Agent 去官网抓取支付地址，省去人工操作。但如果 Agent 可以填规则本身，那规则保护的是谁？Agent 可能从被篡改的页面拿到错误地址，也可能受到 prompt injection 攻击被诱导填入攻击者地址。结论是：**规则由人定，执行才交给 Agent**——这两件事不能颠倒。

---

### 方向 2：Payment / Commerce（为什么不是纯 AI / 纯 Web3）

**不是纯 AI 问题，因为：**
- AI 可以对比报价、判断服务方信誉，但它不能发起一笔链上转账——支付需要私钥签名，Web3 设施不可绕过
- 链上支付的不可逆性意味着 AI 的决策错误无法退款，需要链上机制（托管/质押罚没）兜底

**不是纯 Web3 问题，因为：**
- 纯 Web3 支付只知道「地址 A 转了 X USDC 给地址 B」，不知道转账背后的语义——是买 API 调用、付订阅费还是被骗了
- 服务发现、报价对比、交付质量判断——这些 Web3 本身做不了，需要 AI 做决策

**结合点：** Guard 是 AI 判断和链上执行的交汇点——确认「该付」之后才让「能付」发生。

**这个方向让我发现的一个问题：**

看到一个支付链路：`Stablecoin → Budget → Quote → Payment Intent → Guard`，第一反应觉得顺序不对——Guard 放在最后，意味着已经生成了 Payment Intent 才来检查「该不该付」。这相当于签了合同再审合同，顺序反了。

正确顺序应该是：`Budget → Quote → Guard → Payment Intent → 执行 → Receipt`

Guard 必须在 Payment Intent 之前，先确认「该付」，再承诺「要付」。另外原来的链路还缺 Receipt——付完钱服务给没给、给对没给，链路里看不到，这是个盲区。

---

## 三、主方向选择：Wallet / Permission

### 为什么选这个方向

**1. 问题的起点在这里。**

Week 1 画「两处红线」时就在问同一个问题——Agent 在什么条件下可以自主操作链上资产？Wallet / Permission 直接回答这个。其他方向（Payment、Identity、Security）都是在这个基础上生长的——先有权限边界，才有支付边界、身份声明边界、安全拦截边界。

分析 Payment/Commerce 的时候也发现了这一点：「能花多少钱、花给谁」本质上是一种权限规则。Session Key 的金额上限、地址白名单——这些既是 Permission 的设计，也是 Payment 的约束。**Payment 边界是 Permission 边界的子集**，选主方向的时候两个可以一起推进，不需要分开做两条线。

**2. 有直接的技术优势。**

Go 后端开发经验让我对「权限中间件 → 策略引擎 → 审计日志」这条链路天然熟悉。Session Key 的过期机制 = JWT 的 TTL，Policy 的规则匹配 = 中间件的路由 guard，Guard 的最终拦截 = 网关层的安全检查。概念迁移成本低，能快速进入实现层。

**3. 有真实产品和团队在验证。**

Cobo、Elytro、Safe 都在这个方向上有落地产品，不是纯概念研究。Cobo 5/26 直播展示了链上 Agent 权限管理的实际实现，有工程参照。

### 备选方向

- **Payment / Commerce**：和主方向紧密相关，作为延伸方向自然带上。
- **Security / Privacy**：重要但前置依赖多——Prompt Injection 攻击面、Guard 机制、Simulation 预演，这些是后续叠加层，不是 Week 2 的起点。

---

## 四、（后续任务）

Week 2 后续子任务围绕 Wallet / Permission 展开：

1. Agent 链上权限策略（Session Key → Policy → Guard → Human Check）
2. 最小支付流程拆解（Budget → Quote → Guard → Payment Intent → 执行 → Receipt）
3. Agent 身份声明草图（读完 Agent Identity 后做）
4. Threat Model + 确认策略（读完 AI Security 后做）
5. 汇总成总交付 Proposal
