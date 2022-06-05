---
title: 读书笔记 (45)
date: 2022-05-29
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二叉树(序列化篇)

<!-- more -->

#### 二叉树的序列化与反序列化
- 问题描述
    * 给你输入一棵二叉树的根节点 root,要能将树转换为字符串,也要能将字符串转换为树
- 思路
    * 前序遍历实现即可
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode(object):
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

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
        # ser = Codec()
        # deser = Codec()
        # ans = deser.deserialize(ser.serialize(root))
    ```





