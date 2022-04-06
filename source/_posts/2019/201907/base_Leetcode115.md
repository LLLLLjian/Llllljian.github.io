---
title: Leetcode_基础 (115)
date: 2019-07-31
tags: Leetcode
toc: true
---

### 三数之和
    Leetcode学习-15

<!-- more -->

#### Q
    给定一个包含 n 个整数的数组 nums,判断 nums 中是否存在三个元素 a,b,c ,使得 a + b + c = 0 ？找出所有满足条件且不重复的三元组.

    注意: 答案中不可以包含重复的三元组.

    例如, 给定数组 nums = [-1, 0, 1, 2, -1, -4],
    满足要求的三元组集合为: 
    [
    [-1, 0, 1],
    [-1, -1, 2]
    ]

#### A
    ```php
        /**
         * 解法: 先对数组进行排序,再利用双指针的思想,构建三元组
         * 取一个固定值,用双指针寻找另外两个值,直至找到两个值之和等于固定值的负数,因为a+b+c=0===》a+b=-c
         * 当两值之和小于固定值的负数时,左指针右移
         * 当两值之和大于固定值的负数时,右指针左移
         * 当两值之和等于固定值的负数时,要进行去重处理,防止最后出现重复的结果: 判断 left+1的值,right-1的值,是否与上一个一样,相同的话,左右指针分别移动
         */
         class Solution {
            function threeSum($nums) {
                //查找数
                //先排序,再双指针
                sort($nums);
                $len = count($nums);
                $result = [];
                //小于3根本构不成三元组,直接返回错误
                if ($len<3) return $result;
                //遍历数组,固定一个值,在剩下的列表中,用双指针寻找两个值的和是否是固定值的负值
                foreach ($nums as $key => $value) {
                    $target = -$value;//取固定值-c
                    $left = $key+1;//左指针
                    $right = $len-1;//右指针
                    //固定值一开始为正,或者最后一个都为负数,则不能组成=0的三元组
                    if($value>0 || $nums[$right]<0) break;
                    //跳过,该值与上一值相同时,则构成的三元组重复
                    if($key>0 && $value==$nums[$key-1]) continue;
                    while ($left<$right) {
                        if ($nums[$right] < 0) break;
                        //满足条件
                        if($nums[$left] + $nums[$right] == $target) {
                            $result[] = [$value,$nums[$left],$nums[$right]];
                            //排除重复值,跳过处理
                            while ($left<$right &&$nums[$left] == $nums[$left+1]) 
                                $left += 1;
                            while ($left<$right &&$nums[$right] == $nums[$right-1]) 
                                $right -= 1;
                            //左右指针的都移动
                            $left += 1;
                            $right -= 1;
                        }elseif($nums[$left] + $nums[$right] < $target)
                        //a+b+c=0====>a+b=-c
                            $left += 1;
                        else
                            $right -= 1;
                    }
                }
                return $result;
            }
        }
    ```
