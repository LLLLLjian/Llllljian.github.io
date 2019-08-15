---
title: Leetcode_基础 (116)
date: 2019-08-01
tags: Leetcode
toc: true
---

### 最接近的三数之和
    Leetcode学习-16

<!-- more -->

#### Q
    给定一个包括 n 个整数的数组 nums 和 一个目标值 target.找出 nums 中的三个整数,使得它们的和与 target 最接近.返回这三个数的和.假定每组输入只存在唯一答案.

    例如,给定数组 nums = [-1,2,1,-4], 和 target = 1.
    与 target 最接近的三个数的和为 2. (-1 + 2 + 1 = 2).

#### A
    ```php
        class Solution {
            function threeSumClosest($nums, $target) {
                //先排序,再双指针
                sort($nums);
                $len = count($nums);
                //小于3根本构不成三元组,直接返回错误
                if ($len<3) return 0;
                $result = 0;//存储结果答案
                $flag = 1;//第一次循环
                foreach ($nums as $key => $value) {
                    $left = $key+1;//左指针
                    $right = $len-1;//右指针
                    //跳过,该值与上一值相同时,则构成的三元组重复
                    if($key>0 && $value==$nums[$key-1]) continue;
                    while ($left<$right) {
                        $sum = $value + $nums[$left] + $nums[$right];
                        $tmp = $sum-$target;//求三元组相加与目标值的差距值
                        if(abs($tmp)<$max || $flag==1){
                            $flag=0;
                            $max = abs($tmp); //目前最大差距
                            $result = $sum;
                            //当为0时,已经满足最小条件,无需继续循环,直接返回
                            if($tmp==0) return $sum;
                        }
                        if($tmp<0)
                            //a+b+c=0====>a+b=-c
                            $left += 1;
                        elseif($tmp>0)
                            $right -= 1;
                    }
                }
                return $result;
            }
        }
    ```
