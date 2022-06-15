---
title: Interview_总结 (185)
date: 2022-06-10
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### 目标和
- 问题描述
    * 给你一个整数数组 nums 和一个整数 target .向数组中的每个整数前添加 '+' 或 '-' ,然后串联起所有整数,可以构造一个 表达式 ：例如,nums = [2, 1] ,可以在 2 之前添加 '+' ,在 1 之前添加 '-' ,然后串联起来得到表达式 "+2-1" .返回可以通过上述方法构造的、运算结果等于 target 的不同 表达式 的数目.
- 思路
    * 回溯+剪枝
    * 对于每一个 1,要么加正号,要么加负号,把所有情况穷举出来,即可计算结果
- 代码实现
    ```python
        class Solution:
            def findTargetSumWays(self, nums: List[int], target: int) -> int:
                if not nums:
                    return 0
                # 备忘录
                memo = {}
                def dp(nums, i, remain):
                    # base case
                    if i == len(nums):
                        if remain == 0:
                            return 1
                        else:
                            return 0
                    # 把它俩转成字符串才能作为哈希表的键
                    key = "%s,%s" % (i, remain)
                    if key in memo:
                        # 避免重复计算
                        return memo[key]
                    # 穷举
                    result = dp(nums, i + 1, remain - nums[i]) + dp(nums, i + 1, remain + nums[i])
                    # 记入备忘录
                    memo[key] = result
                    return result
                return dp(nums, 0, target)
    ```





