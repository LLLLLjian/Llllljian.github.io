---
title: Leetcode_基础 (12)
date: 2019-02-18
tags: Leetcode
toc: true
---

### 搜索插入位置
    Leetcode学习-35

<!-- more -->

#### Q
    给定一个排序数组和一个目标值,在数组中找到目标值,并返回其索引.如果目标值不存在于数组中,返回它将会被按顺序插入的位置.
    你可以假设数组中无重复元素

    示例 1:
    输入: [1,3,5,6], 5
    输出: 2

    示例 2:
    输入: [1,3,5,6], 2
    输出: 1

    示例 3:
    输入: [1,3,5,6], 7
    输出: 4

    示例 4:
    输入: [1,3,5,6], 0
    输出: 0

#### A
    ```php
        class Solution {
            function searchInsert($nums, $target) {
                if (!is_array($nums) || empty($target)) {
                    return 0;
                } else {
                    $start = 0;
                    $count = count($nums);
                    
                    if ($nums[0] >= $target) {
                        return $start;
                    }
                    if (end($nums) < $target) {
                        return $count;
                    }
                    
                    while ($start <= $count) {
                        $mid = floor(($start + $count) / 2);
                        #找到元素
                        if($nums[$mid] == $target) {
                            return $mid;
                        }
                        #中元素比目标大,查找左部
                        if($nums[$mid] > $target) {
                            $count = $mid - 1;
                        }
                        #重元素比目标小,查找右部
                        if($nums[$mid] < $target) {
                            $start = $mid + 1;
                        }
                    }
                    return $start;
                }
            }
        }

        $a = new Solution();
        $arr = [1,3,5,6];
        $target = 5;
        echo $a->searchInsert($arr, $target)."<br />";

        $arr = [1,3,5,6];
        $target = 2;
        echo $a->searchInsert($arr, $target)."<br />";

        $arr = [1,3,5,6];
        $target = 7;
        echo $a->searchInsert($arr, $target)."<br />";

        $arr = [1,3,5,6];
        $target = 0;
        echo $a->searchInsert($arr, $target)."<br />";

        $arr = [1,3,5];
        $target = 4;
        echo $a->searchInsert($arr, $target)."<br />";

        $arr = [3,5,7,9,10];
        $target = 8;
        echo $a->searchInsert($arr, $target)."<br />";
    ```
