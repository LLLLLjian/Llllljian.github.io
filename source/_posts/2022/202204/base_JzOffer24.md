---
title: 剑指Offer_基础 (24)
date: 2022-04-21
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 链表是否有环
- 问题描述
    * 链表是否有环
- 思路
    * 双指针 快慢指针
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None
        class Solution:
            def hasCycle(self, head: Optional[ListNode]) -> bool:
                if (head == None) or (head.next == None):
                    return False
                fastNode = head.next
                slowNode = head
                while (slowNode != fastNode):
                    if (fastNode == None) or (fastNode.next == None):
                        return False
                    slowNode = slowNode.next
                    fastNode = fastNode.next.next
                return True
    ```

#### 链表的入环节点
- 问题描述
    * 链表入环节点
- 思路
    * head到入环为a, 入环到相遇为b, b到入环为c
    * slow * 2 = fast;
    * slow = a + b;
    * fast = a + b + c + b = a + 2*b + c;
    * (a + b)\*2 = a + 2*b + c;
    * a = c;
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution(object):
            def detectCycle(self, head):
                fast, slow = head, head
                while True:
                    if not (fast and fast.next): return
                    fast, slow = fast.next.next, slow.next
                    if fast == slow: break
                fast = head
                while fast != slow:
                    fast, slow = fast.next, slow.next
                return fast
    ```

#### 有环链表的环长
- 问题描述
    * 有环链表的环长
- 思路
    * 第一次相遇之后, 两个人按照你1步我2步的速度, 再次相遇就是环长
- 代码实现
    ```python
        class Solution(object):
            def detectCycle(self, head):
                fast, slow = head, head
                while True:
                    if not (fast and fast.next): return
                    fast, slow = fast.next.next, slow.next
                    if fast == slow: break
                slow = slow.next
                fast = fast.next.next
                len = 1
                while fast != slow:
                    len += 1
                    fast, slow = fast.next.next, slow.next
                return len
    ```

#### 有环链表的总长
> 环长+head到入环的长



