---
title: 读书笔记 (53)
date: 2022-06-14
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-动态规划

<!-- more -->

#### 编辑距离
> 解决两个字符串的动态规划问题，一般都是用两个指针 i, j 分别指向两个字符串的最后，然后一步步往前移动，缩小问题的规模
- 问题描述
    ```
        给你两个单词 word1 和 word2， 请返回将 word1 转换成 word2 所使用的最少操作数  。

        你可以对一个单词进行如下三种操作：

        插入一个字符
        删除一个字符
        替换一个字符
    ```
- 动图演示
    ![编辑距离](/img/20220614_1.gif)
- 梳理思路
    ```
        if s1[i] == s2[j]:
            啥都别做（skip）
            i, j 同时向前移动
        else:
            三选一：
                插入（insert）
                删除（delete）
                替换（replace）
    ```
- 暴力解法
    ```python
        class Solution:
            def minDistance(self, word1: str, word2: str) -> int:
                def dp(s1, l1, s2, l2):
                    """
                    定义：返回 s1[0..i] 和 s2[0..j] 的最小编辑距离
                    """
                    # base case
                    if l1 == -1:
                        return l2 + 1
                    if l2 == -1:
                        return l1 + 1
                    if s1[l1] == s2[l2]:
                        # 啥都不做
                        return dp(s1, l1-1, s2, l2-1)
                    return min(
                        # 插入
                        # # 解释：
                        # 我直接在 s1[i] 插入一个和 s2[j] 一样的字符
                        # 那么 s2[j] 就被匹配了，前移 j，继续跟 i 对比
                        # 别忘了操作数加一
                        dp(s1, l1, s2, l2 - 1) + 1,
                        # 删除
                        # 解释：
                        # 我直接把 s[i] 这个字符删掉
                        # 前移 i，继续跟 j 对比
                        # 操作数加一
                        dp(s1, l1 - 1, s2, l2) + 1,
                        # 替换
                        # 解释：
                        # 我直接把 s1[i] 替换成 s2[j]，这样它俩就匹配了
                        # 同时前移 i，j 继续对比
                        # 操作数加一
                        dp(s1, l1 - 1, s2, l2 - 1) + 1
                    )

                l1 = len(word1)
                l2 = len(word2)
                return dp(word1, l1-1, word2, l2-1)
    ```
- 备忘录解法(递归, 从上到下)
    ```python
        class Solution:
            def minDistance(self, word1: str, word2: str) -> int:
                def dp(s1, l1, s2, l2):
                    """
                    定义：返回 s1[0..i] 和 s2[0..j] 的最小编辑距离
                    """
                    # base case
                    if l1 == -1:
                        return l2 + 1
                    if l2 == -1:
                        return l1 + 1
                    # 查备忘录，避免重叠子问题
                        if (memo[l1][l2] != -1):
                            return memo[l1][l2]
                    if s1[l1] == s2[l2]:
                        # 啥都不做
                        memo[l1][l2] = dp(s1, l1-1, s2, l2-1)
                    else: 
                        memo[l1][l2] = min(
                            # 插入
                            dp(s1, l1, s2, l2 - 1) + 1,
                            # 删除
                            dp(s1, l1 - 1, s2, l2) + 1,
                            # 替换
                            dp(s1, l1 - 1, s2, l2 - 1) + 1
                        )
                    return memo[l1][l2]

                l1 = len(word1)
                l2 = len(word2)
                # 备忘录 存储 s1[0..i] 和 s2[0..j] 的最小编辑距离
                memo = [[-1] * l2 for _ in range(l1)]
                return dp(word1, l1-1, word2, l2-1)
    ```
- DP table(自底向上)
    * 图解
        ![DP table](/img/20220614_2.PNG)
    ```python
        class Solution:
            def minDistance(self, word1: str, word2: str) -> int:
                l1 = len(word1)
                l2 = len(word2)
                # 备忘录
                dp = [[0] * (l2+1) for _ in range(l1+1)]
                # base case
                for i in range(1, l1+1):
                    dp[i][0] = i
                for i in range(1, l2+1):
                    dp[0][i] = i
                # 自底向上求解
                for i in range(1, l1+1):
                    for j in range(1, l2+1):
                        if word1[i-1] == word2[j-1]:
                            dp[i][j] = dp[i - 1][j - 1]
                        else:
                            dp[i][j] = min(
                                dp[i - 1][j] + 1,
                                dp[i][j - 1] + 1,
                                dp[i - 1][j - 1] + 1
                            )
                # 储存着整个 s1 和 s2 的最小编辑距离
                return dp[l1][l2]
    ```
