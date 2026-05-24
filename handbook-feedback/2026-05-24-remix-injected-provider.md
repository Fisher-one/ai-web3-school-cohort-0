# Handbook 反馈：Remix IDE 环境配置

- **日期**：2026-05-24
- **来源**：Fisher（学员）

## 相关页面


## 问题描述

在 Remix IDE 中部署合约时，部署环境下拉菜单找不到「Injected Provider - MetaMask」选项。学员以为 Remix 出问题了，排查后发现是 MetaMask 需要先在浏览器中解锁并在当前 Remix 页面授权连接，刷新页面后才会出现。

## 建议改进

Handbook 中如有 Remix 部署指引，建议补充一条：
> **提示**：如果部署环境下拉找不到 MetaMask，请先确保 MetaMask 已解锁，然后在 Remix 页面上授权连接（点击 MetaMask 图标），刷新页面后即可看到「Injected Provider」。

## 备注

另一个问题（git push 偶发 SSL 连接错误）为网络抖动，重试几次即自动恢复，不涉及 Handbook 内容。
