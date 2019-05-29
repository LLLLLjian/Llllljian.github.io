---
title: Leetcode_基础 (62)
date: 2019-05-23
tags: Leetcode
toc: true
---

### 缺失数字
    Leetcode学习-268

<!-- more -->

#### Q
    给定一个包含 0, 1, 2, ..., n 中 n 个数的序列，找出 0 .. n 中没有出现在序列中的那个数。
    示例 1:
    输入: [3,0,1]
    输出: 2

    示例 2:
    输入: [9,6,4,2,3,5,7,0,1]
    输出: 8
    说明:
    你的算法应具有线性时间复杂度。你能否仅使用额外常数空间来实现?

#### A
    ```php
        class Solution {
            /**
            * @param Integer[] $nums
            * @return Integer
            */
            function missingNumber($nums) {
                $max = max($nums);
                $temp = array();
                for ($i=0;$i<=$max;$i++) {
                    $temp[] = $i;
                }
                $res = array_diff($temp, $nums);
                if (empty($res)) {
                    $res = $max + 1;
                } else {
                    $res = end($res);
                }
                return $res;
            }

            function missingNumber1($nums) {
                $max = max($nums);
                $temp = array();
                for ($i=0;$i<=$max;$i++) {
                    $temp[] = $i;
                }
                $tempS = array_sum($temp);
                $numsS = array_sum($nums);
                
                $res = $tempS - $numsS;
                if (empty($res)) {
                    return var_dump((count($nums) == 1), count($nums));
                    if ((count($nums) == 1) && ($nums[0] == 1)) {
                        return 0;
                    } else {
                        $res = $max + 1;
                    }
                }
                return $res;
            }
        }
    ```
