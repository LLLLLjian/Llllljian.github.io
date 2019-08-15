---
title: Leetcode_基础 (108)
date: 2019-07-22
tags: Leetcode
toc: true
---

### 找到字符串中所有字母异位词
    Leetcode学习-438

<!-- more -->

#### Q
    给定一个字符串 s 和一个非空字符串 p,找到 s 中所有是 p 的字母异位词的子串,返回这些子串的起始索引.

    字符串只包含小写英文字母,并且字符串 s 和 p 的长度都不超过 20100.

    说明：

    字母异位词指字母相同,但排列不同的字符串.
    不考虑答案输出的顺序.
    示例 1:

    输入:s: "cbaebabacd" p: "abc"
    输出:[0, 6]
    解释:
    起始索引等于 0 的子串是 "cba", 它是 "abc" 的字母异位词.
    起始索引等于 6 的子串是 "bac", 它是 "abc" 的字母异位词.
     示例 2:

    输入:s: "abab" p: "ab"
    输出:[0, 1, 2]
    解释:
    起始索引等于 0 的子串是 "ab", 它是 "ab" 的字母异位词.
    起始索引等于 1 的子串是 "ba", 它是 "ab" 的字母异位词.
    起始索引等于 2 的子串是 "ab", 它是 "ab" 的字母异位词.

#### A
    ```php
        class Solution {
            function findAnagrams($s, $p) {
                //滑动窗口
                $lenp = strlen($p);
                $lens = strlen($s);
                //p比s长,直接返回空数组
                if($lens<$lenp) return [];
                //构建p的哈希表
                $map = [];
                for($i = 0;$i<$lenp;$i++){
                    $map[$p[$i]]++;
                }
                $result = [];//存储结果
                $low = $height = 0;//定义窗口上界和下届的指针
                $num = 0;//窗口长度
                //滑动窗口法：从左往右滑动窗口, 遇到一个p内的字符就将$num+1
                while ($height<$lens) {
                    if(isset($map[$s[$height]]) && $map[$s[$height]]-- >= 1)
                        $num++;
                    $height++;
                //如果$num==p的长度时,则窗口满足长度要求,与要求进行判断后得出结果
                    if($num == $lenp)
                        $result[] = $low;
                //一旦窗口大小等于p的长度, 需要删去左端点字符, 删去时需要考虑是否要将$num-1
                    if($height-$low == $lenp){
                        if(isset($map[$s[$low]]) && $map[$s[$low]]++ >= 0)
                            $num--;
                        $low++;
                    }
                }
                return $result;
            }
        }
    ```
