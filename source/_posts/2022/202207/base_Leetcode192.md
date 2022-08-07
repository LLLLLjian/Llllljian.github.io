---
title: Leetcode_基础 (192)
date: 2022-07-18
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了刷题了

<!-- more -->

#### 数独
- 题目链接
    * https://leetcode.cn/problems/sudoku-solver/
1. 对每一个格子所有可能的数字进行穷举,从1到9就是选择,全部试一遍不就行了
2. 简易代码
    ```python
        def backtrack(board, i, j):
            for ch in range(1, 10):
                # 做选择
                board[i][j] = ch
                # 继续穷举下一个
                backtrack(board, i+1, j)
                # 撤销选择
                board[i][j] = "."
    ```
3. i/j有效判断, 以及数字是否合法
    ```python
        def backtrack(board, i, j):
            if (j == n):
                # 穷举到最后一列的话就要换到下一行重新开始
                backtrack(board, i+1, 0)
                return
            # 如果该位置是预设的数字,不用我们操心
            if board[i][j] != ".":
                backtrack(board, i, j+1)
                return
            for ch in range(1, 10):
                # 如果遇到不合法的数字 就跳过
                if (not isValid(board, i, j, ch)):
                    continue
                # 做选择
                board[i][j] = ch
                # 继续穷举下一个
                backtrack(board, i+1, j)
                # 撤销选择
                board[i][j] = "."
        def isValid(board, i, j, ch):
            # 判断 board[i][j]是否可以填入 n
            for temp in range(10):
                # 判断行是否存在重复
                if board[i][temp] == ch:
                    return false
                # 判断列是否存在重复
                if board[temp][j] == ch:
                    return false
                # 判断 3 x 3方框是否存在重复
                if board[(i/3)*3+temp/3][(j/3)*3+temp%3] == ch:
                    return false
                return true
    ```
4. 确定basecase
    r == m 的时候就穷举完最后一行,完成了所有的穷举
    为了减少复杂度,我们可以让backtrack函数的返回值为bool, 如果找到一个可行解就返回true, 这样可以阻止后续的递归
5. 完整代码
    ```python
        class Solution:
            def solveSudoku(self, board):
                """
                :type board: List[List[str]]
                :rtype: None Do not return anything, modify board in-place instead.
                """
                def backtrack(i, j, board, n):
                    # 穷举到最后一列的话就换到下一行重新开始.
                    if  j == n:
                        return backtrack(i+1, 0, board, n)
                    if  i == n:
                        # 找到一个可行解,触发 base case
                        return board
                    # 如果该位置是预设的数字,不用我们操心
                    if board[i][j] != ".":
                        return backtrack(i, j+1, board, n)
                    for ch in range(1, 10):
                        ch = str(ch)
                        if isValid(i, j, board, n, ch):
                            # 做选择
                            board[i][j] = ch
                        else:
                            # 如果遇到不合法的数字,就跳过
                            continue
                        # 继续穷举下一个
                        if backtrack(i, j+1, board, n):
                            return True
                        # 撤销选择
                        board[i][j]='.'
                    return False
                def isValid(i, j, board, n, ch):
                    """
                    判断 board[i][j] 是否可以填入 n
                    """
                    for n1 in range(n):
                        # 判断行是否存在重复
                        if ch == board[n1][j]:
                            return False
                        # 判断列是否存在重复
                        if ch == board[i][n1]:
                            return False
                        # 数字 1-9 在每一个以粗实线分隔的 3x3 宫内只能出现一次.
                        if ch == board[(i//3)*3+n1%3][(j//3)*3+n1//3]: 
                            return False
                    return True
                backtrack(0, 0, board, 9)
    ```









