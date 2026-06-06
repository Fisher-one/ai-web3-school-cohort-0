# Week 4 Sprint Plan

> Week 3｜最低完成路径（20 pts）
> Deadline：2026/6/7 23:59

---

## 目标

Week 4（6/9–6/13 12:00）是黑客松的最终冲刺阶段。核心目标：**一个可运行的 demo + 一段 3-5 分钟的演示视频 + 完整的 README**。

---

## Day-by-Day 计划

### 6/9（周一）— 边界 case 测试 + README 初稿

**真实实现：**
- 运行完整链路测试：`./start-workers.sh` + `python agent/main.py`
- 测试边界 case：「你好」、空字符串、「查 BTC 价格」、多轮查询
- 确认 429 触发机制、tx hash 输出、报告格式

**可 mock / fallback：**
- 如果 Sepolia 网络不稳定，用已有的 tx hash 演示链上记录

**产出：**
- 边界 case 测试记录（截图）
- README 初稿（架构图 + 运行方式 + CAW 集成说明）

---

### 6/10（周二）— 项目流程图 + 已知漏洞文档

**真实实现：**
- 用 Excalidraw 画最终版架构图（含 A2A 经济流、CAW Pact 权限层）
- 写 README 的 Narrative Warning 段落：Go server 不是普通 API，是自主经济服务

**fallback：**
- 架构图用 ASCII art 替代，保证 README 可读性

**产出：**
- 最终版架构图（PNG）
- README 中的「已知漏洞」段落（合法浪费攻击、Sybil attack）
- README 中的「A2A 路线图」段落

---

### 6/11（周三）— Demo 视频脚本 + 录制

**Demo 脚本（约 3-5 分钟）：**
1. 启动三个 Worker（`./start-workers.sh`），展示各 Worker 的 `/catalog` 接口
2. 开第四个终端，运行 `python agent/main.py`
3. 输入查询：「分析 Ethereum DeFi 生态的 TVL、收益率和主要代币价格」
4. 展示 Agent 发现 Worker 列表、LLM 推理选择、429 触发付款
5. 展示链上 tx hash、最终结构化报告
6. 展示 Etherscan 上的交易记录

**工具：** QuickTime 录屏 + 语音讲解

**产出：**
- Demo 视频草稿（可二次剪辑）

---

### 6/12（周四）— README 终稿 + 视频剪辑

**真实实现：**
- 完善 README：加运行截图、评委问题 FAQ、链上 tx 链接
- 视频剪辑：压缩到 5 分钟内，配字幕

**产出：**
- README 终稿
- Demo 视频终稿（上传 YouTube 或 Loom）

---

### 6/13（周五）上午 — 最终提交

**提交清单：**
- [ ] GitHub Repo URL：https://github.com/Fisher-one/chain-research-agent
- [ ] README（含架构图、运行方式、CAW 集成说明）
- [ ] Demo 视频（3-5 分钟）
- [ ] 链上 tx hash：`0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`
- [ ] Agent Wallet：`0x74aae83c8bf22c72a9246b33fc793f20af79e64b`（Sepolia）

**截止：2026-06-13 12:00 UTC+8**

---

## 风险与 Fallback

| 风险 | Fallback |
|------|---------|
| Sepolia 网络延迟 | 用已有 tx hash 演示，不重新跑链上支付 |
| LLM API 限速 | 用本地 Ollama 或降级到 mock 报告 |
| Worker 网络不稳定 | 录制时在本地环境，不用公网地址 |
| 视频录制音频质量差 | 换成截图 + 文字说明的 GIF 演示 |

---

## 已确认完成的部分（不需要 Week 4 再做）

- ✅ 真实服务发现（`list_data_workers()` → HTTP 探测）
- ✅ LLM 推理比价选 Worker
- ✅ CAW Pact 授权 + 链上支付
- ✅ x402 验证 + 真实 API 数据返回
- ✅ 结构化报告输出 + 支付摘要页脚
- ✅ 429/402 统一处理
- ✅ 链上 tx hash 记录

---

*完成日期：2026-06-06*
