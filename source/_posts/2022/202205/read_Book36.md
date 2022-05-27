---
title: 读书笔记 (36)
date: 2022-05-20
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-如何判断回文链表

<!-- more -->

#### 寻找回文字符串
- 核心代码
    ```python
        def palindrome(s, l, r):
            # 防止索引越界
            while (l >= 0) and (r < len(s)) and (s[l] == s[r]):
                # 双指针,向两边展开
                l -= 1
                r += 1
            # 返回以 s[l] 和 s[r] 为中心的最长回文串
            return s[l+1:r]
    ```

#### 判断一个字符串是不是回文串
- 核心代码
    ```python
        def isPalindrome(s):
            # 一左一右两个指针相向而行
            left = 0
            right = len(s) - 1;
            while (left < right):
                if s[left] != s[right]
                    return False
                left +=1
                right -= 1
            return True
    ```

#### 判断回文单链表
- 问题描述
    * 给你一个单链表的头节点 head ,请你判断该链表是否为回文链表.如果是,返回 true ；否则,返回 false
- 思路
    ![判断回文单链表](/img/20220520_1.gif)
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def isPalindrome(self, head: ListNode) -> bool:
                # 左侧指针
                self.left = head
                return self.traverse(head)
            
            def traverse(self, right):
                if not right:
                    return True
                res = self.traverse(right.next)
                # 后序遍历代码
                res = res and (right.val == self.left.val)
                self.left = self.left.next
                return res
    ```
- 优化空间复杂度
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def isPalindrome(self, head: ListNode) -> bool:
                fast, slow = head, head
                while fast and fast.next:
                    slow = slow.next
                    fast = fast.next.next
                # 防止是奇数
                if fast:
                    slow = slow.next
                left = head
                right = self.reverse(slow)
                while right:
                    if left.val != right.val:
                        return False
                    left = left.next
                    right = right.next
                return True

            def reverse(self, head):
                if not head:
                    return head
                cur = head
                pre = None
                while cur:
                    temp = cur.next
                    cur.next = pre
                    pre = cur
                    cur = temp
                return pre
    ```
