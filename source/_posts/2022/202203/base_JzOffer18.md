---
title: 剑指Offer_基础 (18)
date: 2022-03-30
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 只出现一次的数字
- 问题描述
    * 给定一个非空整数数组,除了某个元素只出现一次以外,其余每个元素均出现两次.找出那个只出现了一次的元素.
- 解题思路
    * 任何数和 0 做异或运算,结果仍然是原来的数,即 a ^ 0 = a
    * 任何数和其自身做异或运算,结果是 0,即 a ^ a = 0
    * 异或运算满足交换律和结合律,a ^ b ^ c ^ a ^ b = (a ^ a) ^ (b ^ b) ^ c = 0 ^ 0 ^ c = c
- 代码实现
    ```python
        class Solution:
            def singleNumber(self, nums: List[int]) -> int:
                res = 0
                for num in nums:
                    res ^= num
                return res
    ```

#### 只出现一次的数字 II
- 问题描述
    * 给你一个整数数组 nums ,除某个元素仅出现 一次 外,其余每个元素都恰出现三次 .请你找出并返回那个只出现了一次的元素.
- 解题思路
    * 某个数出现了三次, 转换成二进制之后 说明每个位置上的1都能被3整除, 整除不了的就是多的
    * 这样做的好处是如果题目改成K个一样,只需要把代码改成cnt%k,很通用
- 代码实现
    ```python
        class Solution:
            def singleNumber(self, nums: List[int]) -> int:
                res = 0
                for i in range(32):
                    mask = 1 << i
                    cnt = 0
                    for num in nums:
                        # 按位与 相当于判断一下每一个数 在1-32位上哪一位是1
                        if (num & mask) != 0 :
                            cnt += 1
                    # 如果不能被3整除 说明这个位多了一个
                    if (cnt % 3) != 0:
                        # 那就把这一位 按位或 到结果里
                        res |= mask
                if (res > pow(2, 31) - 1):
                    return res - pow(2, 32)
                else:
                    return res
    ```

#### 只出现一次的数字 III
- 问题描述
    * 给定一个整数数组 nums,其中恰好有两个元素只出现一次,其余所有元素均出现两次. 找出只出现一次的那两个元素.你可以按 任意顺序 返回答案.
- 解题思路
    * ans = a ^ b, 取出ans最后一个1的位置, 然后分别和num异或就得到了两个数了
- 代码实现
    ```python
        class Solution:
            def singleNumber(self, nums: List[int]) -> List[int]:
                # 所有出现两次的相同元素,相互异或为0,那么全部异或得到最终答案的两个数的异或结果
                # 这个异或结果可以告诉我们他们俩哪些位是不同的
                ans = 0
                for num in nums:
                    ans ^= num
                ans &= -ans
                ans1 = ans2 = 0
                for num in nums:
                    # 根据这位1将所有num分成两组,两个不同的数会在两组,其他仍然是相同的
                    if num & ans:
                        ans1 ^= num
                    else:
                        ans2 ^= num
                return [ans1, ans2]
    ```
