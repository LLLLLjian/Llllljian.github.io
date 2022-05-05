---
title: Interview_总结 (159)
date: 2022-04-28
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 两数之和
- 问题描述
    * 给定一个整数数组 nums 和一个整数目标值 target,请你在该数组中找出 和为目标值 target  的那 两个 整数,并返回它们的数组下标.你可以假设每种输入只会对应一个答案.但是,数组中同一个元素在答案里不能重复出现.你可以按任意顺序返回答案.
- 思路
    * 哈希判断
- 代码实现
    ```python
        class Solution:
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                res = {}
                if not nums:
                    return []
                for i in range(len(nums)):
                    temp = target - nums[i]
                    if temp in res:
                        return [res[temp], i]
                    else:
                        res[nums[i]] = i
                return []
    ```

#### 有效的括号
- 问题描述
    * 给定一个只包括 '(',')','{','}','[',']' 的字符串 s ,判断字符串是否有效.有效字符串需满足：左括号必须用相同类型的右括号闭合.左括号必须以正确的顺序闭合.
- 思路
    * 左括号入栈, 右括号的话取栈顶元素进行比较, 相同就出栈, 不同返回false
- 代码实现
    ```python
        class Solution:
            def isValid(self, s: str) -> bool:
                stack = []
                list_s = list(s)
                left = ["(", "[", "{"]
                for temp in list_s:
                    if temp in left:
                        # temp 入栈
                        stack.append(temp)
                    else:
                        if stack and self._isValid(stack[-1], temp):
                            stack.pop()
                        else:
                            return False
                return not stack
            
            def _isValid(self, a, b):
                if (a == "(") and (b == ")"):
                    return True
                if (a == "{") and (b == "}"):
                    return True
                if (a == "[") and (b == "]"):
                    return True
                return False

            def isValid(self, s: str) -> bool:
                dic = {'{': '}',  '[': ']', '(': ')', '?': '?'}
                stack = ['?']
                for c in s:
                    if c in dic: stack.append(c)
                    elif dic[stack.pop()] != c: return False 
                return len(stack) == 1
    ```

#### 合并两个有序链表
- 问题描述
    * 将两个升序链表合并为一个新的 升序 链表并返回.新链表是通过拼接给定的两个链表的所有节点组成的. 
- 思路
    * 首先,我们设定一个哨兵节点 prehead ,这可以在最后让我们比较容易地返回合并后的链表.我们维护一个 prev 指针,我们需要做的是调整它的 next 指针.然后,我们重复以下过程,直到 l1 或者 l2 指向了 null ：如果 l1 当前节点的值小于等于 l2 ,我们就把 l1 当前的节点接在 prev 节点的后面同时将 l1 指针往后移一位.否则,我们对 l2 做同样的操作.不管我们将哪一个元素接在了后面,我们都需要把 prev 向后移一位.在循环终止的时候, l1 和 l2 至多有一个是非空的.由于输入的两个链表都是有序的,所以不管哪个链表是非空的,它包含的所有元素都比前面已经合并链表中的所有元素都要大.这意味着我们只需要简单地将非空链表接在合并链表的后面,并返回合并链表即可.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
                prehead = ListNode(-1)

                prev = prehead
                while list1 and list2:
                    if list1.val <= list2.val:
                        prev.next = list1
                        list1 = list1.next
                    else:
                        prev.next = list2
                        list2 = list2.next            
                    prev = prev.next

                # 合并后 list1 和 list2 最多只有一个还未被合并完,我们直接将链表末尾指向未合并完的链表即可
                prev.next = list1 if list1 is not None else list2

                return prehead.next

            def mergeTwoLists(self, l1: ListNode, l2: ListNode) -> ListNode:
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

#### 最大子数组和
- 问题描述
    * 给你一个整数数组 nums ,请你找出一个具有最大和的连续子数组(子数组最少包含一个元素),返回其最大和.子数组 是数组中的一个连续部分.
- 思路
    * 动态规划的是首先对数组进行遍历,当前最大连续子序列和为 sum,结果为 ans
    * 如果 sum > 0,则说明 sum 对结果有增益效果,则 sum 保留并加上当前遍历数字
    * 如果 sum <= 0,则说明 sum 对结果无增益效果,需要舍弃,则 sum 直接更新为当前遍历数字
    * 每次比较 sum 和 ans的大小,将最大值置为ans,遍历结束返回结果
    * 时间复杂度：O(n)
- 代码实现
    ```python
        class Solution:
            def maxSubArray(self, nums: List[int]) -> int:
                res, sumRes = nums[0], 0
                for num in nums:
                    if sumRes > 0:
                        sumRes += num
                    else:
                        sumRes = num
                    res = max(res, sumRes)
                return res
    ```

#### 爬楼梯
- 问题描述
    * 假设你正在爬楼梯.需要 n 阶你才能到达楼顶.每次你可以爬 1 或 2 个台阶.你有多少种不同的方法可以爬到楼顶呢？
- 思路
    * f(n) = f(n-1) + f(n-2), f(1) = 1 f(2) = 2
- 代码实现
    ```python
        class Solution:
            def climbStairs(self, n: int) -> int:
                # 找到规律db[i] = db[i-1] + db[i-2]
                # db[0] = 1 , db[1] = 1, 零阶和一阶都是一次
                # db[]的长度为n+1,因为列表头多了一个零阶
                db = [0 for item in range(n+1)]
                db[0] = db[1] = 1

                for i in range(2,n+1):
                    db[i] = db[i-1] + db[i-2]
                return db[-1]

            def climbStairs(self, n: int) -> int:
                a = b = 1
                for i in range(2, n + 1):
                    a, b = b, a + b
                return b
    ```



