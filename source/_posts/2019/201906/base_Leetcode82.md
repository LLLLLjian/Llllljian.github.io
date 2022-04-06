---
title: Leetcode_基础 (82)
date: 2019-06-13 12:00:00
tags: Leetcode
toc: true
---

### 找不同
    Leetcode学习-389

<!-- more -->

#### Q
    给定两个字符串 s 和 t,它们只包含小写字母.

    字符串 t 由字符串 s 随机重排,然后在随机位置添加一个字母.

    请找出在 t 中被添加的字母.

     

    示例:

    输入: 
    s = "abcd"
    t = "abcde"

    输出: 
    e

    解释: 
    'e' 是那个被添加的字母.

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @param String $t
            * @return String
            */
            function findTheDifference($s, $t) {
                if (empty($s)) {
                    return $t;
                } else {
                    $tempArrForS = array_count_values(str_split($s));
                    $tempArrForT = array_count_values(str_split($t));
                    foreach ($tempArrForT as $key => $value) {
                        if (!array_key_exists($key, $tempArrForS)) {
                            return $key;
                        } else {
                            if ($value != $tempArrForS[$key]) {
                                return $key;
                            }
                        }
                    }
                }
            }
        }
    ```
