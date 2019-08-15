---
title: Leetcode_基础 (118)
date: 2019-08-05
tags: Leetcode
toc: true
---

### 四数相加II
    Leetcode学习-454

<!-- more -->

#### Q
    给定四个包含整数的数组列表 A , B , C , D ,计算有多少个元组 (i, j, k, l) ,使得 A[i] + B[j] + C[k] + D[l] = 0.

    为了使问题简单化,所有的 A, B, C, D 具有相同的长度 N,且 0 ≤ N ≤ 500 .所有整数的范围在 -228 到 228 - 1 之间,最终结果不会超过 231 - 1 .

    例如:

    输入:
    A = [ 1, 2]
    B = [-2,-1]
    C = [-1, 2]
    D = [ 0, 2]
    
    输出:2
    解释:两个元组如下:
    1. (0, 0, 0, 1) -> A[0] + B[0] + C[0] + D[1] = 1 + (-2) + (-1) + 2 = 0
    2. (1, 1, 0, 0) -> A[1] + B[1] + C[0] + D[0] = 2 + (-1) + (-1) + 0 = 0

#### A
    ```php
        class Solution {
            function fourSumCount($A, $B, $C, $D) {
                $map = [];
                //记录A+B的每一种可能
                foreach($A as $a){
                    foreach($B as $b){
                        if(isset($map[$a + $b]))
                            //因为同一结果可能有多种可能,所以要+1
                            $map[$a + $b]++;
                        else
                            $map[$a + $b] = 1;
                    }
                }
                //记录结果数量
                $result = 0;
                foreach($C as $c){
                    foreach($D as $d){
                        //a+b=-(c+d)
                        if(isset($map[0-($c+$d)]))
                            //加上map中对应的次数,才是最终的可能结果
                            $result+=$map[0-($c+$d)];
                    }
                }
                return $result;
            }
        }
    ```
