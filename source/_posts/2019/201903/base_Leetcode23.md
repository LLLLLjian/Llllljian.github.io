---
title: Leetcode_基础 (23)
date: 2019-03-12
tags: Leetcode
toc: true
---

### 对称二叉树
    Leetcode学习-101

<!-- more -->

#### Q
    给定一个二叉树,检查它是否是镜像对称的.

    例如,二叉树 [1,2,2,3,4,4,3] 是对称的.

        1
       / \
      2   2
     / \ / \
    3  4 4  3
    但是下面这个 [1,2,2,null,3,null,3] 则不是镜像对称的:

        1
       / \
      2   2
       \   \
        3    3

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
            * @return Boolean
            */
            function isSymmetric($root) {
                return $this->isMirror($root, $root);
            }
            
            function isMirror ($l, $r) {
                if (empty($l) && empty($r)) {
                    return true;
                }
                if (empty($l) || empty($r)) {
                    return false;
                }
                if ($r->val != $l->val) {
                    return false;
                }
                return $this->isMirror($r->right, $l->left) && $this->isMirror($r->left, $l->right);
            }
        }
    ```
