---
title: Leetcode_基础 (73)
date: 2019-06-05 12:00:00
tags: Leetcode
toc: true
---

### 反转字符串中的元音字母
    Leetcode学习-345

<!-- more -->

#### Q
    编写一个函数,以字符串作为输入,反转该字符串中的元音字母.

    示例 1:

    输入: "hello"
    输出: "holle"
    示例 2:

    输入: "leetcode"
    输出: "leotcede"
    说明:
    元音字母不包含字母"y".

#### A
    ```php
        class Solution {
            /**
             * @param String $s
             * @return String
             */
            function reverseVowels($s) {
                // 元音a e i o u A E I O U
                if (empty($s)) {
                    return $s;
                } else {
                    $low = 0;
                    $high = strlen($s) - 1;
                    
                    while ($low <= $high) {
                        while (($low <= $high) && !in_array(strtolower($s[$low]), array('a', 'e', 'i', 'o', 'u'))) {
                            $low++;
                        }
                        while (($low <= $high) && !in_array(strtolower($s[$high]), array('a', 'e', 'i', 'o', 'u'))) {
                            $high--;
                        }
                        if ($low <= $high) {
                            $temp = $s[$low];
                            $s[$low] = $s[$high];
                            $s[$high] = $temp;
                            $low++;
                            $high--;
                        }
                    }
                    return $s;
                }
            }
        }
    ```
