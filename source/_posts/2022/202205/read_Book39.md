---
title: 读书笔记 (39)
date: 2022-05-23
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二维数组的花式遍历技巧

<!-- more -->

#### 顺/逆时针旋转矩阵
- 问题描述
    * 给定一个 n × n 的二维矩阵 matrix 表示一个图像.请你将图像顺时针旋转 90 度.你必须在 原地 旋转图像,这意味着你需要直接修改输入的二维矩阵.请不要 使用另一个矩阵来旋转图像.
- 思路
    * 先对角线反转, 然后再反转每一行就可以了
- 代码实现
    ```python
        class Solution:
            def rotate(self, matrix: List[List[int]]) -> None:
                """
                Do not return anything, modify matrix in-place instead.
                """
                if not matrix:
                    return matrix
                n = len(matrix)
                # 对角线反转
                for i in range(n):
                    for j in range(i, n):
                        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
                # 左右翻转
                for i in range(n):
                    self.reverse(matrix[i])
                return matrix
                    
            def reverse(self, arr):
                i = 0
                j = len(arr) - 1
                while (j > i):
                    #  swap(arr[i], arr[j])
                    arr[i], arr[j] = arr[j], arr[i]
                    i += 1
                    j -= 1
    ```
- 扩展: 逆时针90度旋转
    ```python
        class Solution:
            def rotate(self, matrix: List[List[int]]) -> None:
                """
                Do not return anything, modify matrix in-place instead.
                """
                if not matrix:
                    return matrix
                n = len(matrix)
                # 对角线反转
                for i in range(n):
                    for j in range(n-i):
                        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
                # 左右翻转
                for i in range(n):
                    self.reverse(matrix[i])
                return matrix
                    
            def reverse(self, arr):
                i = 0
                j = len(arr) - 1
                while (j > i):
                    #  swap(arr[i], arr[j])
                    arr[i], arr[j] = arr[j], arr[i]
                    i += 1
                    j -= 1
    ```

#### 矩阵的螺旋遍历
- 问题描述
    * 给你一个 m 行 n 列的矩阵 matrix ,请按照 顺时针螺旋顺序 ,返回矩阵中的所有元素.
- 思路
    * 和顺时针打印矩阵逻辑一致
- 代码实现
    ```python
        class Solution:
            def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
                res = []
                if not matrix:
                    return res
                l, t, r, b = 0, 0, len(matrix[0])-1, len(matrix)-1
                while True:
                    # l->r
                    for i in range(l, r+1):
                        res.append(matrix[t][i])
                    t += 1
                    if t > b:
                        break
                    # t->b
                    for i in range(t, b+1):
                        res.append(matrix[i][r])
                    r -= 1
                    if l > r:
                        break
                    # r->l
                    for i in range(r, l-1, -1):
                        res.append(matrix[b][i])
                    b -= 1
                    if t > b:
                        break
                    # b->t
                    for i in range(b, t-1, -1):
                        res.append(matrix[i][l])
                    l += 1
                    if l > r:
                        break
                return res
    ```

#### 矩阵的螺旋遍历II
- 问题描述
    * 给你一个正整数 n ,生成一个包含 1 到 n2 所有元素,且元素按顺时针顺序螺旋排列的 n x n 正方形矩阵 matrix .
- 思路
    * 顺时针打印矩阵, 换一下条件就可以了
    * 需要注意的点 matrix = [[0 for _ in range(n)] for _ in range(n)] 可以
    * matrix = [[0] * n] * n不行
- 代码实现
    ```python
        class Solution:
            def generateMatrix(self, n: int) -> List[List[int]]:
                if n <= 0:
                    return [[]]
                matrix = [[0 for _ in range(n)] for _ in range(n)]
                l, t, r, b = 0, 0, n-1, n-1
                num = 1
                while True:
                    # l->r
                    for i in range(l, r+1):
                        matrix[t][i] = num
                        num += 1
                    t += 1
                    if t > b:
                        break
                    # t->b
                    for i in range(t, b+1):
                        matrix[i][r] = num
                        num += 1
                    r -= 1
                    if l > r:
                        break
                    # r->l
                    for i in range(r, l-1, -1):
                        matrix[b][i] = num
                        num += 1
                    b -= 1
                    if t > b:
                        break
                    # b->t
                    for i in range(b, t-1, -1):
                        matrix[i][l] = num
                        num += 1
                    l += 1
                    if l > r:
                        break
                return matrix
    ```



