---
title: Leetcode_基础 (44)
date: 2019-04-26
tags: Leetcode
toc: true
---

### 同构字符串
    Leetcode学习-205

<!-- more -->

#### Q
    给定两个字符串 s 和 t，判断它们是否是同构的。

    如果 s 中的字符可以被替换得到 t ，那么这两个字符串是同构的。

    所有出现的字符都必须用另一个字符替换，同时保留字符的顺序。两个字符不能映射到同一个字符上，但字符可以映射自己本身。

    示例 1:

    输入: s = "egg", t = "add"
    输出: true
    示例 2:

    输入: s = "foo", t = "bar"
    输出: false
    示例 3:

    输入: s = "paper", t = "title"
    输出: true
    说明:
    你可以假设 s 和 t 具有相同的长度

#### A
    ```php
        class Solution {
            /**
             * @param String $s
             * @param String $t
             * @return Boolean
             */
            function isIsomorphic($s, $t) 
            {
                $map = array();
                for ($i=0;$i<strlen($s);$i++) {
                    if (!isset($map[$s[$i]])) {
                        $map[$s[$i]]=$t[$i];
                    } else {
                        if ($map[$s[$i]] != $t[$i]) {
                            return false;
                        }
                    }
                }

                return count(array_unique(array_values($map))) == count($map);
            }
        }
    ```
