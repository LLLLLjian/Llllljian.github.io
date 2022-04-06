---
title: Leetcode_基础 (91)
date: 2019-06-19 18:00:00
tags: Leetcode
toc: true
---

### 字符串相加
    Leetcode学习-415

<!-- more -->

#### Q
    给定两个字符串形式的非负整数 num1 和num2 ,计算它们的和.

    注意: 

    num1 和num2 的长度都小于 5100.
    num1 和num2 都只包含数字 0-9.
    num1 和num2 都不包含任何前导零.
    你不能使用任何內建 BigInteger 库, 也不能直接将输入的字符串转换为整数形式.

#### A
    ```php
        class Solution {
            /**
            * @param String $num1
            * @param String $num2
            * @return String
            */
            function addStrings($num1, $num2) {
                $len1 = strlen($num1);
                $len2 = strlen($num2);
                
                if ($len1 > $len2) {
                    $tempLen = $len1 - $len2;
                    for ($i=0;$i<$tempLen;$i++) {
                        $num2 = "0".$num2;
                    }
                } elseif ($len1 < $len2) {
                    $tempLen = $len2 - $len1;
                    for ($i=0;$i<$tempLen;$i++) {
                        $num1 = "0".$num1;
                    }
                }
                
                $jinwei = 0;
                $res = "";
                $len = strlen($num1);
                for ($i=$len-1;$i>=0;$i--) {
                    $temp = $num1[$i] + $num2[$i] + $jinwei;
                    if ($i != 0) {
                        if ($temp > 9) {
                            $temp = $temp - 10;
                            $jinwei = 1;
                        }  else {
                            $jinwei = 0;
                        }
                    } else {
                        $temp = strrev($temp);
                    }
                    
                    $res .= $temp;
                }
                return strrev($res);
            }
        }
    ```
