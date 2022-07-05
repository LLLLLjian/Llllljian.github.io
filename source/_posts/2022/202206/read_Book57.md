---
title: 读书笔记 (57)
date: 2022-06-18 12::00:00
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-子集背包问题

<!-- more -->

#### 分割等和子集
- 问题描述
    * 给你一个 只包含正整数 的 非空 数组 nums 。请你判断是否可以将这个数组分割成两个子集，使得两个子集的元素和相等。
- 思路
    * 可以转换为0-sum/2是否能完全装到背包里
    * dp定义
        * dp[i][j] = x 表示，对于前 i 个物品，当前背包的容量为 j 时，若 x 为 true，则说明可以恰好将背包装满，若 x 为 false，则说明不能恰好将背包装满。
- 代码实现
    ```python
        class Solution:
            def canPartition(self, nums: List[int]) -> bool:
                n = len(nums)
                if n < 2:
                    return False
                total = sum(nums)
                maxNum = max(nums)
                if total & 1:
                    return False
                target = total // 2
                if maxNum > target:
                    return False
                dp = [[False] * (target + 1) for _ in range(n)]
                for i in range(n):
                    dp[i][0] = True
                dp[0][nums[0]] = True
                for i in range(1, n):
                    num = nums[i]
                    for j in range(1, target + 1):
                        if j >= num:
                            # 装入或不装入背包
                            dp[i][j] = dp[i - 1][j] | dp[i - 1][j - num]
                        else:
                            # 背包容量不足，不能装入第 i 个物品
                            dp[i][j] = dp[i - 1][j]
                return dp[n - 1][target]
            
        class Solution:
            def canPartition(self, nums: List[int]) -> bool:
                n = len(nums)
                if n < 2:
                    return False
                total = sum(nums)
                maxNum = max(nums)
                if total & 1:
                    return False
                target = total // 2
                if maxNum > target:
                    return False
                dp = [False] * (target + 1)
                dp[0] = True
                for i in range(n):
                    for j in range(target, -1, -1):
                        if (j - nums[i] >= 0):
                            dp[j] = dp[j] or dp[j - nums[i]]
                return dp[target]
    ```

