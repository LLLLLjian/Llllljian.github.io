---
title: Leetcode_基础 (71)
date: 2019-06-04
tags: Leetcode
toc: true
---

### 4的幂
    Leetcode学习-342

<!-- more -->

#### Q
    给定一个整数 (32 位有符号整数)，请编写一个函数来判断它是否是 4 的幂次方。

    示例 1:

    输入: 16
    输出: true
    示例 2:

    输入: 5
    输出: false
    进阶：
    你能不使用循环或者递归来完成本题吗？

#### A
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return Boolean
             */
            function isPowerOfFour($n) {
                if ($n == 0) {
                    return false;
                } elseif ($n ==1) {
                    return true;
                } else {
                    if ($n % 2 == 1) {
                        return false;
                    }

                    while ($n % 4 == 0) {
                        $n /= 4;
                    }
                    
                    return $n == 1;
                }
            }

            function isPowerOfFour1($n) {
                if ($n==0) {
                    return false;
                } elseif ($n == 1) {
                    return true;
                } else {
                    if ($n % 4 == 0) {
                        $n /= 4; 
                        return $this->isPowerOfThree($n);
                    }
                }
            }
        }
    ```
