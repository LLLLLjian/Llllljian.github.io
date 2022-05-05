---
title: 剑指Offer_基础 (20)
date: 2022-04-01
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### n个骰子的点数及出现的概率
- 题目描述
    * 把 n 个骰子扔在地上,所有骰子朝上一面的点数之和为s,输入n,打印出s的所有可能出现的概率
- 思路
    * 同理跳台阶
    * 跳台阶: dp[i] = dp[i-1] + dp[i-2]
    * 掷骰子: dp[s] = dp[s-1] + dp[s-2] + .. + dp[s-6]
- 代码实现
    ```python
        class Solution:
            def dicesProbability(self, n: int) -> List[float]:
                # 因为最后的结果只与前一个动态转移数组有关,所以这里只需要设置一个一维的动态转移数组
                # 原本dp[i][j]表示的是前i个骰子的点数之和为j的概率,现在只需要最后的状态的数组,所以就只用一个一维数组dp[j]表示n个骰子下每个结果的概率.
                # 初始是1个骰子情况下的点数之和情况,就只有6个结果,所以用dp的初始化的size是6个
                dp = [1 / 6] * 6
                # 从第2个骰子开始,这里n表示n个骰子,先从第二个的情况算起,然后再逐步求3个、4个···n个的情况
                # i表示当总共i个骰子时的结果
                for i in range(2, n + 1):
                    # 每次的点数之和范围会有点变化,点数之和的值最大是i*6,最小是i*1,i之前的结果值是不会出现的；
                    # 比如i=3个骰子时,最小就是3了,不可能是2和1,所以点数之和的值的个数是6*i-(i-1),化简：5*i+1
                    # 当有i个骰子时的点数之和的值数组先假定是temp
                    tmp = [0] * (5 * i + 1)
                    # 从i-1个骰子的点数之和的值数组入手,计算i个骰子的点数之和数组的值
                    # 先拿i-1个骰子的点数之和数组的第j个值,它所影响的是i个骰子时的temp[j+k]的值
                    for j in range(len(dp)):
                        # 比如只有1个骰子时,dp[1]是代表当骰子点数之和为2时的概率,它会对当有2个骰子时的点数之和为3、4、5、6、7、8产生影响,因为当有一个骰子的值为2时,另一个骰子的值可以为1~6,产生的点数之和相应的就是3~8；比如dp[2]代表点数之和为3,它会对有2个骰子时的点数之和为4、5、6、7、8、9产生影响；所以k在这里就是对应着第i个骰子出现时可能出现六种情况,这里可能画一个K神那样的动态规划逆推的图就好理解很多
                        for k in range(6):
                            # 这里记得是加上dp数组值与1/6的乘积,1/6是第i个骰子投出某个值的概率
                            tmp[j + k] += dp[j] / 6
                    # i个骰子的点数之和全都算出来后,要将temp数组移交给dp数组,dp数组就会代表i个骰子时的可能出现的点数之和的概率；用于计算i+1个骰子时的点数之和的概率
                    dp = tmp
                return dp
    ```

#### 扑克牌的顺子
- 题目描述
    * 从扑克牌中随机抽 5 张牌,判断是不是一个顺子,即这 5 张牌是不是 连续的.2~10 为数字本身,A 为 1,J 为 11,Q 为 12,K 为 13,大小王可以看成 任意数字.
- 思路
    * 最大牌 - 最小牌 < 5 则可构成顺子
- 代码实现
    ```python
        class Solution:
            def isStraight(self, nums: List[int]) -> bool:
                repeat = set()
                ma, mi = 0, 14
                for num in nums:
                    if num == 0: continue # 跳过大小王
                    ma = max(ma, num) # 最大牌
                    mi = min(mi, num) # 最小牌
                    if num in repeat: return False # 若有重复,提前返回 false
                    repeat.add(num) # 添加牌至 Set
                return ma - mi < 5 # 最大牌 - 最小牌 < 5 则可构成顺子 
    ```

#### 一手顺子
- 问题描述
    * Alice 手中有一把牌,她想要重新排列这些牌,分成若干组,使每一组的牌数都是 groupSize ,并且由 groupSize 张连续的牌组成.
- 解题思路
    * 手里的扑克只能出顺子, 出完了返回true, 出不完返回false
- 代码实现
    ```python
        class Solution:
            def isNStraightHand(self, hand: List[int], groupSize: int) -> bool:
                if len(hand) % groupSize > 0:
                    return False
                hand.sort()
                # 统计个数 { key : 出现次数}
                cnt = Counter(hand)
                for x in hand:
                    # 已经用完了 或者 不存在 都会返回0
                    if cnt[x] == 0:
                        continue
                    # 从x到x+groupSize 出现了次数就-1
                    for num in range(x, x + groupSize):
                        # 如果这个数用完了 就返回false
                        if cnt[num] == 0:
                            return False
                        cnt[num] -= 1
                return True
    ```
