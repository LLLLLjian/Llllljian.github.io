---
title: Leetcode_基础 (98)
date: 2019-07-11 12:00:00
tags: Leetcode
toc: true
---

### 找到所有数组中消失的数字
    Leetcode学习-448

<!-- more -->

#### Q
    给定一个范围在  1 ≤ a[i] ≤ n ( n = 数组大小 ) 的 整型数组，数组中的元素一些出现了两次，另一些只出现一次。

    找到所有在 [1, n] 范围之间没有出现在数组中的数字。

    您能在不使用额外空间且时间复杂度为O(n)的情况下完成这个任务吗? 你可以假定返回的数组不算在额外空间内。

    示例:

    输入:
    [4,3,2,7,8,2,3,1]

    输出:
    [5,6]

#### A
    ```php
        class Solution {
            /**
            * @param Integer[] $nums
            * @return Integer[]
            */
            function findDisappearedNumbers($nums) {
                $resArr = array();
                if (!empty($nums)) {
                    $max = max(max($nums), count($nums));
                    
                    for ($i=1;$i<=$max;$i++) {
                        if (!in_array($i, $nums)) {
                            $resArr[] = $i;
                        }
                    }
                }
                
                return $resArr;
            }

            function findDisappearedNumbers1($nums) {
                $resArr = array();
                if (!empty($nums)) {          
                    for ($i=0;$i<=count($nums);$i++) {
                        $nums[abs($nums[$i])-1] =  - abs($nums[abs($nums[$i])-1]);
                    }
                    
                    for ($i=0;$i<=count($nums);++$i) {
                        if ($nums[$i] > 0) {
                            $resArr[] = $i+1;
                        }
                    }
                }
                
                return $resArr;
            }
        }
    ```
