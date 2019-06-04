---
title: Leetcode_基础 (72)
date: 2019-06-04
tags: Leetcode
toc: true
---

### 反转字符串
    Leetcode学习-344

<!-- more -->

#### Q
    编写一个函数，其作用是将输入的字符串反转过来。输入字符串以字符数组 char[] 的形式给出。

    不要给另外的数组分配额外的空间，你必须原地修改输入数组、使用 O(1) 的额外空间解决这一问题。

    你可以假设数组中的所有字符都是 ASCII 码表中的可打印字符。

    

    示例 1：

    输入：["h","e","l","l","o"]
    输出：["o","l","l","e","h"]
    示例 2：

    输入：["H","a","n","n","a","h"]
    输出：["h","a","n","n","a","H"]

#### A
    ```php
        class Solution {
            /**
             * @param String[] $s
             * @return NULL
             */
            function reverseString(&$s) {
                $len = count($s);
                
                for ($i=0;$i<$len/2;$i++) {
                    $temp = $s[$i];
                    $s[$i] = $s[$len-1-$i];
                    $s[$len-1-$i] = $temp;
                }
                return $s;
            }
        }
    ```
