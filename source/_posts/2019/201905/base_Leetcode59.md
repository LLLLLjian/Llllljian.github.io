---
title: Leetcode_基础 (59)
date: 2019-05-20
tags: Leetcode
toc: true
---

### 各位相加
    Leetcode学习-258

<!-- more -->

#### Q
    给定一个非负整数 num,反复将各个位上的数字相加,直到结果为一位数.

    示例:

    输入: 38
    输出: 2 
    解释: 各位相加的过程为：3 + 8 = 11, 1 + 1 = 2. 由于 2 是一位数,所以返回 2.
    进阶:
    你可以不使用循环或者递归,且在 O(1) 时间复杂度内解决这个问题吗？

#### A
    ```php
        class Solution {
            /**
             * @param Integer $num
             * @return Integer
             */
            function addDigits($num) {
                while ($num >= 10) {
                    $numS = strval($num);
                    $temp = 0;
                    for ($i=0;$i<strlen($numS);$i++) {
                        $temp += $numS[$i];
                    }
                    $num = $temp;
                }
                
                return $num;
            }

            function addDigits1($num) {
                // 三位数s1 = 100 * a + 10 * b + c
                // s2 = a + b + c
                // s2-s1 = 99 * a + 9 * b
                // f(x*10+y)=f(x*9+x+y)=f(x+y), 成立当f(x)= x%9
                if ($num > 9) {
                    $num = $num % 9;
                    if ($num == 0) {
                        return 9;
                    }
                }
                return $num;
            }
        }
    ```
