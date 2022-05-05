---
title: 剑指Offer_基础 (27)
date: 2022-04-25
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 滑动窗口的最大值
- 题目描述
    * 给定一个数组和滑动窗口的大小,找出所有滑动窗口里数值的最大值
- 思路
    * 未形成窗口时, 只需要把前k个数中最大的放在双端队列的第一个就可以了
    * 形成窗口之后
        * 如果从窗口里滑走的数是双端队列里的最大的值, 那么就移除他
        * 移除双端队列中所有小于当前值的值
        * 将当前值追加到双端队列中
        * 双端队列的第一个永远是最大值
- 代码实现
    ```python
        class Solution:
            def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
                if not nums or k == 0: return []
                deque = collections.deque()
                # 未形成窗口
                for i in range(k):
                    while deque and deque[-1] < nums[i]:
                        deque.pop()
                    deque.append(nums[i])
                res = [deque[0]]
                # 形成窗口后
                for i in range(k, len(nums)):
                    # 如果从窗口里滑走的数是双端队列里的最大的值, 那么就移除他
                    if deque[0] == nums[i - k]:
                        deque.popleft()
                    # 移除双端队列中所有小于当前值的值
                    while deque and deque[-1] < nums[i]:
                        deque.pop()
                    # 将当前值追加到双端队列中
                    deque.append(nums[i])
                    # 双端队列的第一个永远是最大值
                    res.append(deque[0])
                return res
    ```

#### 矩阵中的路径
- 题目描述
    * 请设计一个函数,用来判断在一个矩阵中是否存在一条包含某字符串 所有字符的路径.路径可以从矩阵中的任意一个格子开始,每一步可以在矩阵中向 左,向右,向上,向下移动一个格子.如果一条路径经过了矩阵中的某一个格子, 则该路径不能再进入该格子
- 思路
    * 遍历+剪枝
    * 用visited记录每个节点的访问情况
    * 假设目前已经判断完k, visited[i][j], 那么下一个判断的就是
    * k+1, visited[i+1][j]
    * k+1, visited[i-1][j]
    * k+1, visited[i][j-1]
    * k+1, visited[i][j+1]
    * 他们之间是或的关系
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

#### 礼物的最大价值
- 题目描述
    * 在一个 m*n 的棋盘的每一格都放有一个礼物,每个礼物都有一定的价值(价值大于 0).你可以从棋盘的左上角开始拿格子里的礼物,并每次向右或者向下移动一格、直到到达棋盘的右下角.给定一个棋盘及其上面的礼物的价值,请计算你最多能拿到多少价值的礼物？
- 思路
    * 因为题目里写的只能每次向右或者向下移动一格
    * grid上的数值可以当成是当前格子最大的礼物值
    * grid[i][j] = max(grid[i][j - 1], grid[i - 1][j]) + grid[i][j]
- 代码实现
    ```python
        class Solution:
            def maxValue(self, grid: List[List[int]]) -> int:
                m, n = len(grid), len(grid[0])
                for j in range(1, n): # 初始化第一行
                    grid[0][j] += grid[0][j - 1]
                for i in range(1, m): # 初始化第一列
                    grid[i][0] += grid[i - 1][0]
                for i in range(1, m):
                    for j in range(1, n):
                        grid[i][j] += max(grid[i][j - 1], grid[i - 1][j])
                return grid[-1][-1]
    ```



