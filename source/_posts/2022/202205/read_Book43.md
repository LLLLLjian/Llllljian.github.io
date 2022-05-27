---
title: 读书笔记 (43)
date: 2022-05-27
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二叉树(思路)

<!-- more -->

#### 填充节点的右侧指针
- 问题描述
    * 给定一个 完美二叉树 ,其所有叶子节点都在同一层,每个父节点都有两个子节点.填充它的每个 next 指针,让这个指针指向其下一个右侧节点.如果找不到下一个右侧节点,则将 next 指针设置为 NULL.
- 思路
    * 递归很容易实现了, 但要注意的是不同根相邻节点直接的指向
- 代码实现
    ```python
        """
        # Definition for a Node.
        class Node:
            def __init__(self, val: int = 0, left: 'Node' = None, right: 'Node' = None, next: 'Node' = None):
                self.val = val
                self.left = left
                self.right = right
                self.next = next
        """

        class Solution:
            def connect(self, root: 'Optional[Node]') -> 'Optional[Node]':
                if not root:
                    return root
                self.traverse(root.left, root.right)
                return root
            
            def traverse(self, node1, node2):
                if not node1 or not node2:
                    return
                node1.next = node2
                # 连接相同父节点的两个子节点
                self.traverse(node1.left, node1.right)
                self.traverse(node2.left, node2.right)
                # 连接跨越父节点的两个子节点
                self.traverse(node1.right, node2.left)
    ```

#### 二叉树展开为链表
- 问题描述
    * 给你二叉树的根结点 root ,请你将它展开为一个单链表：
    * 展开后的单链表应该同样使用 TreeNode ,其中 right 子指针指向链表中下一个结点,而左子指针始终为 null .
    * 展开后的单链表应该与二叉树 先序遍历 顺序相同.
- 思路
    * 递归
        * 将 root 的左子树和右子树拉平.
        * 将 root 的右子树接到左子树下方,然后将整个左子树作为右子树.
    * 前序
        * 用list记录前序遍历的顺序, 然后在对list进行操作即可
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def flatten(self, root: TreeNode) -> None:
                """
                Do not return anything, modify root in-place instead.
                递归
                1. 先利用 flatten(x.left) 和 flatten(x.right) 将 x 的左右子树拉平.
                2. 将 x 的右子树接到左子树下方,然后将整个左子树作为右子树.
                """
                # base case
                if not root:
                    return
                # 利用定义,把左右子树拉平
                self.flatten(root.left)
                self.flatten(root.right)
                # 后序遍历位置
                # 1. 左右子树已经被拉平成一条链表
                left = root.left
                right = root.right
                # 2. 将左子树作为右子树
                root.left = None
                root.right = left
                # 3. 将原先的右子树接到当前右子树的末端
                p = root
                while p.right:
                    p = p.right
                p.right = right
            def flatten(self, root: TreeNode) -> None:
                """
                前序遍历直接完成
                """
                preorderList = list()
                def preorderTraversal(root: TreeNode):
                    if root:
                        preorderList.append(root)
                        preorderTraversal(root.left)
                        preorderTraversal(root.right)
                preorderTraversal(root)
                size = len(preorderList)
                for i in range(1, size):
                    prev, curr = preorderList[i - 1], preorderList[i]
                    prev.left = None
                    prev.right = curr
    ```





