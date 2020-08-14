---
title: Leetcode_基础 (164)
date: 2020-07-03
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-长度最小的子数组

<!-- more -->

#### 长度最小的子数组
- 问题描述
    * 给定一个含有 n 个正整数的数组和一个正整数 s , 找出该数组中满足其和 ≥ s 的长度最小的 连续 子数组, 并返回其长度.如果不存在符合条件的子数组, 返回 0.
- 解题思路
    * 用双指针 left 和 right 表示一个窗口
    * right 向右移增大窗口, 直到窗口内的数字和大于等于了 s.进行第 2 步.
    * 记录此时的长度, left 向右移动, 开始减少长度, 每减少一次, 就更新最小长度.直到当前窗口内的数字和小于了 s, 回到第 1 步.
    ```php
        class Solution 
        {
            /**
             * @param Integer $s
             * @param Integer[] $nums
             * @return Integer
             */
            function minSubArrayLen($s, $nums) 
            {
                $slow = $temp = 0;
                $fast = 1;
                $count = count($nums);
                $min = 
                while ($fast < $count) {
                    if ($nums[$slow] >= $s) {
                        $res[] = 1;
                        $slow+=1;
                        continue;
                    }
                    if ($nums[$fast] >= $s) {
                        $res[] = 1;
                        $fast+=1;
                        continue;
                    }
                    if (empty($temp)) {
                        $temp = $nums[$slow];
                    }
                    $temp = $temp + $nums[$fast];
                    if ($temp < $s) {
                        $fast+=1;
                    } else {
                        $res[] = $fast - $slow + 1;
                        $temp -= $nums[$slow];
                        $slow+=1;
                    }
                }

                if (empty($res)) {
                    return 0;
                }
                return min($res);
            }
        }
    ```

