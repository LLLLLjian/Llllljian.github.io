---
title: Leetcode_基础 (24)
date: 2019-03-13
tags: Leetcode
toc: true
---

### 二叉树的最大深度
    Leetcode学习-104

<!-- more -->

#### Q
    给定一个二叉树,找出其最大深度.

    二叉树的深度为根节点到最远叶子节点的最长路径上的节点数.

    说明: 叶子节点是指没有子节点的节点.

    示例: 
    给定二叉树 [3,9,20,null,null,15,7],

        3
       / \
       9  20
         /  \
        15   7
    返回它的最大深度 3 .

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
             * @return Integer
             */
            function maxDepth($root) {
                if (empty($root)) {
                    return 0;
                } else {
                    if (empty($root->left) && empty($root->right)) {
                        return 1;
                    }
                    return max($this->maxDepth($root->left), $this->maxDepth($root->right)) + 1;
                }
            }
        }
    ```
