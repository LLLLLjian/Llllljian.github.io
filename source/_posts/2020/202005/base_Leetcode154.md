---
title: Leetcode_基础 (154)
date: 2020-05-20
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-判断子序列

<!-- more -->

#### 判断子序列
    给定字符串 s 和 t ,判断 s 是否为 t 的子序列.
    你可以认为 s 和 t 中仅包含英文小写字母.字符串 t 可能会很长(长度 ~= 500,000),而 s 是个短字符串(长度 <=100).
    字符串的一个子序列是原始字符串删除一些(也可以不删除)字符而不改变剩余字符相对位置形成的新字符串.(例如,"ace"是"abcde"的一个子序列,而"aec"不是).
    示例 1:
    s = "abc", t = "ahbgdc"
    返回 true.
    示例 2:
    s = "axc", t = "ahbgdc"
    返回 false.
    后续挑战 :
    如果有大量输入的 S,称作S1, S2, ... , Sk 其中 k >= 10亿,你需要依次检查它们是否为 T 的子序列.在这种情况下,你会怎样改变代码
- A
    ```php
        class Solution 
        {
            /**
             * @param String $s
             * @param String $t
             * @return Boolean
             * 
             * 也不用双指针这么麻烦 计数就完事了
             */
            function isSubsequence($s, $t) 
            {
                $nLen = strlen($s);
                $tLen = strlen($t);

                $i = $j = 0;
                while (($i<$nLen)&&($j<$tLen)) {
                    if ($s[$i] == $t[$j]) {
                        $i++;
                    }
                    $j++;
                }
                return $i == $nLen;
            }

            /**
             * 双指针并排往前走, 最后判断$s就可以了
             */
            function isSubsequence1($s, $t) 
            {
                if (empty($s)) {
                    return true;
                }

                if (empty($t)) {
                    return false;
                }
                $sArr = str_split($s);
                $tArr = str_split($t);
                while (!empty($sArr)&&!empty($tArr)) {
                    if (current($sArr) == current($tArr)) {
                        array_shift($sArr);
                        array_shift($tArr);
                    } else {
                        array_shift($tArr);
                    }
                }

                if (empty($sArr)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```

