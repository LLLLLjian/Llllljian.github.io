---
title: Leetcode_基础 (80)
date: 2019-06-12 12:00:00
tags: Leetcode
toc: true
---

### 赎金信
    Leetcode学习-383

<!-- more -->

#### Q
    给定一个赎金信 (ransom) 字符串和一个杂志(magazine)字符串,判断第一个字符串ransom能不能由第二个字符串magazines里面的字符构成.如果可以构成,返回 true ；否则返回 false.

    (题目说明: 为了不暴露赎金信字迹,要从杂志上搜索各个需要的字母,组成单词来表达意思.)

    注意: 

    你可以假设两个字符串均只含有小写字母.

    canConstruct("a", "b") -> false
    canConstruct("aa", "ab") -> false
    canConstruct("aa", "aab") -> true

#### A
    ```python
        class Solution(object):
            def canConstruct(self, ransomNote, magazine):
                """
                :type ransomNote: str
                :type magazine: str
                :rtype: bool
                """
                magazine = list(magazine) # 变为list,好删除
                
                for s in ransomNote:
                    if s not in magazine:
                        return False
                    else:
                        magazine.remove(s)  # 删除已经用过的字母
                
                return True
    ```
    ```php
        class Solution {
            /**
            * @param String $ransomNote
            * @param String $magazine
            * @return Boolean
            */
            function canConstruct($ransomNote, $magazine) {
                if (empty($ransomNote)) {
                    return true;
                }
                $tempArr0 = array_count_values(str_split($ransomNote));
                $tempArr1 = array_count_values(str_split($magazine));

                foreach($tempArr0 as $key=>$value) {
                    if ($value > $tempArr1[$key]) {
                        return false;
                    }
                }
                return true;
            }
        }
    ```
