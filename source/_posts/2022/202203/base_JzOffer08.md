---
title: 剑指Offer_基础 (08)
date: 2022-03-04
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 判断二叉树 A 中是否包含子树 B
- 题目描述
    * 输入两棵二叉树 A, B, 判断 B 是不是 A 的子结构.(ps:我们约定空树不是任意一个树的子结构)
- 思路
    * 若根节点相等, 利用递归比较他们的子树是否相等, 若根节点不相等, 则 利用递归分别在左右子树中查找.
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def isSubStructure(self, A: TreeNode, B: TreeNode) -> bool:
                def recur(A, B):
                    if not B: return True
                    if not A or A.val != B.val: return False
                    return recur(A.left, B.left) and recur(A.right, B.right)

                return bool(A and B) and (recur(A, B) or self.isSubStructure(A.left, B) or self.isSubStructure(A.right, B))

            def isSubStructure1(self, A: TreeNode, B: TreeNode) -> bool:
                if not B:
                    return True
                if not A:
                    return False
                if self.doesTree1HaveTree2(A, B):
                    return True
                return isSubStructure1(A.left, B) or isSubStructure1(A.right, B)
            
            def doesTree1HaveTree2(self, source, target):
                if (source == None) and (target == None):
                    return True
                if (source == None) or (target == None):
                    return False
                if (source.val != target.val):
                    return False
                return self.doesTree1HaveTree2(source.left, target.left) && self.doesTree1HaveTree2(source.right, target.right)
    ```

#### 二叉树的镜像
- 题目描述
    * 操作给定的二叉树, 将其变换为源二叉树的镜像
- 思路
    * 使用递归或非递归方式交换每个节点的左右子树位置
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def mirrorTree(self, root: TreeNode) -> TreeNode:
                if root:
                    tmp_tree = root.left
                    root.left = root.right
                    root.right = tmp_tree
                    self.mirrorTree(root.left)
                    self.mirrorTree(root.right)
                else:
                    return None
                return root
    ```




