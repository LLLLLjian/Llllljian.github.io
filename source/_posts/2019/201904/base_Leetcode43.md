---
title: Leetcode_基础 (43)
date: 2019-04-25
tags: Leetcode
toc: true
---

### 计数质数
    Leetcode学习-204

<!-- more -->

#### Q
    统计所有小于非负整数 n 的质数的数量.

    示例:

    输入: 10
    输出: 4
    解释: 小于 10 的质数一共有 4 个, 它们是 2, 3, 5, 7 

#### A
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return Integer
             */
            function countPrimes($n) 
            {
                if ($n == 1) {
                    return 0;
                } else {
                    $resultArr = array();
                    for ($i=2;$i<$n;$i++) {
                        if ($this->isPrimes($i)) {
                            $resultArr[$i] = $i;
                        }
                    }
                    
                    return count($resultArr);   
                }
            }
            
            /**
             * @param Integer $n
             * @return Boolean
             */
            function isPrimes($n)
            {
                $flag = 0;
                for ($i=1;$i<=$n;$i++) {
                    if ($n%$i == 0) {
                        $flag++;
                    }
                }
                
                if ($flag == 2) {
                    return true;
                } else {
                    return false;
                }
            }

            function countPrimes1($n)
            {
                if (empty($n)) {
                    return 0;
                }
                if (in_array($n, array(1, 2))) {
                    return 0;
                }
                
                $tempArr = array();
                for ($i=0;$i<$n;$i++) {
                    $tempArr[$i] = $i;
                }

                for ($j=2;$j<$n;$j++) {
                    if ($tempArr[$j] != 0) {
                        for ($k=2;$k*$j<$n;$k++) {
                            $tempArr[$k*$j] = 0;
                        }
                    }
                }

                return count(array_filter($tempArr)) - 1;
            }
        }
    ```
