---
title: Interview_总结 (69)
date: 2020-03-09
tags: 
- Interview
- Leetcode
toc: true
---

### 算法题
    Leetcode学习-10
    将有序数组转换为二叉搜索树

<!-- more -->

#### 将有序数组转换为二叉搜索树
- Q
    * 将一个按照升序排列的有序数组, 转换为一棵高度平衡二叉搜索树.
    * 本题中, 一个高度平衡二叉树是指一个二叉树每个节点 的左右两个子树的高度差的绝对值不超过 1.
    * 示例:
    * 给定有序数组: [-10,-3,0,5,9],
    * 一个可能的答案是：[0,-3,9,-10,null,5]
- A
    * O(n)
    * 解题思路: 二叉搜索树的中序遍历结果为递增序列, 以题目给出的 [-10,-3,0,5,9] 为例, 我们选取数组中点, 即数字 0 作为根节点.此时, 以 0 为分界点将数组分为左右两个部分, 左侧为 [-10, -3], 右侧为 [5, 9].因该数组为升序排列的有序数组, 所以左侧数组值均小于 0, 可作为节点 0 的左子树；右侧数组值均大于 0, 可作为节点 0 的右子树
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
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return TreeNode
             */
            function sortedArrayToBST($nums)
            {
                $begin = 0;
                $end = count($nums) - 1;
                if ($begin > $end) {
                    return null;
                }
                $mid = ceil(($begin + $end) / 2);
                $root = new TreeNode($nums[$mid]);
                $root->left = $this->sortedArrayToBST(array_slice($nums, 0, $mid));
                $root->right = $this->sortedArrayToBST(array_slice($nums, $mid + 1));
                return $root;
            }
        }
    ```

