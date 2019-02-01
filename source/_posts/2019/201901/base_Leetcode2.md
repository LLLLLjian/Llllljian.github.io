---
title: Leetcode_基础 (2)
date: 2019-01-22
tags: Leetcode
toc: true
---

### 整数反转
    Leetcode学习

<!-- more -->

#### Q
    给出一个 32 位的有符号整数,你需要将这个整数中每位上的数字进行反转.
    示例 1:
    输入: 123
    输出: 321
    示例 2:
    输入: -123
    输出: -321
    示例 3:
    输入: 120
    输出: 21
    注意:
    假设我们的环境只能存储得下 32 位的有符号整数,则其数值范围为 [−231,  231 − 1].请根据这个假设,如果反转后整数溢出那么就返回 0.

#### A
    ```php
        class Solution {
            function reverse($x) {
                $minNum = pow(-2, 31);
                $maxNum = pow(2, 31) - 1;
                $returnStr = 0;
                
                if ($x > 0) {
                    $returnStr = ltrim(strrev($x), "0"); 
                } elseif ($x < 0) {
                    $returnStr = "-".ltrim(strrev(abs($x)), "0");
                }
                
                if ($returnStr >= $maxNum || ($returnStr <= $minNum)) {
                    $returnStr = 0;
                }
                
                return $returnStr;
            }
        }

        $a = new Solution();
        echo $a->reverse(2147483647)."\n";
        echo $a->reverse(123)."\n";
        echo $a->reverse(-123)."\n";
        echo $a->reverse(120)."\n";
        echo $a->reverse(-120)."\n";
        echo $a->reverse(1534236469)."\n";
    ```
