---
title: Leetcode_基础 (189)
date: 2022-07-05
tags: Leetcode
toc: true
---

### 坚持学习系列
    刷题了刷题了

<!-- more -->

#### 基站信号地图
- 问题描述
    * 大概意思就是一个M x N矩阵, 1表示基站, 0表示平地.基站的上下左右和斜边都会有信号, 可以叠加, 求这个地图上的信号总和
- 思路
    * 直接暴力穷举就可以了
- 代码实现
    ```python
        def getNums(grid):
            count = 0
            m, n = len(grid), len(grid[0])
            def check(i, j):
                if (i<0) or (j<0) or (i>=m) or (j>=n):
                    return 0
                # 如果已经是基站就直接返回
                if grid[i][j] == 1:
                    return 0
                else:
                    return 1
            for i in range(m):
                for j in range(n):
                    if grid[i][j] == 1:
                        count += check(i-1, j-1)
                        count += check(i, j-1)
                        count += check(i+1, j-1)
                        count += check(i+1, j)
                        count += check(i+1, j+1)
                        count += check(i, j+1)
                        count += check(i-1, j+1)
                        count += check(i-1, j+1)
                        count += check(i-1, j)
            return count
    ```










#### 最大发货数量
- 问题描述
    ```
        packs 里有背包容量
        goods 里有商品大小
        最多能装多少货
    ```
- 解题思路
    * 直接倒序 然后双指针就可以了
- 代码实现
    ```python
        def find_max_delivery_express(packs, goods):
            packs.sort()
            goods.sort()
            res = 0
            p, b = len(packs)-1, len(goods)-1
            while (p>=0) and (b>=0):
                if goods[b] <= packs[p]:
                    res += goods[b]
                    b -= 1
                    p -= 1
                else:
                    b -= 1
            return res
    ```

#### 简易日志系统
- 问题描述
    ```
        在一个简易日志系统中, 每条日志有唯一的 ID, 以及它的生成时间 timeStamp(ID 和 timeStamp 均为正整数).根据给出的函数框架, 请实现以下功能：

        void Add(int id,int timeStamp)：增加一条新的日志记录, 将这条日志记录存到系统中.
        int Delete(int id)：在日志系统中尝试删除这个 ID 对应的日志记录.如果该日志 ID 在系统中不存在, 返回 -1, 否则删除这条日志, 并返回 0.
        int Query(int startTime,int endTime)：返回日志系统中生成时间大于等于 startTime 且小于等于 endTime 的日志数量.如果没有, 返回 0.
        注：同一时间可能有多条日志.函数定义以对应语言的右侧实际框架为准.
    ```
- 解题思路
    * 一个map解决
- 代码实现
    ```python
        class LogSystem:
            def __init__(self):
                self.logs = {}

            def add(self, id: int, time_stamp: int) -> None:
                self.logs[id] = time_stamp

            def delete(self, id: int) -> int:
                if id in self.logs:
                    self.logs.pop(id)
                    return 0
                else:
                    return -1

            def query(self, start_time: int, end_time: int) -> int:
                cnt = 0
                for v in self.logs.values():
                    if v >= start_time and v <= end_time:
                        cnt += 1
                return cnt
    ```


#### 按身高排序
- 问题描述
    ```
        假设有打乱顺序的一群人站成一个队列, 数组 people 表示队列中一些人的属性(不一定按顺序).每个 people[i] = [hi, ki] 表示第 i 个人的身高为 hi , 前面 正好 有 ki 个身高大于或等于 hi 的人.

        请你重新构造并返回输入数组 people 所表示的队列.返回的队列应该格式化为数组 queue , 其中 queue[j] = [hj, kj] 是队列中第 j 个人的属性(queue[0] 是排在队列前面的人).
    ```
- 结题思路
    * 身高倒叙, 身高相同时, 位置正序, 然后往进插入就可以了
- 代码实现
    ```python
        class Solution:
            def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
                people = sorted(people, key = lambda x: (-x[0], x[1]))
                res = []
                for temp in people:
                    if len(res) <= temp[1]:
                        res.append(temp)
                    else:
                        res.insert(temp[1], temp)
                return res
    ```