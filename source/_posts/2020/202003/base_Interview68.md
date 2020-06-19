---
title: Interview_总结 (68)
date: 2020-03-06
tags: Interview
toc: true
---

### 算法题
    N个整数, 求其中任意N-1个数的乘积中的最大的一个.

<!-- more -->

#### 给定两个排序的数组判断是否存在相同的元素
- Q
    * 例如 3,2,1,则最大的是3*2=6
    * 提示：整数包括0和负数
    * 要求给出个比较有效率的算法 
- A
    * O(n)
    * 解题思路: 遍历数组, 记录下最小的正数, 最大的负数和零的位置, 同时记录下负数的个数, 遍历时如果存在零, 那么去此零的结果就是解, 如果不存在零, 那么按负数个数的奇偶分2种情况：1、偶数个就去掉最小的正数;2、奇数个就去掉最大的负数
    ```php
        function GetMaxValueInCumulation($arr)
        {
            // 开始循环第一遍
            $mIndex1 = 0;// 最小的正数
            $mIndex2 = 0;// 最大的负数
            $zeroIndex = 0;// 零的位置
            $zeroNum = 0;// 0的个数
            $num++; // 负数的个数
            foreach ($arr as $key=>$value) {
                if ($value > 0) {
                    if (isset($arr[$mIndex1] && ($arr[$mIndex1] < $value))) {
                        $mIndex1 = $key;
                    }
                } elseif ($value < 0) {
                    $num++;
                    if (isset($arr[$mIndex2] && ($arr[$mIndex2] > $value))) {
                        $mIndex2 = $key;
                    }
                } else {
                    $zeroNum++;
                    $zeroIndex = $key;
                }
            }

            if ($zeroNum > 2) {
                return 0;
            }

            if ($num%2 == 1) {
                // 奇数
                if (isset($arr[$mIndex2])) {
                    unset($arr[$mIndex2]);
                }
            } else {
                // 偶数
                if (isset($arr[$mIndex1])) {
                    unset($arr[$mIndex1]);
                }
            }

            $res = 1;
            foreach ($arr as $key=>$value) {
                $res *= $value;
            }
            return $res;
        }
    ```




