---
title: Leetcode_基础 (152)
date: 2020-05-18
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-最大子序和

<!-- more -->

#### 最大子序和
    给定一个整数数组 nums ,找到一个具有最大和的连续子数组(子数组最少包含一个元素),返回其最大和.

    示例:
    输入: [-2,1,-3,4,-1,2,1,-5,4]
    输出: 6
    解释: 连续子数组 [4,-1,2,1] 的和最大,为 6.
    进阶:
    如果你已经实现复杂度为 O(n) 的解法,尝试使用更为精妙的分治法求解.
- A
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer
             * 
             * 动态规划的是首先对数组进行遍历,当前最大连续子序列和为 sum,结果为 ans
             * 如果 sum > 0,则说明 sum 对结果有增益效果,则 sum 保留并加上当前遍历数字
             * 如果 sum <= 0,则说明 sum 对结果无增益效果,需要舍弃,则 sum 直接更新为当前遍历数字
             * 每次比较 sum 和 ans的大小,将最大值置为ans,遍历结束返回结果
             */
            function maxSubArray($nums) 
            {
                $res = $maxAnx = $nums[0];
                $count = count($nums);

                for ($i=1;$i<$count;$i++) {
                    if ($maxAnx >= 0) {
                        $maxAnx = $maxAnx + $nums[$i];
                    } else {
                        $maxAnx = $nums[$i];
                    }
                    $res = max($res, $maxAnx);
                }
                return $res;
            }

            /**
             * f(i)= max{f(i−1)+a[i], a[i]}
             * pre = max(pre + a[i], a[i]);
             */
            function maxSubArray1($nums) 
            {
                $pre = $maxAnx = $nums[0];
                $count = count($nums);

                for ($i=1;$i<$count;$i++) {
                    $pre = max($pre + $nums[$i], $nums[$i]);
                    $maxAnx = max($maxAnx, $pre);
                }
                return $maxAnx;
            }
        }
    ```

