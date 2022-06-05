---
title: 读书笔记 (44)
date: 2022-05-28
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二叉树(构造)

<!-- more -->

#### 最大二叉树
- 问题描述
    * 给定一个不重复的整数数组 nums . 最大二叉树 可以用下面的算法从 nums 递归地构建:
        * 创建一个根节点,其值为 nums 中的最大值.
        * 递归地在最大值 左边 的 子数组前缀上 构建左子树.
        * 递归地在最大值 右边 的 子数组后缀上 构建右子树.
        * 返回 nums 构建的 最大二叉树 .
- 思路
    * base case: nums为空 返回None
    * 找到nums中的最大值, 置为跟节点, 然后开始递归, 左边是左子树, 右边是右子树
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def maxBinaryTree(self, nums:List[int], start, end):
                # 区间内没有数字,返回 None
                if start == end:
                    return None
                # 初始化最大值下标
                maxIndex = start
                # 找到最大值的下标
                for i in range(start + 1, end):
                    if nums[i] > nums[maxIndex]:
                        maxIndex = i
                # 构建根节点
                root = TreeNode(nums[maxIndex])
                # 递归左子树
                root.left = self.maxBinaryTree(nums, start, maxIndex)
                # 递归右子树
                root.right = self.maxBinaryTree(nums, maxIndex + 1, end)
                return root

            def constructMaximumBinaryTree(self, nums: List[int]) -> TreeNode:
                return self.maxBinaryTree(nums, 0, len(nums))
    ```


#### 从前序和中序遍历序列构造二叉树
- 问题描述
    * 给定两个整数数组 preorder 和 inorder ,其中 preorder 是二叉树的先序遍历, inorder 是同一棵树的中序遍历,请构造二叉树并返回其根节点
- 思路
    * 前序遍历: 根左右
    * 中序遍历: 左根右
    * 递归找一下 两种遍历中 子树的两种遍历的left和right
    ![从前序和中序遍历序列构造二叉树](/img/20220528_1.png)
- 代码实现
    ```python
        class Solution:
            def buildTree(self, preorder: List[int], inorder: List[int]) -> TreeNode:
                def myBuildTree(preorder_left: int, preorder_right: int, inorder_left: int, inorder_right: int):
                    """
                    定义
                    前序遍历数组为 preorder[preorder_left..preorder_right],
                    中序遍历数组为 inorder[inorder_left..inorder_right],
                    构造这个二叉树并返回该二叉树的根节点
                    """
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
                    # 递归地构造左子树,并连接到根节点
                    # 先序遍历中「从 左边界+1 开始的 size_left_subtree」个元素就对应了中序遍历中「从 左边界 开始到 根节点定位-1」的元素
                    root.left = myBuildTree(preorder_left + 1, preorder_left + size_left_subtree, inorder_left, inorder_root - 1)
                    # 递归地构造右子树,并连接到根节点
                    # 先序遍历中「从 左边界+1+左子树节点数目 开始到 右边界」的元素就对应了中序遍历中「从 根节点定位+1 到 右边界」的元素
                    root.right = myBuildTree(preorder_left + size_left_subtree + 1, preorder_right, inorder_root + 1, inorder_right)
                    return root
                
                n = len(preorder)
                # 构造哈希映射,帮助我们快速定位根节点
                index = {element: i for i, element in enumerate(inorder)}
                return myBuildTree(0, n - 1, 0, n - 1)
    ```


#### 从后序和中序遍历结果构造二叉树
- 问题描述
    * 给定两个整数数组 inorder 和 postorder ,其中 inorder 是二叉树的中序遍历, postorder 是同一棵树的后序遍历,请你构造并返回这颗二叉树
- 思路
    * 跟上边的题一摸一样
    ![从后序和中序遍历结果构造二叉树](/img/20220528_2.png)
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def buildTree(self, inorder: List[int], postorder: List[int]) -> TreeNode:
                def myBuild(inorder_left, inorder_right, postorder_left, postorder_right):
                    if inorder_left > inorder_right:
                        return None
                    rootVal = postorder[postorder_right]
                    rootIndex = idx_map[rootVal]
                    # 左子树的节点个数
                    leftSize = rootIndex - inorder_left
                    res = TreeNode(rootVal)
                    # 左子树
                    res.left = myBuild(
                        inorder_left,
                        rootIndex - 1,
                        postorder_left,
                        postorder_left + leftSize - 1
                    )
                    # 右子树
                    res.right = myBuild(
                        rootIndex + 1,
                        inorder_right,
                        postorder_left + leftSize,
                        postorder_right - 1
                    )
                    return res
                # 建立(元素,下标)键值对的哈希表
                idx_map = {val:idx for idx, val in enumerate(inorder)} 
                return myBuild(0, len(inorder)-1, 0, len(postorder)-1)
    ```

#### 根据前序和后序遍历构造二叉树
- 问题描述
    * 给定两个整数数组,preorder 和 postorder ,其中 preorder 是一个具有 无重复 值的二叉树的前序遍历,postorder 是同一棵树的后序遍历,重构并返回二叉树.如果存在多个答案,您可以返回其中 任何 一个.
- 思路
    * 首先把前序遍历结果的第一个元素或者后序遍历结果的最后一个元素确定为根节点的值.
    * 然后把前序遍历结果的第二个元素作为左子树的根节点的值.
    * 在后序遍历结果中寻找左子树根节点的值,从而确定了左子树的索引边界,进而确定右子树的索引边界,递归构造左右子树即可
    ![根据前序和后序遍历构造二叉树](/img/20220528_3.png)
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def constructFromPrePost(self, preorder: List[int], postorder: List[int]) -> TreeNode:
                def myBuild(preorder_left, preorder_right, postorder_left, postorder_right):
                    if preorder_left > preorder_right:
                        return None
                    if preorder_left == preorder_right:
                        return TreeNode(preorder[preorder_left])
                    # root 节点对应的值就是前序遍历数组的第一个元素
                    rootVal = preorder[preorder_left]
                    # root.left 的值是前序遍历第二个元素
                    # 通过前序和后序遍历构造二叉树的关键在于通过左子树的根节点
                    # 确定 preorder 和 postorder 中左右子树的元素区间
                    leftRootVal = preorder[preorder_left + 1]
                    # leftRootVal 在后序遍历数组中的索引
                    index = idx_map[leftRootVal]
                    # 左子树的元素个数
                    leftSize = index - postorder_left + 1
                    # 生成根节点
                    res = TreeNode(rootVal)
                    # 左子树
                    res.left = myBuild(
                        preorder_left+1,
                        preorder_left + leftSize,
                        postorder_left,
                        index
                    )
                    # 右子树
                    res.right = myBuild(
                        preorder_left + leftSize + 1,
                        preorder_right,
                        index + 1,
                        postorder_right - 1
                    )
                    return res

                # 建立(元素,下标)键值对的哈希表
                idx_map = {val:idx for idx, val in enumerate(postorder)} 
                return myBuild(0, len(preorder)-1, 0, len(postorder)-1)
    ```
