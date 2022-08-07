---
title: Leetcode_基础 (196)
date: 2022-07-29
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了 刷题了

<!-- more -->

#### 最小路径和
> https://leetcode.cn/problems/minimum-path-sum/
- 思路
    * 直接一维dp就可以了
- 代码实现
    ```python
        class Solution:
            def minPathSum(self, grid: List[List[int]]) -> int:
                m, n = len(grid), len(grid[0])
                # 先算一下行的累加值
                for i in range(1, n):
                    grid[0][i] += grid[0][i-1]
                # 再算一下列的累加值
                for j in range(1, m):
                    grid[j][0] += grid[j-1][0]
                for i in range(1, m):
                    for j in range(1, n):
                        grid[i][j] += min(grid[i-1][j], grid[i][j-1])
                return grid[-1][-1]
    ```

#### 最大礼物价值
> 
- 思路
    * 同上,只不过一个取最大 一个取最小
- 代码实现
    ```python
        class Solution:
            def maxValue(self, grid: List[List[int]]) -> int:
                if not grid:
                    return 0
                m, n = len(grid), len(grid[0])
                # 最左侧
                for i in range(1, m):
                    grid[i][0] += grid[i-1][0]
                # 最上方
                for j in range(1, n):
                    grid[0][j] += grid[0][j-1]
                for i in range(1, m):
                    for j in range(1, n):
                        grid[i][j] += max(grid[i-1][j], grid[i][j-1])
                return grid[-1][-1]
    ```

