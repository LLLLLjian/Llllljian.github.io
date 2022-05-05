---
title: Interview_总结 (158)
date: 2022-04-27
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 删除排序链表中的重复元素
- 问题描述
    * 给定一个已排序的链表的头 head , 删除所有重复的元素,使每个元素只出现一次 .返回 已排序的链表 .
- 思路
    * 迭代判断就可以了
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def deleteDuplicates(self, head: ListNode) -> ListNode:
                if not head:
                    return head
                cur = head
                while cur and cur.next:
                    if cur.val == cur.next.val:
                        cur.next = cur.next.next
                    else:
                        cur = cur.next
                return head
    ```

#### 合并两个有序数组
- 问题描述
    * 给你两个按 非递减顺序 排列的整数数组 nums1 和 nums2,另有两个整数 m 和 n ,分别表示 nums1 和 nums2 中的元素数目.请你 合并 nums2 到 nums1 中,使合并后的数组同样按 非递减顺序 排列.注意：最终,合并后数组不应由函数返回,而是存储在数组 nums1 中.为了应对这种情况,nums1 的初始长度为 m + n,其中前 m 个元素表示应合并的元素,后 n 个元素为 0 ,应忽略.nums2 的长度为 n .
- 思路
    * 从后往前就可以了
- 代码实现
    ```python
        class Solution:
            def merge(self, nums1: List[int], m: int, nums2: List[int], n: int) -> None:
                """
                Do not return anything, modify nums1 in-place instead.
                """
                p1, p2 = m - 1, n - 1
                tail = m + n - 1
                while p1 >= 0 or p2 >= 0:
                    if p1 == -1:
                        nums1[tail] = nums2[p2]
                        p2 -= 1
                    elif p2 == -1:
                        nums1[tail] = nums1[p1]
                        p1 -= 1
                    elif nums1[p1] > nums2[p2]:
                        nums1[tail] = nums1[p1]
                        p1 -= 1
                    else:
                        nums1[tail] = nums2[p2]
                        p2 -= 1
                    tail -= 1
    ```

#### 验证回文串
- 问题描述
    * 给定一个字符串,验证它是否是回文串,只考虑字母和数字字符,可以忽略字母的大小写.
- 思路
    * 左右指针往中间
- 代码实现
    ```python
        class Solution:
            def isPalindrome(self, s: str) -> bool:
                if not s:
                    return True
                l, r = 0, len(s)-1
                while l < r:
                    if not s[l].isalnum():
                        l += 1
                        continue
                    if not s[r].isalnum():
                        r -= 1
                        continue
                    if s[l].lower() == s[r].lower():
                        l += 1
                        r -= 1
                    else:
                        return False
                return True
    ```

#### 只出现一次的数字
- 问题描述
    * 给定一个非空整数数组,除了某个元素只出现一次以外,其余每个元素均出现两次.找出那个只出现了一次的元素.
- 思路
    * 位运算
- 代码实现
    ```python
        class Solution:
            def singleNumber(self, nums: List[int]) -> int:
                res = 0
                for num in nums:
                    res ^= num
                return res
    ```

#### 环形链表
- 问题描述
    * 判断链表是否有环
- 思路
    * 快慢指针
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def hasCycle(self, head: Optional[ListNode]) -> bool:
                if not head:
                    return False
                slow = head
                fast = head
                while True:
                    if slow.next:
                        slow = slow.next
                    else:
                        break
                    if fast.next and fast.next.next:
                        fast = fast.next.next
                    else:
                        break
                    if fast == slow:
                        return True
                return False
    ```




