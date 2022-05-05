---
title: Interview_总结 (163)
date: 2022-05-02
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 汉明距离
- 问题描述
    * 两个整数之间的 汉明距离 指的是这两个数字对应二进制位不同的位置的数目.给你两个整数 x 和 y,计算并返回它们之间的汉明距离.
- 思路
    * 2的0-31次, 与一下相同的话就跳过, 不同的话就加1
- 代码实现
    ```python
        class Solution:
            def hammingDistance(self, x: int, y: int) -> int:
                res = 0
                for i in range(32):
                    temp = pow(2, i)
                    if (x & temp) == (y & temp):
                        pass
                    else:
                        res += 1
                return res
    ```

#### 二叉树的直径
- 问题描述
    * 给定一棵二叉树,你需要计算它的直径长度.一棵二叉树的直径长度是任意两个结点路径长度中的最大值.这条路径可能穿过也可能不穿过根结点.
- 思路
    * 二叉树最长路径可以求出最大的长度, 二叉树的直径和它不同的是, 要将左右相加, 然后更新最大值
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def __init__(self):
                self.max = 0

            def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
                self.maxDepth(root)
                return self.max
                
            def maxDepth(self, root):
                if not root:
                    return 0
                maxLeft = self.maxDepth(root.left)
                maxRight = self.maxDepth(root.right)
                self.max = max(self.max, maxLeft+maxRight)
                return max(maxLeft, maxRight) + 1
    ```

#### 合并二叉树
- 问题描述
    * 给你两棵二叉树： root1 和 root2 .想象一下,当你将其中一棵覆盖到另一棵之上时,两棵树上的一些节点将会重叠(而另一些不会).你需要将这两棵树合并成一棵新二叉树.合并的规则是：如果两个节点重叠,那么将这两个节点的值相加作为合并后节点的新值；否则,不为 null 的节点将直接作为新二叉树的节点.返回合并后的二叉树.
- 思路
    * 
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution(object):
            def mergeTrees(self, t1, t2):
                """
                递归
                """		
                def dfs(r1,r2):
                    # 如果 r1和r2中,只要有一个是null,函数就直接返回
                    if not (r1 and r2):
                        return r1 if r1 else r2
                    # 让r1的值 等于  r1和r2的值累加
                    # 再递归的计算两颗树的左节点、右节点
                    r1.val += r2.val
                    r1.left = dfs(r1.left,r2.left)
                    r1.right = dfs(r1.right,r2.right)
                    return r1
                return dfs(t1,t2)

            def mergeTrees(self, t1, t2):
                """
                迭代
                """	
            # 如果 t1和t2中,只要有一个是null,函数就直接返回
                if not (t1 and t2):
                    return t2 if not t1 else t1
                queue = [(t1,t2)]
                while queue:
                    r1,r2 = queue.pop(0)
                    r1.val += r2.val
                    # 如果r1和r2的左子树都不为空,就放到队列中
                    # 如果r1的左子树为空,就把r2的左子树挂到r1的左子树上
                    if r1.left and r2.left:
                        queue.append((r1.left,r2.left))
                    elif not r1.left:
                        r1.left = r2.left
                    # 对于右子树也是一样的
                    if r1.right and r2.right:
                        queue.append((r1.right,r2.right))
                    elif not r1.right:
                        r1.right = r2.right
                return t1
    ```
