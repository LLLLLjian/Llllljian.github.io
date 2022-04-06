---
title: Leetbook_基础 (7)
date: 2021-12-22
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 双指针技巧
> 头尾指针
- 数组拆分 I
    * Q
        ```
            给定长度为 2n 的整数数组 nums , 你的任务是将这些数分成 n 对, 例如 (a1, b1), (a2, b2), ..., (an, bn) , 使得从 1 到 n 的 min(ai, bi) 总和最大.
            返回该 最大总和

            示例 1
            输入：nums = [1,4,3,2]
            输出：4
            解释：所有可能的分法(忽略元素顺序)为：
            1. (1, 4), (2, 3) -> min(1, 4) + min(2, 3) = 1 + 2 = 3
            2. (1, 3), (2, 4) -> min(1, 3) + min(2, 4) = 1 + 2 = 3
            3. (1, 2), (3, 4) -> min(1, 2) + min(3, 4) = 1 + 3 = 4
            所以最大总和为 4
            示例 2
            输入：nums = [6,2,6,5,1,2]
            输出：9
            解释：最优的分法为 (2, 1), (2, 5), (6, 6). min(2, 1) + min(2, 5) + min(6, 6) = 1 + 2 + 6 = 9
        ```
    * T
        * 其实就是排序后取奇数位, 加起来就是最大
    * A
        ```python
            class Solution:
                def arrayPairSum(self, nums: List[int]) -> int:
                    nums.sort()
                    return sum(nums[::2])
        ```
- 两数之和 II - 输入有序数组
    * Q
        ```
            给定一个已按照 非递减顺序排列 的整数数组 numbers , 请你从数组中找出两个数满足相加之和等于目标数 target .

            函数应该以长度为 2 的整数数组的形式返回这两个数的下标值.numbers 的下标 从 1 开始计数 , 所以答案数组应当满足 1 <= answer[0] < answer[1] <= numbers.length .

            你可以假设每个输入 只对应唯一的答案 , 而且你 不可以 重复使用相同的元素.

             
            示例 1：

            输入：numbers = [2,7,11,15], target = 9
            输出：[1,2]
            解释：2 与 7 之和等于目标数 9 .因此 index1 = 1, index2 = 2 .
            示例 2：

            输入：numbers = [2,3,4], target = 6
            输出：[1,3]
            示例 3：

            输入：numbers = [-1,0], target = -1
            输出：[1,2]
        ```
    * T
        * 我想的是双指针, 一个在前一个在后, 算了和之后大了右指针往前, 小了左指针往后
    * A
        ```python
            class Solution:
                def twoSum(self, numbers: List[int], target: int) -> List[int]:
                    start, end = 0, len(numbers) - 1
                    if numbers[start] > target:
                        return []
                    while start < end:
                        if (numbers[start] + numbers[end]) == target:
                            return [start + 1, end + 1]
                        elif (numbers[start] + numbers[end]) > target:
                            end -= 1
                        else:
                            start += 1
                    return []
        ```

