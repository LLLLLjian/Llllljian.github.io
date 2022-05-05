---
title: 剑指Offer_基础 (26)
date: 2022-04-24
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 把二叉树打印成多行
- 问题描述
    * 从上到下按层打印二叉树,同一层结点从左至右输出.每一层输出一
行
- 解题思路
    * 每层都放到一个数组里
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
                    res = []
                    temp_res = []
                    temp_res.append(root)
                    while temp_res:
                        res.append([tmp.val for tmp in temp_res])
                        ll = []
                        for temp in temp_res:
                            if temp.left:
                                ll.append(temp.left)
                            if temp.right:
                                ll.append(temp.right)
                        temp_res = ll
                return res
    ```

#### 按之字形顺序打印二叉树
- 问题描述
    * 请实现一个函数按照之字形打印二叉树,即第一行按照从左到右的顺 序打印,第二层按照从右至左的顺序打印,第三行按照从左到右的顺序打印,依此 类推.
- 解题思路
    * 参考上题
    * 通过一个中间变量储存奇偶, 然后判断是否要逆向输入
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
                    res = []
                    temp_res = []
                    temp_res.append(root)
                    i = 0
                    while temp_res:
                        if i == 0:
                            res.append([tmp.val for tmp in temp_res])
                            i = 1
                        else:
                            res.append([tmp.val for tmp in temp_res][::-1])
                            i = 0
                        ll = []
                        for temp in temp_res:
                            if temp.left:
                                ll.append(temp.left)
                            if temp.right:
                                ll.append(temp.right)
                        temp_res = ll
                return res
    ```

#### 序列化二叉树
- 问题描述
    * 请实现两个函数,分别用来序列化和反序列化二叉树
- 解题思路
    * 迭代用的是层序遍历
    * 递归用的是前序遍历
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode(object):
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Codec:
            def serialize(self, root):
                if not root: return "[]"
                queue = collections.deque()
                queue.append(root)
                res = []
                while queue:
                    node = queue.popleft()
                    if node:
                        res.append(str(node.val))
                        queue.append(node.left)
                        queue.append(node.right)
                    else: res.append("null")
                return '[' + ','.join(res) + ']'

            def deserialize(self, data):
                if data == "[]": return
                vals, i = data[1:-1].split(','), 1
                root = TreeNode(int(vals[0]))
                queue = collections.deque()
                queue.append(root)
                while queue:
                    node = queue.popleft()
                    if vals[i] != "null":
                        node.left = TreeNode(int(vals[i]))
                        queue.append(node.left)
                    i += 1
                    if vals[i] != "null":
                        node.right = TreeNode(int(vals[i]))
                        queue.append(node.right)
                    i += 1
                return root

        class Codec:
            def __init__(self):
                self.index = -1
            def serialize(self, root):
                res = []
                if not root:
                    res.append("#,")
                    return "".join(res)
                res.append("%s," % root.val)
                res.append(self.serialize(root.left))
                res.append(self.serialize(root.right))
                return "".join(res)
            def deserialize(self, res):
                self.index += 1
                count = len(res)
                temp = res.split(",")
                node = None
                if self.index >= count:
                    return None
                if temp[self.index] != "#":
                    node = TreeNode(int(temp[self.index]))
                    node.left = self.deserialize(res)
                    node.right = self.deserialize(res)
                return node


        # Your Codec object will be instantiated and called as such:
        # codec = Codec()
        # codec.deserialize(codec.serialize(root))
    ```

#### 二叉搜索树的第K小的节点
- 问题描述
    * 给定一棵二叉搜索树,请找出其中的第 k 小的结点
- 思路
    * 中序遍历, 然后找到k大就可以了
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def kthLargest(self, root: TreeNode, k: int) -> int:
                def dfs(root):
                    if not root: return
                    dfs(root.right)
                    if self.k == 0: return
                    self.k -= 1
                    if self.k == 0: self.res = root.val
                    dfs(root.left)

                self.k = k
                dfs(root)
                return self.res
    ```



