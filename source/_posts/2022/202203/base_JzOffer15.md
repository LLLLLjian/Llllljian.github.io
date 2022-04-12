---
title: 剑指Offer_基础 (15)
date: 2022-03-24
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 两两交换链表中的节点
- 问题描述
    * 给你一个链表,两两交换其中相邻的节点,并返回交换后链表的头节点.你必须在不修改节点内部的值的情况下完成本题(即,只能进行节点交换)
- 解题思路
    * 1 2 3 =>  2 1 3
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def swapPairs(self, head: ListNode) -> ListNode:
                """
                递归
                """
                if not head or not head.next:
                    return head
                oneHead = head
                twoHead = oneHead.next
                threeHead = twoHead.next
            
                twoHead.next = oneHead
                oneHead.next = self.swapPairs(threeHead)
                return twoHead

        class Solution:
            def swapPairs(self, head: ListNode) -> ListNode:
                dummyHead = ListNode(0)
                dummyHead.next = head
                oneHead = dummyHead
                while oneHead.next and oneHead.next.next:
                    twoHead = oneHead.next
                    threeHead = oneHead.next.next
                    oneHead.next = threeHead
                    twoHead.next = threeHead.next
                    threeHead.next = twoHead
                    oneHead = twoHead 
                return dummyHead.next
    ```

#### k个一组翻转链表
- 问题描述
    * 
- 解题思路
    * 
- 代码实现
    ```python
        class Solution:
            # 翻转一个子链表,并且返回新的头与尾
            def reverse(self, head: ListNode, tail: ListNode):
                prev = tail.next
                p = head
                while prev != tail:
                    nex = p.next
                    p.next = prev
                    prev = p
                    p = nex
                return tail, head

            def reverseKGroup(self, head: ListNode, k: int) -> ListNode:
                hair = ListNode(0)
                hair.next = head
                pre = hair

                while head:
                    tail = pre
                    # 查看剩余部分长度是否大于等于 k
                    for i in range(k):
                        tail = tail.next
                        if not tail:
                            return hair.next
                    nex = tail.next
                    head, tail = self.reverse(head, tail)
                    # 把子链表重新接回原链表
                    pre.next = head
                    tail.next = nex
                    pre = tail
                    head = tail.next
                
                return hair.next
    ```




