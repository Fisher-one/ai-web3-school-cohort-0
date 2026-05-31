# Week 2 总交付：方向深挖包与项目初步 Proposal

> Week 2 总交付任务（40 pts）
> 主方向：Wallet / Permission / Safe Execution

---

## 一、AI × Web3 问题地图

> 完整版见：[week2-problem-map.md](./week2-problem-map.md)

| 方向 | AI 作用 | Web3 机制 | 为什么必须两者结合 |
|------|---------|-----------|-------------------|
| **Wallet / Permission** ⭐ | Agent 生成交易方案、判断风险等级、解释「为什么该花这笔钱」 | Session Key + Policy + Guard + Simulation + Safe 多签 | AI 管不了私钥安全性，Web3 管不了「什么情况下该花」的判断逻辑 |
| **Payment / Commerce** | Agent 比价、选服务方、判断交付质量 | Quote + Budget + Payment Intent + x402/MPP | AI 做消费决策但付钱必须走链上不可逆交易 |
| **Identity / Reputation** | Agent 需要被其他 Agent / 服务识别和信任 | ERC-8004 + 链上身份声明 + 可验证凭证 | AI 可以声称「我是 Fisher 的 Agent」，但链上需要密码学可验证证据 |
| **Security / Privacy** | Agent 可能被 prompt 注入诱导签名 | Guard（确定性拦截）+ Simulation + Revocation | AI 幻觉风险 × 链上不可逆 = 必须有确定性拦截层 |
| **Dev Tooling / Workflow** | Agent 编排多步链上操作、处理异常和重试 | MCP + Web3 Tool Use + Safe SDK | AI 管策略和编排，Web3 管执行和验证 |

---

## 二、主方向选择：Wallet / Permission

### 为什么不是纯 AI 问题

- AI 能生成交易方案、判断风险，但不能保管私钥——私钥安全是链上机制的职责
- 权限的「能不能撤销」「时间窗口多长」由链上合约决定，不是 AI 推理能替代的
- LLM 判断是概率性的，链上执行是不可逆的——两者之间必须有确定性规则层隔开

### 为什么不是纯 Web3 问题

- 纯 Web3 权限模型（多签、时间锁）是二元的：要么能转要么不能转，缺乏「什么情况下该转」的语义判断层
- Agent 面对 50 个待签交易时，Web3 无法判断哪个是正常的、哪个是钓鱼——这需要 AI 做上下文理解

### 结合点

AI 提供「该不该做」的判断层，Web3 提供「能不能做」的执行层，Guard 是两层之间的翻译器。

---

## 三、主方向问题拆解

| 维度 | 内容 |
|------|------|
| **参与方** | 用户（下单 + 规则制定 + 最终验收）、Agent（执行 + 判断）、智能账户合约（权限执行）、Guard（确定性拦截）、服务提供方（被调用） |
| **流程** | 用户配置 Pact → Agent 发起意图 → Policy 检查 → Guard Simulation → 风险分级 → 自动执行或人工确认 → 链上广播 → 结果验证 → 日志归档 |
| **AI 作用** | 理解用户意图、生成交易方案、判断风险等级、解释执行结果、处理异常重试 |
| **Web3 机制** | ERC-4337 账户抽象、Session Key、Policy 规则引擎、Guard 合约、链上审计日志 |
| **自动化边界** | 金额 ≤ 10 USDC + 已知合约 + Simulation 正常 → 自动执行 |
| **人工确认点** | 金额超阈值、未知地址/合约、Simulation 异常、Pact 配置变更 |
| **验证方式** | tx hash 链上确认、数据签名验证、CAW 审计日志、Guard 执行记录 |
| **主要风险** | Prompt Injection 影响 AI 判断、LLM 幻觉、小额多笔绕过频率限制、白名单合约自身漏洞 |

> 完整流程图见：[week2-agent-permission-policy.md](./week2-agent-permission-policy.md)
> Threat Model 见：[week2-threat-model.md](./week2-threat-model.md)

---

## 四、项目初步 Proposal

### 项目名称

**Chain Research Agent with Guarded Payments**
——具备权限边界和可审计支付能力的链上数据调研 Agent

### 目标用户

- **DeFi 用户 / 投资者**：需要定期获取链上数据（DEX 交易量、流动性变化、协议收益），但不想手动查询多个数据源
- **Go 后端开发者转型 Web3**：想用熟悉的工程思路（Policy 引擎、审计日志）切入 AI × Web3 方向

### 真实场景

用户委托 Agent 查询 Uniswap/Curve 的交易量对比数据。Agent 自主判断是否需要购买付费数据源（如 Dune Analytics），在用户预设的 Pact 范围内完成 x402 支付，验证数据真实性后生成报告返回给用户。

全程用户只需要：① 配置一次 Pact（金额上限 + 白名单地址 + 有效期）② 最终验收报告质量。

### 最小功能（MVP）

| 功能 | 说明 |
|------|------|
| 自然语言接收任务 | 用户用自然语言描述需求 |
| 链上公开数据查询 | 直接读取合约事件，免费 |
| x402 付费 API 调用 | 识别 402 响应，在 Pact 范围内自动完成支付 |
| 数据签名验证 | 验证 API 返回数据的来源真实性 |
| 报告生成与交付 | Markdown 格式，附来源 + tx hash |
| 执行日志 | 支付记录 + 数据 hash + 时间戳 |

### 验证方式

- **Week 3 最小验证**：在测试网上跑通「发起查询 → 收到 402 → CAW 完成支付 → 拿到数据」的完整链路，有 tx hash 为证
- **成功标准**：用户不需要手动签任何链上交易，Agent 在 Pact 范围内自主完成

### 主要风险

| 风险 | 缓解方式 |
|------|---------|
| Prompt Injection 影响链上操作 | Policy/Guard 确定性拦截，不依赖 AI 判断 |
| 付费 API 数据被篡改 | 数字签名验证 |
| 服务方收款后不返回数据 | 当前无自动解决方案，需 Escrow 机制（Week 3 延伸） |
| 报告质量无法自动验证 | 保留人工验收作为最终确认 |

### 可能赛道

- **Cobo Hackathon Track**：CAW + 权限控制方向直接对应
- **ETHPanda / LXDAO 工具类项目**：Go 后端切入 Web3 工具的示范路径
- **长期方向**：Agent Commerce 基础设施，权限和支付层的开发者工具

### Week 3 下一步

1. 用 Go 实现 x402 服务端中间件（复用后端经验）
2. 接入 Cobo CAW SDK，测试网跑通支付闭环
3. 补充 Escrow 合约处理交付失败场景
4. 整理成可提交的 Hackathon proposal

---

## 五、主方向深挖包

### 流程图

> 完整流程见：[week2-agent-permission-policy.md](./week2-agent-permission-policy.md)

核心链路：
```
用户配置 Pact（人工确认）
    → Agent 发起意图
    → Policy 检查（自动）
    → Guard Simulation（自动）
    → 风险分级
        → 低风险：自动执行
        → 高风险：人工确认
    → 链上执行
    → 结果验证 + 日志
```

### 典型场景

> 完整场景见：[week2-payment-commerce-flow.md](./week2-payment-commerce-flow.md)

用户说「查过去 7 天 Uniswap/Curve 的交易量对比」。Agent 发现需要付费数据，调用 CAW 在 Pact 范围内自主完成 5 USDC 的 x402 支付，验证数据签名后生成报告。全程用户无需手动签名。

### 反例

**只做「自然语言发交易」但没有权限控制**：

一个 Agent 说「我可以用自然语言帮你发链上交易」——没有 Session Key 限制、没有 Policy 检查、没有 Guard 确认、没有日志记录。这是危险 demo，不是可信产品。

关键缺失：攻击者通过 prompt injection 让 Agent 发一笔转账，Agent 直接执行，没有任何拦截层。

### 关键风险

> 完整 Threat Model 见：[week2-threat-model.md](./week2-threat-model.md)

| 风险 | Policy/Guard 能否拦截 |
|------|---------------------|
| Prompt Injection → 链上转账 | ✅ 白名单拦截 |
| Prompt Injection → AI 判断 | ❌ LLM 层无法完全防御 |
| Agent 幻觉 | ❌ 需强制工具调用 |
| 越权指令 | ✅ Policy 直接拒绝 |

### 最小验证计划

**目标**：在测试网跑通一次 x402 + CAW 自主支付闭环

**步骤**：
1. 搭建一个返回 402 的 Go 服务（mock Dune API）
2. 配置 CAW 测试账户 + Pact（金额 ≤ 5 USDC，白名单地址）
3. Agent 发起请求 → 收到 402 → CAW 完成支付 → 获取数据
4. 验证：tx hash 可查、审计日志完整、超出 Pact 的请求被拒绝

**成功标准**：有一个可演示的 tx hash 链路，超出权限的操作被自动拒绝。

---

## 六、参考资料清单

| 资料 | 帮助我判断什么 |
|------|--------------|
| **ERC-4337 官方文档** | 账户抽象的标准实现：验证层（validateUserOp）为什么能把「建议」变成「强制」，Session Key 住在哪里 |
| **Cobo CAW 文档**（cobo.com/products/agentic-wallet） | Pact 机制如何实现任务级授权，比 Session Key 的账户级授权粒度更细的地方在哪里 |
| **x402 Docs** | HTTP 402 协议如何把支付触发嵌入标准请求响应流程，适合哪类按次付费场景 |
| **Safe Smart Account Guards** | Guard 合约插槽的设计：为什么「在合约里写自定义检查逻辑」比「在链下检查」更可靠 |
| **ERC-8004（Agent Identity）** | Agent 链上身份声明的格式标准：付款方是谁、被谁授权，让服务方可以验证 Agent 的合法性 |
| **Elytro Agent Wallet（产品参考）** | Session Key + 48h 反劫持窗口的实际产品落地：时间窗口不是理论，是真实产品特性 |
| **Cobo 5/26 直播** | 链上 Agent 权限管理的工程实现参照：CAW 的 Pact 怎么在实际产品里用 |

---

## 七、方向 Backlog

### Identity / Reputation — 暂时不选的原因

方向本身有价值，但**前置依赖太多**：要让 Agent 身份有信誉积累，先得有稳定的执行记录；要有执行记录，先得有权限控制和支付基础设施。身份层是在 Wallet/Permission 之上生长的，不是起点。

另外，当前阶段「Agent 做了 100 次好报告」这个历史记录存在哪、谁来认证，工程实现还不成熟。

### Security / Privacy — 暂时不选为主方向的原因

Security 作为独立主方向复杂度很高——Prompt Injection 防线、可信执行环境、私钥保护、Simulation 预演，每一个都是独立的大问题。但这些问题是**所有方向的底层约束**，不是单独做一个方向的入口。

实际处理方式：把 Security 的核心结论（确定性防线的边界）集成进 Wallet/Permission 的设计里，而不是单独展开。

### Governance / Coordination — 暂时不选的原因

和自己的技术背景（Go 后端 + Web3 新手）距离最远。Governance 需要对 DAO 工具、提案机制、投票合约有深入了解，短期内没有切入优势。而且 Governance 方向的用户群体（DAO 贡献者、社区运营）和自己目前能服务的用户（开发者、DeFi 用户）差异较大。

---

## 八、Week 3 方向

基于本周研究，Week 3 的核心目标：

**从架构设计到可运行的最小闭环。**

1. Go 实现 x402 服务端中间件
2. 接入 Cobo CAW SDK，测试网跑通支付
3. 整理 Hackathon Proposal，明确可提交的 track

---

*完成日期：2026-05-31*
