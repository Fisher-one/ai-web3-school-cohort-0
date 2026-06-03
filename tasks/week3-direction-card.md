# Hackathon Direction Card

> Week 3 任务｜最低完成路径（20 pts）
> Deadline：2026/6/7 23:59

---

## 基本信息

| 字段 | 内容 |
|------|------|
| **参赛赛道** | Cobo 赛道｜Agentic Economy × Cobo Agentic Wallet |
| **赛道方向** | 03｜Agent Resource Procurement |
| **项目名** | Chain Research Agent with Guarded Payments |
| **参赛形式** | 单人 |
| **提交截止** | 2026/6/13 12:00 UTC+8 |
| **Demo Day** | 2026/6/14 |

---

## 要解决的问题

**当 Agent 需要自主采购付费数据时，谁来保证它花的每一分钱都在授权范围内？**

DeFi 用户需要定期分析链上数据（DEX 交易量、流动性变化、协议收益），但：
- 链上公开数据不够用，历史聚合数据需要向 Dune Analytics 等服务付费
- 让 Agent「有权限花钱」很简单，但让它「只能在预算内花钱 + 留下可审计记录」很难
- 现有方案要么是用户每次手动签名（体验差），要么是无限授权（风险高）

**核心矛盾**：Agent 的自主性和资金安全之间的边界在哪里？

---

## 目标用户

- **DeFi 用户 / 投资者**：需要定期获取链上数据分析，不想手动查询多个数据源
- **Go 后端开发者**：希望用已有工程经验（权限中间件、审计日志）切入 AI × Web3 方向

---

## 解决方案

基于 **Cobo CAW + x402** 构建一个具备可审计支付能力的链上数据调研 Agent：

1. 用户一次性配置 CAW Pact（预算上限 + 白名单地址 + 有效期）
2. Agent 接收自然语言任务，自主判断是否需要采购付费数据
3. 遇到 x402 收费 API，在 Pact 范围内自动完成支付，无需用户每次确认
4. 验证数据签名，生成分析报告，附带完整执行日志（tx hash + 数据 hash）
5. 用户只需验收最终报告

**关键设计原则**：规则由人定（Pact 配置），执行才交给 Agent。

---

## 最小功能（MVP）

| 功能 | 说明 | 技术实现 |
|------|------|---------|
| x402 数据服务 | 收费的链上数据 API，拒绝无付款证明的请求 | Go HTTP server + 402 响应 |
| CAW Pact 配置 | 预算 ≤ 10 USDC/次、每日 ≤ 50 USDC、白名单地址 | CAW SDK |
| Agent 支付循环 | 识别 402 → 检查 Pact → 自动支付 → 重发请求 | Python Agent + CAW SDK |
| 数据签名验证 | 验证 API 返回数据的来源真实性 | ECDSA 签名验证 |
| 分析报告生成 | 整合数据，输出 Markdown 报告 + 执行日志 | LLM（Claude / DeepSeek） |

---

## 技术路径

```
用户自然语言输入
    ↓
Agent（Python + LLM）
    ├── 查询链上公开数据（免费）
    └── 遇到 402 → 检查 CAW Pact → 自动支付 → 重发请求
    ↓
x402 数据服务（Go）
    ├── 验证付款 tx hash
    └── 返回数据 + 数字签名
    ↓
Agent 验证签名 → 生成报告
    ↓
用户验收（报告 + 执行日志）
```

**技术栈**：
- 服务端：Go（x402 middleware）
- Agent：Python（LLM 调用 + CAW SDK）
- LLM：Claude API 或 DeepSeek（已有 key）
- 链：Ethereum Sepolia 测试网
- 钱包：Cobo CAW

---

## 主要风险

| 风险 | 可能性 | 缓解方式 |
|------|--------|---------|
| CAW 测试网 API 访问受限 | 中 | 提前申请 API 补贴；准备 mock CAW 作为降级 |
| x402 协议实现复杂度超预期 | 低 | Go 的 HTTP 中间件模式很成熟，参考 x402 官方文档 |
| Agent 被 prompt injection 影响链上操作 | 低 | Pact 白名单兜底，Policy 确定性拦截 |
| 单人开发时间不够 | 中 | Demo 只需跑通核心闭环（一笔 tx hash），不需要完整产品 |

---

## Week 3 开发计划

| 日期 | 任务 |
|------|------|
| 6/3（今天） | Direction Card 提交；Cobo CAW 文档通读 |
| 6/4–6/5 | Go 实现 x402 mock server（可独立运行） |
| 6/6–6/8 | 接入 CAW SDK，测试网配置 Pact，跑通支付 |
| 6/9–6/11 | Agent loop 集成，端到端测试，处理异常 |
| 6/12 | README + Demo 视频录制（3-5 分钟） |
| 6/13 | 提交（GitHub Repo + Demo + tx hash） |

---

## 与 Week 2 的关系

这个项目是 Week 2 研究成果的直接实现：

| Week 2 产出 | 在项目中的角色 |
|------------|--------------|
| x402 + CAW 架构设计 | 技术路径蓝图 |
| Agent 权限策略 | Pact 配置依据 |
| 支付商业流程 | 支付闭环设计 |
| Threat Model | 风险边界说明 |
| Agent Profile | README 基础 |

---

*完成日期：2026-06-03*
