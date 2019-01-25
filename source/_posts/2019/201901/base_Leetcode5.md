---
title: Leetcode_基础 (5)
date: 2019-01-25
tags: Leetcode
toc: true
---

### 罗马数字转整数
    Leetcode学习

<!-- more -->

#### Q
    编写一个函数来查找字符串数组中的最长公共前缀。
    如果不存在公共前缀，返回空字符串 ""。
    示例 1:
    输入: ["flower","flow","flight"]
    输出: "fl"
    示例 2:
    输入: ["dog","racecar","car"]
    输出: ""
    解释: 输入不存在公共前缀。
    说明:
    所有输入只包含小写字母 a-z 。

#### A
    ```php
        class Solution {
            function longestCommonPrefix($arr) {
                $arr = array_filter($arr);
                if (empty($arr) || !is_array($arr)) {
                    return "";
                }

                if (count($arr) == 1) {
                    return $arr[0];
                }
                //获取字符串数组中的第一个值，以这个元素的值为基准，数组中之后的元素都跟这个进行比较
                $common_str= $arr[0];
                //遍历一下数组，把每个字符串都切割成数组，切割完就是这样的 array(0=>array(),1=>array()...n=>array())，你可以把得到的结果想成一个矩阵，矩阵的行数就是有多少个字符串，也就是传入数组的下标，列数就是每个字符串被切割后的数组下标。
                foreach ($arr as $key=>$value) {
                    $arr[$key] = str_split($value);
                }
                //到这里,$arr已经成为一个二维数组
                $length = count($arr);
                $temp = $arr[0];
                //因为我们要把每个字符串都和传入数组的第一个进行比较，所以把第一个单拿出来，作为一个基值
                $len = count($temp);
                //这个for循环中的$i 为矩阵的列，这样就能取出来每个子字符串数组的第i位
                for ($i=0;$i<$len;$i++) { 
                //这里for循环中的$n为矩阵的行，就是传入字符串数组的下标
                    for ($n=1; $n<$length; $n++) { 
                //如果基值的第i位与后面字符串的第i位不相等的话，截取基数字符串到第i位前
                        if($temp[$i]!=$arr[$n][$i]){
                //当然这儿有一个特殊情况，就是比较第0位还没比完时候，就bi掉了，那么就返回无相同前缀
                            if($i == 0) {
                                return "";
                            }
                            return substr($common_str,0,$i);
                        }
                    }
                //此处判断是 加入基数字符串遍历完成，全部都相同，那么我们返回基数字符串
                    if ($i==$len-1) {
                        return $commen_str;
                    }
                }
            }
        }

        $a = new Solution();
        $arr = array("flower","flow","flight");
        echo $a->longestCommonPrefix($arr)."<br />";
        $arr = array("aca","cba");
        echo $a->longestCommonPrefix($arr)."<br />";
        $arr = array("c","acc","ccc");
        echo $a->longestCommonPrefix($arr);
    ```
