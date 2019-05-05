---
title: Leetcode_基础 (38)
date: 2019-04-17
tags: Leetcode
toc: true
---

### 旋转数组
    Leetcode学习-189

<!-- more -->

#### Q
    输入: [1,2,3,4,5,6,7] 和 k = 3
    输出: [5,6,7,1,2,3,4]
    解释:
    向右旋转 1 步: [7,1,2,3,4,5,6]
    向右旋转 2 步: [6,7,1,2,3,4,5]
    向右旋转 3 步: [5,6,7,1,2,3,4]

    示例 2:
    输入: [-1,-100,3,99] 和 k = 2
    输出: [3,99,-1,-100]
    解释: 
    向右旋转 1 步: [99,-1,-100,3]
    向右旋转 2 步: [3,99,-1,-100]

#### A
    ```php
        class Solution {
            /**
            * @param Integer[] $nums
            * @param Integer $k
            * @return NULL
            */
            function rotate(&$nums, $k) {
                for ($k;$k>0;$k--) {
                    $last = array_pop($nums);
                    array_unshift($nums, $last);
                }
                return $nums;
            }

            function rotate1(&$nums, $k) {
                for ($k;$k>0;$k--) {
                    array_unshift($nums, end($nums));
                    unset($nums[count($nums) - 1]);
                }
                
                return $nums;
            }
        }
    ```
    
