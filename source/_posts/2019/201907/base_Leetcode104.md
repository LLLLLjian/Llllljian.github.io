---
title: Leetcode_基础 (104)
date: 2019-07-16 12:00:00
tags: Leetcode
toc: true
---

### 最大连续1的个数
    Leetcode学习-485

<!-- more -->

#### Q
    给定一个二进制数组, 计算其中最大连续1的个数.

    示例 1:

    输入: [1,1,0,1,1,1]
    输出: 3
    解释: 开头的两位和最后的三位都是连续1,所以最大连续1的个数是 3.
    注意: 

    输入的数组只包含 0 和1.
    输入数组的长度是正整数,且不超过 10,000

#### A
    ```php
        class Solution {
            /**
            * @param Integer[] $nums
            * @return Integer
            */
            function findMaxConsecutiveOnes($nums) {
                $j = 0;
                $temp = 0;
                for ($i=0;$i<count($nums);$i++) {
                    if ($nums[$i] == 1) {
                        $j += 1;
                    } else {
                        $temp = max($temp, $j);
                        $j = 0;
                    }
                }
                return max($temp, $j);
            }
        }
    ```
