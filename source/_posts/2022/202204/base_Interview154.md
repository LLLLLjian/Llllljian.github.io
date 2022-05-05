---
title: Interview_总结 (154)
date: 2022-04-18
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    剑指

<!-- more -->

#### 二维数组中的查找
- 问题描述
    * 在一个 n * m 的二维数组中,每一行都按照从左到右递增的顺序排序,每一列都按照从上到下递增的顺序排序.请完成一个高效的函数,输入这样的一个二维数组和一个整数,判断数组中是否含有该整数.
- 思路
    * 从右上角出发, 然后左移 下移
- 实现代码
    ```python
        class Solution:
            def findNumberIn2DArray(self, matrix: List[List[int]], target: int) -> bool:
                if not matrix:
                    return False
                # 从右上角出发, 就可以理解成一个二叉树了
                t, r, b, l = 0, len(matrix[0])-1, len(matrix)-1, 0
                while (r >= l) and (b >= t):
                    if matrix[t][r]  == target:
                        return True
                    elif matrix[t][r] > target:
                        r -= 1
                    else:
                        t += 1
                return False
    ```

#### 从上到下打印二叉树
- 问题描述
    * 层级遍历
- 代码实现
    ```python
        class Solution:
            def levelOrder(self, root: TreeNode) -> List[int]:
                if not root: return []
                res, queue = [], collections.deque()
                queue.append(root)
                while queue:
                    node = queue.popleft()
                    res.append(node.val)
                    if node.left: queue.append(node.left)
                    if node.right: queue.append(node.right)
                return res
    ```

#### 从上到下打印二叉树II
- 问题描述
    * 层级遍历(每层一个数组)
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def levelOrder(self, root: TreeNode) -> List[List[int]]:
                res = []
                if root:
                    temp_list = []
                    temp_list.append(root)
                    while temp_list:
                        res.append([x.val for x in temp_list])
                        temp_list1 = []
                        for temp in temp_list:
                            if temp.left:
                                temp_list1.append(temp.left)
                            if temp.right:
                                temp_list1.append(temp.right)
                        temp_list = temp_list1
                return res
    ```

#### 从上到下打印二叉树III
- 问题描述
    * 层级遍历(每层一个数组, 奇数左到右, 偶数右到左)
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def levelOrder(self, root: TreeNode) -> List[List[int]]:
                res = []
                if root:
                    temp_list = []
                    temp_list.append(root)
                    i = 0
                    while temp_list:
                        if i == 0:
                            res.append([x.val for x in temp_list])
                            i = 1
                        else:
                            res.append([x.val for x in temp_list][::-1])
                            i = 0
                        ll = []
                        for temp in temp_list:
                            if temp.left:
                                ll.append(temp.left)
                            if temp.right:
                                ll.append(temp.right)
                        temp_list = ll
                return res
    ```

