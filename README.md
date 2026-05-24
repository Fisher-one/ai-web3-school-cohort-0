# AI × Web3 School — 个人学习仓库

本仓库是我在 [AI × Web3 School](https://aiweb3.school/zh/handbook/) 的学习记录与 Proof of Work。

---

## Week 1 Proof-of-Work Pack

### 1. AI 学习记录 / 概念卡片

[tasks/week1-ai-concept-cards.md](./tasks/week1-ai-concept-cards.md)

用自己的话解释了 6 个 AI 核心概念：LLM、Prompt、Context、RAG、Agent、Evaluation。
基于 Handbook 阅读 + 实际使用 Hermes Learning Agent 的经验整理。

### 2. Learning Agent / AI 工具实践记录

通过 Telegram 接入 Hermes Agent 作为学习助手，用于：
- 每日生成学习计划和打卡草稿
- Handbook 章节阅读辅助
- 概念拆解与 Socratic 式引导学习

Agent 配置：[learning-agent.zh.txt](https://aiweb3.school/learning-agent.zh.txt)  
每日记录：[daily/](./daily/)

### 3. Web3 概念卡片

[tasks/week1-web3-concept-cards.md](./tasks/week1-web3-concept-cards.md)

用后端类比解释了 8 个 Web3 核心概念：钱包、私钥、交易、Gas、智能合约、ABI、测试网、区块浏览器。

### 4. 测试网交易记录 / 合约地址

在 Sepolia 测试网部署并调用了最小计数器合约（Remix IDE）：

- 合约代码：[contracts/Counter.sol](./contracts/Counter.sol)
- 合约地址：[0x2CbDFd05C0c05260e0950Ed312476b65d7Fd0e8d](https://sepolia.etherscan.io/address/0x2cbdfd05c0c05260e0950ed312476b65d7fd0e8d)
- 部署交易：[0x2abf89c...](https://sepolia.etherscan.io/tx/0x2abf89c26601a8a450ea3e484c3ee9488dc77185aaf051b5e69a2479e90e7bf1)
- increment() 调用：[0xf7617b4...](https://sepolia.etherscan.io/tx/0xf7617b43ce5fc65f50b9e65120f0eb216a73b4eaef6e53449d1d96697b08551f)

### 5. AI × Web3 最小交叉流程图

[tasks/aiweb3.excalidraw](./tasks/aiweb3.excalidraw) ｜ [说明文档](./tasks/week1-ai-web3-cross-workflow.md)

从「用户自然语言输入」到「链上执行验证」的完整流程图，标注了：
- 谁发起 / 谁执行（AI侧 Agent + Web3侧链）
- 两处人工确认红线（复核方案 + 钱包签名）
- 验证结果方式（tx hash + Event 日志 + Agent 自检）
- 5 个风险点（LLM幻觉 / RAG检索不准 / 人工复核形同虚设 / 交易不可逆 / 私钥泄露+盲签）

**一句话总结：** AI 负责推理和生成，人负责决策和签名，链负责执行和记录——三方各守边界，才是可信的 AI × Web3 系统。

### 6. 本周遇到的问题 + 人工修正记录

**问题：流程图箭头连接混乱，布局太紧凑**

第一版流程图画完后发现节点间距过小，看不清楚，且多处箭头连接方向不清晰，不符合「谁发起/谁执行/如何验证」的标注要求。

**人工修正：**
- 主动指出问题（「画的有些太紧凑了」「连接的有点仓促」），逐项确认 6 项标注要求
- 将 Agent 大框扩展到 920×755，所有节点间距拉开
- 重新梳理箭头逻辑：Context 双向读写、RAG→KB 双向、LLM→Eval 绕行路径
- 最终版本经本人对照任务清单逐条核验后才提交

**关键认知：** Agent 生成的方案需要人工审查，不能直接当作最终输出——这条原则在做流程图任务本身时也实际发生了一次。

---

## 链接

- [Handbook](https://aiweb3.school/zh/handbook/)
- [WCB 课程页面](https://web3career.build/zh/programs/AI-Web3-School)
- [WCB Learning 页面](https://web3career.build/zh/programs/AI-Web3-School#tab=learning)

## 目录说明

- `daily/` — 每日学习记录
- `tasks/` — 课程任务笔记
- `contracts/` — 合约代码
- `experiments/` — 实验与代码练习
- `handbook-feedback/` — Handbook 问题与改进建议
- `hackathon/` — Hackathon 项目
- `submissions/` — 提交记录
- `templates/` — 笔记模板

## Learning Agent

本仓库由 Hermes Agent 协助初始化和日常维护。Agent 帮助：

- 拉取 WCB 课程任务并生成每日计划
- 拆解任务、生成概念笔记草稿
- 生成打卡 proof 材料
- 整理 Handbook 反馈

所有创建文件、提交代码、WCB 提交等操作均由我人工确认后执行。Agent 不接触私钥、助记词、API Key 等敏感信息。

Agent 启动 Prompt：[https://aiweb3.school/learning-agent.zh.txt](https://aiweb3.school/learning-agent.zh.txt)

## 隐私提醒

本仓库为公开仓库，请勿提交任何 API Key、私钥、助记词、密码或其他敏感信息。
