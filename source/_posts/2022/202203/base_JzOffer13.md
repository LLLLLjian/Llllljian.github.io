---
title: 剑指Offer_基础 (13)
date: 2022-03-22
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 把数组中的数排成一个最小的数
- 题目描述
    * 输入一个正整数数组,把数组里所有数字拼接起来排成一个数,打印能拼接出的所有数字中最小的一个
- 思路
    * 此题求拼接起来的最小数字,本质上是一个排序问题.设数组 numsnums 中任意两数字的字符串为 xx 和 yy ,则规定 排序判断规则 为
        * 若拼接字符串 x+y>y+x ,则 x “大于” y,反之则 x “小于” y
        * X小于Y表示排序完成后 x应该在y的左边,大于则反之
    * 传递性规则证明
        ```
            字符串 xy < yx , yz < zy ,需证明 xz < zx 一定成立.
            设十进制数 x, y, z 分别有 a, b, c 位,则有：
            (左边是字符串拼接,右边是十进制数计算,两者等价)
            xy = x * 10^b + y 
            yx = y * 10^a + x

            则 xy < yx 可转化为：
            x * 10^b + y < y * 10^a + x
            x (10^b - 1) < y (10^a - 1)
            x / (10^a - 1) < y / (10^b - 1)     ①

            同理, 可将 yz < zy 转化为：
            y / (10^b - 1) < z / (10^c - 1)     ②

            将 ① ② 合并,整理得：
            x / (10^a - 1) < y / (10^b - 1) < z / (10^c - 1)
            x / (10^a - 1) < z / (10^c - 1)
            x (10^c - 1) < z (10^a - 1)
            x * 10^c + z < z * 10^a + x
            ∴  可推出 xz < zx ,传递性证毕
        ```
- 代码实现
    ```python
        class Solution:
            def minNumber(self, nums: List[int]) -> str:
                def quick_sort(l , r):
                    if l >= r: return
                    i, j = l, r
                    while i < j:
                        while strs[j] + strs[l] >= strs[l] + strs[j] and i < j: j -= 1
                        while strs[i] + strs[l] <= strs[l] + strs[i] and i < j: i += 1
                        strs[i], strs[j] = strs[j], strs[i]
                    strs[i], strs[l] = strs[l], strs[i]
                    quick_sort(l, i - 1)
                    quick_sort(i + 1, r)
                
                strs = [str(num) for num in nums]
                quick_sort(0, len(strs) - 1)
                return ''.join(strs)
    ```

#### 求第 N 个丑数
- 题目描述
    * 求从小到大的第 N 个丑数.丑数是只包含因子 2、3 和 5 的数,习惯上我们把 1 当做是第一个丑数.
- 思路
    * 乘 2 或 3 或 5,之后比较取最小值.
    * 可以说是A马一次只能跳两格,B马一次只能跳3格,C马一次只能跳5格.哪匹马落后最多,哪匹马就多跳一次,然后再比较三匹马哪个落后最多,再多跳一次......直到三匹马跳的总次数为n为止. 
- 代码实现
    ```python
        class Solution:
            def nthUglyNumber(self, n: int) -> int:
                dp, a, b, c = [1] * n, 0, 0, 0
                for i in range(1, n):
                    n2, n3, n5 = dp[a] * 2, dp[b] * 3, dp[c] * 5
                    dp[i] = min(n2, n3, n5)
                    if dp[i] == n2: a += 1
                    if dp[i] == n3: b += 1
                    if dp[i] == n5: c += 1
                return dp[-1]
    ```

