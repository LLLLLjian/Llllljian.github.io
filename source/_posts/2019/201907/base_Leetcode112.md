---
title: Leetcode_基础 (112)
date: 2019-07-26
tags: Leetcode
toc: true
---

### 两个数组的交集
    Leetcode学习-349

<!-- more -->

#### Q
    给定两个数组,编写一个函数来计算它们的交集.

    示例 1:

    输入: nums1 = [1,2,2,1], nums2 = [2,2]
    输出: [2]
    示例 2:

    输入: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
    输出: [9,4]
    说明:

    输出结果中的每个元素一定是唯一的.
    我们可以不考虑输出结果的顺序.

#### A
    ```php
        class Solution {
            function intersection($nums1, $nums2) {
                //查找数
                $len1 = count($nums1);
                $len2 = count($nums2);
                if ($len1==0 || $len2==0) return [];
                //建立一个map哈希表
                //把nums2出现的字符都设为1
                $map = $result = [];
                for($i = 0;$i<$len2;++$i){
                    $map[$nums2[$i]] = 1; //['2'=>1]
                }
                for($i = 0;$i<$len1;++$i){
                    //当在num1中找到同样的字符时
                    if($map[$nums1[$i]] == 1){
                        //将找到的字符推入结果数组中
                        $result[] = $nums1[$i];
                        //并设对应的map为0,防止重复检索
                        $map[$nums1[$i]]=0;
                    }
                }
                return $result;
            }
        }
    ```
