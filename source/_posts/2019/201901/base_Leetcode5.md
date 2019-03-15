---
title: Leetcode_基础 (5)
date: 2019-01-25
tags: Leetcode
toc: true
---

### 最长公共前缀
    Leetcode学习-14

<!-- more -->

#### Q
    编写一个函数来查找字符串数组中的最长公共前缀.
    如果不存在公共前缀,返回空字符串 "".
    示例 1:
    输入: ["flower","flow","flight"]
    输出: "fl"
    示例 2:
    输入: ["dog","racecar","car"]
    输出: ""
    解释: 输入不存在公共前缀.
    说明:
    所有输入只包含小写字母 a-z .

#### A
    ```php
        class Solution {
            function longestCommonPrefix($arr) {
                $dataArr = array();
                if (empty($arr) || !is_array($arr)) {
                    return "";
                }

                foreach ($arr as $key=>$value) {
                    if (empty($value)) {
                        return "";
                    }
                }
                $arr = array_unique($arr);
                if (count($arr) == 1) {
                    return $arr[0];
                }

                foreach ($arr as $key=> $value) {
                    for ($i=0;$i<=strlen($value);$i++) {
                        $dataArr[] = substr($value,0,$i);
                    }
                }
                
                foreach (array_count_values($dataArr) as $key=>$value) {
                    if ($value == count($arr)) {
                        $returnArr[] = $key;
                    }
                }
                return end($returnArr);
            }
        }

        $a = new Solution();
        $arr = array("flower","flow","flight");
        echo $a->longestCommonPrefix($arr)."\n";
        $arr = array("aca","cba");
        echo $a->longestCommonPrefix($arr)."\n";
        $arr = array("c","acc","ccc");
        echo $a->longestCommonPrefix($arr)."\n";
        $arr = array("","b");
        echo $a->longestCommonPrefix($arr)."\n";
        $arr = array("c","c");
        echo $a->longestCommonPrefix($arr)."\n";
        $arr = array("a","ac");
        echo $a->longestCommonPrefix($arr)."\n";
    ```
