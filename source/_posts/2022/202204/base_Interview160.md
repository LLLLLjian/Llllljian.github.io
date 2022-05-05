---
title: Interview_总结 (160)
date: 2022-04-29
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 二叉树的中序遍历
- 问题描述
    * 给定一个二叉树的根节点 root ,返回 它的 中序 遍历
- 思路
    * 左根右
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
                def preorder(root):
                    if root:
                        pass
                    else:
                        return
                    preorder(root.left)
                    res.append(root.val)
                    preorder(root.right)
                res = []
                preorder(root)
                return res
    ```

#### 对称二叉树
- 问题描述
    * 给你一个二叉树的根节点 root , 检查它是否轴对称.
- 思路
    * 左子树=右子树
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def isSymmetric(self, root: Optional[TreeNode]) -> bool:
                return self._isSymmetric(root.left, root.right)
            
            def _isSymmetric(self, a, b):
                if (not a) and (not b):
                    return True
                if (not a) or (not b):
                    return False
                if a.val == b.val:
                    pass
                else:
                    return False
                return self._isSymmetric(a.left, b.right) and self._isSymmetric(a.right, b.left)
    ```

#### 二叉树的最大深度
- 问题描述
    * 给定一个二叉树,找出其最大深度.
- 思路
    * 递归, 找出左右的最大值再加1
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def maxDepth(self, root: Optional[TreeNode]) -> int:
                # 节点为空,高度为 0
                if root == None:
                    return 0
                # 递归计算左子树的最大深度
                leftHeight = self.maxDepth(root.left)
                # 递归计算右子树的最大深度
                rightHeight = self.maxDepth(root.right)
                # 二叉树的最大深度 = 子树的最大深度 + 1(1 是根节点)
                return max(leftHeight, rightHeight) + 1
    ```

#### 买卖股票的最佳时机
- 问题描述
    * 给定一个数组 prices ,它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格.你只能选择 某一天 买入这只股票,并选择在 未来的某一个不同的日子 卖出该股票.设计一个算法来计算你所能获取的最大利润.返回你可以从这笔交易中获取的最大利润.如果你不能获取任何利润,返回 0 
- 思路
    * 找到最小值, 然后计算差值就可以了
- 代码实现
    ```python
        class Solution:
            def maxProfit(self, prices: List[int]) -> int:
                minPrice = prices[0]
                res = 0
                for price in prices:
                    minPrice = min(price, minPrice)
                    res = max(res, price-minPrice)
                return res
    ```

#### 只出现一次的数字
- 问题描述
    * 给定一个非空整数数组,除了某个元素只出现一次以外,其余每个元素均出现两次.找出那个只出现了一次的元素.
- 思路
    * 位运算
- 代码实现
    ```python
        class Solution:
            def singleNumber(self, nums: List[int]) -> int:
                res = 0
                for num in nums:
                    res ^= num
                return res
    ```
