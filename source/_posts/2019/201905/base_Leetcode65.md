---
title: Leetcode_基础 (65)
date: 2019-05-28
tags: Leetcode
toc: true
---

### 移动零
    Leetcode学习-283

<!-- more -->

#### Q
    给定一个数组 nums,编写一个函数将所有 0 移动到数组的末尾,同时保持非零元素的相对顺序.

    示例:
    输入: [0,1,0,3,12]
    输出: [1,3,12,0,0]
    说明:

    必须在原数组上操作,不能拷贝额外的数组.
    尽量减少操作次数. 

#### A
    ```php
        class Solution {
            /**
             * @param Integer[] $nums
             * @return NULL
             */
            function moveZeroes(&$nums) {
                if (!empty($nums)) {
                    $len = count($nums);
                    for ($i=0;$i<$len;$i++) {
                        if ($nums[$i] == 0) {
                            unset($nums[$i]);
                            $nums[$len+$i] = 0;
                        }
                    }
                    return $nums;
                }
            }
        }
    ```
