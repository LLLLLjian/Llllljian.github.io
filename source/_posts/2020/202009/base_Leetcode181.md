---
title: Leetcode_基础 (181)
date: 2020-09-22
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-二叉树与图

<!-- more -->

#### 路径总和II
- 问题描述
    > 给定一个二叉树和一个目标和，找到所有从根节点到叶子节点路径总和等于给定目标和的路径。
    说明: 叶子节点是指没有子节点的节点。
    示例:
    给定如下二叉树，以及目标和 sum = 22，
              5
             / \
            4   8
           /   / \
          11  13  4
         /  \    / \
        7    2  5   1
    返回:\[\[5,4,11,2],\[5,8,4,5]]
- 解题思路
    * 我先看看能不能用递归, DFS 深度优先搜索
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
                 * @param TreeNode $root
                 * @param Integer $sum
                 * @return Integer[][]
                 */
                function pathSum($root, $sum) 
                {
                    $result = $list = array();
                    $this->dfs($root, $sum, $list, $result);
                    return $result;
                }

                function dfs($root, $sum, &$list, &$result)
                {
                    // 如果节点为空直接返回
                    if (empty($root)) {
                        return;
                    }
                    // 因为list是引用传递，为了防止递归的时候分支污染，我们要在每个路径中都要新建一个subList
                    $subList = $list;
                    // 把当前节点值加入到subList中
                    array_push($subList, $root->val);
                    // 如果到达叶子节点，就不能往下走了，直接return
                    if (empty($root->left) && empty($root->right)) {
                        // 如果到达叶子节点，并且sum等于叶子节点的值，说明我们找到了一组， 要把它放到result中
                        if ($sum == $root->val) {
                            array_push($result, $subList);
                            // 到叶子节点之后直接返回，因为在往下就走不动了
                            return;
                        }
                    }

                    // 如果没到达叶子节点，就继续从他的左右两个子节点往下找，注意到下一步的时候，sum值要减去当前节点的值
                    $this->dfs($root->left, $sum - $root->val, $subList, $result);
                    $this->dfs($root->right, $sum - $root->val, $subList, $result);
                }
            }
        ```
    * 回溯 往下减
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
                 * @param TreeNode $root
                 * @param Integer $sum
                 * @return Integer[][]
                 */
                function pathSum($root, $sum) 
                {
                    $result = $list = array();
                    $this->dfs($root, $sum, $list, $result);
                    return $result;
                }

                function dfs($root, $sum, &$list, &$result)
                {
                    // 如果节点为空直接返回
                    if (empty($root)) {
                        return;
                    }
                    // 把当前节点值加入到list中
                    array_push($list, $root->val);
                    // 如果到达叶子节点，就不能往下走了，直接return
                    if (empty($root->left) && empty($root->right)) {
                        // 如果到达叶子节点，并且sum等于叶子节点的值，说明我们找到了一组， 要把它放到result中
                        if ($sum == $root->val) {
                            array_push($result, $list);
                        }
                        // 注意别忘了把最后加入的结点值给移除掉，因为下一步直接return了，不会再走最后一行的remove了，所以这里在rerurn之前提前把最后一个结点的值给remove掉。
                        array_pop($list);
                        // 到叶子节点之后直接返回，因为在往下就走不动了
                        return;
                    }

                    // 如果没到达叶子节点，就继续从他的左右两个子节点往下找，注意到下一步的时候，sum值要减去当前节点的值
                    $this->dfs($root->left, $sum-$root->val, $list, $result);
                    $this->dfs($root->right, $sum-$root->val, $list, $result);

                    // 我们要理解递归的本质，当递归往下传递的时候他最后还是会往回走，我们把这个值使用完之后还要把它给移除，这就是回溯
                    array_pop($list);
                }
            }
        ```
    * 回溯 往上加
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
                 * @param TreeNode $root
                 * @param Integer $sum
                 * @return Integer[][]
                 */
                function pathSum($root, $sum) 
                {
                    $result = $list = array();
                    $total = 0;
                    $this->dfs($root, $sum, $total, $list, $result);
                    return $result;
                }

                function dfs($root, $sum, $total, &$list, &$result)
                {
                    // 如果节点为空直接返回
                    if (empty($root)) {
                        return;
                    }
                    // 把当前节点值加入到list中
                    array_push($list, $root->val);
                    // 没往下走一步就要计算走过的路径和
                    $total += $root->val;
                    // 如果到达叶子节点，就不能往下走了，直接return
                    if (empty($root->left) && empty($root->right)) {
                        // 如果到达叶子节点，并且sum等于total的值，说明我们找到了一组， 要把它放到result中
                        if ($sum == $total) {
                            array_push($result, $list);
                        }
                        // 注意别忘了把最后加入的结点值给移除掉，因为下一步直接return了，不会再走最后一行的remove了，所以这里在rerurn之前提前把最后一个结点的值给remove掉。
                        array_pop($list);
                        // 到叶子节点之后直接返回，因为在往下就走不动了
                        return;
                    }

                    // 如果没到达叶子节点，就继续从他的左右两个子节点往下找，注意到下一步的时候，sum值要减去当前节点的值
                    $this->dfs($root->left, $sum, $total, $list, $result);
                    $this->dfs($root->right, $sum, $total, $list, $result);

                    // 我们要理解递归的本质，当递归往下传递的时候他最后还是会往回走，我们把这个值使用完之后还要把它给移除，这就是回溯
                    array_pop($list);
                }
            }
        ```



