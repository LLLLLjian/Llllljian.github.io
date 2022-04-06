---
title: Leetcode_基础 (176)
date: 2020-09-08
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-递归/回溯/分治

<!-- more -->

#### 开胃菜
- 问题描述
    * 生成所有的括号组合
- 解题思路
    * 使用递归去push
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return String[]
             */
            function generateParenthesis($n) 
            {
                $result = array();
                $this->generate("", $n, $result);
                var_dump($result);
            }

            function generate($item, $n, &$result)
            {
                if (strlen($item) == pow(2, $n)) {
                    array_push($result, $item);
                    return;
                }
                $this->generate($item . "(", $n, $result);
                $this->generate($item . ")", $n, $result);
            }
        }

        /**
         * generateParenthesis(2)
         * array(16) {
         *  [0]=>
         *  string(4) "((((" // 左括号>2
         *  [1]=>
         *  string(4) "((()" // 左括号>2
         *  [2]=>
         *  string(4) "(()(" // 左括号>2, 右括号比左括号放的早
         *  [3]=>
         *  string(4) "(())" // 合法
         *  [4]=>
         *  string(4) "()((" // 左括号>2
         *  [5]=>
         *  string(4) "()()" // 合法
         *  [6]=>
         *  string(4) "())(" // 右括号比左括号放的早
         *  [7]=>
         *  string(4) "()))" // 右括号>2
         *  [8]=>
         *  string(4) ")(((" // 右括号>2
         *  [9]=>
         *  string(4) ")(()" // 右括号比左括号放的早
         *  [10]=>
         *  string(4) ")()(" // 右括号比左括号放的早
         *  [11]=>
         *  string(4) ")())" // 右括号比左括号放的早
         *  [12]=>
         *  string(4) "))((" // 右括号比左括号放的早
         *  [13]=>
         *  string(4) "))()" // 右括号>2, 右括号比左括号放的早
         *  [14]=>
         *  string(4) ")))(" // 右括号>2, 右括号比左括号放的早
         *  [15]=>
         *  string(4) "))))" // 右括号>2, 右括号比左括号放的早
         *  }
         * /
    ```

#### 生成括号
- 问题描述
    > 数字 n 代表生成括号的对数,请你设计一个函数,用于能够生成所有可能的并且 有效的 括号组合.
    示例: 
    输入: n = 3
    输出: [
        "((()))",
        "(()())",
        "(())()",
        "()(())",
        "()()()"
        ]
- 解题思路
    * 在开胃菜的基础上添加条件
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return String[]
             */
            function generateParenthesis($n) 
            {
                $result = array();
                $this->generate("", $n, $n, $result);
                return $result;
            }

            function generate($item, $left, $right, &$result)
            {
                if (($left==0) && ($right==0)) {
                    array_push($result, $item);
                    return;
                }
                if ($left > 0) {
                    $this->generate($item . "(", $left-1, $right, $result);
                }
                if ($left < $right) {
                    $this->generate($item . ")", $left, $right-1, $result);
                }
            }
        }
    ```



