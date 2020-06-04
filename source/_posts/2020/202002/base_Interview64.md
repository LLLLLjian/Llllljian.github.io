---
title: Interview_总结 (64)
date: 2020-02-19
tags: Interview
toc: true
---

### 笔试总结
    两数之和, 之前一直以为自己已经掌握这道题了, 最近面试才发现自己掌握的还是有问题, 记录改正一下

<!-- more -->

#### 两数之和
- Q
> 给定一个整数数组 nums 和一个目标值 target, 请你在该数组中找出和为目标值的那 两个 整数, 并返回他们的数组下标.你可以假设每种输入只会对应一个答案.但是, 数组中同一个元素不能使用两遍.示例:给定 nums = [2, 7, 11, 15], target = 9因为 nums[0] + nums[1] = 2 + 7 = 9所以返回 [0, 1]
- A
    ```php
        // 问题的核心在重新创建一个数组, 将原数组的value转化为key 
        function twoSum($nums, $target) {
            if (empty($nums)) {
                return false;
            } else {
                $count = count($nums);
                $tempArr = array();
                for ($i=0;$i<$count;$i++) {
                    $tempStr = $target - $nums[$i];

                    if (array_key_exists($tempStr, $tempArr)) {
                        return array($tempArr[$tempStr], $i);
                    } else {
                        $tempArr[$nums[$i]] = $i;
                    }
                }
            }
        }
    ```

