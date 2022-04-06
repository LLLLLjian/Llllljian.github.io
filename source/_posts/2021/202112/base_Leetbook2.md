---
title: Leetbook_基础 (2)
date: 2021-12-15
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 数组在内存中是如何存放的
- 旋转矩阵
    * Q
        ```
            给你一幅由 N × N 矩阵表示的图像, 其中每个像素的大小为 4 字节.请你设计一种算法, 将图像旋转 90 度.

            不占用额外内存空间能否做到？

            示例 1:

            给定 matrix = 
            [
            [1,2,3],
            [4,5,6],
            [7,8,9]
            ],

            原地旋转输入矩阵, 使其变为:
            [
            [7,4,1],
            [8,5,2],
            [9,6,3]
            ]
            示例 2:

            给定 matrix =
            [
            [ 5, 1, 9,11],
            [ 2, 4, 8,10],
            [13, 3, 6, 7],
            [15,14,12,16]
            ], 

            原地旋转输入矩阵, 使其变为:
            [
            [15,13, 2, 5],
            [14, 3, 4, 1],
            [12, 6, 8, 9],
            [16, 7,10,11]
            ]
        ```
    * T
        * 第一行的第 xx 个元素在旋转后恰好是倒数第一列的第 xx 个元素.
        * 对于矩阵中的第二行而言, 在旋转后, 它出现在倒数第二列的位置
        * matrix\[row]\[col] = matrixnew\[col]\[n−row−1]
    * A
        ```python
            class Solution:
                def rotate(self, matrix: List[List[int]]) -> None:
                    n = len(matrix)
                    # 水平翻转
                    for i in range(n // 2):
                        for j in range(n):
                            matrix[i][j], matrix[n - i - 1][j] = matrix[n - i - 1][j], matrix[i][j]
                    # 主对角线翻转
                    for i in range(n):
                        for j in range(i):
                            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
        ```
- 零矩阵
    * Q
        ```
            编写一种算法, 若M × N矩阵中某个元素为0, 则将其所在的行与列清零.

            示例 1：

            输入：
            [
            [1,1,1],
            [1,0,1],
            [1,1,1]
            ]
            输出：
            [
            [1,0,1],
            [0,0,0],
            [1,0,1]
            ]
            示例 2：

            输入：
            [
            [0,1,2,0],
            [3,4,5,2],
            [1,3,1,5]
            ]
            输出：
            [
            [0,0,0,0],
            [0,4,5,0],
            [0,3,1,0]
            ]
        ```
    * T
        * 先记一下0的行数和列数, 然后把matrix中的行列置为0即可
    * A
        ```python
            class Solution:
                def setZeroes(self, matrix: List[List[int]]) -> None:
                    """
                    Do not return anything, modify matrix in-place instead.
                    """
                    m = len(matrix)
                    n = len(matrix[0])
                    row = [0] * len(matrix)
                    column = [0] * len(matrix[0])

                    # 统计、记录行列为0的元素
                    for i in range(m):
                        for j in range(n):
                            if matrix[i][j] == 0:
                                row[i] = 1
                                column[j] = 1
                    for i in range(m):
                        for j in range(n):
                            if row[i] == 1 or column[j] == 1:
                                matrix[i][j] = 0
        ```