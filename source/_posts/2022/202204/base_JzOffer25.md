---
title: 剑指Offer_基础 (25)
date: 2022-04-22
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 删除链表中重复的节点
- 问题描述
    * 给定一个已排序的链表的头 head , 删除所有重复的元素,使每个元素只出现一次 .返回 已排序的链表 .
- 思路
    * 
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def deleteDuplicates(self, head) -> ListNode:
                # 解法一：递归
                if not head or not head.next: return head
                head.next=self.deleteDuplicates(head.next)
                if head.val==head.next.val:
                    head.next = head.next.next
                return head
                
                # 解法二：遍历
                dummy = ListNode(next=head)
                while head:
                    while head.next and head.val==head.next.val:
                        head.next = head.next.next
                    head = head.next
                return dummy.next
    ```

#### 二叉树的下一个节点
- 问题描述
    * 给定一个二叉树和其中的一个结点,请找出中序遍历顺序的下一个结 点并且返回.注意,树中的结点不仅包含左右子结点,同时包含指向父结点的指 针.
- 思路
    * 有右子树的,它的下一个是右子树的最左子节点.(一直沿着指向左子结点的指针找到的叶子节点即为下一个节点)
    * 没有右子树的,且如果它是它父节点的左子节点的话,它的下一个是它的父节点
    * 没有右子树的,且它是它父节店的右子节点的话,它的情况比较复杂,要沿着它父节点上去,直到找到它是它父节点的左子节点为止,那么下一个就是这个父节点.
- 代码实现
    ```python
        def getNext(node):
            if not node:
                return node
            if node.right:
                tempNode = node.right
                while tempNode.left:
                    tempNode = temp.left
                return tempNode
            while node.next:
                # 找第一个当前节点是父节点左孩子的节点
                if node.next.left == node:
                    return node.next
                node = node.next
            return None
    ```

#### 对称的二叉树
- 问题描述
    * 请实现一个函数,用来判断一颗二叉树是不是对称的.注意:如果一
个二叉树同此二叉树的镜像是同样的,定义其为对称的.
- 思路
    * 利用递归进行判断,若左子树的左孩子等于右子树的右孩子且左子树的右 孩子等于右子树的左孩子,并且左右子树节点的值相等,则是对称的.
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def isSymmetric(self, root: TreeNode) -> bool:
                return self.route(root.left, root.right)
                
            def route(self, rootA, rootB):
                if not rootA and not rootB:
                    return True
                if not rootA or not rootB:
                    return False
                if rootA.val != rootB.val:
                    return False
                return self.route(rootA.left, rootB.right) and self.route(rootA.right, rootB.left)
    ```



