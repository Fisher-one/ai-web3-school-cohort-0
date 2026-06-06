# 技术验证计划

> Week 3｜加分挑战（30 pts）
> Deadline：2026/6/7 23:59

---

## 背景

项目：**Chain Research Agent with Guarded Payments**
当前进展：Week 3 核心链路已全部跑通，Week 4 进入 demo 打磨和边界验证阶段。

---

## Week 4 需要验证的关键技术点

### 1. 多 Worker 服务发现（端到端验证）

**验证点：**
- `list_data_workers()` 能否正确探测三个 Worker 的 `/catalog` 接口
- Worker 离线时是否正确跳过（不影响其他 Worker 发现）
- 返回的 Worker 列表格式是否正确传递给 LLM

**验证方式：**
```bash
./start-workers.sh           # 启动 8081 8082 8083
kill -9 <8082 pid>           # 模拟 Worker 2 离线
python agent/main.py         # 确认只发现 2 个 Worker
```

**成功标准：** LLM 收到的 Worker 列表只含在线的，并能正常选择

---

### 2. 429 触发 + CAW 支付闭环

**验证点：**
- Worker 第一次调用是否正确返回 429（超出免费额度）
- Agent 收到 429 后是否正确触发 CAW 支付
- CAW 在 Pact 范围内是否能成功广播 Sepolia 交易
- 带 `X-Payment-Proof: tx_hash` 重发后 Worker 是否正确验证并返回数据

**验证方式：**
- 查看 Agent 日志中的 tx hash 输出
- 在 Etherscan Sepolia 查询该 tx hash：https://sepolia.etherscan.io/tx/0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc

**成功标准：** 有可查的链上 tx，报告页脚显示 tx hash + 金额

---

### 3. CAW Pact 越权拦截

**验证点：**
- 尝试付给不在白名单的地址，CAW 是否拒绝
- 尝试超过金额上限的支付，CAW 是否拒绝
- 确认拦截在 Pact 层，不是代码层（即使绕过 Agent 代码也无法执行）

**验证方式：**
```python
# 临时修改 agent/tools.py 中的收款地址为非白名单地址
# 确认 CAW 返回 FORBIDDEN 错误而不是广播交易
```

**成功标准：** 越权操作被 CAW 拒绝，Agent 打印拦截日志

---

### 4. 真实 API 数据返回验证

**验证点：**
- Worker 8081 是否返回真实 DefiLlama TVL 数据
- Worker 8082 是否返回真实 DefiLlama 收益率数据
- Worker 8083 是否返回真实 CoinGecko 价格数据
- Agent 生成的报告是否引用了这些真实数据

**验证方式：**
```bash
# 直接调用 Worker catalog 接口
curl http://localhost:8081/catalog
curl http://localhost:8082/catalog
curl http://localhost:8083/catalog

# 验证数据：对比 DefiLlama 官网和 CoinGecko 官网
```

**成功标准：** 报告中的 TVL/APY/价格数据与来源网站一致（合理误差范围内）

---

### 5. 结构化报告输出

**验证点：**
- Agent 最终报告是否包含分析内容 + 支付摘要
- 支付摘要是否列出每笔 tx hash、金额、Worker 地址
- 报告是否可被评委理解（格式清晰、有来源说明）

**验证方式：**
```bash
python agent/main.py
# 输入：「分析 Ethereum DeFi 生态的 TVL、收益率和主要代币价格」
# 检查输出格式
```

**成功标准：** 报告包含 Markdown 格式分析 + 页脚支付记录，无乱码

---

### 6. 边界 Case 测试

**验证点：**
| 输入 | 预期行为 |
|------|---------|
| 「你好」 | Agent 说明需要具体的链上数据查询请求 |
| 空字符串 | 提示用户输入有效查询 |
| 「查 BTC 价格」 | 调用 CoinGecko Worker，返回 BTC 价格数据 |
| 多轮查询（连续输入两次） | 第二次不再触发付款（Worker 已在优先通道内） |

**成功标准：** 无 unhandled exception，所有 case 有合理输出

---

## 验证时间表

| 验证点 | 计划日期 | 状态 |
|-------|---------|------|
| 多 Worker 服务发现 | 6/9 | 待验证 |
| 429 + CAW 支付闭环 | 6/9 | 已有链上 tx，需重新演示 |
| CAW Pact 越权拦截 | 6/10 | 待验证 |
| 真实 API 数据返回 | 6/9 | 部分已验证 |
| 结构化报告输出 | 6/9 | 已验证，需截图 |
| 边界 Case | 6/9 | 待验证 |

---

## 已完成的技术验证（Week 3）

- ✅ CAW spike tx 成功广播：`0xe77dcf36b81eeee1eb016b6c5dd53419c2bbdc3bd34e584dc03deeea0fafb2cc`
- ✅ 三个 Worker 在本地跑通（DefiLlama + CoinGecko 真实数据）
- ✅ 429/402 触发机制验证
- ✅ x402 验证 + 数据交付闭环
- ✅ 服务发现（HTTP 探测，无 mock 数据）

---

*完成日期：2026-06-06*
