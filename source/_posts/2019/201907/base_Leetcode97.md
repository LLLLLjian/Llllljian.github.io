---
title: Leetcode_基础 (97)
date: 2019-07-01 18:00:00
tags: Leetcode
toc: true
---

### 回旋镖的数量
    Leetcode学习-447

<!-- more -->

#### Q
    给定平面上 n 对不同的点,“回旋镖” 是由点表示的元组 (i, j, k) ,其中 i 和 j 之间的距离和 i 和 k 之间的距离相等(需要考虑元组的顺序).

    找到所有回旋镖的数量.你可以假设 n 最大为 500,所有点的坐标在闭区间 [-10000, 10000] 中.

    示例:

    输入:
    [[0,0],[1,0],[2,0]]

    输出:
    2

    解释:
    两个回旋镖为 [[1,0],[0,0],[2,0]] 和 [[1,0],[2,0],[0,0]]

#### A
    ```php
        class Solution {
            function numberOfBoomerangs($points) {
                //查找数
                $len = count($points);
                $num = 0;
                //取一个固定点,检测该固定点到其他点的距离
                for($i = 0;$i<$len;++$i){
                    $distance = [];
                    for($j = 0;$j<$len;++$j){
                        if($j != $i){
                            $key = $this->dis($points[$i],$points[$j]);
                            if(isset($distance[$key])){
                                $distance[$key]++;
                            }else{
                                $distance[$key] = 1;
                            }
                        }
                    }
                    //print_r($distance);
                    //取得的结果,两两成一对,每一对可以有两种可能,所以进行排列组合排列组合An(n-1)
                    foreach ($distance as $v)
                        if($v>1)
                            $num += $v*($v-1);
                }
                return $num;
            }
            function dis($a ,$b){
                //勾股定理,不开根号,防止出现浮点数
                return ($a[0]-$b[0])*($a[0]-$b[0]) + ($a[1]-$b[1])*($a[1]-$b[1]);
            }
        }
    ```
