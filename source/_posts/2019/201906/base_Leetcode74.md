---
title: Leetcode_基础 (74)
date: 2019-06-05 18:00:00
tags: Leetcode
toc: true
---

### 两个数组的交集
    Leetcode学习-349

<!-- more -->

#### Q
    给定两个数组,编写一个函数来计算它们的交集.

    示例 1:

    输入: nums1 = [1,2,2,1], nums2 = [2,2]
    输出: [2]
    示例 2:

    输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
    输出: [9,4]
    说明:

    输出结果中的每个元素一定是唯一的.
    我们可以不考虑输出结果的顺序.

#### A
    ```php
        class Solution {
            /**
             * @param Integer[] $nums1
             * @param Integer[] $nums2
             * @return Integer[]
             */
            function intersection($nums1, $nums2) {
                return array_intersect(array_unique($nums1), array_unique($nums2));
            }

            function intersection1($nums1, $nums2) {
                $nums1 = array_unique($nums1);
                $nums2 = array_unique($nums2);
                $tempArr0 = $tempArr1 = $tempArr2 = array();
                
                if (count($nums1) >= count($nums2)) {
                    $tempArr0 = $nums2;
                    $tempArr1 = $nums1;
                } else {
                    $tempArr0 = $nums1;
                    $tempArr1 = $nums2;
                }
                
                foreach ($tempArr0 as $key=>$value) {
                    if (in_array($value, $tempArr1) && (!in_array($value, $tempArr2))) {
                        $tempArr2[] = $value;
                    }
                }
                
                return $tempArr2;
            }
        }
    ```
