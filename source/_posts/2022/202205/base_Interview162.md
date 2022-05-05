---
title: Interview_总结 (162)
date: 2022-05-01
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 翻转二叉树
- 问题描述
    * 给你一棵二叉树的根节点 root ,翻转这棵二叉树,并返回其根节点.
- 思路
    * 递归
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def invertTree(self, root: TreeNode) -> TreeNode:
                if not root:
                    return None
                root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)
                return root
    ```

#### 回文链表
- 问题描述
    * 给你一个单链表的头节点 head ,请你判断该链表是否为回文链表.如果是,返回 true ；否则,返回 false .
- 思路
    * 扔数组里, 然后反转比较就可以了
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def isPalindrome(self, head: ListNode) -> bool:
                vals = []
                current_node = head
                while current_node is not None:
                    vals.append(current_node.val)
                    current_node = current_node.next
                return vals == vals[::-1]
    ```

#### 移动零
- 问题描述
    * 给定一个数组 nums,编写一个函数将所有 0 移动到数组的末尾,同时保持非零元素的相对顺序.请注意 ,必须在不复制数组的情况下原地对数组进行操作.
- 思路
    * 们创建两个指针i和j,第一次遍历的时候指针j用来记录当前有多少非0元素.即遍历的时候每遇到一个非0元素就将其往数组左边挪,第一次遍历完后,j指针的下标就指向了最后一个非0元素下标.第二次遍历的时候,起始位置就从j开始到结束,将剩下的这段区域内的元素全部置为0
- 代码实现
    ```python
        class Solution(object):
            def moveZeroes(self, nums):
                """
                :type nums: List[int]
                :rtype: None Do not return anything, modify nums in-place instead.
                """
                if not nums:
                    return 0
                # 第一次遍历的时候,j指针记录非0的个数,只要是非0的统统都赋给nums[j]	
                j = 0
                for i in range(len(nums)):
                    if nums[i]:
                        nums[j] = nums[i]
                        j += 1
                # 非0元素统计完了,剩下的都是0了
                # 所以第二次遍历把末尾的元素都赋为0即可
                for i in range(j,len(nums)):
                    nums[i] = 0
    ```

#### 比特位计数
- 问题描述
    * 给你一个整数 n ,对于 0 <= i <= n 中的每个 i ,计算其二进制表示中 1 的个数 ,返回一个长度为 n + 1 的数组 ans 作为答案.
- 思路
    * 奇数：二进制表示中,奇数一定比前面那个偶数多一个 1,因为多的就是最低位的 1
    * 0 = 0       1 = 1         2 = 10      3 = 11
    * 偶数：二进制表示中,偶数中 1 的个数一定和除以 2 之后的那个数一样多.因为最低位是 0,除以 2 就是右移一位,也就是把那个 0 抹掉而已,所以 1 的个数是不变的.
    * 2 = 10       4 = 100       8 = 1000   3 = 11       6 = 110       12 = 1100
    * 奇数=前一个偶数+1 偶数=偶数/2 的个数
- 代码实现
    ```python
        class Solution:
            def countBits(self, n: int) -> List[int]:
                res = [0] * (n+1)
                for i in range(1, n+1):
                    if (i % 2 == 1):
                        res[i] = res[i-1] + 1
                    else:
                        res[i] = res[i//2]
                return res
    ```

#### 找到所有数组中消失的数字
- 问题描述
    * 给你一个含 n 个整数的数组 nums ,其中 nums[i] 在区间 [1, n] 内.请你找出所有在 [1, n] 范围内但没有出现在 nums 中的数字,并以数组的形式返回结果.s
- 思路
    * 方法1: 利用set去重之后, 再查找就是O(1)了, 然后循环不存在就直接append
    * 方法2: 可以理解为 将每个数自己索引位置的数字设置为负数, 然后大于0的数字对饮的索引就是缺少的数字
- 代码实现
    ```python
        class Solution:
            def findDisappearedNumbers(self, nums: List[int]) -> List[int]:
                s = set(nums)
                return [i for i in range(1, len(nums) + 1) if i not in s]

            def findDisappearedNumbers(self, nums: List[int]) -> List[int]:
                for n in nums:
                    nums[abs(n)-1] = - abs(nums[abs(n)-1])
                    #找到相应的鸽笼位置,取反
                res = []
                for i, v in enumerate(nums):
                    if v >0:#如果大于0,说明没被占过,也就是没有出现过的数字
                        res.append(i+1)
                return res
    ```
