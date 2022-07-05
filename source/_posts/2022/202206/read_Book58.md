---
title: 读书笔记 (58)
date: 2022-06-18 18::00:00
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-完全背包问题

<!-- more -->

#### 零钱兑换
- 问题描述
    * 给你一个整数数组 coins ，表示不同面额的硬币；以及一个整数 amount ，表示总金额。计算并返回可以凑成总金额所需的 最少的硬币个数 。如果没有任何一种硬币组合能组成总金额，返回 -1 。你可以认为每种硬币的数量是无限的。
- 思路
    * 备忘录解法
    * 我们只要判断一下每一个钱数减去对应的硬币金额之后是否有效, 然后取一个最小值就可以了
- 代码实现
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                # 备忘录
                memo = dict()
                def dp(n):
                    # 查备忘录，避免重复计算
                    if n in memo: return memo[n]
                    # base case
                    if n == 0: return 0
                    if n < 0: return -1
                    res = float('INF')
                    for coin in coins:
                        subproblem = dp(n - coin)
                        if subproblem == -1: continue
                        res = min(res, 1 + subproblem)
                    # 记入备忘录
                    memo[n] = res if res != float('INF') else -1
                    return memo[n]
                return dp(amount)
    ```





#### 零钱兑换II
- 问题描述
    * 给你一个整数数组 coins 表示不同面额的硬币，另给一个整数 amount 表示总金额。请你计算并返回可以凑成总金额的硬币组合数。如果任何硬币组合都无法凑出总金额，返回 0 。假设每一种面额的硬币有无限个。 题目数据保证结果符合 32 位带符号整数。
- 思路
    * 可以这样考虑
    * 假设我们要求5块有几种组成方式, 可以先求一下1块的组成方式, 然后求2块的, 从小到大就可以了 
- 代码实现
    ```python
        class Solution:
            def change(self, amount: int, coins: List[int]) -> int:
                dp = [0] * (amount+1)
                # base case
                # 为什么是1
                # 假设钱和硬币额度相同, 那么默认有一种解法(假设1块的组成方式只有1块1种)
                dp[0] = 1
                for i in range(len(coins)):
                    for j in range(1, amount+1):
                        if j >= coins[i]:
                            dp[j] = dp[j] + dp[j-coins[i]]
                return dp[amount]
    ```

