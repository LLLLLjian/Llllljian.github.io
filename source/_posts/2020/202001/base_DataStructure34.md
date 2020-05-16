---
title: DataStructure_基础 (34)
date: 2020-01-02
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[如何实现大整数相加]

<!-- more -->

#### 如何实现大整数相加
- Q
    * 给出两个很大的整数, 要求实现程序求出两个整数的和
- A
    * 把每一个整数倒序存储在单独的数组中, 
    * 遍历两个数组, 对应位数相加
    * 反转结果数组, 转为字符串输出
    ```php
        function bigNumberSum($a, $b)
        {
            $max = strrev(strval(max($a, $b)));
            $maxLen = strlen($max);
            $min = strrev(strval(min($a, $b)));
            $minLen = strlen(strval($min));
            for ($i=0;$i<$maxLen;$i++) {
                $arrMax[] = $max[$i];
                $arrMin[] = isset($min[$i]) ? $min[$i] : 0;
            }

            $temp = 0;
            for ($i=0;$i<$maxLen;$i++) {
                if (($temp + $arrMax[$i] + $arrMin[$i]) >= 10) {
                    $resArr[] = ($temp + $arrMax[$i] + $arrMin[$i]) - 10;
                    $temp = 1;
                } else {
                    $resArr[] = ($temp + $arrMax[$i] + $arrMin[$i]);
                    $temp = 0;
                }
            }
            $resArr = array_reverse($resArr);
            return implode("", $resArr);
        }

        $a = 426709752318;
        $b = 95481253129;
        var_dump(bigNumberSum($a, $b));
    ```






