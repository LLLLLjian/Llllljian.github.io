---
title: DataStructure_基础 (29)
date: 2019-12-25
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[最大公约数]

<!-- more -->

#### 最大公约数
- Q
    * 写一段代码, 求两个整数的最大公约数
- A1
    * 暴力破解法
    ```php
        function getGreatestCommonDivisorV1($a, $b)
        {
            $max = $a > $b ? $a : $b;
            $min = $a < $b ? $a : $b;

            if ($max%$min == 0) {
                return $min;
            }
            for ($i=$min/2;$i>1;$i--) {
                if (($min%$i == 0) && ($max%$i == 0) ) {
                    return $i;
                }
            }
            return 1;
        }
    ```
- A2
    * 辗转相除法, 又名欧几里得算法
    * 两个正整数a, b(a > b), 他们的最大公约数等于a除以b的余数c和b之间的最大公约数
    ```php
        function getGreatestCommonDivisorV2($a, $b)
        {
            $max = $a > $b ? $a : $b;
            $min = $a < $b ? $a : $b;

            if ($max%$min == 0) {
                return $min;
            }
            return getGreatestCommonDivisorV2($max%$min, $min);
        }
    ```
- A3
    * 更相减损数
    * 两个正整数a, b(a > b), 他们的最大公约数等于a减去b的差值c和b之间的最大公约数
    ```php
        function getGreatestCommonDivisorV3($a, $b)
        {
            $max = $a > $b ? $a : $b;
            $min = $a < $b ? $a : $b;

            if ($max%$min == 0) {
                return $min;
            }
            return getGreatestCommonDivisorV2($max-$min, $min);
        } 
    ```
- A4
    * 移位运算
    * 当a, b均为偶数时, getGreatestCommonDivisor(a, b) = 2 * getGreatestCommonDivisor(a/2, b/2) = 2 * getGreatestCommonDivisor(a>>1, b>>1)
    * 当a为偶数, b为奇数时, getGreatestCommonDivisor(a, b) = getGreatestCommonDivisor(a/2, b) = getGreatestCommonDivisor(a>>1, b)
    * 当b为偶数, a为奇数时, getGreatestCommonDivisor(a, b) = getGreatestCommonDivisor(a, b/2) = getGreatestCommonDivisor(a, b>>1)
    * 当a, b均为奇数时,  getGreatestCommonDivisor(a, b) = getGreatestCommonDivisor(b, a-b), 此时a-b必为偶数, 然后又可以进行移位运算了
    ```php
        function getGreatestCommonDivisorV4($a, $b)
        {
            if ($a == $b) {
                return $a;
            }

            if ((($a&1) == 0) && (($b&1) == 0)) {
                return getGreatestCommonDivisorV4($a>>1, $b>>1)<<1;
            } elseif ((($a&1) == 0) && (($b&1) != 0)) {
                return getGreatestCommonDivisorV4($a>>1, $b);
            } elseif ((($a&1) != 0) && (($b&1) == 0)) {
                return getGreatestCommonDivisorV4($a, $b>>1);
            } else {
                $max = $a > $b ? $a : $b;
                $min = $a < $b ? $a : $b;
                return getGreatestCommonDivisorV4($b, $a-$b);
            }
        }
    ```


