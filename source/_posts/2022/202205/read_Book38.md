---
title: 读书笔记 (38)
date: 2022-05-22
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-差分数组

<!-- more -->

#### 差分数组
> 差分数组的主要适用场景是频繁对原始数组的某个区间的元素进行增减
- 先引入一个题
    * 输入一个数组 nums,然后又要求给区间 nums[2..6] 全部加 1,再给 nums[3..9] 全部减 3,再给 nums[0..4] 全部加 2,一通操作猛如虎,然后问你,最后 nums 数组的值是什么
- 思路
    * for循环去做, 时间复杂度每次为n
- 巧妙的办法
    * 我们先对 nums 数组构造一个 diff 差分数组,diff[i] 就是 nums[i] 和 nums[i-1] 之差
    * 这样构造差分数组 diff,就可以快速进行区间增减的操作,如果你想对区间 nums[i..j] 的元素全部加 3,那么只需要让 diff[i] += 3,然后再让 diff[j+1] -= 3 即可
    * 原理很简单,回想 diff 数组反推 nums 数组的过程,diff[i] += 3 意味着给 nums[i..] 所有的元素都加了 3,然后 diff[j+1] -= 3 又意味着对于 nums[j+1..] 所有元素再减 3,那综合起来,是不是就是对 nums[i..j] 中的所有元素都加 3 了
- 差分数组工具类
    ```python
        # 差分数组工具类
        class Difference:
            # 差分数组
            def __init__(self, nums):
                self.diff = []
                if len(nums) > 0:
                    self.diff = [0] * len(nums)
                    self.diff[0] = nums[0]
                    for i in range(1, len(nums)):
                        self.diff[i] = nums[i] - nums[i-1]

            # 给闭区间 [i, j] 增加 val(可以是负数)
            def increment(self, i, j, val):
                self.diff[i] += val
                if (j + 1 < len(self.diff)):
                    self.diff[j + 1] -= val

            # 返回结果数组
            def result(self):
                res = [0] * len(self.diff)
                # 根据差分数组构造结果数组
                res[0] = self.diff[0]
                for i in range(1, len(self.diff)):
                    res[i] = res[i-1] + self.diff[i]
                return res

        nums = [8, 5, 9, 6, 1]
        a = Difference(nums)
        a.increment(1, 3, 3)
        a.increment(2, 5, -1)
        print(a.result())
    ```

#### 区间加法
- 问题描述
    * 假设你有一个长度为 n 的数组,初始情况下所有的数字均为 0,你将会被给出 k​​​​​​​ 个更新的操作.其中,每个操作会被表示为一个三元组：[startIndex, endIndex, inc],你需要将子数组 A[startIndex … endIndex](包括 startIndex 和 endIndex)增加 inc.请你返回 k 次操作后的数组.
- 思路
    * 利用差分数组
- 代码实现
    ```python
        class Solution:
            def getModifiedArray(self, length: int, updates: List[List[int]]) -> List[int]:
                target = [0] * (length+1)
                length1 = len(updates)
                for j in range(length1):
                    start = int(updates[j][0])
                    end = int(updates[j][1])
                    opreate = int(updates[j][2])
                    target[start] += opreate
                    target[end+1] -= opreate
                for i in range(1,length):
                    target[i] += target[i-1]
                return target[0:length]
    ```

#### 航班预订统计
- 问题描述
    * 这里有 n 个航班,它们分别从 1 到 n 进行编号.有一份航班预订表 bookings ,表中第 i 条预订记录 bookings[i] = [firsti, lasti, seatsi] 意味着在从 firsti 到 lasti (包含 firsti 和 lasti )的 每个航班 上预订了 seatsi 个座位.请你返回一个长度为 n 的数组 answer,里面的元素是每个航班预定的座位总数.
- 思路
    * 差分数组
- 代码实现
    ```python
        class Solution:
            def corpFlightBookings(self, bookings: List[List[int]], n: int) -> List[int]:
                target = [0] * n
                length1 = len(bookings)
                for j in range(length1):
                    # 因为航班从1开始编号, 所以这里的start 从n-1开始
                    start = int(bookings[j][0]) - 1
                    end = int(bookings[j][1]) - 1
                    opreate = int(bookings[j][2])
                    target[start] += opreate
                    if end+1 < n:
                        target[end+1] -= opreate
                for i in range(1,n):
                    target[i] += target[i-1]
                return target
    ```

#### 拼车
- 问题描述
    * 车上最初有 capacity 个空座位.车 只能 向一个方向行驶(也就是说,不允许掉头或改变方向)给定整数 capacity 和一个数组 trips ,  trip[i] = [numPassengersi, fromi, toi] 表示第 i 次旅行有 numPassengersi 乘客,接他们和放他们的位置分别是 fromi 和 toi .这些位置是从汽车的初始位置向东的公里数.当且仅当你可以在所有给定的行程中接送所有乘客时,返回 true,否则请返回 false.
- 思路
    * 差分数组
- 代码实现
    ```python
        class Difference:
            def __init__(self, nums):
                n = len(nums)
                assert n > 0
                self.diff = [0 for _ in range(n)]
                self.diff[0] = nums[0]
                for i in range(1, n):
                    self.diff[i] = nums[i] - nums[i-1]
            
            def increment(self, i, j, val):
                self.diff[i] += val
                if j+1 < len(self.diff):
                    self.diff[j+1] -= val
            
            def result(self):
                n = len(self.diff)
                res = [0 for _ in range(n)]
                res[0] = self.diff[0]
                for i in range(1, n):
                    res[i] = res[i-1] + self.diff[i]
                return res

        class Solution:
            def carPooling(self, trips: List[List[int]], capacity: int) -> bool:
                nums = [0 for _ in range(1001)]
                df = Difference(nums)

                for trip in trips:
                    # 注意这里,在toi的时候乘客已经下去了,所以j=toi-1
                    i, j, val = trip[1], trip[2]-1, trip[0]
                    df.increment(i, j, val)
                
                res = df.result()
                for num in res:
                    if num > capacity:
                        return False
                return True
    ```





