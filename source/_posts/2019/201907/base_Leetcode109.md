---
title: Leetcode_基础 (109)
date: 2019-07-23
tags: Leetcode
toc: true
---

### 长度最小的子数组
    Leetcode学习-209

<!-- more -->

#### Q
    给定一个含有 n 个正整数的数组和一个正整数 s ,找出该数组中满足其和 ≥ s 的长度最小的连续子数组.如果不存在符合条件的连续子数组,返回 0.

    示例: 

    输入:s = 7, nums = [2,3,1,2,4,3]
    输出: 2
    解释: 子数组 [4,3]是该条件下的长度最小的连续子数组.

#### A
    ```php
        class Solution {
            function minSubArrayLen($s, $nums) {
                //滑动窗口
                //初始条件,如果全部相加都小于$s,直接返回0
                if(array_sum($nums)<$s) return 0;
                $len = count($nums);
                $low = 0;$height = 0;//滑动窗口左右边界
                $min = $len;//最长数组长度
                $sum = 0;
                //右指针要后移一位
                while ($height<=$len) {
                    //满足条件则比较,且左边界右移
                    if($sum >= $s) {
                        $min = min($min,$height-$low);
                        $sum -= $nums[$low++];
                    }else{
                        //没满足条件则继续相加,右边界右移
                        $sum += $nums[$height];
                        $height++;
                    }
                }
                return $min;
            }
        }
    ```
