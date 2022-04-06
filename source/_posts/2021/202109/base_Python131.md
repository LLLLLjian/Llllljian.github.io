---
title: Python_基础 (131)
date: 2021-09-28
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### python之两数之和
- Q
    * nums = [2, 7, 11, 15]
    * targer = 9
    * result = [0, 1]
- A
    ```python
        class Solution:
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                """
                执行用时 564 ms
                内存消耗 15.2 MB	
                """
                for key in range(len(nums)):
                    value = nums[key]
                    tmp_value = target - value
                    if tmp_value in nums:
                        tmp_key = nums.index(tmp_value)
                        if tmp_key == key:
                            continue
                        else:
                            return [key, tmp_key]
                            break
                    else:
                        continue

        class Solution:
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                """
                执行用时 32 ms
                内存消耗 15.2 MB
                """
                hashmap={}
                for ind,num in enumerate(nums):
                    hashmap[num] = ind
                for i,num in enumerate(nums):
                    j = hashmap.get(target - num)
                    if j is not None and i!=j:
                        return [i,j]
    ```





