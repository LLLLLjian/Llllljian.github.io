---
title: Interview_总结 (156)
date: 2022-04-20
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 树的子结构
- 问题描述
    * 输入两棵二叉树A和B,判断B是不是A的子结构.(约定空树不是任意一个树的子结构)B是A的子结构, 即 A中有出现和B相同的结构和节点值.
- 解题思路
    1. 如果A或B为空 那就返回False
    2. 如果A的值等于B的值, 并且A的左子树与B的左子树相等 且 A的右子树与B的右子树相等 那就返回True
    3. 递归A的左子树和B 或 A的右子树和B
    4. 判断两个数是否相等
    5. 如果B为空, 说明B已经是A的一部分了, 返回True
    6. 如果A为空, 说明越界了 返回False
    7. 如果A的值等于B的值, 递归自己 A的左树和B的左树 A的右树和B的右树
    8. 如果A的值不等于B的值, 返回False
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
                if (not A) or (not B):
                    return False
                if (A.val == B.val) and (self.helper(A.left, B.left)) and (self.helper(A.right, B.right)):
                    return True
                return self.isSubStructure(A.left, B) or self.isSubStructure(A.right, B)
            
            def helper(self, A, B):
                if not B:
                    return True
                if not A:
                    return False
                if A.val == B.val:
                    return self.helper(A.left, B.left) and self.helper(A.right, B.right)
                else:
                    return False
    ```

#### 二叉树的镜像
- 问题描述
    * 请完成一个函数,输入一个二叉树,该函数输出它的镜像
- 思路
    * 
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
                if not root: return
                root.left, root.right = self.mirrorTree(root.right), self.mirrorTree(root.left)
                return root

            def mirrorTree1(self, root: TreeNode) -> TreeNode:
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

#### 对称的二叉树
- 问题描述
    * 
- 思路

        isSymmetric(root) ：

        特例处理： 若根节点 root 为空,则直接返回 truetrue .
        返回值： 即 recur(root.left, root.right) ;
        recur(L, R) ：

        终止条件：
        当 LL 和 RR 同时越过叶节点： 此树从顶至底的节点都对称,因此返回 truetrue ；
        当 LL 或 RR 中只有一个越过叶节点： 此树不对称,因此返回 falsefalse ；
        当节点 LL 值 \ne 
        
        ​
        = 节点 RR 值： 此树不对称,因此返回 falsefalse ；
        递推工作：
        判断两节点 L.leftL.left 和 R.rightR.right 是否对称,即 recur(L.left, R.right) ；
        判断两节点 L.rightL.right 和 R.leftR.left 是否对称,即 recur(L.right, R.left) ；
        返回值： 两对节点都对称时,才是对称树,因此用与逻辑符 && 连接.

- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None
        class Solution:
            def isSymmetric(self, root: TreeNode) -> bool:
                def recur(L, R):
                    if not L and not R: return True
                    if not L or not R or L.val != R.val: return False
                    return recur(L.left, R.right) and recur(L.right, R.left)

                return recur(root.left, root.right) if root else True
    ```

