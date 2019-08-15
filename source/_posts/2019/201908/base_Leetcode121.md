---
title: Leetcode_基础 (121)
date: 2019-08-08
tags: Leetcode
toc: true
---

### 存在重复元素III
    Leetcode学习-220

<!-- more -->

#### Q
    给定一个整数数组,判断数组中是否有两个不同的索引 i 和 j,使得 nums [i] 和 nums [j] 的差的绝对值最大为 t,并且 i 和 j 之间的差的绝对值最大为 ķ.

    示例 1:

    输入: nums = [1,2,3,1], k = 3, t = 0
    输出: true
    示例 2:

    输入: nums = [1,0,1,1], k = 1, t = 2
    输出: true
    示例 3:

    输入: nums = [1,5,9,1,5,9], k = 2, t = 3
    输出: false

#### A
    ```php
        class Solution {
            function containsNearbyAlmostDuplicate($nums, $k, $t) {
                $map = [];
                foreach ($nums as $n) {
                    //查找满足条件的数,nums [i] 和 nums [j] 的差的绝对值最大为 t
                    foreach ($map as $m) {
                        if(abs($m-$n)<=$t) return true;
                    }
                    array_push($map, $n);
                    //维持一个固定长度的窗口
                    if(count($map) == $k+1) array_shift($map);
                }
                return false;
            }
        }
    ```
