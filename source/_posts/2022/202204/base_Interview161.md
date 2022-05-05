---
title: Interview_总结 (161)
date: 2022-04-30
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 环形链表
- 问题描述
    * 给你一个链表的头节点 head ,判断链表中是否有环.
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
                fast = head
                slow = head
                while True:
                    if fast.next and fast.next.next:
                        fast = fast.next.next
                    else:
                        break
                    if slow.next:
                        slow = slow.next
                    else:
                        break
                    if slow == fast:
                        return True
                return False
    ```

#### 最小栈
- 问题描述
    设计一个支持 push ,pop ,top 操作,并能在常数时间内检索到最小元素的栈.
    实现 MinStack 类:
    MinStack() 初始化堆栈对象.
    void push(int val) 将元素val推入堆栈.
    void pop() 删除堆栈顶部的元素.
    int top() 获取堆栈顶部的元素.
    int getMin() 获取堆栈中的最小元素.
- 思路
    * 两个数组, 最小栈中维护的是 1-9 顺序的数组
- 代码实现
    ```python
        class MinStack:
            def __init__(self):
                self.list1 = []
                self.list2 = []

            def push(self, val: int) -> None:
                self.list1.append(val)
                if (not self.list2) or (val <= self.list2[-1]):
                    self.list2.append(val)

            def pop(self) -> None:
                temp = self.list1.pop()
                if temp == self.list2[-1]:
                    self.list2.pop()
                return temp

            def top(self) -> int:
                return self.list1[-1]

            def getMin(self) -> int:
                if not self.list2:
                    return None
                return self.list2[-1]

        # Your MinStack object will be instantiated and called as such:
        # obj = MinStack()
        # obj.push(val)
        # obj.pop()
        # param_3 = obj.top()
        # param_4 = obj.getMin()
    ```

#### 相交链表
- 问题描述
    * 给你两个单链表的头节点 headA 和 headB ,请你找出并返回两个单链表相交的起始节点.如果两个链表不存在相交节点,返回 null .
- 思路
    * 两个链表比较长短, 长的要向短的靠齐, 保证两个链表一样长, 然后一块往前走
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
                m, n, tempA, tempB = 0, 0, headA, headB
                while tempA:
                    m += 1
                    tempA = tempA.next
                while tempB:
                    n += 1
                    tempB = tempB.next
                if m > n:
                    for i in range(m-n):
                        headA = headA.next
                else:
                    for i in range(n-m):
                        headB = headB.next
                
                res = None
                while headA and headB:
                    if headA == headB:
                        res = headA
                        break
                    else:
                        headA = headA.next
                        headB = headB.next
                return res
    ```

#### 多数元素
- 问题描述
    * 给定一个大小为 n 的数组 nums ,返回其中的多数元素.多数元素是指在数组中出现次数 大于 ⌊ n/2 ⌋ 的元素.
- 思路
    * 自杀法, 相当于最多的那个元素, 不管怎么自杀, 他一定是活到最后的那个
- 代码实现
    ```python
        class Solution:
            def majorityElement(self, nums: List[int]) -> int:
                v = 0
                for num in nums:
                    if v == 0:
                        x = num
                    if x == num:
                        v += 1
                    else:
                        v -= 1
                return x
    ```

#### 反转链表
- 问题描述
    * 给你单链表的头节点 head ,请你反转链表,并返回反转后的链表.
- 思路
    * 
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseList(self, head: ListNode) -> ListNode:
                if not head:
                    return None
                cur = head
                pre = None
                while cur:
                    temp = cur.next
                    cur.next = pre
                    pre = cur
                    cur = temp
                return pre
    ```
