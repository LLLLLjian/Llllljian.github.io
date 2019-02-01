---
title: Leetcode_基础 (1)
date: 2019-01-21
tags: Leetcode
toc: true
---

### 两数之和
    Leetcode学习

<!-- more -->

#### Q
    给定一个整数数组 nums 和一个目标值 target,请你在该数组中找出和为目标值的那 两个 整数,并返回他们的数组下标.
    你可以假设每种输入只会对应一个答案.但是,你不能重复利用这个数组中同样的元素.
    示例:
    给定 nums = [2, 7, 11, 15], target = 9
    因为 nums[0] + nums[1] = 2 + 7 = 9
    所以返回 [0, 1]

#### A
    ```php
        class Solution 
        {
            function twoSum($nums, $target) 
            {
                $resultArr = array(0, 0);
                if (!empty($nums) && is_array($nums)) {
                    for ($m=0;$m<count($nums);$m++) {
                        $key = $m;
                        $value = $nums[$m];

                        for ($n=$m+1;$n<count($nums);$n++) {
                            $key1 = $n;
                            $value1 = $nums[$n];

                            if (($value1 + $value) == $target) {
                                $resultArr = array($m, $n);
                                return $resultArr;
                            }
                        }
                    }
                }
                
                return $resultArr;
            }
        }

        $a = new Solution();
        $nums = array(2, 7, 11, 15);
        $target = 9;
        print_r($a->twoSum($nums, $target));

        $nums = array(0, 4, 3, 0);
        $target = 0;
        print_r($a->twoSum($nums, $target));

        $nums = array(-3, 4, 3, 90);
        $target = 0;
        print_r($a->twoSum($nums, $target));
    ```
