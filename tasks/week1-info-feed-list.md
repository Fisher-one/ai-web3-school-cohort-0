# AI × Web3 行业信息流关注清单

> Week 1 任务｜建立 AI × Web3 行业信息流（20 pts）

---

## 我关注的 10 个账号

### A. 课程与社区（必关注）

| 名称 | X Handle | 为什么关注 | 想观察什么 |
|------|----------|-----------|-----------|
| AI Web3 School | @aiweb3school | 课程官方账号，任务通知、活动更新、优秀作品展示都在这里 | 课程进度、Week 2/3/4 新任务方向、同学作品参考 |
| ETHPanda | @ETHPanda_Org | 课程联合发起方，华语以太坊核心社区 | 中文 Ethereum 生态活动、Hackathon 信息、中文 builder 动向 |
| LXDAO | @LXDAO_Official | 课程联合发起方，研发驱动 DAO，关注开源和公共物品方向 | 开源项目机会、公共物品资助、DAO 协作模式 |
| Web3 Career Build | @web3careerbuild | WCB 平台官方账号，任务和学习记录都在这里交 | 任务更新、优秀学员作品、求职/项目机会 |

### B. 赞助方 / 合作方（必关注）

| 名称 | X Handle | 为什么关注 | 想观察什么 |
|------|----------|-----------|-----------|
| Z.AI / GLM | @Zai_org | 课程领衔赞助方，做 GLM 模型和 AI coding 工具 | Agent 工具调用能力更新、GLM API 变化、AI coding 实践案例 |
| Cobo | @Cobo_Global | 课程联合赞助方，做机构钱包和 MPC 托管 | Agent Wallet 的安全边界、MPC 多签实践、机构级钱包设计思路 |

### C. 行业专家与 Builder（自选）

| 名称 | X Handle | 为什么关注 | 想观察什么 |
|------|----------|-----------|-----------|
| Vitalik Buterin | @VitalikButerin | Ethereum 核心，他的文章是 AI × Web3、账户抽象、隐私等方向最原始的思考来源 | AI × Crypto 的长期路线判断、账户抽象设计哲学、公共物品与治理 |
| Bruce Xu | @brucexu_eth | ETHPanda / LXDAO 核心 builder，中文生态信息密度高，和这门课直接相关 | 中文 builder 生态的项目和机会、AI × Web3 共学实践、工作/合作信息 |
| Elytro | @elytro_eth | 做 AA 钱包（账户抽象），和「比较 EOA/智能账户/多签」任务直接相关，也是 Agent Wallet 方向的实际产品 | 社交恢复、Session Keys、Spending Limits 如何在实际产品中落地；Agent 执行链上操作的权限边界怎么设计 |
| Austin Griffith | @austingriffith | 专注 Ethereum 开发者路径和 Grant，对想进这个行业的开发者很有参考价值 | 开发者如何在 Web3 找到位置、Grant 机会、Scaffold-ETH 等工具实践 |

---

## 为什么这样选

按方向分类：

- **课程生态（4个）**：aiweb3school / ETHPanda / LXDAO / web3careerbuild — 保持和课程同步，不错过任务和机会
- **AI / Agent 工具（1个）**：Z.AI — 观察国内 LLM 在 Agent 工具调用方向的实际进展
- **Web3 钱包 / 安全（2个）**：Cobo + Elytro — 一个看机构级安全边界，一个看 AA 钱包的用户侧产品设计
- **以太坊核心思想（1个）**：Vitalik — 打基础，避免只追热点不懂底层
- **中文生态 + 开发者路径（2个）**：Bruce Xu + Austin — 一个连接中文生态机会，一个提供开发者职业路径参考

---

## 我接下来想持续观察的问题

1. **Agent Wallet 的权限边界怎么设计**：Agent 可以自动执行哪些操作，哪些必须人工确认？Elytro 的 Session Keys 和 Spending Limits 是目前最接近答案的实践，想持续跟进
2. **Go 后端开发者如何切入 AI × Web3**：Scaffold-ETH / Foundry 生态里有没有适合 Go 开发者的工具方向？Grant 路径和就业路径有什么区别？

---

## 高质量内容笔记

### Elytro — Agent Wallet 安全设计的两层防线

Elytro 的 Agent Wallet 不靠单一手段防风险，用了分层设计：

- **Layer 1：2FA** — 日常操作需要二次确认，防止误操作或被脚本滥用
- **Layer 2：Social Recovery + 48h 反劫持窗口** — 即使 Agent 被劫持发起了恢复请求，真正的控制权转移要等 48 小时，owner 有足够时间取消

这两层之间有个关键设计：时间差。不是「出事了能不能拦住」，而是「拦不住的时候还有多少时间反应」。Agent Wallet 的安全边界不只是签名校验，更是产品层面的时间窗口设计。

---

*建立日期：2026-05-24*
