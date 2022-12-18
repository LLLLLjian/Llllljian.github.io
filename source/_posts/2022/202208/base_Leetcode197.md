---
title: Leetcode_基础 (196)
date: 2022-08-05
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了 刷题了

<!-- more -->

#### 递归
> 如果在函数中存在着调用函数本身的情况, 这种现象就叫递归

#### 基本步骤
1. 定义一个函数, 明确函数功能
2. 寻找问题与子问题之间的关系(递归公式)
3. 将递推公式在定义的函数中实现
4. 推导时间复杂度, 判定是否可以接受, 无法接受更换算法

#### 爬楼梯
> https://leetcode.cn/problems/climbing-stairs/
- 思路
    * 直接递归
    * 超时了, 那就用备忘录解法吧
- 实现
    ```python
        class Solution:
            def climbStairs(self, n: int) -> int:
                if n == 1:
                    return 1
                if n == 2:
                    return 2
                return self.climbStairs(n-1) + self.climbStairs(n-2)

        class Solution:
            def climbStairs(self, n: int) -> int:
                res = {}
                res[1] = 1
                res[2] = 2
                for i in range(3, n+1):
                    res[i] = res[i-1] + res[i-2]
                return res[n]
    ```

#### 青蛙跳台阶
> https://leetcode.cn/problems/qing-wa-tiao-tai-jie-wen-ti-lcof/
- 思路
    * 直接备忘录解法吧
- 代码实现
    ```python
        class Solution:
            def numWays(self, n: int) -> int:
                res = {}
                res[0] = 1
                res[1] = 1
                res[2] = 2
                for i in range(3, n+1):
                    res[i] = res[i-2] + res[i-1]
                return res[n] % 1000000007
    ```

#### 翻转二叉树
> https://leetcode.cn/problems/invert-binary-tree/
- 思路
    * 递归
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
                if root == None:
                    return
                root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)
                return root
    ```

#### 路径总和
> https://leetcode.cn/problems/path-sum/
- 思路
    * 还是递归呀
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
                if root == None:
                    return False
                if root.left == None and root.right == None and root.val == targetSum:
                    return True
                return self.hasPathSum(root.left, targetSum-root.val) or self.hasPathSum(root.right, targetSum-root.val)
    ```

#### 细胞分裂
- 问题描述
    * 有一个细胞, 没一个小时分裂一次, 一次分裂出一个新细胞, 第三个小时分裂后自然死亡.那么M(M<20)个小时后有多少细胞
- 思路
    * 还是递归的思路
    * f(n)表示n小时细胞的总数
    * f_a(n)表示n小时一状态细胞数
    * f_b(n)表示n小时二状态细胞数
    * f_c(n)表示n小时三状态细胞数
    * 四状态细胞就死了
    * f(n) = f_a(n) + f_b(n) + f_c(n)
    * f_a(n) = f_a(n-1) + f_b(n-1) + f_c(n-1) f_a(1) = 1
    * f_b(n) = f_a(n-1) f_b(1) = 0
    * f_c(n) = f_b(n-1) f_c(1) = 0 f_c(2) = 0
- 代码实现
    ```python
        def getRes(n):
            return a(n) + b(n) + c(n)
        
        def a(n):
            res = {}
            res[1] = 1
            for i in range(2, n+1):
                res[i] = res[i-1] + res[i-2]
            return res[n]
        def b(n):
            res = {}
            res[1] = 0
            for i in range(2, n+1):
                res[i] = a(n-1)
            return res[n]
        def c(n):
            res = {}
            res[1] = 0
            res[2] = 0
            for i in range(2, n+1):
                res[i] = b(n-1)
            return res[n]
    ```

