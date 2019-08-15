---
title: Leetcode_基础 (114)
date: 2019-07-30
tags: Leetcode
toc: true
---

### 单词模式
    Leetcode学习-290

<!-- more -->

#### Q
    给定一种 pattern(模式) 和一个字符串 str ,判断 str 是否遵循相同的模式.

    这里的遵循指完全匹配,例如, pattern 里的每个字母和字符串 str 中的每个非空单词之间存在着双向连接的对应模式.

    示例1:

    输入: pattern ="abba", str ="dog cat cat dog"
    输出: true
    示例 2:

    输入:pattern ="abba", str ="dog cat cat fish"
    输出: false
    示例 3:

    输入: pattern ="aaaa", str ="dog cat cat dog"
    输出: false
    示例 4:

    输入: pattern ="abba", str ="dog dog dog dog"
    输出: false
    说明:
    你可以假设 pattern 只包含小写字母, str 包含了由单个空格分隔的小写字母

#### A
    ```php
        class Solution {
            function wordPattern($pattern, $str) {
                //查找数
                $str = explode(' ', $str);//将字符串分段
                $lenp = strlen($pattern);
                $pattern = str_split($pattern);//将模式分割
                $lens = count($str);
                //如果字符串段数,跟pattern字符串长度不一样,则不满足条件
                if($lens != $lenp) return false;
                //构建map哈希表
                $map = [];
                for($i = 0;$i<$lens;++$i){
                    //当map中存在该数时,且与pattern数不相等,证明出现了不对应的数,返回false
                    if(isset($map[$str[$i]]) && $map[$str[$i]] != $pattern[$i]){
                        return false;
                    }else{
                        //map中不存在该数,该数第一次出现
                        $map[$str[$i]] = $pattern[$i];
                    }
                }
                //按照题目要求,不能出现值相同的情况
                if(count($map) == count(array_unique($map))) return true;
                return false;
            }
        }
    ```
