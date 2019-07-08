---
title: Leetcode_基础 (94)
date: 2019-06-21 12:00:00
tags: Leetcode
toc: true
---

### 找到字符串中所有字母异位词
    Leetcode学习-438

<!-- more -->

#### Q
    给定一个字符串 s 和一个非空字符串 p,找到 s 中所有是 p 的字母异位词的子串,返回这些子串的起始索引.

    字符串只包含小写英文字母,并且字符串 s 和 p 的长度都不超过 20100.

    说明：

    字母异位词指字母相同,但排列不同的字符串.
    不考虑答案输出的顺序.
    示例 1:

    输入:
    s: "cbaebabacd" p: "abc"

    输出:
    [0, 6]

    解释:
    起始索引等于 0 的子串是 "cba", 它是 "abc" 的字母异位词.
    起始索引等于 6 的子串是 "bac", 它是 "abc" 的字母异位词.
     示例 2:

    输入:
    s: "abab" p: "ab"

    输出:
    [0, 1, 2]

    解释:
    起始索引等于 0 的子串是 "ab", 它是 "ab" 的字母异位词.
    起始索引等于 1 的子串是 "ba", 它是 "ab" 的字母异位词.
    起始索引等于 2 的子串是 "ab", 它是 "ab" 的字母异位词.

#### A
    ```php
        class Solution {
            /**
             * @param String $s
             * @param String $p
             * @return Integer[]
             */
            function findAnagrams($s, $p) {
                $lenS = strlen($s);
                $lenP = strlen($p);

                $res = $tempS = array();
                if ($lenP > $lenS) {
                    return $res;
                }
                $tempP = $this->changeStr($p);
                for ($i=0;$i<$lenS;$i++) {
                    if (($lenP + $i) > $lenS) {
                        break;
                    }
                    if (($this->changeStr(substr($s , $i , $lenP))) == $tempP) {
                        $res[] = $i;
                    }
                }
                
                return $res;
            }
            
            function changeStr($str) {
                $arr = str_split($str);
                asort($arr);
                $str=implode('',$arr);
                return $str;
            }
        }
    ```
