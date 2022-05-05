---
title: Interview_总结 (165)
date: 2022-05-04
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 电话号码的字母组合
- 问题描述
    * 给定一个仅包含数字 2-9 的字符串,返回所有它能表示的字母组合.答案可以按 任意顺序 返回.
- 思路
    * 我们也可以使用队列,先将输入的 digits 中第一个数字对应的每一个字母入队,然后将出队的元素与第二个数字对应的每一个字母组合后入队...直到遍历到 digits 的结尾.最后队列中的元素就是所求结果.
- 代码实现
    ```python
        class Solution:
            def letterCombinations(self, digits: str) -> List[str]:
                if not digits:
                    return []
                result_dict = {
                    "2": ["a", "b", "c"],
                    "3": ["d", "e", "f"],
                    "4": ["g", "h", "i"],
                    "5": ["j", "k", "l"],
                    "6": ["m", "n", "o"],
                    "7": ["p", "q", "r", "s"],
                    "8": ["t", "u", "v"],
                    "9": ["w", "x", "y", "z"],
                }
                digit_list = list(digits)
                queue = ['']  # 初始化队列
                for digit in digit_list:
                    if digit in result_dict:
                        for _ in range(len(queue)):
                            tmp = queue.pop(0)
                            for letter in result_dict[digit]:
                                queue.append(tmp + letter)
                return queue
    ```

#### 删除链表的倒数第N个结点
- 问题描述
    * 给你一个链表,删除链表的倒数第n个结点,并且返回链表的头结点
- 思路
    * 双指针就可以了
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

#### 括号生成
- 问题描述
    * 数字 n 代表生成括号的对数,请你设计一个函数,用于能够生成所有可能的并且 有效的 括号组合.
- 思路
    * 想像成一个满二叉树,我们只需要DFS所有节点即可, 遍历完所有的结果之后再加条件过滤不需要的
    * 比如(((( 比如)))) 比如( > n 比如) > n 比如) > (
- 代码实现
    ```python
        class Solution:
            def generateParenthesis(self, n: int) -> List[str]:
                if n <= 0: return []
                res = []
                def dfs(paths, left, right):
                    if left > n or right > left: return
                    if len(paths) == n * 2:  # 因为括号都是成对出现的
                        res.append(paths)
                        return
                    dfs(paths + '(', left + 1, right)  # 生成一个就加一个
                    dfs(paths + ')', left, right + 1)
                dfs('', 0, 0)
                return res
    ```

#### 下一个排列
- 问题描述
    * 给你一个整数数组 nums ,找出 nums 的下一个排列.
- 思路
    * 对于 [2, 6, 3, 5, 4, 1]
    * 先从后往前找到一个逆序数 N, 即为 3
    * 然后再从 N 后面找到一个比它大的 "最小数"
    * 即在 [5, 4, 1] 中找到比 3 大的最小数, 为 4(这里可以直接再次从后往前找,因为这段数字倒着遍历必然是正序的)
    * 交换两者位置,则为 [2, 6, 4, 5, 3, 1]
    * 然后对一开始 N 后面位置进行反转
    * 即从 [2, 6, 4, 5, 3, 1] 到 [2, 6, 4, 1, 3, 5]
- 代码实现
    ```python
        class Solution:
            def nextPermutation(self, nums: List[int]) -> None:
                """
                Do not return anything, modify nums in-place instead.
                """
                n = len(nums)
                if n <= 1: return
                modify = -1
                # 从后往前寻找非升序数组的第一个元素对应的下标modify
                for i in range(n - 1, -1, -1):
                    if i == n - 1: continue
                    if nums[i] < nums[i + 1]:
                        modify = i
                        break
                # 如果modify没变,则此时排列为最大,将数组逆序
                if modify == -1: 
                    nums[:] = nums[::-1]
                # 否则
                else: 
                    target = -1
                    # 找到modify之后比modify大且最接近的元素的下标target
                    for i in range(n - 1, modify, -1):
                        if nums[i] > nums[modify]: 
                            target = i 
                            break
                    # 将modify和target位置的元素交换
                    nums[modify], nums[target] = nums[target], nums[modify]
                    # 将modify位置之后的元素倒序
                    i, j = modify + 1, n - 1
                    while i < j:
                        nums[i], nums[j] = nums[j], nums[i]
                        i, j = i + 1, j - 1
    ```

#### 搜索旋转排序数组
- 问题描述
    * 给你 旋转后 的数组 nums 和一个整数 target ,如果 nums 中存在这个目标值 target ,则返回它的下标,否则返回 -1 
- 思路
    * 二分查找
- 代码实现
    ```python
        class Solution:
            def search(self, nums: List[int], target: int) -> int:
                if not nums:
                    return -1
                left, right = 0, len(nums) - 1
                while left <= right:
                    mid = (left + right) // 2
                    if target == nums[mid]:
                        return mid
                    if nums[left] <= nums[mid]:
                        if nums[left] <= target <= nums[mid]:
                            right = mid - 1
                        else:
                            left = mid + 1
                    else:
                        if nums[mid] <= target <= nums[right]:
                            left = mid + 1
                        else:
                            right = mid - 1
                return -1
    ```
