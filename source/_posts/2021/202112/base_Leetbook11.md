---
title: Leetbook_基础 (11)
date: 2021-12-28
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 反转字符串中的单词 III
- Q
    ```
        给定一个字符串, 你需要反转字符串中每个单词的字符顺序, 同时仍保留空格和单词的初始顺序
        示例：
        输入："Let's take LeetCode contest"
        输出："s'teL ekat edoCteeL tsetnoc"

        提示：
        在字符串中, 每个单词由单个空格分隔, 并且字符串中不会有任何额外的空格
    ```
- T
    * 按空格分割, 然后数组项反转, 去掉最后一项再拼接
- A
    ```python
        class Solution:
            def reverseWords(self, s: str) -> str:
                s = s.split(' ')
                s = [i[::-1]+' ' for i in s]
                return ''.join(s)[:-1]
    ```

#### 寻找旋转排序数组中的最小值
- Q
    ```
        已知一个长度为 n 的数组, 预先按照升序排列, 经由 1 到 n 次 旋转 后, 得到输入数组.例如, 原数组 nums = [0,1,2,4,5,6,7] 在变化后可能得到：
        若旋转 4 次, 则可以得到 [4,5,6,7,0,1,2]
        若旋转 7 次, 则可以得到 [0,1,2,4,5,6,7]
        注意, 数组 [a[0], a[1], a[2], ..., a[n-1]] 旋转一次 的结果为数组 [a[n-1], a[0], a[1], a[2], ..., a[n-2]] .

        给你一个元素值 互不相同 的数组 nums , 它原来是一个升序排列的数组, 并按上述情形进行了多次旋转.请你找出并返回数组中的 最小元素 .

        示例 1：
        输入：nums = [3,4,5,1,2]
        输出：1
        解释：原数组为 [1,2,3,4,5] , 旋转 3 次得到输入数组.
        示例 2：
        输入：nums = [4,5,6,7,0,1,2]
        输出：0
        解释：原数组为 [0,1,2,4,5,6,7] , 旋转 4 次得到输入数组.
        示例 3：
        输入：nums = [11,13,15,17]
        输出：11
        解释：原数组为 [11,13,15,17] , 旋转 4 次得到输入数组.

        提示：
        n == nums.length
        1 <= n <= 5000
        -5000 <= nums[i] <= 5000
        nums 中的所有整数 互不相同
        nums 原来是一个升序排序的数组, 并进行了 1 至 n 次旋转
    ```
- T
    * 二分查找, 时间复杂度O(log2 n)
- A
    ```python
        class Solution:
            def findMin(self, nums: List[int]) -> int:
                left, right = 0, len(nums) - 1
                while left < right:
                    mid = (left + right) >> 1
                    if nums[mid] > nums[right]:         
                        left = mid + 1
                    else:                               
                        right = mid
                return nums[left]
    ``





