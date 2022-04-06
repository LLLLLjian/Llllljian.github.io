---
title: 剑指Offer_基础 (07)
date: 2022-03-03
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 输出反转后的链表
- 题目描述
    * 输入一个链表, 反转链表后, 输出新链表的表头
- 思路
    * 定义两个指针, 反向输出
- 代码实现
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
                    tmp = cur.next
                    cur.next = pre
                    pre = cur
                    cur = tmp
                return pre
    ```

#### 合并两个有序链表
- 题目描述
    * 输入两个单调递增的链表, 输出两个链表合成后的链表, 当然我们需要合成后的链表满足单调不减规则
- 思路
    * 递归与非递归求解, 小数放在前面
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
                """
                迭代
                """
                prehead = ListNode(-1)

                prev = prehead
                while l1 and l2:
                    if l1.val <= l2.val:
                        prev.next = l1
                        l1 = l1.next
                    else:
                        prev.next = l2
                        l2 = l2.next            
                    prev = prev.next

                # 合并后 l1 和 l2 最多只有一个还未被合并完, 我们直接将链表末尾指向未合并完的链表即可
                prev.next = l1 if l1 is not None else l2

                return prehead.next

            def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
                """
                递归
                """
                if l1 is None:
                    return l2
                elif l2 is None:
                    return l1
                elif l1.val < l2.val:
                    l1.next = self.mergeTwoLists(l1.next, l2)
                    return l1
                else:
                    l2.next = self.mergeTwoLists(l1, l2.next)
                    return l2
    ```

