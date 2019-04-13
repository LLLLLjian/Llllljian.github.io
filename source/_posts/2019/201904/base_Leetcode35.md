---
title: Leetcode_基础 (34)
date: 2019-04-03
tags: Leetcode
toc: true
---

### 求众数
    Leetcode学习-169

<!-- more -->

#### Q
    给定一个大小为 n 的数组,找到其中的众数.众数是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素.

    你可以假设数组是非空的,并且给定的数组总是存在众数.

    示例 1:

    输入: [3,2,3]
    输出: 3
    示例 2:

    输入: [2,2,1,1,1,2,2]
    输出: 2

#### A
    ```php
       class Solution {
            /**
             * @param Integer[] $nums
             * @return Integer
             * PHP内置函数完成
             */
            function majorityElement($nums) {
                $newArray=array_count_values($nums);
                arsort($newArray);
                return array_keys($newArray)[0];
            }

            /**
             * @param Integer[] $nums
             * @return Integer
             * 摩尔算法
             * 从第一个数开始count=1,遇到相同的就加1,遇到不同的就减1,减到0就重新换个数开始计数,总能找到最多的那个
             */
            function majorityElement1($nums) {
                $cnt = 0;
                $ret = 0;
                
                for($i=0;$i<count($nums);$i++) {
                    if ($cnt == 0) {
                        $ret = $nums[$i];
                    }
                    if ($ret != $nums[$i]) {
                        $cnt -= 1;
                    } else {
                        $cnt += 1;
                    }
                }
                return $ret;
            }
        }
    ```
