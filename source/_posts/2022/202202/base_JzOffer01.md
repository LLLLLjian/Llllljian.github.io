---
title: 剑指Offer_基础 (01)
date: 2022-02-07
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 二维数组中查找目标值
- 题目描述
    * 在一个二维数组中, 每一行都按照从左到右递增的顺序排序, 每一列 都按照从上到下递增的顺序排序.请完成一个函数, 输入这样的一个二维数组和一 个整数, 判断数组中是否含有该整数.
- 思路
    * 从右上角出发, 可以把它想成一个二叉树, 比根大往右, 比根小往左, 和根相等返回True, 越界返回False
- 代码实现
    ```python
        class Solution:
            def findNumberIn2DArray(self, matrix: List[List[int]], target: int) -> bool:
                if not matrix:
                    return False
                # n * m 的二维数组
                n, m = len(matrix), len(matrix[0])
                # 小于第一个 或者 大于最后一个直接返回false
                if (matrix[0][0] > target) or (matrix[n-1][m-1] < target):
                    return False
                i, j = len(matrix) - 1, 0
                while i >= 0 and j < len(matrix[0]):
                    if matrix[i][j] > target: i -= 1
                    elif matrix[i][j] < target: j += 1
                    else: return True
                return False
    ```

#### 替换字符串中的空格
- 题目描述
    * 将一个字符串中的空格替换成“%20”.例如:当字符串为 We Are Happy.则经过替换之后的字符串为 We%20Are%20Happy.
- 思路
    * 直接循环替换/直接使用函数
- 代码实现
    ```python
        class Solution:
            def replaceSpace(self, s: str) -> str:
                res = []
                for i in range(len(s)):
                    if s[i] == " ":
                        res.append("%20")
                    else:
                        res.append(s[i])
                return "".join(res)
    ```



