---
title: 剑指Offer_基础 (14)
date: 2022-03-23
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 反转链表
- 代码
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def reverseList(self, head: ListNode) -> ListNode:
                if not head:
                    return head
                cur = head
                pre = None
                while cur:
                    next = cur.next
                    cur.next = pre
                    pre = cur
                    cur = next
                return pre
    ```

#### 反转链表II
- 问题描述
    * 给你单链表的头指针 head 和两个整数 left 和 right ,其中 left <= right .请你反转从位置 left 到位置 right 的链表节点,返回 反转后的链表 .
- 代码
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseBetween(self, head: ListNode, left: int, right: int) -> ListNode:
                """
                leftNode + revNode + rightNode
                """
                def reverse(node):
                    if not node:
                        return node
                    cur = node
                    pre = None
                    while cur:
                        next = cur.next
                        cur.next = pre
                        pre = cur
                        cur = next
                    return pre
                # 初始化
                dumpNode = curNode = ListNode(-1)
                curNode.next = head
                # 找 leftNode
                for _ in range(left-1):
                    curNode = curNode.next
                leftNode = curNode
                # 找 revNode
                revNode = curNode.next
                # 找 rightNode
                for _ in range(right-left+1):
                    curNode = curNode.next
                rightNode = curNode.next
                curNode.next = None
                # 反转
                leftNode.next = reverse(revNode)
                revNode.next = rightNode
                return dumpNode.next

        class Solution:
            def reverseBetween(self, head: ListNode, left: int, right: int) -> ListNode:
                # 设置 dummyNode 是这一类问题的一般做法
                dummy_node = ListNode(-1)
                dummy_node.next = head
                pre = dummy_node
                for _ in range(left - 1):
                    pre = pre.next

                cur = pre.next
                for _ in range(right - left):
                    next = cur.next
                    cur.next = next.next
                    next.next = pre.next
                    pre.next = next
                return dummy_node.next
    ```
