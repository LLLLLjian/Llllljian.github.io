---
title: Leetcode_基础 (193)
date: 2022-07-19
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了刷题了

<!-- more -->

#### 括号生成
- 问题描述
    * 数字 n 代表生成括号的对数,请你设计一个函数,用于能够生成所有可能的并且 有效的 括号组合.
- 思路
    * 题目转换
    * 现在有 2n 个位置,每个位置可以放置字符 ( 或者 ),组成的所有括号组合中,有多少个是合法的
    * 一个「合法」括号组合的左括号数量一定等于右括号数量,这个很好理解.
    * 对于一个「合法」的括号字符串组合 p,必然对于任何 0 <= i < len(p) 都有：子串 p[0..i] 中左括号的数量都大于或等于右括号的数量.
- 代码实现
    ```python
        class Solution:
            def generateParenthesis(self, n: int) -> List[str]:
                res = []
                # 1. 左括号的数量要等于右括号的数量
                # 2. 对于一个「合法」的括号字符串组合 p,必然对于任何 0 <= i < len(p) 都有：子串 p[0..i] 中左括号的数量都大于或等于右括号的数量
                def backtrack(path, left, right):
                    # 若左括号剩下的多,说明不合法
                    if right < left:
                        return
                    # 数量小于 0 肯定是不合法的
                    if (left < 0) or (right < 0):
                        return
                    # 当所有括号都恰好用完时,得到一个合法的括号组合
                    if (left == 0) and (right == 0):
                        res.append(list(path))
                        return
                    # 尝试放一个左括号
                    path.append("(")
                    backtrack(path, left-1, right)
                    path.pop()

                    # 尝试放一个右括号
                    path.append(")")
                    backtrack(path, left, right-1)
                    path.pop()
                backtrack([], n, n)
                temp = []
                for row in res:
                    temp.append("".join(row))
                return temp
    ```






