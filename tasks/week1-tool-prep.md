# Week 1｜工具准备记录

## 协作工具

| 工具 | 用途 | 状态 |
|------|------|------|
| **Telegram** | 课程社群、Co-learning 直播、每日与 Learning Agent 交互 | ✅ |
| **GitHub** | 学习仓库 `ai-web3-school-cohort-0`，任务 proof 提交入口 | ✅ |
| **WeChat** | 报名联系方式、课程通知 | ✅ |
| **Zoom** | 线上直播活动 | 浏览器直接访问 |

## AI 工具

| 工具 | 用途 | 状态 |
|------|------|------|
| **Hermes Agent v0.14.0** | Learning Agent，辅助每日规划、任务拆解、概念解释、打卡草稿 | ✅ 已配置 |
| **DeepSeek API (v4-pro)** | Hermes 底层模型 | ✅ 已配置 |


### Hermes Agent 当前能力

- 读取 WCB 任务列表并生成每日计划
- 查询个人资料和课程进度
- 生成打卡草稿和任务 proof 材料
- Terminal + 文件读写 + 浏览器工具

## Web3 工具

| 工具 | 用途 | 状态 |
|------|------|------|
| **MetaMask** | 测试钱包，管理测试网账户、签名交易 | ✅ |
| **Remix (浏览器 IDE)** | Solidity 合约部署和调用 | ✅ |
| **Git** | 代码版本管理、proof 提交 | ✅ |
| **Node.js v24.12** | Hardhat / viem / wagmi 等工具链运行时 | ✅ |
| **Python 3.9.6** | 脚本工具、数据处理 | ✅ |


## 每个工具在 Week 1 怎么用

### 已就绪的

- **Hermes Agent** → 负责每日学习规划、任务拆解提醒、概念卡片草稿、Learning Agent Setup 任务。已经在用。
- **GitHub** → 学习仓库已初始化（`ai-web3-school-cohort-0`），任务 proof 写到这里，提交时贴 repo 链接到 WCB。
- **MetaMask + Remix** → 完成测试网交易（任务 12）和最小合约部署（任务 13）。Remix 直接浏览器里写 Solidity，MetaMask 确认交易。
- **Telegram** → 社群自我介绍 + 活动通知。Hermes Agent 也走 Telegram，同一个入口。

### 需要补充的

- **Foundry 或 Hardhat（二选一）** → 用于更正式的合约开发，Remix 适合快速实验但不适合项目管理。计划优先装 **Hardhat**（JS 生态更熟悉），用来完成合约部署进阶任务（任务 13/14）。


## 下一步
1. 安装 Hardhat：`npm install -g hardhat`
2. 确认 MetaMask 已切换到 Sepolia 或其他测试网
3. 领取测试币

---

