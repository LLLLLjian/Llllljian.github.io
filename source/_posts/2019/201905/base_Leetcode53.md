---
title: Leetcode_基础 (53)
date: 2019-05-10
tags: Leetcode
toc: true
---

### 有效的字母异位词
    Leetcode学习-242

<!-- more -->

#### Q
    给定两个字符串 s 和 t ,编写一个函数来判断 t 是否是 s 的一个字母异位词.

    示例 1:

    输入: s = "anagram", t = "nagaram"
    输出: true
    示例 2:

    输入: s = "rat", t = "car"
    输出: false
    说明:
    你可以假设字符串只包含小写字母.

    进阶:
    如果输入字符串包含 unicode 字符怎么办？你能否调整你的解法来应对这种情况？

#### A
    ```php
        class Solution {
            /**
             * @param String $s
             * @param String $t
             * @return Boolean
             */
            function isAnagram($s, $t) {
                if ($s === $t) {
                    return true;
                }
                if(!empty($s) || !empty($t)) {
                    $tempS = str_split($s);
                    $tempT = str_split($t);
                    rsort($tempS);
                    rsort($tempT);
                    return ($tempS === $tempT);
                } else {
                    return false;
                }
            }
        }
    ```
