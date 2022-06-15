---
title: Interview_总结 (184)
date: 2022-06-08 22:00:00
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 图解赛马问题
- 问题描述
    * 有64匹马和8条跑道,每次只允许最多8匹马同时比赛(假定每匹马每次比赛速度相同),但是没有秒表不能计时,问最少要比多少次,才能选出最快的4匹马？
- 思路
    1. 把64匹马随机分为8组,总共比8场,淘汰每组后4名.为方便可视,我将马进行标记组别并同时记录每组中各马的名次
    ![赛马问题](/img/20220608_4.png)
    2. 在8组中选每组第1名的马进行比赛,按名次排序(重新对马进行标记,第一名为A1,其次为B1、C1、D1…)
    ![赛马问题](/img/20220608_5.png)
    3. 因为要取前4, 且A1>B1>C1>D1>E1>F1>G1>H1, 所以淘汰E1、F1、G1、H1, 再因为E1、F1、G1、H1都淘汰了所以E1、F1、G1、H1后边的兄弟也都淘汰了
    4. 因为要取前4, 且A1>B1>C1>D1>D2>D3>D4, 所以淘汰了D2>D3>D4, 同理B4、C3-4也淘汰了
    ![赛马问题](/img/20220608_6.png)
    5. 此时A1已经胜出了, 除了A1之外还有9个马
    6. 那就让除了D1之外的剩下8个马再比一次, 然后重点判断C1的名次
    7. 如果C1排第二, 那么B1、C1晋级, 剩下的7个再比一次
    8. 如果C1排3-7名, 那么除D1这8匹马中的前三名就直接进入TOP4
    9. 所以答案是10或11

#### 吃席
- 问题描述
    * 一间屋子有许多桌子,许多人.如果3个人坐一桌多2个人,如果5个人坐一桌多4个人,如果7个人坐一桌多6个人,如果9个人坐一桌多8个人,如果11个人坐一桌刚好,请问屋子里有多少人 要过程哦
- 思路
    1. 如果再来一个人, 刚好3个人坐一桌
    2. 如果再来一个人,刚好5个人坐一桌
    3. 如果再来一个人,刚好7个人坐一桌
    4. 如果再来一个人,刚好9个人坐一桌
    5. 所以人数应该是5,7,9的倍数 再减1
    6. 5,7,9的最小公倍数为315, 但314不能整除11
    7. 只有2519可以整除11

#### 摘果子
- 问题描述
    * 牛牛摘果子, num1是果子量, num2是每天摘的量, 求每天摘的果子量(不够的话 就全摘了)
- 思路
    * 先对果子排序, 然后叠加每天要摘的果子
    * 当天的时候假设把计划量全压到一天来做,预排序后通过二分找起点树,前面的苹果树上的苹果依次全摘,做加法,后面的苹果上的苹果树不管,直接做乘法.加完后减去前段时间摘得苹果数,就是今天能摘得苹果总数了.
- 代码实现
    ```python
        #!/usr/bin/python
        # Write Python 3 code in this online editor and run it.

        def help_search(nums, target):
            """
            找到nums中最接近target的下表
            """
            left = 0
            right = len(nums)
            while (left < right):
                mid = left + (right - left) // 2
                if nums[mid] == target:
                    right = mid
                elif nums[mid] > target:
                    right = mid
                elif nums[mid] < target:
                    left = mid + 1
            return left

        def help_main(num1, num2):
            num1.sort()
            preSumA = [0] * (len(num1) + 1)
            for i in range(1, len(num1)):
                # 前缀和
                preSumA[i] = preSumA[i-1] + num1[i-1]
            preSumB = [0] * len(num2)
            preSumB[0] = num2[0]
            for i in range(1, len(num2)):
                # 前缀和
                preSumB[i] = preSumB[i-1] + num2[i]
            # 结果
            start = 0
            res = []
            cur = pre = i= 0
            for x in num2:
                cur += x
                i = help_search(num1, cur)
                res.append(preSumA[i] + (len(num1)-i)*cur)
                res[-1] -= pre
                pre += res[-1]
            return res

        num1 = [10, 20, 10]
        num2 = [5, 7, 2]
        print(help_main(num1, num2))
    ```