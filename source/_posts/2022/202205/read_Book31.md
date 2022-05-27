---
title: 读书笔记 (31)
date: 2022-05-15
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-双指针(数组)

<!-- more -->

#### 双指针
1. 左右指针: 两个指针相向而行或者相背而行
2. 快慢指针: 两个指针同向而行,一快一慢

#### 快慢指针技巧
- 删除有序数组中的重复项
    * 问题描述
        * 给你一个 升序排列 的数组 nums ,请你 原地 删除重复出现的元素,使每个元素 只出现一次 ,返回删除后数组的新长度.
    * 思路
        * 我们让慢指针 slow 走在后面,快指针 fast 走在前面探路,找到一个不重复的元素就赋值给 slow 并让 slow 前进一步.
    * 代码实现
        ```python
            class Solution:
                def removeDuplicates(self, nums: List[int]) -> int:
                    if not nums:
                        return 0
                    fast, slow = 0, 0
                    while fast < len(nums):
                        # 快慢指针
                        if nums[fast] != nums[slow]:
                            slow += 1
                            # 维护 nums[0..slow] 无重复
                            nums[slow] = nums[fast]
                        fast += 1
                    return slow + 1
        ```
- 删除排序链表中的重复元素
    * 问题描述
        * 有序列表去重
    * 思路
        * 和数组去重是一模一样的,唯一的区别是把数组赋值操作变成操作指针而已
    * 代码实现
        ```python
            # Definition for singly-linked list.
            # class ListNode:
            #     def __init__(self, val=0, next=None):
            #         self.val = val
            #         self.next = next
            class Solution:
                def deleteDuplicates(self, head: ListNode) -> ListNode:
                    if not head:
                        return None
                    fast, slow = head, head
                    while fast != None:
                        if fast.val != slow.val:
                            # nums[slow] = nums[fast]
                            slow.next = fast
                            # slow += 1
                            slow = slow.next
                        # fast++
                        fast = fast.next
                    # 断开与后面重复元素的连接
                    slow.next = None
                    return head
        ```
- 移除元素
    * 问题描述
        * 给你一个数组 nums 和一个值 val,你需要 原地 移除所有数值等于 val 的元素,并返回移除后数组的新长度.
    * 思路
        * 如果 fast 遇到值为 val 的元素,则直接跳过,否则就赋值给 slow 指针,并让 slow 前进一步
        * 注意这里和有序数组去重的解法有一个细节差异,我们这里是先给 nums[slow] 赋值然后再给 slow++,这样可以保证 nums[0..slow-1] 是不包含值为 val 的元素的,最后的结果数组长度就是 slow.
    * 代码实现
        ```python
            class Solution:
                def removeElement(self, nums: List[int], val: int) -> int:
                    slow = 0
                    fast = 0
                    while fast < len(nums):
                        if nums[fast] != val:
                            nums[slow] = nums[fast]
                            slow += 1
                        fast += 1
                    return slow
        ```
- 移动零
    * 问题描述
        * 给你输入一个数组 nums,请你原地修改,将数组中的所有值为 0 的元素移到数组末尾
    * 思路
        * 把非0的往前移动, 剩下的都再置为0
    * 代码实现
        ```python
            class Solution:
                def moveZeroes(self, nums: List[int]) -> None:
                    """
                    Do not return anything, modify nums in-place instead.
                    """
                    fast, slow = 0, 0
                    while fast < len(nums):
                        if nums[fast]:
                            nums[slow] = nums[fast]
                            slow += 1
                        fast += 1
                    for i in range(slow, len(nums)):
                        nums[i] = 0
                    return nums
        ```

#### 左右指针技巧
- 二分查找
    * eg
        ```python
            def binarySearch(nums, target):
                # 一左一右两个指针相向而行
                left, right = 0, len(nums) - 1
                while left <= right:
                    mid = left + (right - left) // 2
                    if nums[mid] == target:
                        return mid
                    elif nums[mid] > target:
                        # [left, mid-1]
                        right = mid - 1
                    elif nums[mid] < target:
                        # [mid+1, right]
                        left = mid + 1
                return -1
        ```
- 两数之后II
    * 问题描述
        * 给你一个下标从 1 开始的整数数组 numbers ,该数组已按 非递减顺序排列  ,请你从数组中找出满足相加之和等于目标数 target 的两个数
    * 思路
        * 只要数组有序,就应该想到双指针技巧.这道题的解法有点类似二分查找,通过调节 left 和 right 就可以调整 sum 的大小
    * 代码实现
        ```python
            class Solution:
                def twoSum(self, numbers: List[int], target: int) -> List[int]:
                    left, right = 0, len(numbers) - 1
                    while left <= right:
                        temp = numbers[left] + numbers[right]
                        if temp == target:
                            return [left + 1, right + 1]
                        elif temp > target:
                            # [left, right - 1]
                            right -= 1
                        elif temp < target:
                            # [left + 1, rihgt]
                            left += 1
                    return [-1, -1]
        ```
- 反转数组
    * 问题描述
        * 编写一个函数,其作用是将输入的字符串反转过来.输入字符串以字符数组 s 的形式给出.不要给另外的数组分配额外的空间,你必须原地修改输入数组、使用 O(1) 的额外空间解决这一问题
    * 思路
        * 左右指针
    * 代码实现
        ```python
            class Solution:
                def reverseString(self, s: List[str]) -> None:
                    """
                    Do not return anything, modify s in-place instead.
                    """
                    left, right = 0, len(s)-1
                    while left <= right:
                        s[left], s[right] = s[right], s[left]
                        left += 1
                        right -= 1
                    return s
        ```
- 回文串判断
    * 问题描述
        * 是否为回文串
    * 思路
        * 左右指针判断是否相等即可
    * 代码实现
        ```python
            def isPalindrome(s):
                left, right = 0, len(s):
                while left <= right:
                    if s[left] == s[right]:
                        left -= 1
                        right += 1
                    else:
                        return False
                return True
        ```
- 最长回文子串
    * 问题描述
        * 给你一个字符串 s,找到 s 中最长的回文子串
    * 思路
        * 从中心向两端扩散的双指针技巧
        * 如果回文串的长度为奇数,则它有一个中心字符；如果回文串的长度为偶数,则可以认为它有两个中心字符
        * 如果输入相同的 l 和 r,就相当于寻找长度为奇数的回文串,如果输入相邻的 l 和 r,则相当于寻找长度为偶数的回文串
    * 代码实现
        ```python
            class Solution:
                def longestPalindrome(self, s: str) -> str:
                    res = ""
                    def palindrome(s, l, r):
                        # 防止索引越界
                        while (l >= 0) and (r < len(s)) and (s[l] == s[r]):
                            # 双指针,向两边展开
                            l -= 1
                            r += 1
                        # 返回以 s[l] 和 s[r] 为中心的最长回文串
                        return s[l+1:r]
                    for i in range(len(s)):
                        # 以 s[i] 为中心的最长回文子串
                        s1 = palindrome(s, i, i)
                        # 以 s[i] 和 s[i+1] 为中心的最长回文子串
                        s2 = palindrome(s, i, i+1)
                        res = s1 if len(s1) > len(res) else res
                        res = s2 if len(s2) > len(res) else res
                    return res
        ```