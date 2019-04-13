---
title: Leetcode_基础 (33)
date: 2019-04-01
tags: Leetcode
toc: true
---

### 两数之和 II - 输入有序数组
    Leetcode学习-167

<!-- more -->

#### Q
    给定一个已按照升序排列 的有序数组,找到两个数使得它们相加之和等于目标数.

    函数应该返回这两个下标值 index1 和 index2,其中 index1 必须小于 index2.

    说明:

    返回的下标值（index1 和 index2）不是从零开始的.
    你可以假设每个输入只对应唯一的答案,而且你不可以重复使用相同的元素.
    示例:

    输入: numbers = [2, 7, 11, 15], target = 9
    输出: [1,2]
    解释: 2 与 7 之和等于目标数 9 .因此 index1 = 1, index2 = 2 .

#### A
    ```php
       class Solution {
            /**
            * @param Integer[] $numbers
            * @param Integer $target
            * @return Integer[]
            */
            function twoSum($numbers, $target) {
                if (!empty($numbers)) {
                    $count = count($numbers);
                    for ($i=1;$i<=$count;$i++) {
                        for ($m=$i+1;$m<=$count;$m++) {
                            if (($numbers[$i] + $numbers[$m]) == $target) {
                                return array($i, $m);
                            }
                        }
                    }
                }
            }
        }

        $a = new Solution();
        $numbers = array(
            1 => 2, 
            2 => 7, 
            3 => 11, 
            4 => 15);
        $target = 9;
        var_dump($a->twoSum($numbers, $target));
    ```
