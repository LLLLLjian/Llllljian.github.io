---
title: Leetbook_基础 (10)
date: 2021-12-27
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 杨辉三角
- Q
    ```
        给定一个非负整数 numRows, 生成「杨辉三角」的前 numRows 行.

        在「杨辉三角」中, 每个数是它左上方和右上方的数的和.
        示例 1:
        输入: numRows = 5
        输出: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
        示例2:
        输入: numRows = 1
        输出: [[1]]

        提示:
        1 <= numRows <= 30
    ```
- T
    * 先生成一个全是1的指定数量的二位数组, 然后在循环去变更要变更的值
    * res\[m]\[n] = res\[m-1]\[n-1] + res\[m-1]\[n]
- A
    ```python
        class Solution:
            def generate(self, numRows: int) -> List[List[int]]:
                res = []
                for i in range(numRows):
                    res.append([1] * (i + 1))
                for m in range(2, numRows):
                    for n in range(1, m):
                        res[m][n] = res[m-1][n-1] + res[m-1][n]
                return res
    ```

#### 杨辉三角 II
- Q
    ```
        给定一个非负索引 rowIndex, 返回「杨辉三角」的第 rowIndex 行
        在「杨辉三角」中, 每个数是它左上方和右上方的数的和

        示例 1:
        输入: rowIndex = 3
        输出: [1,3,3,1]
        示例 2:
        输入: rowIndex = 0
        输出: [1]
        示例 3:
        输入: rowIndex = 1
        输出: [1,1]

        你可以优化你的算法到 O(rowIndex) 空间复杂度吗
    ```
- T
    * 方法1
    * rowIndex=3时, res变化过程
    * 初始化 [1, 1, 1, 1]
    * i=1时 [1, 2, 1, 1]
    * i=2时 j=2 [1, 2, 3, 1]
    *       j=1 [1, 3, 2, 1]
    * 方法2
    * 每一行等于上一行前后错位后之和
    * O(k)的空间复杂度, 防止覆盖需要倒序遍历
        ```
            1 3 3 1 0
          + 0 1 3 3 1
          = 1 4 6 4 1
        ```
- A
    ```python
        class Solution:
            def getRow(self, rowIndex: int) -> List[int]:
                res = []
                res = [1] * (rowIndex + 1)
                if rowIndex < 2:
                    return res
                for i in range(1, rowIndex):
                    for j in range(i, 0, -1):
                        res[j] = res[j] + res[j - 1]
                return res

            def getRow(self, rowIndex: int) -> List[int]:
                row = [0] * (rowIndex + 1)
                for i in range(0, rowIndex + 1):
                    for j in range(i, -1, -1):
                        if j == 0 or j == i:
                            row[j] = 1
                        else:
                            row[j] = row[j] + row[j-1]
                return row
    ```

