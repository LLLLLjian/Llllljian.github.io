---
title: Leetcode_基础 (85)
date: 2019-06-14 18:00:00
tags: Leetcode
toc: true
---

### 左叶子之和
    Leetcode学习-404

<!-- more -->

#### Q
    计算给定二叉树的所有左叶子之和.

    示例：

        3
       / \
      9  20
        /  \
       15   7

    在这个二叉树中,有两个左叶子,分别是 9 和 15,所以返回 24

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
            public $leftSum=0;
            /**
            * @param TreeNode $root
            * @return Integer
            */
            function sumOfLeftLeaves($root) {
                if (!empty($root->left) && (empty($root->left->left)) && (empty($root->left->right))) {
                    $this->leftSum += $root->left->val;
                }

                if (!empty($root->left)) {
                    $this->sumOfLeftLeaves($root->left);
                }
                if (!empty($root->right)) {
                    $this->sumOfLeftLeaves($root->right);
                }

                return $this->leftSum;
            }
        }
    ```
