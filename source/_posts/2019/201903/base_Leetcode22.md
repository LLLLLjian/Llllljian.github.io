---
title: Leetcode_基础 (22)
date: 2019-03-11
tags: Leetcode
toc: true
---

### 相同的树
    Leetcode学习-100

<!-- more -->

#### Q
    给定两个二叉树,编写一个函数来检验它们是否相同.

    如果两个树在结构上相同,并且节点具有相同的值,则认为它们是相同的.

    示例 1:

    输入:       1         1
               / \       / \
              2   3     2   3

            [1,2,3],   [1,2,3]

    输出: true
    示例 2:

    输入:      1          1
              /           \
              2             2

            [1,2],     [1,null,2]

    输出: false
    示例 3:

    输入:       1         1
              / \       / \
             2   1     1   2

            [1,2,1],   [1,1,2]

    输出: false

#### A
    ```php
        /**
         * Definition for a binary tree node.
         * class TreeNode {
         *     public $val = null;
         *     public $left = null;
         *     public $right = null;
         *     function __construct($value) { $this->val = $value; }
         * }
         */
        class Solution {

            /**
            * @param TreeNode $p
            * @param TreeNode $q
            * @return Boolean
            */
            function isSameTree($p, $q) {
                
                if(json_encode($p) == json_encode($q)){
                    return true;   
                }
                return false;
            }
        }

        $a = new Solution();
        var_dump($a->isSameTree([1,null,2,3], [1,null,2,null,3]));
    ```
