---
title: Leetcode_基础 (106)
date: 2019-07-18
tags: Leetcode
toc: true
---

### 盛最多水的容器
    Leetcode学习-11

<!-- more -->

#### Q
    给定 n 个非负整数 a1,a2,...,an,每个数代表坐标中的一个点 (i, ai) .在坐标内画 n 条垂直线,垂直线 i 的两个端点分别为 (i, ai) 和 (i, 0).找出其中的两条线,使得它们与 x 轴共同构成的容器可以容纳最多的水.

    说明：你不能倾斜容器,且 n 的值至少为 2.
    示例:

    输入: [1,8,6,2,5,4,8,3,7]

#### A
    ```php
        class Solution {
            // 双指针(对撞指针)类型问题,面积为短的一侧*距离,则面积最终取决于短的一边,因此指针移动也是移动短的一根
            function maxArea($height) {
                //对撞指针
                $max = 0;
                for ($i = 0,$j = count($height)-1;$i<$j;) {
                    //优先左侧移动
                    if ($height[$i]<=$height[$j]) {
                        $area = ($j-$i)*$height[$i];
                        $i++;
                    } else {
                        $area = ($j-$i)*$height[$j];
                        $j--;
                    }
                    $max = max($max,$area);
                }
                return $max;
            }
        }
    ```
