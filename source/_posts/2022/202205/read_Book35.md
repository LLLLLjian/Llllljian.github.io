---
title: 读书笔记 (35)
date: 2022-05-19
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-如何K个一组反转链表

<!-- more -->

#### 如何K个一组反转链表
- 问题描述
    * 给你链表的头节点 head ,每 k 个节点一组进行翻转,请你返回修改后的链表.k 是一个正整数,它的值小于或等于链表的长度.如果节点总数不是 k 的整数倍,那么请将最后剩余的节点保持原有顺序.你不能只是单纯的改变节点内部的值,而是需要实际进行节点交换.
- 思路
    * 不要觉得是困难就做不下去
    * 分解成子问题
        * 先反转以head开头的k个元素
            * 可以先写出来反转整个链表
            * 然后再改变条件实现反转部分链表
        * 将第 k + 1 个元素作为 head 递归调用 reverseKGroup 函数
        * 将上述两个过程的结果连接起来.
    * base case: 元素不足k个, 将剩余节点保持原有顺序
- 代码实现-翻转整个链表
    ```python
        def reverse(head):
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
- 代码实现-反转部分链表
    ```python
        # 只要改变迭代条件即可
        def reverse(head, head1):
            if not head:
                return head
            cur = head
            pre = None
            while cur != head1:
                temp = cur.next
                cur.next = pre
                pre = cur
                cur = temp
            return pre
    ```
- 代码实现-完整代码
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
                if not head:
                    return head
                a, b = head, head
                for i in range(k):
                    # 不足 k 个,不需要反转,base case
                    if b:
                        b = b.next
                    else:
                        return head
                # 反转前k个
                newHead = self.reverse(a, b)
                # 递归反转后续链表并连接起来
                a.next = self.reverseKGroup(b, k)
                return newHead

            def reverse(self, head, n):
                """
                反转head直到n
                """
                if not head:
                    return head
                cur = head
                pre = None
                while cur != n:
                    temp = cur.next
                    cur.next = pre
                    pre = cur
                    cur = temp
                return pre
    ```

