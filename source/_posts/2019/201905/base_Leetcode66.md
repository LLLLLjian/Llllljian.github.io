---
title: Leetcode_基础 (66)
date: 2019-05-29
tags: Leetcode
toc: true
---

### 移动零
    Leetcode学习-283

<!-- more -->

#### Q
    给定一种规律 pattern 和一个字符串 str ,判断 str 是否遵循相同的规律.

    这里的 遵循 指完全匹配,例如, pattern 里的每个字母和字符串 str 中的每个非空单词之间存在着双向连接的对应规律.

    示例1:
    输入: pattern = "abba", str = "dog cat cat dog"
    输出: true
    示例 2:
    输入:pattern = "abba", str = "dog cat cat fish"
    输出: false
    示例 3:
    输入: pattern = "aaaa", str = "dog cat cat dog"
    输出: false
    示例 4:
    输入: pattern = "abba", str = "dog dog dog dog"
    输出: false
    说明:
    你可以假设 pattern 只包含小写字母, str 包含了由单个空格分隔的小写字母.  

#### A
    ```php
        class Solution {
            /**
            * @param String $pattern
            * @param String $str
            * @return Boolean
            */
            function wordPattern($pattern, $str) {
                if (empty($pattern) && empty($str)) {
                    return true;
                } else {
                    if (empty($pattern) || empty($str)) {
                        return false;
                    }
                }
                $tempP = str_split($pattern);
                $tempS = explode(" ", $str);
                if (count($tempP) == count($tempS)) {
                    $len = count($tempP);
                    for ($i=0;$i<$len;$i++) {
                        if (!array_key_exists($tempP[$i], $resArr) && !array_search($tempS[$i], $resArr)) {
                            $resArr[$tempP[$i]] = $tempS[$i];
                        } else {
                            if ($resArr[$tempP[$i]] == $tempS[$i]) {
                                continue;
                            } else {
                                return false;
                            }
                        }
                    }
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```
