---
title: 剑指Offer_基础 (02)
date: 2022-02-08
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 从尾到头打印链表
- 题目描述
    * 输入一个链表, 从尾到头打印链表每个节点的值
- 思路
    * 借助栈实现, 或使用递归的方法.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def reversePrint(self, head: ListNode) -> List[int]:
                res = []
                if head:
                    while head:
                        res.append(head.val)
                        head = head.next
                return res[::-1]
            
             def reversePrint(self, head: ListNode) -> List[int]:
                res = []
                def dfs(head):
                    if head:
                        res.append(head.val)
                        if head.next == None:
                            pass
                        else:
                            dfs(head.next)
                dfs(head)
                return res[::-1]
    ```

#### 由前序和中序遍历重建二叉树
- 题目描述
    * 输入某二叉树的前序遍历和中序遍历的结果, 请重建出该二叉树.假 设输入的前序遍历和中序遍历的结果中都不含重复的数字.例如输入前序遍历序列 {1,2,4,7,3,5,6,8}和中序遍历序列{4,7,2,1,5,3,8,6}, 则重建二叉树并返回.
- 思路
    * 先找出根节点, 然后利用递归方法构造二叉树
- 代码实现
    * 时间复杂度:O(n), 空间复杂度:O(n)
    ```python
        class Solution(object):
            def buildTree(self, preorder, inorder):
                """
                :type preorder: List[int]
                :type inorder: List[int]
                :rtype: TreeNode
                """
                if len(inorder) == 0:
                    return
                root = TreeNode()
                root.val = preorder.pop(0)
                ind = inorder.index(root.val)
                root.left = self.buildTree(preorder, inorder[:ind])
                root.right = self.buildTree(preorder, inorder[ind+1:])
                return root
        
        class Solution:
            def buildTree(self, preorder: List[int], inorder: List[int]) -> TreeNode:
                def myBuildTree(preorder_left: int, preorder_right: int, inorder_left: int, inorder_right: int):
                    if preorder_left > preorder_right:
                        return None
                    
                    # 前序遍历中的第一个节点就是根节点
                    preorder_root = preorder_left
                    # 在中序遍历中定位根节点
                    inorder_root = index[preorder[preorder_root]]
                    
                    # 先把根节点建立出来
                    root = TreeNode(preorder[preorder_root])
                    # 得到左子树中的节点数目
                    size_left_subtree = inorder_root - inorder_left
                    # 递归地构造左子树, 并连接到根节点
                    # 先序遍历中「从 左边界+1 开始的 size_left_subtree」个元素就对应了中序遍历中「从 左边界 开始到 根节点定位-1」的元素
                    root.left = myBuildTree(preorder_left + 1, preorder_left + size_left_subtree, inorder_left, inorder_root - 1)
                    # 递归地构造右子树, 并连接到根节点
                    # 先序遍历中「从 左边界+1+左子树节点数目 开始到 右边界」的元素就对应了中序遍历中「从 根节点定位+1 到 右边界」的元素
                    root.right = myBuildTree(preorder_left + size_left_subtree + 1, preorder_right, inorder_root + 1, inorder_right)
                    return root
                
                n = len(preorder)
                # 构造哈希映射, 帮助我们快速定位根节点
                index = {element: i for i, element in enumerate(inorder)}
                return myBuildTree(0, n - 1, 0, n - 1)
    ```


