---
title: Leetcode_基础 (30)
date: 2019-03-22
tags: Leetcode
toc: true
---

### 验证回文串
    Leetcode学习-125

<!-- more -->

#### Q
    给定一个字符串,验证它是否是回文串,只考虑字母和数字字符,可以忽略字母的大小写.
    说明: 本题中,我们将空字符串定义为有效的回文串.

    示例 1:
    输入: "A man, a plan, a canal: Panama"
    输出: true

    示例 2:
    输入: "race a car"
    输出: false

#### A
    ```php
       class Solution {
            /**
             * @param String $s
             * @return Boolean
             */
            function isPalindrome($s) {
                $s = preg_replace("/[^\\da-zA-Z0-9]/", "", $s);
                $tempS = strrev($s);
                
                if (strtolower($s) == strtolower($tempS)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```
