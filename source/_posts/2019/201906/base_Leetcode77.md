---
title: Leetcode_基础 (77)
date: 2019-06-10 18:00:00
tags: Leetcode
toc: true
---

### 有效的完全平方数
    Leetcode学习-367

<!-- more -->

#### Q
    给定一个正整数 num,编写一个函数,如果 num 是一个完全平方数,则返回 True,否则返回 False.
    说明：不要使用任何内置的库函数,如  sqrt.

    示例 1：
    输入：16
    输出：True
    示例 2：
    输入：14
    输出：False

#### A
    ```php
        class Solution {
            /**
             * @param Integer $num
             * @return Boolean
             */
            function isPerfectSquare($num) {
                // 1 = 1 = 1 * 1
                // 1 + 3 = 4 = 2 * 2 
                // 1 + 3 + 5 = 9 = 3 * 3
                // 1 + 3 + 5 + 7 = 16 = 4 * 4
                $sumNum = 1;
                while($num > 0) {
                    $num -= $sumNum;
                    $sumNum += 2;
                }
                return $num == 0;
            }
        }
    ```
