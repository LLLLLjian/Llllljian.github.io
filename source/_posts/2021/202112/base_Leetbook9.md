---
title: Leetbook_基础 (9)
date: 2021-12-24
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 双指针技巧
> 快慢指针
- 最大连续1的个数
    * Q
        ```
            给定一个二进制数组,  计算其中最大连续 1 的个数.
            示例：
            输入：[1,1,0,1,1,1]
            输出：3
            解释：开头的两位和最后的三位都是连续 1 , 所以最大连续 1 的个数是 3.
        ```
    * T
        * 
    * A
        ```python
            class Solution:
                def findMaxConsecutiveOnes(self, nums: List[int]) -> int:
                    result = 0
                    max = 0
                    for i in range(len(nums)):
                        if nums[i] == 1:
                            result += 1
                            if max > result:
                                pass
                            else:
                                max = result
                        else:
                            result = 0
                    return max
        ```
- 长度最小的子数组
    * Q
        ```
            给定一个含有 n 个正整数的数组和一个正整数 target .

            找出该数组中满足其和 ≥ target 的长度最小的 连续子数组 [numsl, numsl+1, ..., numsr-1, numsr] , 并返回其长度.如果不存在符合条件的子数组, 返回 0 .

            示例 1：
            输入：target = 7, nums = [2,3,1,2,4,3]
            输出：2
            解释：子数组 [4,3] 是该条件下的长度最小的子数组.
            示例 2：
            输入：target = 4, nums = [1,4,4]
            输出：1
            示例 3：
            输入：target = 11, nums = [1,1,1,1,1,1,1,1]
            输出：0
        ```
    * T
        * 通过快慢指针维护一个滑动窗口, 和大于target的时候慢指针移动, 小与target的时候快指针移动
    * A
        ```python
            class Solution:
                def minSubArrayLen(self, s: int, nums: List[int]) -> int:

                    if not nums:
                        return 0

                    n = len(nums)
                    # 滑动窗口左右边界
                    left = right = 0
                    # 记录当前元素和
                    sum = 0
                    # 记录最短长度
                    min_len = float('inf')

                    while right < n:

                        sum += nums[right]
                        # 如果当前元素和 >= s
                        while sum >= s:
                            # 取之前窗口长度和当前窗口长度最短的
                            min_len = min(min_len, right - left + 1)
                            # 去掉左侧的数
                            sum -= nums[left]
                            # 缩小窗口
                            left += 1
                        right += 1

                    # 如果整个数组所有元素的和相加都 < s
                    # 即不存在符合条件的子数组, 返回 0
                    if min_len == float('inf'):
                        return 0
                    else:
                        return min_len
        ```




