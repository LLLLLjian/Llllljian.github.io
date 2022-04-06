---
title: Leetcode_基础 (63)
date: 2019-05-24
tags: Leetcode
toc: true
---

### 最接近的二叉搜索树值
    Leetcode学习-270

<!-- more -->

#### Q
    给定非空二进制搜索树和目标值,找到BST中最接近目标的值.

    注意
    给定目标值是浮点数.
    保证BST中只有一个最接近目标的唯一值

    输入:  root = [4,2,5,1,3],target = 3.714286

            4
           / \
         2 5
        / \
        1  3

#### A
    ```php
        class Solution {
            function closestValue($root, $target) {
                // 如果当前节点值小于目标值,则结果只可能是当前节点值或者右子树中的值
                // 如果当前节点值大于目标值,则结果只可能是当前节点值或者左子树中的值
                $res = $root->val;

                while (!empty($root)) {
                    if (bccomp($root->val, $tatget)) {
                        $res = $root->val;
                        $root = $root->left;
                    } else {
                        $root = $root->right;
                    }
                }

                return $res;
            }
        }
    ```
