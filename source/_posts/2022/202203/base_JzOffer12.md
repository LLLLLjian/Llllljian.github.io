---
title: 剑指Offer_基础 (12)
date: 2022-03-15
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 找出最小的 K 个数
- 题目描述
    * 输入 n 个整数,找出其中最小的 K 个数.
- 思路
    * 先将前 K 个数放入数组,进行堆排序,若之后的数比它还小,则进行调整
- 代码实现
    ```python
        class Solution:
            def getLeastNumbers(self, arr: List[int], k: int) -> List[int]:
                if k >= len(arr): return arr
                def quick_sort(l, r):
                    i, j = l, r
                    while i < j:
                        while i < j and arr[j] >= arr[l]: j -= 1
                        while i < j and arr[i] <= arr[l]: i += 1
                        arr[i], arr[j] = arr[j], arr[i]
                    arr[l], arr[i] = arr[i], arr[l]
                    if k < i: return quick_sort(l, i - 1) 
                    if k > i: return quick_sort(i + 1, r)
                    return arr[:k]
                return quick_sort(0, len(arr) - 1)
    ```

#### 连续子数组的最大和
- 题目描述
    * 输入一个整型数组,数组中有正数也有负数,数组中一个或连续的多个整数组成一个子数组,求连续子数组的最大和
- 思路
    * 若和小于0,则将最大和置为当前值,否则计算最大和
- 代码实现
    ```python
        class Solution:
            def maxSubArray(self, nums: List[int]) -> int:
                for i in range(1, len(nums)):
                    nums[i] += max(nums[i - 1], 0)
                return max(nums)
    ```

#### 买卖股票的最佳时机
- 题目描述
    * 给定一个数组 prices ,它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格.你只能选择 某一天 买入这只股票,并选择在 未来的某一个不同的日子 卖出该股票.设计一个算法来计算你所能获取的最大利润.返回你可以从这笔交易中获取的最大利润.如果你不能获取任何利润,返回 0 .
- 思路
    * 
- 代码实现
    ```python
        class Solution:
            def maxProfit(self, prices: List[int]) -> int:
                n = len(prices)
                if n == 0: return 0 # 边界条件
                dp = [0] * n
                minprice = prices[0] 
                for i in range(1, n):
                    minprice = min(minprice, prices[i])
                    dp[i] = max(dp[i - 1], prices[i] - minprice)
                return dp[-1]

        class Solution:
            def maxProfit(self, prices: List[int]) -> int:
                low = float("inf")
                result = 0
                for i in range(len(prices)):
                    low = min(low, prices[i]) # 取最左最小价格
                    result = max(result, prices[i] - low) # 直接取最大区间利润
                return result
    ```



