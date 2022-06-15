---
title: 读书笔记 (50)
date: 2022-06-08 12:00:00
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-如何高效解决接雨水问题

<!-- more -->

#### 接雨水
- 核心思想
    * 需要拆分到每个i能容纳的水量
    ![接雨水](/img/20220608_1.png)
    * 具体来说,仅仅对于位置 i,能装下多少水呢？
    * 能装 2 格水,因为 height[i] 的高度为 0,而这里最多能盛 2 格水,2-0=2.
    * 为什么位置 i 最多能盛 2 格水呢？因为,位置 i 能达到的水柱高度和其左边的最高柱子、右边的最高柱子有关,我们分别称这两个柱子高度为 l_max 和 r_max；位置 i 最大的水柱高度就是 min(l_max, r_max)
    * 得到规律
        ```
            water[i] = min(
               # 左边最高的柱子
               max(height[0..i]),  
               # 右边最高的柱子
               max(height[i..end]) 
            ) - height[i]
        ```
    * 验证一下结论
    ![接雨水](/img/20220608_2.png)
    ![接雨水](/img/20220608_3.png)
- 暴力解法
    ```python
        class Solution:
            def trap(self, height: List[int]) -> int:
                res = 0
                if not height:
                    return res
                for i in range(1, len(height)):
                    """
                    取当前数字的左右最大值, 然后比较出一个最小值, 减去当前位置上的数字, 加起来就是它能容纳的水
                    试了一下 果然超时了
                    """
                    minNum = max(height[0:i], default=0)
                    maxNum = max(height[i+1:], default=0)
                    temp = min(minNum, maxNum) - height[i]
                    if temp > 0:
                        res += temp
                return res
    ```
- 备忘录
    ```python
        class Solution:
            def trap(self, height: List[int]) -> int:
                res = 0
                if not height:
                    return res
                length = len(height)
                """
                记录一下每个位置 从左到右 从右到左的最大值即可
                O(N)
                """
                leftMaxNums = [0] * length
                leftMaxNums[0] = height[0]
                rightMaxNums = [0] * length
                rightMaxNums[length-1] = height[-1]
                for i in range(1, length):
                    leftMaxNums[i] = max(leftMaxNums[i-1], height[i])
                for i in range(length-2, -1, -1):
                    rightMaxNums[i] = max(rightMaxNums[i+1], height[i])
                for i in range(1, len(height)):
                    temp = min(leftMaxNums[i], rightMaxNums[i]) - height[i]
                    if temp > 0:
                        res += temp
                return res
    ```
- 双指针
    ```python
        class Solution:
            def trap(self, height: List[int]) -> int:
                res = 0
                if not height:
                    return res
                leftMaxNums, rightMaxNum = 0, 0
                left, right = 0, len(height) -1
                while left <= right:
                    # leftMaxNums 是 height[0..left] 中最高柱子的高度
                    # rightMaxNum 是 height[right..end] 的最高柱子的高度
                    leftMaxNums = max(leftMaxNums, height[left])
                    rightMaxNum = max(rightMaxNum, height[right])

                    # res += min(leftMaxNums, rightMaxNum) - height[i]
                    # 我们已经知道 leftMaxNums < rightMaxNum 了,至于这个 rightMaxNum 是不是右边最大的,不重要.重要的是 height[i] 能够装的水只和较低的 leftMaxNums 之差有关
                    if (leftMaxNums < rightMaxNum):
                        res += leftMaxNums - height[left]
                        left += 1
                    else:
                        res += rightMaxNum - height[right]
                        right -= 1
                return res
    ```

#### 盛最多水的容器
- 问题描述
    * 给定一个长度为 n 的整数数组 height .有 n 条垂线,第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) .找出其中的两条线,使得它们与 x 轴共同构成的容器可以容纳最多的水.返回容器可以储存的最大水量.说明：你不能倾斜容器.
- 思路
    * 面积 = min(height[left], height[right]) * (right - left)
    * max面积 = height[left]谁小谁变换, 因为换最小面积可能会变大
- 代码实现
    ```python
        class Solution:
            def maxArea(self, height: List[int]) -> int:
                """
                面积 = min(height[left], height[right]) * (right - left)
                max面积 = height[left]谁小谁变换
                """
                left, right = 0, len(height) - 1
                res = 0
                while left <= right:
                    res = max(res, min(height[left], height[right]) * (right - left))
                    if height[left] > height[right]:
                        right -= 1
                    else:
                        left += 1
                return res
    ```

