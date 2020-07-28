---
title: Interview_总结 (94)
date: 2020-04-30
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 三十六进制加法
- Q
    * 36进制由0-9,a-z,共36个字符表示,最小为'0'
    * '0''9'对应十进制的09,'a''z'对应十进制的1035
    * 例如：'1b' 换算成10进制等于 1 * 36^1 + 11 * 36^0 = 36 + 11 = 47
    * 要求按照加法规则计算出任意两个36进制正整数的和
    * 如：按照加法规则,计算'1b' + '2x' = '48'
    * 要求：不允许把36进制数字整体转为10进制数字,计算出10进制数字的相加结果再转回为36进制
- A
    ```php
        function f($a, $b)
        {
            $tempArr = array(
                '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
            );

            $lenA = strlen($a)-1;
            $lenB = strlen($b)-1;
            $temp = 0;
            $res = array();
            while (($lenA>=0) && ($lenB>=0)) {
                $tempSum = array_search($a[$lenA], $tempArr) + array_search($b[$lenB], $tempArr) + $temp;
                if (($tempSum%36) >= 0) {
                    $temp = floor($tempSum/36);
                    array_unshift($res, $tempSum%36);
                } else {
                    $temp = 0;
                    array_unshift($res, $tempSum);
                }
                $lenA-=1;
                $lenB-=1;
            }
            while ($lenA>=0) {
                $tempSum = $a[$lenA] + $temp;
                if (($tempSum%36) >= 0) {
                    $temp = floor($tempSum/36);
                    array_unshift($res, $tempSum%36);
                } else {
                    $temp = 0;
                    array_unshift($res, $tempSum);
                }
                $lenA-=1;
            }
            while ($lenB>=0) {
                $tempSum = $b[$lenB] + $temp;
                if (($tempSum%36) >= 0) {
                    $temp = floor($tempSum/36);
                    array_unshift($res, $tempSum%36);
                } else {
                    $temp = 0;
                    array_unshift($res, $tempSum);
                }
                $lenB-=1;
            }
            
            if (!empty($temp)) {
                array_unshift($res, $temp);
            }
            return implode($res);
        }
    ```

