---
title: Leetcode_基础 (101)
date: 2019-07-12 18:00:00
tags: Leetcode
toc: true
---

### 汉明距离
    Leetcode学习-461

<!-- more -->

#### Q
    两个整数之间的汉明距离指的是这两个数字对应二进制位不同的位置的数目.

    给出两个整数 x 和 y,计算它们之间的汉明距离.

    注意: 
    0 ≤ x, y < 231.

    示例:

    输入: x = 1, y = 4

    输出: 2

    解释:
    1   (0 0 0 1)
    4   (0 1 0 0)
           ↑   ↑

    上面的箭头指出了对应二进制位不同的位置.

#### A
    ```php
        class Solution {
            /**
            * @param Integer $x
            * @param Integer $y
            * @return Integer
            */
            function hammingDistance($x, $y) {
                $res = 0;
                if ($x > $y) {
                    $min = $y;
                    $max = $x;
                } else {
                    $min = $x;
                    $max = $y;
                }
                $minB = decbin($min);
                $maxB = decbin($max);
                
                for ($i=0;$i<strlen($maxB);$i++) {
                    if (strlen($minB) == strlen($maxB)) {
                        break;
                    }
                    $minB = "0".$minB;
                }
                
                for ($i=0;$i<strlen($maxB);$i++) {
                    if ($maxB[$i] != $minB[$i]) {
                        $res++;
                    }
                }
                return $res;
            }
        }
    ```
