---
title: Leetcode_基础 (93)
date: 2019-06-20 18:00:00
tags: Leetcode
toc: true
---

### 字符串中的单词数
    Leetcode学习-434

<!-- more -->

#### Q
    统计字符串中的单词个数,这里的单词指的是连续的不是空格的字符.

    请注意,你可以假定字符串里不包括任何不可打印的字符.

    示例:

    输入: "Hello, my name is John"
    输出: 5

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @return Integer
            */
            function countSegments($s) {
                if (empty($s)) {
                    return 0;
                } else {
                    $tempArr = array();
                    $tempArr = array_filter(explode(" ", $s));
                    return count($tempArr);
                }
            }
        }
    ```
