---
title: Leetbook_基础 (15)
date: 2022-01-27
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-二叉树

<!-- more -->

#### 先上一张图

![二叉树的遍历](/img/20220127_1.gif)

#### BFS
> 广度层序遍历
- code
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def bfs(self,root):
                """
                :type root: TreeNode
                :rtype: List[List[int]]
                """
                res = []
                queue = []
                queue.append(root)
                while queue:
                    tmp_list = []
                    for node in queue:
                        res.append(node.val)
                        if node.left:
                            tmp_list.append(node.left)
                        if node.right:
                            tmp_list.append(node.right)
                    queue = tmp_list
                # [1,2,3,4,5,6,7,8,9]
                return res
    ```


#### DFS
> 深度层序遍历
- demo
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def levelOrder(self,root):
                """
                :type root: TreeNode
                :rtype: List[List[int]]
                """
                res = []
                def dfs(node):
                    if node.left:
                        dfs(node.left)
                    if node.right:
                        dfs(node.right)
                    res.append(node.val)
                dfs(root)
                # 前 [1,2,4,8,9,5,3,6,7]
                # 中 [8,4,9,2,5,1,6,3,7]
                # 后 [8,9,4,5,2,6,7,3,1]
                return res
    ```

