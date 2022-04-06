---
title: Leetcode_基础 (88)
date: 2019-06-18 12:00:00
tags: Leetcode
toc: true
---

### Fizz Buzz
    Leetcode学习-412

<!-- more -->

#### Q
    写一个程序,输出从 1 到 n 数字的字符串表示.

    1. 如果 n 是3的倍数,输出“Fizz”；

    2. 如果 n 是5的倍数,输出“Buzz”；

    3.如果 n 同时是3和5的倍数,输出 “FizzBuzz”.

    示例: 

    n = 15,

    返回:
    [
        "1",
        "2",
        "Fizz",
        "4",
        "Buzz",
        "Fizz",
        "7",
        "8",
        "Fizz",
        "Buzz",
        "11",
        "Fizz",
        "13",
        "14",
        "FizzBuzz"
    ]

#### A
    ```php
        class Solution {
            /**
            * @param Integer $n
            * @return String[]
            */
            function fizzBuzz($n) {
                $resArr = array();
                for ($i=1;$i<$n+1;$i++) {
                    if ($i%15 == 0) {
                        $resArr[] = "FizzBuzz";
                    } elseif ($i%5 == 0) {
                        $resArr[] = "Buzz";
                    } elseif ($i%3 == 0) {
                        $resArr[] = "Fizz";
                    } else {
                        $resArr[] = strval($i);
                    }
                }
                return $resArr;
            }

            function fizzBuzz1($n) {
                $resArr = array();
                for ($i=1;$i<$n+1;$i++) {
                    $resArr[$i] = strval($i);
                }
                array_walk_recursive($resArr, [$this, 'walk'] );
                return $resArr;
            }
            
            function walk(&$v, $k) {
                if ($v%15 == 0) {
                    $v = "FizzBuzz";
                } elseif ($v%5 == 0) {
                    $v = "Buzz";
                } elseif ($v%3 == 0) {
                    $v = "Fizz";
                } else {
                    $v = $v;
                }
            }
        }
    ```
