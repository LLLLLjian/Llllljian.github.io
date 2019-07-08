---
title: Leetcode_基础 (83)
date: 2019-06-13 18:00:00
tags: Leetcode
toc: true
---

### 第N个数字
    Leetcode学习-400

<!-- more -->

#### Q
    在无限的整数序列 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ...中找到第 n 个数字.

    注意:
    n 是正数且在32为整形范围内 ( n < 231).

    示例 1:

    输入:
    3

    输出:
    3
    示例 2:

    输入:
    11

    输出:
    0

    说明:
    第11个数字在序列 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, ... 里是0,它是10的一部分.

#### A
    ```php
        class Solution {
            /**
            * @param Integer $n
            * @return Integer
            */
            function findNthDigit($n) {
                // 1234567891011
                // 0 - 9 => 1 * 10^0 * 9个数
                // 10 - 99 =>  2 * 10^1 * 9
                // 100 - 999 => 3 * 10^2 * 9
                if ($n < 10) {
                    return $n;
                }
                
                $rec = array();
                $rec[0] = 0;
                for ($i=1;$i<10;$i++) {
                    $rec[$i] = $i * 9 * pow(10, $i-1);
                }
                
                for ($i=1;$i<10;$i++) {
                    if ($n <= $rec[$i]) {
                        $c = pow(10, $i-1) + ($n-1)/$i;
                        $y = ($n-1)%$i;
                        
                        $c = strval($c);
                        return $c[$y];
                    } else {
                        $n -= $rec[$i];
                    }
                }
                return -1;
            }
        }
    ```
