---
title: 读书笔记 (37)
date: 2022-05-21
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-前缀和数组

<!-- more -->

#### 区域和检索-数组不可变
- 问题描述
    * 给定一个整数数组  nums,处理以下类型的多个查询:计算索引 left 和 right (包含 left 和 right)之间的 nums 元素的 和 ,其中 left <= right实现 NumArray 类：NumArray(int[] nums) 使用数组 nums 初始化对象 int sumRange(int i, int j) 返回数组 nums 中索引 left 和 right 之间的元素的 总和 ,包含 left 和 right 两点(也就是 nums[left] + nums[left + 1] + ... + nums[right] )
- 思路
    * 利用前缀和, 初始化的时候就计算出每个位置的前缀和
- 代码实现
    ```python
        class NumArray:
            def __init__(self, nums: List[int]):
                self.preSum = [0] * len(nums)
                if len(nums) > 0:
                    self.preSum[0] = nums[0]
                    for i in range(1, len(nums)):
                        self.preSum[i] = self.preSum[i-1] + nums[i]

            def sumRange(self, left: int, right: int) -> int:
                if left == 0:
                    return self.preSum[right]
                else:
                    return self.preSum[right] - self.preSum[left-1]

        # Your NumArray object will be instantiated and called as such:
        # obj = NumArray(nums)
        # param_1 = obj.sumRange(left,right)
    ```

#### 二维区域和检索-矩阵不可变
- 问题描述
    * 给定一个二维矩阵 matrix,以下类型的多个请求：计算其子矩形范围内元素的总和,该子矩阵的 左上角 为 (row1, col1) ,右下角 为 (row2, col2) .实现 NumMatrix 类：NumMatrix(int[][] matrix) 给定整数矩阵 matrix 进行初始化 int sumRegion(int row1, int col1, int row2, int col2) 返回 左上角 (row1, col1) 、右下角 (row2, col2) 所描述的子矩阵的元素 总和 .
- 思路
    * 求preSum
    * S(O,D) = S(O,C) + S(O,B) − S(O,A) + D
    * preSum[i][j] = preSum[i−1][j] + preSum[i][j−1] − preSum[i−1][j−1] + matrix[i][j]
    ![步骤一](/img/20220512_1.png)
    * 根据 preSum 求子矩形面积
    * S(A,D)=S(O,D)−S(O,E)−S(O,F)+S(O,G)
    * preSum[row2][col2] − preSum[row2][col1−1] − preSum[row1−1][col2] + preSum[row1−1][col1−1]
    ![步骤二](/img/20220512_2.png)
- 代码实现
    ```python
        class NumMatrix:
            def __init__(self, matrix: List[List[int]]):
                if not matrix or not matrix[0]:
                    M, N = 0, 0
                else:
                    M, N = len(matrix), len(matrix[0])
                # 定义：preSum[i][j] 记录 matrix 中子矩阵 [0, 0, i-1, j-1] 的元素和
                self.preSum = [[0] * (N + 1) for _ in range(M + 1)]
                for i in range(M):
                    for j in range(N):
                        # preSum[1][1] = [0, 0, 0, 0]
                        self.preSum[i + 1][j + 1] = self.preSum[i][j + 1] + self.preSum[i + 1][j]  - self.preSum[i][j] + matrix[i][j]
            def sumRegion(self, row1: int, col1: int, row2: int, col2: int) -> int:
                return self.preSum[row2 + 1][col2 + 1] - self.preSum[row2 + 1][col1] - self.preSum[row1][col2 + 1] + self.preSum[row1][col1]
        # Your NumMatrix object will be instantiated and called as such:
        # obj = NumMatrix(matrix)
        # param_1 = obj.sumRegion(row1,col1,row2,col2)
    ```

