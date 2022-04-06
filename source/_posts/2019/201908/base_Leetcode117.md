---
title: Leetcode_基础 (117)
date: 2019-08-02
tags: Leetcode
toc: true
---

### 四数之和
    Leetcode学习-18

<!-- more -->

#### Q
    给定一个包含 n 个整数的数组 nums 和一个目标值 target,判断 nums 中是否存在四个元素 a,b,c 和 d ,使得 a + b + c + d 的值与 target 相等？找出所有满足条件且不重复的四元组.

    注意: 答案中不可以包含重复的四元组.

    示例: 

    给定数组 nums = [1, 0, -1, 0, -2, 2],和 target = 0.
    满足要求的四元组集合为: 
    [
    [-1,  0, 0, 1],
    [-2, -1, 1, 2],
    [-2,  0, 0, 2]
    ]

#### A
    ```php
        class Solution {
            function fourSum($nums, $target) {
                //查找数
                //先排序,再双指针
                sort($nums);
                $len = count($nums);
                $result = [];
                //小于3根本构不成三元组,直接返回错误
                if ($len<4) return $result;
                //在三数之和的基础上多套一层循环
                for($i = 0;$i<$len-3;++$i){
                    //去重操作
                    if($i>0 && $nums[$i] == $nums[$i-1]) continue;
                    for($j = $i+1;$j<$len-2;++$j){
                        //去重操作
                        if($j>$i+1 && $nums[$j] == $nums[$j-1]) continue;
                        $left = $j+1;//左指针
                        $right = $len-1;//右指针
                        while ($left<$right) {
                            //四数相加
                            $sum = $nums[$i] + $nums[$j] + $nums[$left] + $nums[$right];
                            if($sum == $target){
                                //满足条件时,将四元组压入结果数组
                                $result[] = [$nums[$i],$nums[$j],$nums[$left],$nums[$right]];
                                //排除重复值,跳过处理
                                while ($left<$right &&$nums[$left] == $nums[$left+1]) 
                                    $left += 1;
                                while ($left<$right &&$nums[$right] == $nums[$right-1]) 
                                    $right -= 1;
                                //左右指针的都移动
                                $left += 1;
                                $right -= 1;
                            }elseif($sum < $target)
                            //a+b+c=0====>a+b=-c
                                $left += 1;
                            else
                                $right -= 1;
                        }
                    }
                }
                return $result;
            }
        }
    ```
