# Handbook 反馈：RAG Retriever 与向量库交互细节

- **日期**：2026-05-22
- **来源**：Fisher Week 1 Day 5 学习笔记
- **相关章节**：AI基础 → RAG

## 问题

RAG 的原理讲清楚了（chunk → embedding → 向量搜索 → rerank → prompt），但 Retriever 和向量库之间的具体交互——比如 similarity search 的调用方式、top_k 怎么选、什么时候需要 rerank——没有展开。知道原理但不知道代码长什么样。

## 建议

在 RAG 章节增加一个简单的伪代码/流程图示例，展示 Retriever 调用向量库的核心步骤，帮助读者从「知道原理」过渡到「能写出来」。

## 标签

`ai基础` `rag` `代码示例缺失`
