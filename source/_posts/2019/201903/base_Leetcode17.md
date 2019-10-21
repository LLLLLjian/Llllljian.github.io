---
title: Leetcode_基础 (17)
date: 2019-03-04
tags: Leetcode
toc: true
---

### 二进制求和
    Leetcode学习-67

<!-- more -->

#### Q
    给定两个二进制字符串,返回他们的和(用二进制表示).
    输入为非空字符串且只包含数字 1 和 0.

    示例 1:
    输入: a = "11", b = "1"
    输出: "100"

    示例 2:
    输入: a = "1010", b = "1011"
    输出: "10101"

#### A
    ```php
        // 方法弊端 : PHP弱数据类型语言,数字过大的话会转成科学计数法进行输出
        class Solution 
        {
            /**
            * @param String $a
            * @param String $b
            * @return String
            */
            function addBinary($a, $b) {
                $temp = strval($a + $b);
                $tempArr = str_split($temp);
                $tempLen = count($tempArr);
                
                for ($i=$tempLen-1;$i>=0;$i--) {
                    if ($tempArr[$i] >= 2) {
                        $tempArr[$i] = $tempArr[$i] - 2;
                        @$tempStr = $tempArr[$i-1];
                        @$tempArr[$i-1] = $tempStr + 1;
                    }
                }
                ksort($tempArr);
                return implode($tempArr);
            }
        }

        $a = new Solution();
        echo $a->addBinary(11, 1)."\n";
        echo $a->addBinary(1010, 1011)."\n";
        echo $a->addBinary(1111, 1111)."\n";
    ```
