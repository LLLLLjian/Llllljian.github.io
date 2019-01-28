---
title: Leetcode_基础 (9)
date: 2019-01-31
tags: Leetcode
toc: true
---

### 有效的括号
    Leetcode学习

<!-- more -->

#### Q
    给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
    有效字符串需满足：
    左括号必须用相同类型的右括号闭合。
    左括号必须以正确的顺序闭合。
    注意空字符串可被认为是有效字符串。
    示例 1:
    输入: "()"
    输出: true
    示例 2:
    输入: "()[]{}"
    输出: true
    示例 3:
    输入: "(]"
    输出: false
    示例 4:
    输入: "([)]"
    输出: false
    示例 5:
    输入: "{[]}"
    输出: true

#### A
    ```php
        class Solution {
            function isValid($s) {
                $arr = array('(', ')', '{', '}', '[', ']');
                
                if (empty($s)) {
                    return true;
                } else {
                    if (strlen($s) % 2 != 0) {
                        return false;
                    } else {
                        while (strstr($s, '{}') || strstr($s, '()') || strstr($s, '[]')) {
                            $s = str_replace("{}","",$s);
                            $s = str_replace("()","",$s);
                            $s = str_replace("[]","",$s);
                        }
                        return $s == '';
                    }
                }
            }
        }

        $a = new Solution();
        $s = "()";
        echo $a->isValid($s)."\n";
        $s = "()[]{}";
        echo $a->isValid($s)."\n";
        $s = "(]";
        echo $a->isValid($s)."\n";
        $s = "([)]";
        echo $a->isValid($s)."\n";
        $s = "{[]}";
        echo $a->isValid($s)."\n";
    ```
