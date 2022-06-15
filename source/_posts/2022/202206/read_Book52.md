---
title: 读书笔记 (52)
date: 2022-06-11
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-动态规划

<!-- more -->

#### 下降路径最小和
- 问题描述
    * 给你一个 n x n 的 方形 整数数组 matrix ,请你找出并返回通过 matrix 的下降路径 的 最小和 .下降路径 可以从第一行中的任何元素开始,并从每一行中选择一个元素.在下一行选择的元素和当前行所选元素最多相隔一列(即位于正下方或者沿对角线向左或者向右的第一个元素).具体来说,位置 (row, col) 的下一个元素应当是 (row + 1, col - 1)、(row + 1, col) 或者 (row + 1, col + 1) .
- 思路
    * 转化一下思路就是, 走到最后一行的最小步数, 所以我们可以通过动态规划计算出每一行的每个位置达到时的最小步数
- 题解
    * [下降路径最小和](https://leetcode.cn/problems/minimum-falling-path-sum/solution/python-by-llllljian-n3qu/)
- 代码实现
    ```python
        class Solution:
            def minFallingPathSum(self, matrix: List[List[int]]) -> int:
                if not matrix:
                    return 0
                n = len(matrix)
                memo = [[0] * n for _ in range(n)]
                def dp(i, j):
                    # 设置边界
                    if (i<0) or (j<0) or (i>=n) or (j>=n):
                        return 9999
                    # 从备忘录中取值
                    if memo[i][j]:
                        return memo[i][j]
                    # 列公式
                    temp = min(
                        # 以5为例子, 其实我要比的是2 1 3中的最小值
                        # 2
                        dp(i-1, j-1),
                        dp(i-1, j),
                        dp(i-1, j+1)
                    )
                    if temp == 9999:
                        # 全都越界了
                        temp = 0
                    memo[i][j] = temp + matrix[i][j]
                    return memo[i][j]
                for i in range(n):
                    for j in range(n):
                        dp(i, j)
                return min(memo[n-1])
    ```

#### 最长回文子序列
- 问题描述
    * 给你一个字符串 s ,找出其中最长的回文子序列,并返回该序列的长度.子序列定义为：不改变剩余字符顺序的情况下,删除某些字符或者不删除任何字符形成的一个序列.
- 思路
    * 直接抄动态规划模板, 但是要注意的是在越界情况里 还有一个特殊情况 i比j大是没有意义的 直接返回0就可以,原因是memo[i][j]的定义是 从i到j范围内的最长回文子序列长度, 所以i比j大没意义, 还有一个要注意的点是, 当i=j时, 此时应该直接返回1, 因为一个字母本身它就是长度为1的回文字符串
- 题解
    * [最长回文子序列](https://leetcode.cn/problems/longest-palindromic-subsequence/solution/python3dong-tai-gui-hua-wo-zhen-de-jiao-35g9s/)
- 代码实现
    ```python
        class Solution:
            def longestPalindromeSubseq(self, s: str) -> int:
                if not s:
                    return 0
                length = len(s)
                # 备忘录
                # 字符串s在[i, j]范围内最长的回文子序列的长度为memo[i][j]
                memo = [[0] * length for _ in range(length)]
                def dp(i, j):
                    if (i<0) or (j<0) or (i>=length) or (j>=length) or (i>j):
                        # 越界情况
                        return 0
                    if i == j:
                        return 1
                    if memo[i][j]:
                        # 备忘录中有结果的话 使用备忘录
                        return memo[i][j]
                    # 开始条件判断
                    if s[i] == s[j]:
                        # 可以这么理解
                        # 假设有索引 i i+1 i+2 ..... j-1 j
                        # 如果s[i] == s[j], 那么 memo[i][j] = memo[i+1][j-1] + 2
                        memo[i][j] = dp(i+1, j-1) + 2
                    else:
                        memo[i][j] = max(
                            # 还可以这么理解
                            # 假设有索引 i i+1 i+2 ..... j-1 j
                            # 如果 s[i] != s[j], 那么 memo[i][j] = max(memo[i][j-1], memo[i+1][j])
                            # 加入s[i]
                            dp(i, j-1),
                            # 加入s[j]
                            dp(i+1, j)
                        )
                    return memo[i][j]
                return dp(0, length-1)
    ```