---
title: Leetcode_基础 (36)
date: 2019-04-15
tags: Leetcode
toc: true
---

### Excel表列序号
    Leetcode学习-171

<!-- more -->

#### Q
    给定一个Excel表格中的列名称，返回其相应的列序号
    例如，
        A -> 1
        B -> 2
        C -> 3
        ...
        Z -> 26
        AA -> 27
        AB -> 28 
        ...
    示例 1:
    输入: "A"
    输出: 1

    示例 2:
    输入: "AB"
    输出: 28

    示例 3:
    输入: "ZY"
    输出: 701

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @return Integer
            */
            function titleToNumber($s) {
                for($i='A'; $i<='Z'; $i++) {
                    $arr[] = $i;
                    if (count($arr) >=26) {
                        break;
                    }
                }
                $sum = 0;
                $arr = array_flip($arr);
                for ($i = strlen($s)-1;$i>=0;$i--) {
                    $sum += ($arr[$s[$i]] + 1) * pow(26, strlen($s)-$i-1);
                }
                return $sum;
            }
        }
    ```
