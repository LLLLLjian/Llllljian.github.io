---
title: Interview_总结 (41)
date: 2019-10-10
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 斐波那契数列求解
- Q
    * 什么是斐波那契数列,1,1,2,3,5,8,13...这样一个数列就是斐波那契数列,求第n项的值
- A
    ```php
        // fun1 递归
        // fun1 观察数列可得,除了第一项和第二项,所有的数列的值都是前一项和前一项的前一项的加和,转换成函数也就是f(n) = f(n-1) + f(n-2)
        function f1($n)
        {
            if ($n < 1) {
                return 0;
            } elseif (($n == 1) || ($n == 2)) {
                return 1;
            }

            return f1($n-1) + f1($n-2);
        }

        // fun2 顺序求解
        // 因为斐波那契数列可以从左到右顺序的求出每一项的值,因此只需要顺序计算到n项即可,时间复杂度为O(n)的,我们可以把它看成在单链表的最后插入一个右最后一个和倒数第二个指针指向的值来决定的
        function f2($n)
        {
            if ($n < 1) {
                return 0;
            } elseif (($n == 1) || ($n == 2)) {
                return 1;
            }

            $res = 1;
            $pre = 1;
            $temp = 0;
            for ($i=3;$i<$n;$i++) {
                $temp = $res;
                $res = $res+ $pre;
                $pre = $temp;
            }
            return $res;
        }
    ```

#### 动态规划之股票最大收益
- Q
    * 这一周股市价格为[2,6,1,4,8],求哪一天买入哪一天卖出,可获得最大收益,最大收益为多少 
- A
    ```php
        // 暴力法
        function f1($prices) 
        {
            $count = count($prices);
            $maxDiff = array(
                "day" => 0,
                "money" => 0
            );
            for ($i=0;$i<$count;$i++) {
                for ($j=$i+1;$j<$count;$j++) {
                    if ($prices[$i] < $prices[$j]) {
                        $tempDiff = $prices[$j] - $prices[$i];
                        if ($tempDiff > $maxDiff['money']) {
                            $maxDiff['day'] = $j +1;
                            $maxDiff['money'] = $tempDiff;
                        }
                    } else {
                        continue;
                    }
                }
            }
            return $maxDiff['money'];
        }

        // 一次遍历
        function f2($prices)
        {
            // 所得到的最小的谷值和最大的利润(卖出价格与最低价格之间的最大差值)
            $minPrice = 100000;
            $maxProfit = 0;
            $count = count($prices);
            for ($i=0;$i<$count;$i++) {
                if ($prices[$i] < $minPrice) {
                    $minPrice = $prices[$i];
                } elseif ($prices[$i] - $minPrice > $maxProfit) {
                    $maxProfit = $prices[$i] - $minPrice;
                }
            }
            return $maxProfit;
        }
    ```


