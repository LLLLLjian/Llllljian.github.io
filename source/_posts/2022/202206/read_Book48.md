---
title: 读书笔记 (48)
date: 2022-06-02
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-岛屿问题

<!-- more -->

#### 岛屿问题模板
- 代码实现
    ```python
        def dfs(grid, i, j, visited):
            m, n = len(grid), len(grid[0])
            if (i < 0) or (j < 0) or (i >= m) or (j >= n):
                # 超出索引边界
                return 
            if visited[i][j]:
                # 已遍历过 (i, j)
                return
            # 进入节点 (i, j)
            visited[i][j] = true
            # 上
            dfs(grid, i - 1, j, visited)
            # 下
            dfs(grid, i + 1, j, visited)
            # 左
            dfs(grid, i, j - 1, visited)
            # 右
            dfs(grid, i, j + 1, visited)
    ```

#### 岛屿数量
- 问题描述
    * 给你一个由 '1'(陆地)和 '0'(水)组成的的二维网格,请你计算网格中岛屿的数量.岛屿总是被水包围,并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成.此外,你可以假设该网格的四条边均被水包围.
- 思路
    * 先写一下模板,
    * 这里省略visited, 是因为直接将计算过的陆地置为水,这样就可以不走重复路了
    * 找到一个岛屿, 然后将他的上下左右都置为水, 然后返回, 再找一下个岛屿就可以了
- 代码实现
    ```python
        class Solution:
            def numIslands(self, grid: List[List[str]]) -> int:
                if not grid:
                    return 0
                res = 0
                m, n = len(grid), len(grid[0])
                def dfs(grid, i, j):
                    """
                    从 (i, j) 开始,将与之相邻的陆地都变成海水
                    """
                    m, n = len(grid), len(grid[0])
                    if (i < 0) or (j < 0) or (i >=m) or (j >= n):
                        # 超出索引边界
                        return
                    if grid[i][j] == "0":
                        # 已经是海水了
                        return
                    # 将 (i, j) 变成海水
                    grid[i][j] = "0"
                    # 淹没上下左右的陆地
                    dfs(grid, i-1, j)
                    dfs(grid, i+1, j)
                    dfs(grid, i, j-1)
                    dfs(grid, i, j+1)
                for i in range(m):
                    for j in range(n):
                        if grid[i][j] == "1":
                            # 每发现一个岛屿,岛屿数量加一
                            res += 1
                            # 然后使用 DFS 将岛屿淹了
                            dfs(grid, i, j)
                return res
    ```




#### 统计封闭岛屿的数目
- 问题描述
    * 二维矩阵 grid 由 0 (土地)和 1 (水)组成.岛是由最大的4个方向连通的 0 组成的群,封闭岛是一个 完全 由1包围(左、上、右、下)的岛.请返回 封闭岛屿 的数目.
- 思路
    * 上下左右的岛屿肯定不能算进去, 所以先将上下左右分别往中心扩展,一直淹没到陆地
    * 然后就和岛屿数量一样了
- 代码实现
    ```python
        class Solution:
            def closedIsland(self, grid: List[List[int]]) -> int:
                def dfs(nums, i, j):
                    m, n = len(grid), len(grid[0])
                    if (i < 0) or (j < 0) or (i >= m) or (j >= n):
                        return
                    if grid[i][j] == 1:
                        return
                    grid[i][j] = 1
                    dfs(grid, i-1, j)
                    dfs(grid, i+1, j)
                    dfs(grid, i, j-1)
                    dfs(grid, i, j+1)
                res = 0
                if not grid:
                    return res
                m, n = len(grid), len(grid[0])
                # 上下都置为1
                for j in range(n):
                    dfs(grid, 0, j)
                    dfs(grid, m-1, j)
                # 左右都置为1
                for i in range(m):
                    dfs(grid, i, 0)
                    dfs(grid, i, n - 1)
                for i in range(m):
                    for j in range(n):
                        if grid[i][j] == 0:
                            res += 1
                            dfs(grid, i, j)
                return res
    ```

#### 飞地的数量
- 问题描述
    * 给你一个大小为 m x n 的二进制矩阵 grid ,其中 0 表示一个海洋单元格、1 表示一个陆地单元格.一次 移动 是指从一个陆地单元格走到另一个相邻(上、下、左、右)的陆地单元格或跨过 grid 的边界.返回网格中 无法 在任意次数的移动中离开网格边界的陆地单元格的数量.
- 思路
    * 和上题基本一致, 把该淹的淹了, 然后循环一遍就可以了
- 代码实现
    ```python
        class Solution:
            def numEnclaves(self, grid: List[List[int]]) -> int:
                if not grid:
                    return 0
                res = 0
                m, n = len(grid), len(grid[0])
                def dfs(grid, i, j):
                    if (i<0) or (j<0) or (i>=m) or (j>=n):
                        return
                    if (grid[i][j] == 0):
                        return
                    grid[i][j] = 0
                    dfs(grid, i-1, j)
                    dfs(grid, i+1, j)
                    dfs(grid, i, j-1)
                    dfs(grid, i, j+1)
                # 淹没上下岛屿
                for j in range(n):
                    dfs(grid, 0, j)
                    dfs(grid, m-1, j)
                # 淹没左右岛屿
                for i in range(m):
                    dfs(grid, i, 0)
                    dfs(grid, i, n-1)
                for i in range(m):
                    for j in range(n):
                        if grid[i][j] == 1:
                            res += 1
                return res
    ```


#### 岛屿的最大面积
- 问题描述
    * 给你一个大小为 m x n 的二进制矩阵 grid .岛屿 是由一些相邻的 1 (代表土地) 构成的组合,这里的「相邻」要求两个 1 必须在 水平或者竖直的四个方向上 相邻.你可以假设 grid 的四个边缘都被 0(代表水)包围着.岛屿的面积是岛上值为 1 的单元格的数目.计算并返回 grid 中最大的岛屿面积.如果没有岛屿,则返回面积为 0 .
- 思路
    * 给 dfs 函数设置返回值,记录每次淹没的陆地的个数
- 代码实现
    ```python
        class Solution:
            def maxAreaOfIsland(self, grid: List[List[int]]) -> int:
                if not grid:
                    return 0
                m, n = len(grid), len(grid[0])
                def dfs(grid, i, j):
                    if (i<0) or (j<0) or (i>=m) or (j>=n):
                        # 越界
                        return 0
                    if grid[i][j] == 0:
                        # 已经是海了
                        return 0
                    # 不是海就置为海
                    grid[i][j] = 0
                    return dfs(grid, i-1, j) + dfs(grid, i+1, j) + dfs(grid, i, j-1) + dfs(grid, i, j+1) + 1
                res = 0
                for i in range(m):
                    for j in range(n):
                        if grid[i][j] == 1:
                            # 淹没岛屿,并更新最大岛屿面积
                            res = max(res, dfs(grid, i, j))
                return res
    ```





#### 统计子岛屿
- 问题描述
    * 给你两个 m x n 的二进制矩阵 grid1 和 grid2 ,它们只包含 0 (表示水域)和 1 (表示陆地).一个 岛屿 是由 四个方向 (水平或者竖直)上相邻的 1 组成的区域.任何矩阵以外的区域都视为水域.如果 grid2 的一个岛屿,被 grid1 的一个岛屿 完全 包含,也就是说 grid2 中该岛屿的每一个格子都被 grid1 中同一个岛屿完全包含,那么我们称 grid2 中的这个岛屿为 子岛屿 .请你返回 grid2 中 子岛屿 的 数目 .
- 思路
    * 当岛屿 B 中所有陆地在岛屿 A 中也是陆地的时候,岛屿 B 是岛屿 A 的子岛.
    * 反过来说,如果岛屿 B 中存在一片陆地,在岛屿 A 的对应位置是海水,那么岛屿 B 就不是岛屿 A 的子岛.
- 代码实现
    ```python
        class Solution:
            def countSubIslands(self, grid1: List[List[int]], grid2: List[List[int]]) -> int:
                m, n = len(grid1), len(grid1[0])
                def dfs(grid, i, j):
                    if (i<0) or (j<0) or (i>=m) or (j>=n):
                        return
                    if grid[i][j] == 0:
                        return
                    grid[i][j] = 0
                    dfs(grid, i, j+1)
                    dfs(grid, i, j-1)
                    dfs(grid, i-1, j)
                    dfs(grid, i+1, j)
                for i in range(m):
                    for j in range(n):
                        if (grid1[i][j] == 0) and (grid2[i][j] == 1):
                            # 这个岛屿肯定不是子岛,淹掉
                            dfs(grid2, i, j)
                res = 0
                # 现在 grid2 中剩下的岛屿都是子岛,计算岛屿数量
                for i in range(m):
                    for j in range(n):
                        if grid2[i][j] == 1:
                            res += 1
                            dfs(grid2, i, j)
                return res
    ```