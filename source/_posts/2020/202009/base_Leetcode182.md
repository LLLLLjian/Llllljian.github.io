---
title: Leetcode_基础 (182)
date: 2020-09-23
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-二叉树与图

<!-- more -->

#### 路径总和III
- 问题描述
    > 给定一个二叉树, 它的每个结点都存放着一个整数值.
    找出路径和等于给定数值的路径总数.
    路径不需要从根节点开始, 也不需要在叶子节点结束, 但是路径方向必须是向下的(只能从父节点到子节点).
    二叉树不超过1000个节点, 且节点数值范围是 \[-1000000,1000000] 的整数.
    示例：
    root = \[10,5,-3,3,2,null,11,3,-2,null,1], sum = 8
          10
         /  \
        5   -3
       / \    \
      3   2   11
     / \   \
    3  -2   1
    返回 3.和等于 8 的路径有:
    1.  5 -> 3
    2.  5 -> 2 -> 1
    3.  -3 -> 11
- 解题思路
    * 先来递归 DFS 深度优先遍历
        ```php
            /**
             * Definition for a binary tree node.
             * class TreeNode {
             *     public $val = null;
             *     public $left = null;
             *     public $right = null;
             *     function __construct($val = 0, $left = null, $right = null) {
             *         $this->val = $val;
             *         $this->left = $left;
             *         $this->right = $right;
             *     }
             * }
             */
            class Solution 
            {
                /**
                 * @param TreeNode $root
                 * @param Integer $sum
                 * @return Integer
                 */
                function pathSum($root, $sum)
                {
                    return $this->dfs($root, $sum, array());
                }

                function dfs($root, $sum, $sumList)
                {
                    if (empty($root)) {
                        return 0;
                    }

                    foreach ($sumList AS $key=>$value) {
                        $sumList[$key] += $root->val;
                    }
                    $sumList[] = $root->val;
                    $count = 0;
                    foreach ($sumList AS $key=>$value) {
                        if ($value == $sum) {
                            $count++;
                        }
                    }
                    return $count + $this->dfs($root->left, $sum, $sumList) + $this->dfs($root->right, $sum, $sumList);
                }
            }
        ```