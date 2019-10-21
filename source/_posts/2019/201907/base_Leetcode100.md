---
title: Leetcode_基础 (100)
date: 2019-07-12 12:00:00
tags: Leetcode
toc: true
---

### 重复的子字符串
    Leetcode学习-459

<!-- more -->

#### Q
    给定一个非空的字符串,判断它是否可以由它的一个子串重复多次构成.给定的字符串只含有小写英文字母,并且长度不超过10000.

    示例 1:

    输入: "abab"

    输出: True

    解释: 可由子字符串 "ab" 重复两次构成.
    示例 2:

    输入: "aba"

    输出: False
    示例 3:

    输入: "abcabcabcabc"

    输出: True

    解释: 可由子字符串 "abc" 重复四次构成. (或者子字符串 "abcabc" 重复两次构成.)

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @return Boolean
            */
            function repeatedSubstringPattern($s) {
                // 在周期t下 s[i%t]==s[i]
                $len = strlen($s);
                for ($t=1;$t<=$len/2;$t++) {
                    if ($len%$t) {
                        continue;
                    }
                    for ($i=$t;$i<$len;$i++) {
                        if ($s[$i] != $s[$i%$t]) {
                            break;
                        }
                    }
                    if ($i == $len) {
                        return true;
                    } 
                }
                return false;
            }

            function repeatedSubstringPattern1($s) {
                // 一个字符串如果符合要求,则该字符串至少由2个子串组成.例：b b / abc abc
                // s+s.以后,则该字符串至少由4个子串组成 bb+bb / abcabc+abcabc
                // 截去首尾各一个字符s[1:-1] (注：只截一个是为了判断类似本例,重复子串长度为1的情况.当重复子串长度大于1时,任意截去首尾小于等于重复子字符串长度都可)
                // 由于s+s组成的4个重复子串被破坏了首尾2个,则只剩下中间两个 b bb b.此时在判断中间两个子串组成是否等于s,若是,则成立.
                $tempS = str_repeat($s, 2);
                $tempS = substr($tempS, 1, strlen($tempS)-2);
                if (strpos($tempS, $s) === false) {
                    return false;
                } else {
                    return true;
                }
            }
        }
    ```
