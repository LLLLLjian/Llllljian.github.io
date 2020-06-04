---
title: DataStructure_基础 (38)
date: 2020-01-08
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[如何实现红包算法]

<!-- more -->

#### 如何实现红包算法
- Q
    * 例如一个人在群里发了100块的红包, 10个人一起抢, 每个人抢到的金额随机
    * 规则1 : 所有人抢到的金额之和要等于红包金额, 不能多也不能少
    * 规则2 : 每个人至少抢到一分钱
    * 规则3 : 尽可能分布均匀, 不要出现两极分化太严重的
- 解题思路1
    * 二倍均值法
    * 假设剩余红包金额为m元, 剩余人数为n, 每次抢到的金额= 随机区间[0.01, m/n*2-0.01]
- A1
    ```php
        /**
         * $totalAmount 总金额
         * $totalPeopleNum 总人数
         **/
        function divideRedPackage($totalAmount, $totalPeopleNum)
        {
            $resAmount = $totalAmount;
            $resPeopleNum = $totalPeopleNum;
            $amountArr = array();
            for ($i=0;$i<$totalPeopleNum-1;$i++) {
                $amount = rand(0.01, $resAmount/$resPeopleNum * 2 - 0.01);
                $resAmount -= $amount;
                $resPeopleNum--;
                $amountArr[] = $amount;
            }
            $amountArr[] = $resAmount;
            return $amountArr;
        }
    ```
- 解题思路2
    * 线段切割法
    * 线段分割法就是把红包总金额想象成一条线段, 而每个人抢到的金额, 则是这条主线段所拆分出的子线段.当N个人一起抢红包的时候, 就需要确定N-1个切割点.因此, 当N个人一起抢总金额为M的红包时, 我们需要做N-1次随机运算, 以此确定N-1个切割点.随机的范围区间是(1,  M).当所有切割点确定以后, 子线段的长度也随之确定.这样每个人来抢红包的时候, 只需要顺次领取与子线段长度等价的红包金额即可
- A2
    ```php
        /**
         * $totalAmount 总金额
         * $totalPeopleNum 总人数
         **/
        function divideRedPackage($totalAmount, $totalPeopleNum)
        {
            // 将元转化为分
            $amountFen = $totalAmount * 100;
            // 从$totalPeopleNum中取$totalPeopleNum-1个随机数
            $i = 1;
            $randArr = array();
            while ($i < $totalPeopleNum) {
                $randNum = rand(1, $amountFen - 1);
                // 如果已经存在该随机数不保存, 主要解决抢到0元的情况
                if (!in_array($randNum, $randArr)) {
                    $randArr[] = $randNum;
                    $i += 1;
                }
            }
            // 从小到大排序
            sort($randArr);

            //中奖结果
            $result = array();
            foreach ($randArr as $key =>$value) {
                if ($key == 0) {
                    $result[] = $value;
                } else {
                    $result[] = $value - $randArr[$key - 1];
                }
            }

            //最后一个人的中奖结果
            $result[] = $amountFen - $randArr[count($randArr) - 1];
            //转化成元
            foreach ($result as $key=>$value) {
                $result[$key] = $value / 100;
            }
            return $result;
        }
    ```
