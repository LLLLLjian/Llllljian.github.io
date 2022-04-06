---
title: Leetcode_基础 (185)
date: 2022-01-04
tags: Leetcode
toc: true
---

### 今日被问傻系列
    leetcode

<!-- more -->

#### 两数之和
- Q
    ```
        给定一个整数数组 nums 和一个整数目标值 target, 请你在该数组中找出 和为目标值 target  的那 两个 整数, 并返回它们的数组下标.
        你可以假设每种输入只会对应一个答案.但是, 数组中同一个元素在答案里不能重复出现.
        你可以按任意顺序返回答案.
    ```
- T
    * 思路其实很简单, 就是计算一下差在不在给的nums里, 在的话就返回, 不在的话就往后
- A
    ```python
        class Solution:
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                """
                执行用时 32 ms
                内存消耗 15.2 MB
                """
                hashmap={}
                for ind,num in enumerate(nums):
                    hashmap[num] = ind
                for i,num in enumerate(nums):
                    j = hashmap.get(target - num)
                    if j is not None and i!=j:
                        return [i,j]
    ```

#### 反转链表
- Q
    ```
        1->2->3->4 => 4->3->2->1
    ```
- T
    * 保存下一个节点, 维护当前节点
- A
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseList(self, head: ListNode) -> ListNode:
                if (head == None) or (head.next == None):
                    return head
                else:
                    pre = None
                    cur = head
                    while cur != None:
                        tmp = cur.next
                        cur.next = pre
                        pre = cur
                        cur = tmp
                    return pre
    ```

#### 链表是否有环
- Q
    * 给一个链表 判断是否有环
- T
    * 追击问题, 我觉得快慢指针就挺好的
- A
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def hasCycle(self, head: Optional[ListNode]) -> bool:
                """
                判断快的有没有走完 没走完的话 判断是否和慢的相等
                """
                if (head == None) or (head.val == None) or (head.next == None):
                    return False
                fastNode = head
                slowNode = head
                while (fastNode != None):
                    fastNode = fastNode.next
                    if fastNode != None:
                        fastNode = fastNode.next
                    if fastNode == slowNode:
                        return True
                    slowNode = slowNode.next
                return False

            def hasCycle1(self, head: Optional[ListNode]) -> bool:
                """
                其实和上边是一样的 不同写法而已
                """
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




