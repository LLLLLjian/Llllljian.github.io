---
title: Leetcode_基础 (13)
date: 2019-02-19
tags: Leetcode
toc: true
---

### 报数
    Leetcode学习-38

<!-- more -->

#### Q
    报数序列是一个整数序列,按照其中的整数的顺序进行报数,得到下一个数.其前五项如下：
    1.     1
    2.     11
    3.     21
    4.     1211
    5.     111221
    1 被读作  "one 1"  ("一个一") , 即 11.
    11 被读作 "two 1s" ("两个一"), 即 21.
    21 被读作 "one 2",  "one 1" ("一个二" ,  "一个一") , 即 1211.

    给定一个正整数 n(1 ≤ n ≤ 30),输出报数序列的第 n 项.
    注意：整数顺序将表示为一个字符串.
    
    示例 1:
    输入: 1
    输出: "1"

    示例 2:
    输入: 4
    输出: "1211"

#### A
    ```php
        // 看到有大佬用的穷举法 直接列出1-30的结果 时间复杂度为O(1)
        class Solution {
            function countAndSay($n) {
                $resultArr = array('1' => '1');
                
                if (array_key_exists($n, $resultArr)) {
                    return $resultArr[$n];
                } else {
                    for ($i=2;$i<=$n;$i++) {
                        if (array_key_exists($n, $resultArr)) {
                            return $resultArr[$n];
                        } else {
                            $nums = 1;
                            $res = '';
                            $str0 = $resultArr[$i-1];
                            $len = strlen($str0);
                            
                            for ($m=0;$m<$len;$m++) {
                                $number=$str0[$m];
                                if ($str0[$m] != @$str0[$m+1]) {
                                    $res .= $nums.$number;
                                    $nums = 1;
                                } else {
                                    $nums++;
                                }
                            }
                            
                            $resultArr[$i] = $res;
                        }
                    }
                
                    return $resultArr[$n];
                }
            }
        }

        $a = new Solution();
        $n = 5;
        echo $a->countAndSay($n);
    ```
