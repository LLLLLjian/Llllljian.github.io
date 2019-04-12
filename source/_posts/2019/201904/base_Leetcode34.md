---
title: Leetcode_基础 (34)
date: 2019-04-02
tags: Leetcode
toc: true
---

### Excel表列名称
    Leetcode学习-168

<!-- more -->

#### Q
    给定一个正整数，返回它在 Excel 表中相对应的列名称。

    例如，

        1 -> A
        2 -> B
        3 -> C
        ...
        26 -> Z
        27 -> AA
        28 -> AB 
        ...
    示例 1:

    输入: 1
    输出: "A"
    示例 2:

    输入: 28
    输出: "AB"
    示例 3:

    输入: 701
    输出: "ZY"

#### A
    ```php
       class Solution {
            /**
            * @param Integer $n
            * @return String
            */
            function convertToTitle($n) {
                $arr = array();
                for($i='A'; $i<='Z'; $i++) {
                    $arr[] = $i;
                }
                $re = "";
                while ($n != 0) {
                    if ($n%26 == 0) {
                        $re = $arr[25].$re;
                        $n = floor($n/26) - 1;
                    } else {
                        $re = $arr[$n%26-1].$re;
                        $n = floor($n/26);
                    }
                }
                
                return $re;
            }
        }

        $a = new Solution();
        var_dump($a->convertToTitle(24568));
    ```
