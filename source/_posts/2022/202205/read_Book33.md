---
title: 读书笔记 (33)
date: 2022-05-17
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-团灭 NSUM 问题

<!-- more -->

#### twoSum问题
- 问题描述
    * 如果假设输入一个数组 nums 和一个目标和 target,请你返回 nums 中能够凑出 target 的两个元素的值,
- 思路
    * 双指针, 返回
- 代码实现
    ```python
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                left, right = 0, len(nums)-1
                nums.sort()
                while left <= right:
                    temp = nums[left] + nums[right]
                    if temp == target:
                        return [left, right]
                    elif temp > target:
                        # [left, right-1]
                        right -= 1
                    elif temp < target:
                        # [left+1, right]
                        left += 1
                return []
    ```
- 加深难度-问题描述
    * nums 中可能有多对儿元素之和都等于 target,请你的算法返回所有和为 target 的元素对儿,其中不能出现重复
- 思路
    * 
- 代码实现
    ```python
        def twoSumTarget(nums, target):
            if not nums:
                return []
            left, right = 0, len(nums) - 1
            nums.sort()
            res = []
            while left <= right:
                temp = nums[left] + nums[right]
                if temp == target:
                    res.append([left, right])
                    left += 1
                    right -= 1
                    # 跳过所有重复的元素
                    while (left <= right) && (nums[left] == nums[left+1]):
                        left += 1
                    while (left <= right) && (nums[right] == nums[right-1]):
                        right -= 1
                elif temp > target:
                    right -= 1
                elif temp < target:
                    left += 1
            return res
    ```

#### 3Sum问题
- 问题描述
    * 给你一个包含 n 个整数的数组 nums,判断 nums 中是否存在三个元素 a,b,c ,使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组.
- 思路
    * 特判,对于数组长度 n,如果数组为 null 或者数组长度小于 3,返回 [].
    * 对数组进行排序.
    * 遍历排序后数组：
    * 若 nums[i]>0：因为已经排序好,所以后面不可能有三个数加和等于 0,直接返回结果.
    * 对于重复元素：跳过,避免出现重复解
    * 令左指针 L=i+1,右指针 R=n−1,当 L<R 时,执行循环：
    * 当 nums[i]+nums[L]+nums[R]==0,执行循环,判断左界和右界是否和下一位置重复,去除重复解.并同时将 L,R 移到下一位置,寻找新的解
    * 若和大于 0,说明 nums[R] 太大,R 左移
    * 若和小于 0,说明 nums[L] 太小,L 右移
- 代码实现
    ```python
        class Solution:
            def threeSum(self, nums: List[int]) -> List[List[int]]:
                n=len(nums)
                res=[]
                if(not nums or n<3):
                    return []
                nums.sort()
                res=[]
                for i in range(n):
                    if(nums[i]>0):
                        return res
                    if(i>0 and nums[i]==nums[i-1]):
                        continue
                    L=i+1
                    R=n-1
                    while(L<R):
                        if(nums[i]+nums[L]+nums[R]==0):
                            res.append([nums[i],nums[L],nums[R]])
                            while(L<R and nums[L]==nums[L+1]):
                                L=L+1
                            while(L<R and nums[R]==nums[R-1]):
                                R=R-1
                            L=L+1
                            R=R-1
                        elif(nums[i]+nums[L]+nums[R]>0):
                            R=R-1
                        else:
                            L=L+1
                return res
    ```
