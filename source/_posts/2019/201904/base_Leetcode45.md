---
title: Leetcode_基础 (45)
date: 2019-04-28
tags: Leetcode
toc: true
---

### 存在重复元素
    Leetcode学习-217

<!-- more -->

#### Q
    给定一个整数数组,判断是否存在重复元素.

    如果任何值在数组中出现至少两次,函数返回 true.如果数组中每个元素都不相同,则返回 false.

    示例 1:

    输入: [1,2,3,1]
    输出: true
    示例 2:

    输入: [1,2,3,4]
    输出: false
    示例 3:

    输入: [1,1,1,3,3,4,3,2,4,2]
    输出: true

#### A
    ```php
        class Solution {
            /**
            * @param Integer[] $nums
            * @return Boolean
            */
            function containsDuplicate($nums) 
            {
                if (!empty($nums) && is_array($nums)) {
                    $tempArr = array_count_values($nums);
                    
                    if (count($nums) == count($tempArr)) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return false;
                }
            }
        }
    ```
