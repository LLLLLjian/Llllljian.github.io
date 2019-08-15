---
title: Leetcode_基础 (120)
date: 2019-08-07
tags: Leetcode
toc: true
---

### 直线上最多的点数
    Leetcode学习-149

<!-- more -->

#### Q
    给定一个二维平面,平面上有 n 个点,求最多有多少个点在同一条直线上.

    示例 1:

    输入: [[1,1],[2,2],[3,3]]
    输出: 3
    解释:
    ^
    |
    |        o
    |     o
    |  o  
    +------------->
    0  1  2  3  4
    示例 2:

    输入: [[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]
    输出: 4
    解释:
    ^
    |
    |  o
    |     o        o
    |        o
    |  o        o
    +------------------->
    0  1  2  3  4  5  6

#### A
    ```php
        /**
         * Definition for a point.
         * class Point(
         *     public $x = 0;
         *     public $y = 0;
         *     function __construct(int $x = 0, int $y = 0) {
         *         $this->x = $x;
         *         $this->y = $y;
         *     }
         * )
         */
        class Solution {
            function maxPoints($points) {
                //[[1,1],[2,2],[3,3]]
                //[[2,3],[3,3],[-5,3]]
                //[[1,1],[1,1],[2,2],[2,2]]
                //[[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]
                //查找数
                $len = count($points);
                $max = 0;//记录在同一直线点数最多的数
                for($i = 0;$i<$len;++$i){
                    $distance = [0];//斜率比值哈希表
                    $x = $y = 0;//记录平行点
                    $common = 1;//记录重复点
                    for($j = 0;$j<$len;++$j){
                        if($j != $i){
                            $key = $this->dis($points[$i],$points[$j]);
                            if($key == 'x') $x++;
                            elseif($key == 'y') $y++;
                            elseif($key == 'same') $common++;
                            else{
                                if(isset($distance[$key]))
                                    $distance[$key]++;
                                else
                                    $distance[$key] = 1; 
                            }
                        }
                    }
                    $num = max($x,$y,max($distance)) + $common;
                    if($num > $max) $max = $num;
                    //已经包含全部记录,无需继续检索
                    if($num == $len) break;
                }
                return $max;
            }
            //求斜率比值/平行点/重复点
            function dis($a,$b){
                $x = $a->x - $b->x;
                $y = $a->y - $b->y;
                if($x == 0 && $y==0) return 'same';//重复点
                if( $x == 0 ) return 'x';//平行于x轴
                if( $y == 0 ) return 'y';//平行于y轴
                $div = $this->max_divisor($x,$y);
                return $x/$div.':'.$y/$div;
            }
            //求最大公约数
            function max_divisor($a, $b){
                if($b==0)
                    return $a;
                else
                    return $this->max_divisor($b,($a%$b));
            }
        }
    ```
