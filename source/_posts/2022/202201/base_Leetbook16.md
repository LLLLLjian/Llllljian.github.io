---
title: Leetbook_基础 (16)
date: 2022-01-28
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-二叉树

<!-- more -->

#### 运用递归解决树的问题
- “自顶向下” 的解决方案
    * “自顶向下” 意味着在每个递归层级, 我们将首先访问节点来计算一些值, 并在递归调用函数时将这些值传递到子节点. 所以 “自顶向下” 的解决方案可以被认为是一种前序遍历. 具体来说, 递归函数 top_down(root, params) 的原理是这样的：
        ```
            return specific value for null node
            update the answer if needed                      // answer <-- params
            left_ans = top_down(root.left, left_params)		// left_params <-- root.val, params
            right_ans = top_down(root.right, right_params)	// right_params <-- root.val, params
            return the answer if needed                      // answer <-- left_ans, right_ans
        ```
- “自底向上” 的解决方案
    * “自底向上” 是另一种递归方法. 在每个递归层次上, 我们首先对所有子节点递归地调用函数, 然后根据返回值和根节点本身的值得到答案. 这个过程可以看作是后序遍历的一种. 通常,  “自底向上” 的递归函数 bottom_up(root) 为如下所示：
        ```
            return specific value for null node
            left_ans = bottom_up(root.left)			// call function recursively for left child
            right_ans = bottom_up(root.right)		// call function recursively for right child
            return answers                           // answer <-- left_ans, right_ans, root.val
        ```

#### 二叉树的最大深度
- Q
    * 给你一棵树, 返回树的最大深度
- T
    * 递归 自底向上
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def maxDepth(self, root: Optional[TreeNode]) -> int:
                if root is None:
                    return 0
                max_left = self.maxDepth(root.left)
                mex_right = self.maxDepth(root.right)
                return max(max_left, max_right) + 1
    ```

#### 对称二叉树
- Q
    * 给你一个二叉树的根节点 root ,  检查它是否轴对称
- T
    * 直接套上边递归的办法,  注意退出条件.左子树的左节点=右子树的右节点才是轴对称
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:

            def compareTree(self, left, right):
                # 若左右节点不存在(即只有根节点)
                if left == None and right == None:
                    return True
                # 左节点为空右节点不为空或左节点不为空右节点为空, 则不对称
                elif (left == None and right != None) or (left != None and right == None):
                    return False
                # 左右节点不为空, 但数值不等, 则不对称
                elif left.val != right.val:
                    return False

                # 使用递归, 对接下来的每一层做判断
                # 判断左子树的左子树和右子树的右子树是否相等
                leftrightTree = self.compareTree(left.left, right.right)
                # 判断左子树的右子树和右子树的左子树是否相等
                rightleftTree = self.compareTree(left.right, right.left)
                
                isCompareTree = leftrightTree and rightleftTree 
                
                return isCompareTree

            def isSymmetric(self, root: TreeNode) -> bool:
                # 空树
                if root == None:
                    return True
                
                return self.compareTree(root.left, root.right)

        class Solution(object):
            def isSymmetric(self, root):
                """
                :type root: TreeNode
                :rtype: bool
                迭代
                """
                if not root or not (root.left or root.right):
                    return True
                # 用队列保存节点	
                queue = [root.left,root.right]
                while queue:
                    # 从队列中取出两个节点, 再比较这两个节点
                    left = queue.pop(0)
                    right = queue.pop(0)
                    # 如果两个节点都为空就继续循环, 两者有一个为空就返回false
                    if not (left or right):
                        continue
                    if not (left and right):
                        return False
                    if left.val!=right.val:
                        return False
                    # 将左节点的左孩子,  右节点的右孩子放入队列
                    queue.append(left.left)
                    queue.append(right.right)
                    # 将左节点的右孩子, 右节点的左孩子放入队列
                    queue.append(left.right)
                    queue.append(right.left)
                return True

            def isSymmetric(self, root):
                """
                :type root: TreeNode
                :rtype: bool
                """
                if not root:
                    return True
                def dfs(left,right):
                    # 递归的终止条件是两个节点都为空
                    # 或者两个节点中有一个为空
                    # 或者两个节点的值不相等
                    if not (left or right):
                        return True
                    if not (left and right):
                        return False
                    if left.val!=right.val:
                        return False
                    return dfs(left.left,right.right) and dfs(left.right,right.left)
                # 用递归函数, 比较左节点, 右节点
                return dfs(root.left,root.right)
    ```

#### 路径总和
- Q
    * 给你二叉树的根节点 root 和一个表示目标和的整数 targetSum .判断该树中是否存在 根节点到叶子节点 的路径, 这条路径上所有节点值相加等于目标和 targetSum .如果存在, 返回 true ；否则, 返回 false .叶子节点 是指没有子节点的节点.
- T
    * 还是直接套递归公式
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
                if root is None:
                    return False
                if (root.left is None) and (root.right is None) and (root.val == targetSum):
                    return True
                left_result = self.hasPathSum(root.left, targetSum-root.val)
                right_result = self.hasPathSum(root.right, targetSum-root.val)
                return left_result or right_result
    ```



