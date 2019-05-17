---
title: Leetcode_基础 (47)
date: 2019-04-30
tags: Leetcode
toc: true
---

### 存在重复元素 II
    Leetcode学习-219

<!-- more -->

#### Q
    给定一个整数数组和一个整数 k，判断数组中是否存在两个不同的索引 i 和 j，使得 nums [i] = nums [j]，并且 i 和 j 的差的绝对值最大为 k。

    示例 1:

    输入: nums = [1,2,3,1], k = 3
    输出: true
    示例 2:

    输入: nums = [1,0,1,1], k = 1
    输出: true
    示例 3:

    输入: nums = [1,2,3,1,2,3], k = 2
    输出: false

#### A
    ```php
        class Solution {
            /**
             * 注意读题 最大为k 意思是比k小也可以
             * @param Integer[] $nums
             * @param Integer $k
             * @return Boolean
             */
            function containsNearbyDuplicate($nums, $k) 
            {
                $resArr = array();
                
                for ($i=0;$i<count($nums);$i++) {
                    if (array_key_exists($nums[$i], $resArr)) {
                        if ($k >= ($i - $resArr[$nums[$i]])) {
                            return true;
                        } else {
                            $resArr[$nums[$i]] = $i;
                        }
                    } else {
                        $resArr[$nums[$i]] = $i;
                    }
                }
                return false;
            }

            // 最大等于k
            function containsNearbyDuplicate1($nums, $k) {
                if ($k >= count($nums)) {
                    return false;
                }
                for ($i=0;$i<count($nums);$i++) {
                    if (isset($nums[$i+$k])) {
                        if ($nums[$i+$k] == $nums[$i]) {
                            return true;
                        } else {
                            continue;
                        }
                    } else {
                        return false;
                    }
                }
            }
        }
    ```
