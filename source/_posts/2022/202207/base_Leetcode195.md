---
title: Leetcode_基础 (195)
date: 2022-07-28
tags: Leetcode
toc: true
---

### 坚持学习系列
    二分查找-二分查找的前提是数组有序

<!-- more -->

#### 在 D 天内送达包裹的能力
> https://leetcode.cn/problems/capacity-to-ship-packages-within-d-days/
- 思路
    * 这艘船最小的运输能力是货物中最重的
    * 最大的运输能力是货物总和,一次运走
    * 然后就在这个区间里找一个最小天数就可以了
- 代码实现
    ```python
        class Solution:
            def shipWithinDays(self, weights: List[int], D: int) -> int:
                # 最小值得是任何一个货物都可以运走, 不可以分割货物
                start = max(weights)
                # 最大值是一趟就全部运走, 所以是所有货物之和
                end = sum(weights)
                # 二分法模板
                while start < end:
                    # 先求中间值
                    mid = (start + end)//2

                    # 计算这个中间值需要计算需要多少天运完
                    days = self.countDays(mid, weights)
                    # 如果天数超了, 说明运载能力有待提升, start改大一点, 继续二分搜索
                    if days > D:
                        start = mid + 1
                    # 否则运载能力改小一点继续搜索
                    else:
                        end = mid
                return start

            def countDays(self, targetWeight, weights):
                days = 1
                current = 0
                for weight in weights:
                    current += weight
                    if current > targetWeight:
                        days += 1
                        current = weight
                return days
    ```

#### 分割数组的最大值
> https://leetcode.cn/problems/split-array-largest-sum/
- 思路
    * 和上题一眼,搜索区间应该在max(nums)和sum(nums)之间
- 代码实现
    ```python
        class Solution:
            def splitArray(self, nums: list, m: int) -> int:
                # 由于题目的返回要求：返回最小和的值
                # 最小和必然落在 [max(nums), sum(nums)] 之间
                # 我们可以使用二分来进行查找
                low, high = max(nums), sum(nums)
                while low < high:
                    mid = (low + high) // 2
                    # 淘汰算法
                    # 我们由前向后对nums进行划分,使其子数组和 <= mid,然后统计满足条件的数组数量
                    # 若我们选的sum值过小,则满足条件的数量 > m,目标值应落在 [mid+1, high]
                    # 若我们选的sum值过大,则满足条件的数量 < m,目标值应落在 [low, mid-1]
                    count = 0
                    sub_sum = 0
                    for i in range(len(nums)):
                        sub_sum += nums[i]
                        if sub_sum > mid:
                            count += 1
                            sub_sum = nums[i]
                    # 注意：末尾还有一个子数组我们没有统计,这里把它加上
                    count += 1
                    if count > m:
                        low = mid + 1
                    else:
                        high = mid
                return low
    ```


#### 爱吃香蕉的珂珂
> https://leetcode.cn/problems/koko-eating-bananas/
- 思路
    * 最快每个小时吃max(nums)个,最慢每个小时吃1个
    * 小时要向上取整,因为吃不完剩下的一个小时也不能干别的
- 代码实现
    ```python
        class Solution:
            def minEatingSpeed(self, piles: List[int], h: int) -> int:
                def consume(nums: List[int], v: int) -> int:
                    ans = 0
                    for num in nums:
                        ans += num // v
                        if num % v != 0:
                            ans += 1
                    return ans

                left, right, n = 1, max(piles), len(piles)

                while left <= right:
                    mid = left + right >> 1
                    res = consume(piles, mid)
                    if res <= h:
                        right = mid - 1
                    else:
                        left = mid + 1
                    
                return left
    ```


