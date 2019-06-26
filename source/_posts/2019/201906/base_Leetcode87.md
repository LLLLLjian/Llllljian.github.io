---
title: Leetcode_基础 (87)
date: 2019-06-17 18:00:00
tags: Leetcode
toc: true
---

### 最长回文串
    Leetcode学习-409

<!-- more -->

#### Q
    给定一个包含大写字母和小写字母的字符串，找到通过这些字母构造成的最长的回文串。

    在构造过程中，请注意区分大小写。比如 "Aa" 不能当做一个回文字符串。

    注意:
    假设字符串的长度不会超过 1010。

    示例 1:

    输入:
    "abccccdd"

    输出:
    7

    解释:
    我们可以构造的最长的回文串是"dccaccd", 它的长度是 7

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @return Integer
            */
            function longestPalindrome($s) {
                $tempArr = array_count_values(str_split($s));
                foreach($tempArr as $key=>$value) {
                    if ($value%2 == 1) {
                        $flag = true;
                        $tempArr[$key] = $value - 1;
                    }
                }
                
                if ($flag) {
                    return array_sum($tempArr) + 1;
                } else {
                    return array_sum($tempArr);
                }
            }
        }
    ```
