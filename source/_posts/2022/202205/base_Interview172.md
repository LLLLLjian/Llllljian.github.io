---
title: Interview_总结 (172)
date: 2022-05-17
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### 字母异位词分组
- 问题描述
    * 给你一个字符串数组,请你将 字母异位词 组合在一起.可以按任意顺序返回结果列表.字母异位词 是由重新排列源单词的字母得到的一个新单词,所有源单词中的字母通常恰好只用一次.
- 思路
    * 将每一项排序转为tuple, 然后归并到dict中
- 代码实现
    ```python
        class Solution:
            def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
                res = {}
                for item in strs:
                    key = tuple(sorted(item))
                    res[key] = res.get(key, []) + [item]
                return list(res.values())
    ```

#### 最小路径和
- 问题描述
    * 给定一个包含非负整数的 m x n 网格 grid ,请找出一条从左上角到右下角的路径,使得路径上的数字总和为最小.
- 思路
    * 先初始化第一行和第一列, 然后dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])
    * 因为grid可以变成dp, 所以就用grid[i][j]表示到达i,j处所需的最小路径
- 代码实现
    ```python
        class Solution:
            def minPathSum(self, grid: List[List[int]]) -> int:
                if not grid:
                    return 0
                m, n = len(grid), len(grid[0])
                for i in range(1, m):
                    # 初始化第一列
                    grid[i][0] += grid[i-1][0]
                for i in range(1, n):
                    # 初始化第一行
                    grid[0][i] += grid[0][i-1]
                for i in range(1, m):
                    for j in range(1, n):
                        grid[i][j] = grid[i][j] + min(grid[i][j-1], grid[i-1][j])
                return grid[-1][-1]
    ```

#### 颜色分类
- 问题描述
    * 给定一个包含红色、白色和蓝色、共 n 个元素的数组 nums ,原地对它们进行排序,使得相同颜色的元素相邻,并按照红色、白色、蓝色顺序排列.我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色.必须在不使用库的sort函数的情况下解决这个问题.
- 思路
    * 先移动0, 然后从0下标处移动1
- 代码实现
    ```python
        class Solution:
            def sortColors(self, nums: List[int]) -> None:
                length = len(nums)
                temp = 0
                for i in range(length):
                    if (nums[i] == 0):
                        nums[i], nums[temp] = nums[temp], nums[i]
                        temp += 1
                for i in range(temp, length):
                    if (nums[i] == 1):
                        nums[i], nums[temp] = nums[temp], nums[i]
                        temp += 1
                return nums
    ```

#### 单词搜索
- 问题描述
    * 给定一个 m x n 二维字符网格 board 和一个字符串单词 word .如果 word 存在于网格中,返回 true ；否则,返回 false .单词必须按照字母顺序,通过相邻的单元格内的字母构成,其中“相邻”单元格是那些水平相邻或垂直相邻的单元格.同一个单元格内的字母不允许被重复使用.
- 思路
    * 
- 代码实现
    ```python
        class Solution:
            def exist(self, board: List[List[str]], word: str) -> bool:
                m, n = len(board), len(board[0])
                visited = [[False] * n for _ in range(m)]
                def bfs(i, j, k):
                    if k == len(word):
                        return True
                    # 矩阵越界
                    if i < 0 or i >= m:
                        return False
                    # 矩阵越界
                    if j < 0 or j >= n:
                        return False
                    # 字符被使用
                    if visited[i][j]:
                        return False
                    # 字符串不相等
                    if word[k] != board[i][j]:
                        return False
                    visited[i][j] = True
                    # 这里用与符号|会超时,改成or就通过了,
                    # 应该与会递归每一个bfs, 而or只要前一个有True,后面的就不再执行了
                    res = bfs(i+1, j, k+1) or bfs(i-1, j, k+1) or bfs(i, j+1, k+1) or bfs(i, j-1, k+1)
                    # 剪枝
                    visited[i][j] = False
                    return res
                for i in range(m):
                    for j in range(n):
                        if bfs(i, j, 0):
                            return True
                return False
    ```




