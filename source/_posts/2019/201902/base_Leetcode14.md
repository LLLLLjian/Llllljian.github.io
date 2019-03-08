---
title: Leetcode_基础 (14)
date: 2019-02-20
tags: Leetcode
toc: true
---

### 最大子序和
    Leetcode学习

<!-- more -->

#### Q
    给定一个整数数组 nums ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

    示例:

    输入: [-2,1,-3,4,-1,2,1,-5,4],
    输出: 6
    解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。

#### A
    ```php
        class Solution {
            function maxSubArray($nums) {
                if (is_array($nums) && (count($nums) == 1)) {
                    return $nums[0];
                }
                $sum = $res = $nums[0];
                for ($i=1;$i<count($nums);$i++) {
                    if ($sum > 0) {
                        $sum += $nums[$i];
                    } else {
                        $sum = $nums[$i];
                    }

                    if ($sum > $res) {
                        $res = $sum;
                    }
                }
                return $res;
            }
        }
    ```
