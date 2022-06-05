---
title: 读书笔记 (46)
date: 2022-05-30
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二叉树(后序篇)

<!-- more -->

#### 回顾
> 前序位置的代码只能从函数参数中获取父节点传递来的数据,而后序位置的代码不仅可以获取参数数据,还可以获取到子树通过函数返回值传递回来的数据


#### 寻找重复的子树
- 问题描述
    * 给定一棵二叉树 root,返回所有重复的子树.对于同一类的重复子树,你只需要返回其中任意一棵的根结点即可.如果两棵树具有相同的结构和相同的结点值,则它们是重复的.
- 思路
    * 子树所以就用到后序遍历
    * 我想知道有没有和我一样的兄弟,那我就要找到所有以我为根的路径,然后再通过hash去判断存在的数量
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def __init__(self):
                self.res=[]
                self.hashmap={}

            def traverse(self,root):
                if root==None:
                    return '#'
                left=self.traverse(root.left)
                right=self.traverse(root.right)

                subtree=left+","+right+","+str(root.val)
                fre=self.hashmap.get(subtree,0)
                if fre==1:
                    self.res.append(root)
                self.hashmap[subtree]=fre+1
                return subtree
            
            def findDuplicateSubtrees(self, root: Optional[TreeNode]) -> List[Optional[TreeNode]]:
                self.traverse(root)
                return self.res
    ```





