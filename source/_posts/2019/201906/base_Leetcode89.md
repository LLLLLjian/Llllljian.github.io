---
title: Leetcode_基础 (89)
date: 2019-06-18 18:00:00
tags: Leetcode
toc: true
---

### 第三大的数
    Leetcode学习-414

<!-- more -->

#### Q
    写一个程序，输出从 1 到 n 数字的字符串表示。

    1. 如果 n 是3的倍数，输出“Fizz”；

    2. 如果 n 是5的倍数，输出“Buzz”；

    3.如果 n 同时是3和5的倍数，输出 “FizzBuzz”。

    示例：

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
        if (count($nums) < 3) {
            return max($nums);
        }

        $max1 = $max2 = $max3 = min($nums);
        for($i=0;$i<count($nums);$i++) {
            if ($nums[$i] > $max1) {
                $max3 = $max2;
                $max2 = $max1;
                $max1 = $nums[$i];
                continue;
            }

            if (($nums[$i] != $max1) && ($nums[$i] > $max2)) {
                $max3 = $max2;
                $max2 = $nums[$i];
                continue;
            }

            if (($nums[$i] != $max1) && ($nums[$i] != $max2) && ($nums[$i] > $max3)) {
                $max3 = $nums[$i];
                continue;
            }

            if (($max1 == min($nums)) || ($max2 == min($nums)) || ($max3 == min($nums))) {
                return max($max1, $max2, $max3);
            }
        }
    ```
