---
title: Leetcode_基础 (18)
date: 2019-03-05
tags: Leetcode
toc: true
---

### x的平方根
    Leetcode学习-69

<!-- more -->

#### Q
    实现 int sqrt(int x) 函数.

    计算并返回 x 的平方根,其中 x 是非负整数.

    由于返回类型是整数,结果只保留整数的部分,小数部分将被舍去.

    示例 1:

    输入: 4
    输出: 2
    示例 2:

    输入: 8
    输出: 2
    说明: 8 的平方根是 2.82842..., 
    由于返回类型是整数,小数部分将被舍去.

#### A
    ```php
        class Solution 
        {
            /**
            * @param Integer $x
            * @return Integer
            */
            function mySqrt($x) {
                if ($x == 0 || $x == 1) {
                    return $x;
                }
                
                for ($i = 1; $i <= $x / 2; $i++) {
                    if ($i * $i <= $x && ($i + 1) * ($i + 1) > $x){
                        return $i;
                    }
                }
            }
        }
    ```
