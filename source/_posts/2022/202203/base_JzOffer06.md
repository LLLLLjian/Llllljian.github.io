---
title: 剑指Offer_基础 (06)
date: 2022-03-02
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### O(1)时间删除链表节点
- 题目描述
    * 给定单向链表的头指针和一个节点指针, 在 O(1)时间复杂度内删除该节点.
- 思路
    * 将要删除节点的下一个节点的值赋给要删除的节点, 然后指向下下一个节点
- 代码实现
    ```python
        class Solution:
            def deleteNode(self, head: ListNode, val: int) -> ListNode:
                """ 
                快慢指针
                """
                if head.val == val: return head.next
                pre, cur = head, head.next
                while cur and cur.val != val:
                    pre, cur = cur, cur.next
                if cur: pre.next = cur.next
                return head
        
        class Solution:
            def deleteNode(self, head: ListNode, val: int) -> ListNode:
                """
                递归
                """
                if head.val == val: return head.next
                head.next = self.deleteNode(head.next, val)
                return head
    ```

#### 将数组中的奇数放在偶数前
- 题目描述
    * 输入一个整数数组, 实现一个函数来调整该数组中数字的顺序, 使得 所有的奇数位于数组的前半部分, 所有的偶数位于位于数组的后半部分, 并保证奇 数和奇数, 偶数和偶数之间的相对位置不变
- 思路
    * 初始化： i, j 双指针, 分别指向数组 nums 左右两端；
    * 循环交换： 当 i = j 时跳出；
    * 指针 i 遇到奇数则执行 i=i+1 跳过, 直到找到偶数；
    * 指针 j 遇到偶数则执行 j=j−1 跳过, 直到找到奇数；
    * 交换 nums[i] 和 nums[j] 值；
    * 返回值： 返回已修改的 nums 数组.
- 代码实现
    * 时间复杂度 O(n), 空间复杂度 O(1)
    ```python
        class Solution:
            def exchange(self, nums: List[int]) -> List[int]:
                i, j = 0, len(nums) - 1
                while i < j:
                    while i < j and nums[i] & 1 == 1: i += 1
                    while i < j and nums[j] & 1 == 0: j -= 1
                    nums[i], nums[j] = nums[j], nums[i]
                return nums
    ```

#### 求链表中倒数第 K 个节点
- 题目描述
    * 输入一个链表, 输出该链表中倒数第 k 个结点.
- 思路
    * 定义一快一慢两个指针, 快指针走 K 步, 然后慢指针开始走, 快指针到尾 时, 慢指针就找到了倒数第 K 个节点.
- 代码实现
    * 时间复杂度:O(n), 空间复杂度:O(1)
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def kthToLast(self, head: ListNode, k: int) -> int:
                pre, cur = head, head
                for _ in range(k):
                    cur = cur.next
                while cur:
                    pre, cur = pre.next, cur.next
                return pre.val
    ```

#### 链表中倒数第k个节点
- 题目描述
    ```
        输入一个链表, 输出该链表中倒数第k个节点.为了符合大多数人的习惯, 本题从1开始计数, 即链表的尾节点是倒数第1个节点.
        例如, 一个链表有 6 个节点, 从头节点开始, 它们的值依次是 1、2、3、4、5、6.这个链表的倒数第 3 个节点是值为 4 的节点.

        给定一个链表: 1->2->3->4->5, 和 k = 2.

        返回链表 4->5.
    ```
- 思路
    * 定义一快一慢两个指针, 快指针走 K 步, 然后慢指针开始走, 快指针到尾 时, 慢指针就找到了倒数第 K 个节点.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def getKthFromEnd(self, head: ListNode, k: int) -> ListNode:
                slow, fast = head, head
                for _ in range(k):
                    fast = fast.next
                while fast:
                    fast = fast.next
                    slow = slow.next
                return slow
    ```

#### 删除链表的倒数第n个结点
- 题目描述
    ```
        给定一个链表, 删除链表的倒数第 n 个结点, 并且返回链表的头结点.

        输入：head = [1,2,3,4,5], n = 2
        输出：[1,2,3,5]
    ```
- 思路
    * 还是快慢指针, 但是需要加一个头节点
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def removeNthFromEnd(self, head: ListNode, n: int) -> ListNode:
                dummy = ListNode(0, head)
                left, right = dummy, head
                n -= 1
                while n: # 快慢指针, 快指针先走
                    n -= 1
                    right = right.next
                
                while right.next: # 慢指针跟上
                    right = right.next
                    left = left.next
                
                left.next = left.next.next # 删除节点
                return dummy.next
    ```

