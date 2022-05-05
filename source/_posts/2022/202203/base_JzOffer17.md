---
title: 剑指Offer_基础 (17)
date: 2022-03-29
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 两个链表的第一个公共节点
- 题目描述
    * 输入两个链表,找出它们的第一个公共结点
- 思路
    * 两个人走同样的路, 相等的话就是公共节点
- 代码实现
    ```python
        class Solution:
            def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
                A, B = headA, headB
                while A != B:
                    A = A.next if A else headB
                    B = B.next if B else headA
                return A
    ```

#### 求某个数在数组中出现次数
- 题目描述
    * 统计一个数字在排序数组中出现的次数
- 思路
    * 利用二分查找+递归思想,进行寻找.当目标值与中间值相等时进行判断
- 代码实现
    ```python
        class Solution:
            def search(self, nums: [int], target: int) -> int:
                def bisect(x):
                    left, right = 0, len(nums)
                    while left < right:
                        mid = left + (right - left) // 2
                        if nums[mid] <= x: 
                            left = mid + 1
                        else: 
                            right = mid
                    return right
                return bisect(target) - bisect(target - 1)
    ```

#### 求某个二叉树的深度
- 题目描述
    * 输入一棵二叉树,求该树的深度.从根结点到叶结点依次经过的结点 (含根、叶结点)形成树的一条路径,最长路径的长度为树的深度.
- 思路
    * 利用递归遍历分别返回左右子树深度
- 代码思路
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def maxDepth(self, root: TreeNode) -> int:
                if not root:
                    return 0
                return max(self.maxDepth(root.left), self.maxDepth(root.right)) + 1
    ```

#### 判断某二叉树是否是平衡二叉树
- 题目描述
    * 输入一棵二叉树,判断该二叉树是否是平衡二叉树.
- 思路
    * 平衡二叉树的条件:左子树是平衡二叉树,右子树是平衡二叉树,左右子树高度不超过 1
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None
        class Solution:
            def isBalanced(self, root: TreeNode) -> bool:
                if not root:
                    return True 
                temp = abs(self.maxDepth(root.left) - self.maxDepth(root.right)) <= 1
                return self.isBalanced(root.left) and self.isBalanced(root.right) and temp

            def maxDepth(self, root: TreeNode) -> int:
                if not root:
                    return 0
                return max(self.maxDepth(root.left), self.maxDepth(root.right)) + 1
    ```
