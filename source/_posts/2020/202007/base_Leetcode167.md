---
title: Leetcode_基础 (167)
date: 2020-07-17
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-贪心法

<!-- more -->

#### 钞票支付问题
- 问题描述
    * 有1元 5元 10元 20元 100元 200元的钞票无穷张, 现使用这些钞票支付x元, 最少需要支付几张
- 解题思路
    * 从最大的钱开始往下, 取除数取余数
    ```php
        function getMinPieces($x, $returnType) 
        {
            $RMB = array(
                200, 100, 20, 10, 5, 1
            );
            $res = 0;
            $resArr = array();

            while ($x > 0) {
                $temp = floor($x / current($RMB));
                $res += $temp;
                
                if ($temp > 0) {
                    $resArr[] = array(
                        'num' => $temp,
                        'money' => current($RMB)
                    );
                }

                $x = $x % max($RMB);
                array_shift($RMB);
            }
            
            if ($returnType == 1) {
                return $res;
            } else {
                return $resArr;
            }
        }

        echo "<pre>";
        var_dump(getMinPieces(628, 2));
    ```

#### 分糖果
- 问题描述
    * 已知一些孩子和糖果, 糖果数最多可以满足几个孩子
    * 孩子需求[5, 10, 2, 9, 15, 9] 糖果大小[6, 1, 20, 3, 8], 最多可以满足3个孩子20=>15, 8=>5, 6=>2
- 解题思路
    * 人和糖果都排序, 让小的糖果先满足小需求的人, 碰到满足不了的人糖果后移
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $g
             * @param Integer[] $s
             * @return Integer
             */
            function findContentChildren($g, $s) 
            {
                $g = $this->quickSort($g);
                $s = $this->quickSort($s);
                $res = 0;

                while (!empty($s) && !empty($g)) {
                    $tempForG = end($g);
                    $tempForS = end($s);

                    if ($tempForG <= $tempForS) {
                        $res += 1;
                        array_pop($s);
                    } 
                    array_pop($g);
                }

                return $res;
            }

            function quickSort($arr)
            {
                if (empty($arr)) {
                    return $arr;
                }
                $temp = $arr[0];
                $left = $right = array();

                $count = count($arr);
                for ($i=1;$i<$count;$i++) {
                    if ($temp > $arr[$i]) {
                        $left[] = $arr[$i];
                    } else {
                        $right[] = $arr[$i];
                    }
                }

                $left = $this->quickSort($left);
                $right = $this->quickSort($right);

                $res = array_merge($left, array($temp), $right);
                return $res;
            }
        }
    ```


