---
title: Interview_总结 (67)
date: 2020-03-05
tags: Interview
toc: true
---

### 算法题
    给定两个排序的数组判断是否存在相同的元素

<!-- more -->

#### 给定两个排序的数组判断是否存在相同的元素
- A1
    * O(nlogn)
    * 解题思路: 任意挑选一个数组, 遍历这个数组的所有元素, 遍历过程中, 在另一个数组中对第一个数组中的每个元素进行binary search
    ```php
        function findcommon($arr1, $arr2)
        {
            $count = count($arr);
            for ($i=0;$i<$count;$i++) {
                $start = 0;
                $end = count($arr2) - 1;
                while ($start < $end) {
                    $mid = ($start + $end)/2;
                    if($arr1[$i] == $arr2[$mid]) {
                        return true;
                    } elseid ($arr1[$i] < $arr2[$mid]) {
                        $end = $mid - 1;
                    } else {
                        $start = $mind + 1;
                    }
                }
            }
            return false;
        }
    ```
- A2
    * O(n)
    * 解题思路: 双指针, 依次向后遍历, 小的往前走
    ```php
        function findcommon2($arr1, $arr2)
        {
            $i = $j = 0;
            $count1 = count($arr1);
            $count2 = count($arr2);
            while (($i<$count1) && ($j<$count2)) {
                if ($arr1[$i] == $arr2[$j]) {
                    return true;
                } elseif (arr1[$i] < $arr2[$j]) {
                    $i++;
                } else {
                    $j++;
                }
            }
            return false;
        }
    ```



