---
title: Leetcode_基础 (61)
date: 2019-05-22
tags: Leetcode
toc: true
---

### 回文排列
    Leetcode学习-266

<!-- more -->

#### Q
    给定一个字符串，判断字符串是否存在一个排列是回文排列。
    给定s = "code", 返回 False.
    给定s = "aab", 返回 True.
    给定s = "carerac", 返回 True.

#### A
    ```php
        class Solution {
            function canPermutePalindrome($str) {
                $res = array();
                for ($i=0;$i<strlen($str);$i++) {
                    if (!array_key_exists($str[$i], $res)) {
                        $res[$str[$i]] = $str[$i];
                    } else {
                        unset($res[$str[$i]]);
                    }
                }

                if (empty($res) || (count($res) == 1)) {
                    return true;
                } else {
                    return false;
                }
            }
            
            function canPermutePalindrome1($str) {
                $res = $res1 = array();
                $res = str_split($str);
                foreach (array_count_values($res) as $key=>$value) {
                    if ($value != 2) {
                        $res1[$key] = $value;
                    }
                }
                if (empty($res1) || (count($res1) == 1)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        
        $a = new Solution();
        var_dump($a->canPermutePalindrome('code'));echo "<br />";
        var_dump($a->canPermutePalindrome('aab'));echo "<br />";
        var_dump($a->canPermutePalindrome('carerac'));echo "<br />";
        var_dump($a->canPermutePalindrome1('code'));echo "<br />";
        var_dump($a->canPermutePalindrome1('aab'));echo "<br />";
        var_dump($a->canPermutePalindrome1('carerac'));
    ```
