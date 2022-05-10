---
title: 读书笔记 (25)
date: 2022-05-07
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-回溯算法

<!-- more -->

#### 回溯三问题
1. 路径：也就是已经做出的选择
2. 选择列表：也就是你当前可以做的选择
3. 结束条件：也就是到达决策树底层,无法再做选择的条件
4. 回溯算法的框架
    ```
        result = []
        def backtrack(路径, 选择列表):
            if 满足结束条件:
                result.add(路径)
                return
            for 选择 in 选择列表:
                做选择
                backtrack(路径, 选择列表)
                撤销选择
    ```

#### 全排列问题
- 问题描述
    * 给定一个不含重复数字的数组 nums ,返回其 所有可能的全排列 .你可以 按任意顺序 返回答案.
- 思路
    * 回溯
- 代码实现0
    ```python
        class Solution:
            def permute(self, nums: List[int]) -> List[List[int]]:
                res = []
                length = len(nums)
                def backtrack(path, nums):
                    # path 路径
                    # nums 选择列表
                    if len(path) == length:
                        res.append(path)
                        return
                    for num in nums:
                        path.append(num)
                        backtrack(path, nums)
                        path.remove(num)
                backtrack([], nums)
                return res
    ```
- 代码实现0问题
    * 输入[1, 2, 3] 返回结果为 [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
    * 因为变量 path 所指向的列表 在深度优先遍历的过程中只有一份 ,深度优先遍历完成以后,回到了根结点,成为空列表, 所以这里需要做一次拷贝,用path[:]即可
- 代码实现1
    ```python
        class Solution:
            def permute(self, nums: List[int]) -> List[List[int]]:
                res = []
                length = len(nums)
                def backtrack(path, nums):
                    # path 路径
                    # nums 选择列表
                    if len(path) == length:
                        res.append(path)
                        return
                    for num in nums:
                        path.append(num)
                        backtrack(path, nums)
                        path.remove(num)
                backtrack([], nums)
                return res
    ```
- 代码实现1问题
    * 输入[1, 2, 3] 返回结果为[[1,1,1],[1,1,2],[1,1,3],[1,2,1],[2,1,2],[1,2,3],[1,3,1],[3,1,2],[3,1,3],[2,1,1],[2,1,2],[1,2,3],[2,2,1],[2,2,2],[2,2,3],[2,3,1],[2,3,2],[3,2,3],[3,1,1],[3,1,2],[3,1,3],[3,2,1],[3,2,2],[3,2,3],[3,3,1],[3,3,2],[3,3,3]]
    * 可以看到,选择列表中没有去掉已经被使用的值,这里用一个参数去做, 将使用的值标记为True, 不用了再改为False
- 代码实现2
    ```python
        class Solution:
            def permute(self, nums: List[int]) -> List[List[int]]:
                res = []
                length = len(nums)
                def backtrack(path, nums, used):
                    # path 路径
                    # nums 选择列表
                    if len(path) == length:
                        res.append(path[:])
                        return
                    for num in nums:
                        if not used:
                            pass
                        if (num in used) and used[num]:
                            continue
                        path.append(num)
                        used[num] = True
                        backtrack(path, nums, used)
                        path.remove(num)
                        used[num] = False
                backtrack([], nums, {})
                return res
    ```

#### 二叉树中和为某一值的路径
- 问题描述
    * 给你二叉树的根节点 root 和一个整数目标和 targetSum ,找出所有 从根节点到叶子节点 路径总和等于给定目标和的路径.叶子节点 是指没有子节点的节点.
- 思路
    * 初始化： 结果列表 res ,路径列表 path .
    * 返回值： 返回 res 即可.
    * 递推参数： 当前节点 root ,当前目标值 tar .
    * 终止条件： 若节点 root 为空,则直接返回.
    * 递推工作：
        * 路径更新： 将当前节点值 root.val 加入路径 path ；
        * 目标值更新： tar = tar - root.val(即目标值 tar 从 sum 减至 00 )；
        * 路径记录： 当 ① root 为叶节点 且 ② 路径和等于目标值 ,则将此路径 path 加入 res .
        * 先序遍历： 递归左 / 右子节点.
        * 路径恢复： 向上回溯前,需要将当前节点从路径 path 中删除,即执行 path.pop() .
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
            def pathSum(self, root: TreeNode, sum: int) -> List[List[int]]:
                res, path = [], []
                def recur(root, tar):
                    if not root: return
                    path.append(root.val)
                    tar -= root.val
                    if tar == 0 and not root.left and not root.right:
                        res.append(list(path))
                    recur(root.left, tar)
                    recur(root.right, tar)
                    path.pop()
                recur(root, sum)
                return res
    ```







