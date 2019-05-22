---
title: Leetcode_基础 (54)
date: 2019-05-13
tags: Leetcode
toc: true
---

### 单词最短距离
    Leetcode学习-243

<!-- more -->

#### Q
    给定一个单词列表和两个单词word1和word2，返回列表中这两个单词之间的最短距离。

    示例：
    假设words = ["practice", "makes", "perfect", "coding", "makes"]。

    输入： word1 = “coding”，word2 = “practice”
    输出： 3
    输入： word1 = "makes"，word2 = "coding"
    输出： 1
    注意：
    您可以假设word1 不等于 word2，而word1和word2都在列表中。

#### A
    ```php
        class Solution {
            function shortestDistance($words, $word1, $word2) {
                if (empty($words)) {
                    return false;
                } else {
                    $tempArr = array($word1, $word2);
                    $temp = array_keys(array_intersect($a, $b));
                    return $temp[1]-$temp[0];
                }
            }
        }
    ```
