---
title: Leetcode_基础 (58)
date: 2019-05-17
tags: Leetcode
toc: true
---

### 二叉树的所有路径
    Leetcode学习-257

<!-- more -->

#### Q
    给定一个二叉树,返回所有从根节点到叶子节点的路径.

    说明: 叶子节点是指没有子节点的节点.

    示例:

    输入:

        1
      /   \
     2     3
      \
       5

    输出: ["1->2->5", "1->3"]

    解释: 所有根节点到叶子节点的路径为: 1->2->5, 1->3

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
            * @return String[]
            */
            function binaryTreePaths($root) {
                $this->resArr = array();

                if (empty($root)) {
                    return $res;
                } else {
                    $temp = "";
                    $this->helper($this->resArr, $temp, $root);
                    return $this->resArr;
                }
            }

            function helper($res, $temp, $root) {
                if (empty($root)) {
                    return;
                } 
                $temp .= $root->val;

                if (empty($root->left) && empty($root->right)) {
                    $this->resArr[] = $temp;
                    return;
                } else {
                    $this->helper($this->resArr, $temp."->", $root->left);
                    $this->helper($this->resArr, $temp."->", $root->right);
                }
            }
        }
    ```
