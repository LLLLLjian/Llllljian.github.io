---
title: Leetcode_基础 (107)
date: 2019-07-19
tags: Leetcode
toc: true
---

### 数组中的第K个最大元素
    Leetcode学习-215

<!-- more -->

#### Q
    在未排序的数组中找到第 k 个最大的元素.请注意,你需要找的是数组排序后的第 k 个最大的元素,而不是第 k 个不同的元素.

    示例 1:
    输入:
    [3,2,1,5,6,4] 和
    k = 2
    输出: 5

    示例 2:

    输入:
    [3,2,3,1,2,4,5,5,6] 和
    k = 4

    输出: 4

#### A
    ```php
        class Solution {
            function findKthLargest($nums, $k) {
                //对撞指针
                $aim = count($nums)-$k;//从小到大排序,第k大即为总数减去排位k
                $low = 0;
                $height = count($nums)-1;
                $position = $this->partition($nums,$low,$height);
                //将结果逼近到目标答案处
                while ($position != $aim) {
                    if($position > $aim){
                        $height = $position-1;
                    }else{
                        $low = $position+1;
                    }
                    $position = $this->partition($nums,$low,$height);
                }
                return $nums[$position];
            }
            //快排关键函数,分区函数
            function partition(&$arr,$low,$height){
                $flag = $arr[$low];
                while ($low<$height) {
                    while ($low<$height && $arr[$height] >= $flag) {
                        $height--;
                    }
                    $this->swap($arr,$low,$height);
                    while ($low<$height && $arr[$low] < $flag) {
                        $low++;
                    }
                    $this->swap($arr,$low,$height);
                }
                return $low;
            }
            //交换函数
            function swap(&$arr,$i,$j){
                $tmp = $arr[$i];
                $arr[$i] = $arr[$j];
                $arr[$j] = $tmp;
            }
        }
    ```
