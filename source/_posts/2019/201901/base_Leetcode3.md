---
title: Leetcode_基础 (3)
date: 2019-01-23
tags: Leetcode
toc: true
---

### 回文数
    Leetcode学习-9

<!-- more -->

#### Q
    判断一个整数是否是回文数.回文数是指正序(从左向右)和倒序(从右向左)读都是一样的整数.
    示例 1:
    输入: 121
    输出: true
    示例 2:
    输入: -121
    输出: false
    解释: 从左向右读, 为 -121 . 从右向左读, 为 121- .因此它不是一个回文数.
    示例 3:
    输入: 10
    输出: false
    解释: 从右向左读, 为 01 .因此它不是一个回文数.

#### A
    ```php
        class Solution {
            function isPalindrome($x) {
                $xRev = strrev($x);
                if ($xRev == $x) {
                    return true;
                } else {
                    return false;
                }
            }
        }

        $a = new Solution();
        echo $a->isPalindrome(121)."\n";
        echo $a->isPalindrome(-121)."\n";
        echo $a->isPalindrome(10)."\n";
        echo $a->isPalindrome(0)."\n";
    ```
