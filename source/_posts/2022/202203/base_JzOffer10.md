---
title: 剑指Offer_基础 (10)
date: 2022-03-09
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 层序遍历二叉树
- 题目描述
    * 从上往下打印出二叉树的每个节点,同层节点从左至右打印
- 思路
    * 利用队列(链表)辅助实现.
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def levelOrder(self, root: TreeNode) -> List[List[int]]:
                res = []
                if not root:
                    return res
                queue = []
                queue.append(root)
                while queue:
                    res.append([node.val for node in queue])
                    tmp_list = []
                    for node in queue:
                        if node.left:
                            tmp_list.append(node.left)
                        if node.right:
                            tmp_list.append(node.right)
                    queue = tmp_list
                return res
    ```

#### 后序遍历二叉搜索树
- 题目描述
    * 输入一个整数数组,判断该数组是不是某二叉搜索树的后序遍历的结 果.如果是则输出 Yes,否则输出 No.假设输入的数组的任意两个数字都互不相 同.
- 思路
    * 先找到右子树的开始位置,然后分别进行左右子树递归处理.
- 代码实现
    ```python
        class Solution:
            def verifyPostorder(self, postorder: [int]) -> bool:
                def recur(i, j):
                    # 此子树节点数量小于1 ,无需判别正确性,因此直接返回 true
                    if i >= j: return True
                    # 找到第一个大于根节点的节点m  
                    # 此时应该可以划分 左子树区间 [i,m-1] 、右子树区间 [m,j−1] 、根节点索引 j
                    p = i
                    while postorder[p] < postorder[j]: p += 1
                    m = p
                    while postorder[p] > postorder[j]: p += 1
                    # 向下分治
                    return p == j and recur(i, m - 1) and recur(m, j - 1)

                return recur(0, len(postorder) - 1)
    ```

#### 二叉树中和为某值的路径
- 题目描述
    * 输入一颗二叉树和一个整数,打印出二叉树中结点值的和为输入整数 的所有路径.路径定义为从树的根结点开始往下一直到叶结点所经过的结点形成一条路径.
- 思路
    * 先保存根节点,然后分别递归在左右子树中找目标值,若找到即到达叶子节点,打印路径中的值
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def pathSum(self, root: TreeNode, sum: int) -> List[List[int]]:
                res, path = [], []
                def recur(root, tar):
                    # 若节点 root 为空,则直接返回
                    if not root: return
                    # 1. 路径更新： 将当前节点值 root.val 加入路径 path
                    path.append(root.val)
                    # 2. 目标值更新： tar = tar - root.val(即目标值 tar 从 sum 减至 0 )；
                    tar -= root.val
                    # 3. 路径记录： 当 ① root 为叶节点 且 ② 路径和等于目标值 ,则将此路径 path 加入 res 
                    if tar == 0 and not root.left and not root.right:
                        res.append(list(path))
                    # 4. 先序遍历： 递归左 / 右子节点.
                    recur(root.left, tar)
                    recur(root.right, tar)
                    # 5. 向上回溯前,需要将当前节点从路径 path 中删除,即执行 path.pop() .
                    path.pop()
                recur(root, sum)
                return res
    ```





