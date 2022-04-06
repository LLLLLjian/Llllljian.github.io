---
title: Leetcode_基础 (6)
date: 2019-01-28
tags: Leetcode
toc: true
---

### 三数之和
    Leetcode学习-15

<!-- more -->

#### Q
    给定一个包含 n 个整数的数组 nums,判断 nums 中是否存在三个元素 a,b,c ,使得 a + b + c = 0 ？找出所有满足条件且不重复的三元组.
    注意: 答案中不可以包含重复的三元组.
    例如, 给定数组 nums = [-1, 0, 1, 2, -1, -4],
    满足要求的三元组集合为: 
    [
    [-1, 0, 1],
    [-1, -1, 2]
    ]

#### A
    ```php
        class Solution {
            function threeSum($nums) {
                $resultArr = array();
                if (empty($nums) || !is_array($nums)) {
                    return $resultArr;
                } else {
                    $count = count($nums);
                    for ($i=0;$i<$count;$i++) {
                        for ($m=$i+1;$m<$count;$m++) {
                            for ($n=$i+2;$n<$count;$n++) {
                                if (($nums[$i] + $nums[$m] + $nums[$n]) == 0) {
                                    $key = array($nums[$i], $nums[$m], $nums[$n]);
                                    sort($key);
                                    $returnArr[implode($key)] = array($nums[$i], $nums[$m], $nums[$n]);
                                }
                            }
                        }
                    }
                    
                    if (!empty($returnArr)) {
                        $k = 0;
                        foreach($returnArr as $key=>$value) {
                            $returnArr[$k] = $value;
                            unset($returnArr[$key]);
                            $k += 1;
                        }
                    }
                    
                    return $returnArr;
                }
            }
        }
    ```
