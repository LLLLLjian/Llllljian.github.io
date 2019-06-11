---
title: Leetcode_基础 (75)
date: 2019-06-06
tags: Leetcode
toc: true
---

### 两个数组的交集 II
    Leetcode学习-350

<!-- more -->

#### Q
    给定两个数组,编写一个函数来计算它们的交集.

    示例 1:

    输入: nums1 = [1,2,2,1], nums2 = [2,2]
    输出: [2,2]
    示例 2:

    输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
    输出: [4,9]
    说明：

    输出结果中每个元素出现的次数,应与元素在两个数组中出现的次数一致.
    我们可以不考虑输出结果的顺序.
    进阶:

    如果给定的数组已经排好序呢？你将如何优化你的算法？
    如果 nums1 的大小比 nums2 小很多,哪种方法更优？
    如果 nums2 的元素存储在磁盘上,磁盘内存是有限的,并且你不能一次加载所有的元素到内存中,你该怎么办？

#### A
    ```php
        class Solution {
            /**
             * @param Integer[] $nums1
             * @param Integer[] $nums2
             * @return Integer[]
             */
            function intersect($nums1, $nums2) {
                sort($nums1);
                sort($nums2);
                $tempArr0 = $tempArr1 = $tempArr2 = array();
                
                if (count($nums1) >= count($nums2)) {
                    $tempArr0 = $nums2;
                    $tempArr1 = $nums1;
                } else {
                    $tempArr0 = $nums1;
                    $tempArr1 = $nums2;
                }
                
                for ($i=0;$i<count($tempArr0);$i++) {
                    for ($j=0;$j<count($tempArr1);$j++) {
                        // 因为是经过排序的 数组0中的值比数组1中值大的时候就没有循环下去的必要了
                        if ($tempArr0[$i] > $tempArr1[$j]) {
                            continue;
                        }
                        
                        if ($tempArr0[$i] === $tempArr1[$j]) {
                            $tempArr2[] = $tempArr0[$i];
                            $tempArr1[$j] = "a";
                            continue 2;
                        }
                    }
                }
                return $tempArr2;
            }

            function intersect1($nums1, $nums2) {
                sort($nums1);
                sort($nums2);
                $tempArr1 = $tempArr2 = array();
                
                for ($i=0;$i<count($nums1);$i++) {
                    if (array_key_exists($nums1[$i], $tempArr2)) {
                        $tempArr2[$nums1[$i]] += 1;
                    } else {
                        $tempArr2[$nums1[$i]] = 1;
                    }
                }
                for ($j=0;$j<count($nums2);$j++) {
                    if (array_key_exists($nums2[$j], $tempArr2) && ($tempArr2[$nums2[$j]] > 0)) {
                        $tempArr2[$nums2[$j]] -= 1;
                        $tempArr1[] = $nums2[$j];
                    }
                }
                return $tempArr1;
            }
        }
    ```
