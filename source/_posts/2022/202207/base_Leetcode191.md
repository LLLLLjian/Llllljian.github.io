---
title: Leetcode_基础 (191)
date: 2022-07-12
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了刷题了

<!-- more -->

#### 最小路径和
- 题目链接
    * https://leetcode.cn/problems/minimum-path-sum/
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