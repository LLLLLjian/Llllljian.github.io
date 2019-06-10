---
title: Leetcode_基础 (70)
date: 2019-06-03 18:00:00
tags: Leetcode
toc: true
---

### 3的幂
    Leetcode学习-326

<!-- more -->

#### Q
    给定一个整数,写一个函数来判断它是否是 3 的幂次方.

    示例 1:
    输入: 27
    输出: true
    
    示例 2:
    输入: 0
    输出: false
    
    示例 3:
    输入: 9
    输出: true
    
    示例 4:
    输入: 45
    输出: false
    进阶：
    你能不使用循环或者递归来完成本题吗

#### A
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return Boolean
             */
            function isPowerOfThree($n) {
                if ($n==0) {
                    return false;
                } else {
                    if ($n % 2 == 0) {
                        return false;
                    }

                    while ($n % 3 == 0) {
                        $n /= 3;
                    }
                    
                    return $n == 1;
                }
            }

            function isPowerOfThree1($n) {
                if ($n==0) {
                    return false;
                } elseif ($n == 1) {
                    return true;
                } else {
                    if ($n % 2 == 0) {
                        return false;
                    }

                    if ($n % 3 == 0) {
                        $n /= 3; 
                        return $this->isPowerOfThree($n);
                    }
                }
            }

            function isPowerOfThree2($n) {
                // 3^19 = 1162261467
                return ($n > 0) && (1162261467 % $n == 0);
            }
        }
    ```
