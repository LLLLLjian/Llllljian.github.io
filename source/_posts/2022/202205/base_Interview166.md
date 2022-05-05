---
title: Interview_总结 (166)
date: 2022-05-05
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 在排序数组中查找元素的第一个和最后一个位置
- 问题描述
    * 给定一个按照升序排列的整数数组 nums,和一个目标值 target.找出给定目标值在数组中的开始位置和结束位置.如果数组中不存在目标值 target,返回 [-1, -1].
- 思路
    * 二分查找, 注意边界
- 代码实现
    ```python
        class Solution(object):
            def searchRange(self,nums, target):
                """
                :type nums: List[int]
                :type target: int
                :rtype: List[int]
                """
                def left_func(nums,target):
                    n = len(nums)-1
                    left = 0
                    right = n
                    while(left<=right):
                        mid = (left+right)//2
                        if nums[mid] >= target:
                            right = mid-1
                        if nums[mid] < target:
                            left = mid+1
                    return left
                a =  left_func(nums,target)
                b = left_func(nums,target+1)
                if  a == len(nums) or nums[a] != target:
                    return [-1,-1]
                else:
                    return [a,b-1]
    ```

#### 组合总和
- 问题描述
    * 给你一个 无重复元素 的整数数组 candidates 和一个目标整数 target ,找出 candidates 中可以使数字和为目标数 target 的 所有 不同组合 ,并以列表形式返回.你可以按 任意顺序 返回这些组合.
- 思路
    * use表示已经使用过的数(组成的列表)
    * remain表示距离target还有多大
    * 对candidates升序排序,以方便根据remain的大小使用return减小搜索空间；
    * 递归求可能的组合.具体的,每次递归时对所有candidates做一次遍历,情况有3：1,满足条件,则答案加入一条；2,不足,继续递归,3,超出,则直接退出本路线.
    * 注意每层递归都对全体candidates做遍历会导致如[2,2,3],[3,2,2]这样的对称重复的答案的产生.这是因为发生了“往前选择”的情况,我们每次更深层的递归都往后缩小一个candidates,强制函数只能“往后选择”,这将不会出现重复答案.
- 代码实现
    ```python
        class Solution:
            def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
                def dfs(candidates, begin, size, path, res, target):
                    if target < 0:
                        return
                    if target == 0:
                        res.append(path)
                        return
                    for index in range(begin, size):
                        dfs(
                            candidates,
                            index,
                            size,
                            path + [candidates[index]],
                            res,
                            target - candidates[index]
                        )
                size = len(candidates)
                if size == 0:
                    return []
                path = []
                res = []
                dfs(candidates, 0, size, path, res, target)
                return res

            def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
                candidates = sorted(candidates)
                ans = []
                def find(start, use, remain):
                    for i in range(start, len(candidates)):
                        c = candidates[i]
                        if c == remain:
                            ans.append(use + [c])
                        if c < remain:
                            find(i, use + [c], remain - c)
                        if c > remain:
                            return
                find(0, [], target)
                return ans
    ```

#### 
- 问题描述
    * 
- 思路
    * 
- 代码实现
    ```python
        1
    ```


#### 旋转图像
- 问题描述
    * 给定一个 n × n 的二维矩阵 matrix 表示一个图像.请你将图像顺时针旋转 90 度.
- 思路
    * 水平轴翻转 matrix[row][col] ​=> matrix[n−row−1][col]
    * 主对角线翻转 matrix[row][col] => matrix[col][row]
- 代码实现
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

