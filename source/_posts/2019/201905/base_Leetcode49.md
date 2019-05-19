---
title: Leetcode_基础 (49)
date: 2019-05-06
tags: Leetcode
toc: true
---

### 翻转二叉树
    Leetcode学习-226

<!-- more -->

#### Q
    翻转一棵二叉树.

    示例：

    输入：

            4
          /   \
         2     7
        / \   / \
       1   3 6   9
    输出：
            4
          /   \
         7     2
        / \   / \
       9   6 3   1

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
             * @param TreeNode $root
             * @return TreeNode
             */
            function invertTree($root) {
                if (!empty($root)) {
                    $left = $root->left;
                    $root->left = $root->right;
                    $root->right = $left;
                    
                    $this->invertTree($root->left);
                    $this->invertTree($root->right);
                } else {
                    return null;
                }
                return $root;
            }
        }
    ```
