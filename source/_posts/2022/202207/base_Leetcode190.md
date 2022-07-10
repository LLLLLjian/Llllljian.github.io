---
title: Leetcode_基础 (190)
date: 2022-07-06
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了刷题了

<!-- more -->

#### 稳定三角形的个数
- 问题描述
    * 大概意思就是给个数组, 从里边调三个数字组成三角形, 能组成有效三角形的个数
- 结题思路
    * 方法1, 我直接用的回溯+剪枝, 先求出所有的3个元素的组合, 然后在判断这三个数合规不合规.考试ac了, 但leetcode超时了
    * 方法2, 直接用二分, 规律见下
    * ![稳定三角形的个数](/img/20220706_1.PNG)
- 代码实现
    ```python
        class Solution:
            def triangleNumber(self, nums: List[int]) -> int:
                count = 0
                res = []
                def check(arr):
                    if ((arr[0] + arr[1]) > arr[2]) and (abs(arr[0] - arr[1]) < arr[2]):
                        return True
                    else:
                        return False
                def backtrack(path, nums, used, start):
                    if (len(path) == 3):
                        res.append(list(path))
                        return
                    for i in range(start, len(nums)):
                        if i in used and used[i]:
                            continue
                        path.append(nums[i])
                        used[i] = True
                        backtrack(path, nums, used, i)
                        path.pop()
                        used[i]= False
                backtrack([], nums, {}, 0)
                for tmp in res:
                    if check(tmp):
                        count += 1
                return count

        class Solution:
            def triangleNumber(self, nums: List[int]) -> int:
                nums.sort()
                n = len(nums)
                res = 0
                for right in range(2, n):
                    left = 0
                    mid = right - 1
                    while left < mid:
                        if nums[left] + nums[mid] > nums[right]:
                            res += mid - left
                            mid -= 1
                        else:
                            left += 1
                return res
    ```




#### 
- 问题描述
    ```
        给定一个形如 “HH:MM” 表示的时刻, 利用当前出现过的数字构造下一个距离当前时间最近的时刻.每个出现数字都可以被无限次使用.

        你可以认为给定的字符串一定是合法的.例如, “01:34” 和 “12:09” 是合法的, “1:34” 和 “12:9” 是不合法的.
        样例 1:
        输入: “19:34”
        输出: “19:39”
        解释: 利用数字 1, 9, 3, 4 构造出来的最近时刻是 19:39, 是 5 分钟之后.结果不是 19:33 因为这个时刻是 23 小时 59 分钟之后.
        样例 2:
        输入: “23:59”
        输出: “22:22”
        解释: 利用数字 2, 3, 5, 9 构造出来的最近时刻是 22:22. 答案一定是第二天的某一时刻, 所以选择可构造的最小时刻.
    ```
- 解题思路
    * 没啥解题思路, 就直接暴力点, 能算出来mm+1和HH+1就可以了, 保证不越界就行
- 代码实现
    ```python
        class Solution:
            def nextClosestTime(self, time: str) -> str:
                hour1, minute1 = time.split(":")
                numbers = set(hour1 + minute1)
                hour2 = hour1
                minute2 = minute1

                # 寻找更大的分钟
                for i in range(int(minute1) + 1, 60):
                    minute = str(i).zfill(2)
                    if minute[0] in numbers and minute[1] in numbers:
                        return hour2 + ":" + minute

                # 寻找更大的小时
                for i in range(int(hour1) + 1, 24):
                    temp = str(i).zfill(2)
                    if temp[0] in numbers and temp[1] in numbers:
                        hour2 = temp
                        break

                # 寻找最小的分钟
                for i in range(0, 60):
                    temp = str(i).zfill(2)
                    if temp[0] in numbers and temp[1] in numbers:
                        minute2 = temp
                        break

                # 这一天还有更大的小时
                if hour1 != hour2:
                    return hour2 + ":" + minute2

                # 寻找下一天里最小的小时
                for i in range(0, 23):
                    hour2 = str(i).zfill(2)
                    if hour2[0] in numbers and hour2[1] in numbers:
                        return hour2 + ":" + minute2

                # 无法改变
                return hour1 + ":" + minute1
    ```

#### 流水线生产商品
- 问题描述
    * 
- 思路
    * 
- 代码实现
    ```python
        1
    ```
