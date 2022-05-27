---
title: 读书笔记 (34)
date: 2022-05-18
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-递归魔法：反转单链表

<!-- more -->

#### 递归反转整个链表
- 问题描述
    * 给你单链表的头节点 head ,请你反转链表,并返回反转后的链表.
- 思路
    * 迭代我记住了, 这里主要看一下递归
    * 设置base case, 如果链表为空或者只有一个节点的时候,反转结果就是它自己,直接返回即可
    * last = self.reverseList(head.next)
    ![递归第一步](/img/20220518_1.png)
    ![递归第二步](/img/20220518_2.png)
    * head.next.next = head
    ![递归第三步](/img/20220518_3.png)
    * head.next = None
    * return last
    ![递归第四步](/img/20220518_4.png)
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseList(self, head: ListNode) -> ListNode:
                """
                递归
                """
                if (not head) or (not head.next):
                    return head
                last = self.reverseList(head.next)
                head.next.next = head
                head.next = None
                return last
            def reverseList(self, head: ListNode) -> ListNode:
                """
                迭代
                """
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

#### 反转链表前N个节点
- 问题描述
    * 反转以 head 为起点的 n 个节点,返回新的头结点
- 思路
    * 本题的关键是要记录n+1个节点, 把它放在successor里
    ![关键一步](/img/20220518_4.png)
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def __init(self):
                self.successor = None
            def reverseN(self, head, n):
                """
                反转以 head 为起点的 n 个节点,返回新的头结点
                """
                if n == 1:
                    # 记录n+1个节点
                    self.successor = head.next
                    return head
                # 以 head.next 为起点,需要反转前 n - 1 个节点
                last = self.reverseN(head.next, n-1)
                head.next.next = head
                # 让反转之后的 head 节点和后面的节点连起来
                head.next = self.successor
                return last
    ```

#### 反转链表的一部分
- 问题描述
    * 给你单链表的头指针 head 和两个整数 left 和 right ,其中 left <= right .请你反转从位置 left 到位置 right 的链表节点,返回 反转后的链表 .
- 思路
    * 当m=1时, 那就是反转以 head 为起点的 n 个节点
    * 如果m!=1, 那就先反转以head.next为起点的 m-1,到n-1个节点, 一直到m=1
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def __init__(self):
                # 后驱节点
                self.successor = None
            def reverseN(self, head, n):
                """
                反转以 head 为起点的 n 个节点,返回新的头结点
                """
                if n == 1:
                    # 记录n+1个节点
                    self.successor = head.next
                    return head
                # 以 head.next 为起点,需要反转前 n - 1 个节点
                last = self.reverseN(head.next, n-1)
                head.next.next = head
                # 让反转之后的 head 节点和后面的节点连起来
                head.next = self.successor
                return last
            def reverseBetween(self, head: ListNode, left: int, right: int) -> ListNode:
                # base case
                if left == 1:
                    return self.reverseN(head, right)
                # 前进到反转的起点触发 base case
                head.next = self.reverseBetween(head.next, left-1, right-1)
                return head
    ```



