---
title: Leetcode_基础 (55)
date: 2019-05-14
tags: Leetcode
toc: true
---

### 中心对称数
    Leetcode学习-246

<!-- more -->

#### Q
    写一个函数来确定一个数字是否是strobogrammatic。一个数字翻转180度后仍为原数据的数

    例1：

    输入：   “69”
    输出： true
    例2：

    输入：   “88”
    输出： true
    例3：

    输入：   “962”
    输出： false

#### A
    ```php
        http://leetcode.liangjiateng.cn/leetcode/algorithm
        class Solution {
            function isStrobogrammatic($nums) {
                // 0 1 8 6和9
                $nums = strval($nums);
                $len = strlen($nums);

                if ($len == 0) {
                    return false;
                }

                $left = 0;
                $right = $len-1;
                while($left <= $right)
                {
                    $tempL = $nums[$left];
                    $tempR = $nums[$right];

                    if (($tempL == $tempR) && (!in_array($tempL, array(10, 1, 8)))) {
                        return false;
                    } else {
                        if ((($tempL == 6) && ($tempR == 9)) && (($tempL == 9) && ($tempR == 6))) {
                            return false;
                        }
                    }

                    $left++;
                    $right--; 
                }

                return true;
            }
        }
    ```
