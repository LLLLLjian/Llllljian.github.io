---
title: Leetcode_基础 (57)
date: 2019-05-16
tags: Leetcode
toc: true
---

### 粉刷房子
    Leetcode学习-256

<!-- more -->

#### Q
    假如有一排房子,共 n 个,每个房子可以被粉刷成红色、蓝色或者绿色这三种颜色中的一种,你需要粉刷所有的房子并且使其相邻的两个房子颜色不能相同.

    当然,因为市场上不同颜色油漆的价格不同,所以房子粉刷成不同颜色的花费成本也是不同的.每个房子粉刷成不同颜色的花费是以一个 n x 3 的矩阵来表示的.

    例如,costs[0][0] 表示第 0 号房子粉刷成红色的成本花费；costs[1][2] 表示第 1 号房子粉刷成绿色的花费,以此类推.请你计算出粉刷完所有房子最少的花费成本.

    注意：

    所有花费均为正整数.

    示例：

    输入: [[17,2,17],[16,16,5],[14,3,19]]
    输出: 10
    解释: 将 0 号房子粉刷成蓝色,1 号房子粉刷成绿色,2 号房子粉刷成蓝色.
        最少花费: 2 + 5 + 3 = 10.

#### A
    ```php
        /**
         *  思路：
         *  用dp[i][j]来表示在第 i 个房子,涂第j种颜色的最小开销.
         *   显然对于第一行dp[0], dp[0] == costs[0],
         *  对于i ！=0的情况,dp[i][j] = costs[i][j] + 上一行另外两种颜色的开销的较小值.
         */
        class Solution {
            function minCost($costs) {
                if (empty($costs)) {
                    return 0;
                } else {
                    $result = $costs;
                    $len = count($costs);
                    for ($i=1;$i<$len;$i++){
                        $result[$i][0] += min($result[$i-1][1], $result[$i-1][2]);
                        $result[$i][1] += min($result[$i-1][0], $result[$i-1][2]);
                        $result[$i][2] += min($result[$i-1][0], $result[$i-1][1]);
                    }
                    return min(end($result));
                }
            }
        }
        $a = new Solution();
        $arr = array(
            array(17,2,17),
            array(16,16,5),
            array(14,3,19)
        );
        var_dump($a->minCost($arr));
    ```
