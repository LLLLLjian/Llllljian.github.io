---
title: Leetcode_基础 (15)
date: 2019-02-21
tags: Leetcode
toc: true
---

### 最后一个单词的长度
    Leetcode学习-58

<!-- more -->

#### Q
    给定一个仅包含大小写字母和空格 ' ' 的字符串,返回其最后一个单词的长度.
    如果不存在最后一个单词,请返回 0 
    说明：一个单词是指由字母组成,但不包含任何空格的字符串.

    示例:
    输入: "Hello World"
    输出: 5

#### A
    ```php
        class Solution {
            function lengthOfLastWord($s) {
                $s = trim($s);
                if (!empty($s)) {
                    $tempArr = explode(" ", $s);
                    return strlen(end($tempArr));
                } else {
                    return 0;
                }
            }
        }
    ```
