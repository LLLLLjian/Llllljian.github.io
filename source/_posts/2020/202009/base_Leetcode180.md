---
title: Leetcode_基础 (180)
date: 2020-09-21
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-二叉树与图

<!-- more -->

#### 二叉树的所有路径
- 问题描述
    > 给定一个二叉树，返回所有从根节点到叶子节点的路径。
    说明: 叶子节点是指没有子节点的节点。
    示例:
    输入:
           1
         /   \
        2     3
         \
          5
    输出: ["1->2->5", "1->3"]
    解释: 所有根节点到叶子节点的路径为: 1->2->5, 1->3
- 解题思路
    * DFS 深度优先搜索
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
                 * @return String[]
                 */
                function binaryTreePaths($root) 
                {
                    $result = array();
                    if (empty($root)) {
                        return $result;
                    }
                    $this->dfs($root, "", $result);
                    return $result;
                }

                /**
                 * 首先初始化临时路径为空“”
                 * 之后每下降一层，就将临时路径跟当前节点的值拼接上
                 * 对于任何一个节点，要不就是叶子节点，要不就是非叶子节点，我们可以这样处理：
                 * 如果当前节点如果是叶子节点，那么拼接的内容是root.val
                 * 如果当前节点不是叶子节点，那么拼接的内容是root.val+"->"
                 */
                function dfs($root, $path, &$result)
                {
                    if (empty($root)) {
                        return;
                    }

                    // 如果是叶子结点， 将root.val拼接到临时路径中
                    if (!empty($root) && empty($root->left) && empty($root->right)) {
                        array_push($result, $path.$root->val);
                        return;
                    }

                    // 如果当前节点不是叶子节点，将 root.val+"->" 拼接到临时路径中
                    if (!empty($root->left)) {
                        $this->dfs($root->left, $path . $root->val . "->", $result);
                    }
                    if (!empty($root->right)) {
                        $this->dfs($root->right, $path . $root->val . "->", $result);
                    }
                }
            }
        ```
    * BFS 广度优先搜索
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
                 * @return String[]
                 */
                function binaryTreePaths($root) 
                {
                    $result = $queue = array();
                    $pair = array();
                    if (empty($root)) {
                        return $result;
                    }

                    $pair = array(
                        'path' => "",
                        'node' => $root
                    );
                    $queue[] = $pair;
                    while (!empty($queue)) {
                        $temp = array_shift($queue);
                        $path = $temp['path'];
                        $node = $temp['node'];
                        if (empty($node)) {
                            continue;
                        }
                        // 如果当前节点是叶子节点，将其拼装后放入最终结果集中
                        if (!empty($node) && empty($node->left) && empty($node->right)) {
                            array_push($result, $path . $node->val);
                            continue;
                        }
                        // 如果当前节点不是叶子节点，将其左子树和新路径放入队列中
                        if (!empty($node->left)) {
                            $pair = array(
                                'path' => $path . $node->val . "->",
                                'node' => $node->left
                            );
                            array_push($queue, $pair);
                        }
                        // 如果当前节点不是叶子节点，将其右子树和新路径放入队列中
                        if (!empty($node->right)) {
                            $pair = array(
                                'path' => $path . $node->val . "->",
                                'node' => $node->right
                            );
                            array_push($queue, $pair);
                        }
                    }
                    return $result;
                }
            }
        ```

#### 路径总和
- 问题描述
    > 给定一个二叉树和一个目标和，判断该树中是否存在根节点到叶子节点的路径，这条路径上所有节点值相加等于目标和。
    说明: 叶子节点是指没有子节点的节点。
    示例: 
    给定如下二叉树，以及目标和 sum = 22，
              5
             / \
            4   8
           /   / \
          11  13  4
         /  \      \
        7    2      1
    返回 true, 因为存在目标和为 22 的根节点到叶子节点的路径 5->4->11->2。
- 解题思路
    * 递归
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
                 * @return Boolean
                 */
                function hasPathSum($root, $sum)
                {
                    if (empty($root)) {
                        return false;
                    }
                    if (($root->val == $sum) && empty($root->left) && empty($root->right)) {
                        return true;
                    }
                    return $this->hasPathSum($root->left, $sum-$root->val) || $this->hasPathSum($root->right, $sum-$root->val);
                }
            }
        ```
    * BFS 广度优先搜索
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
                 * @return Boolean
                 */
                function hasPathSum($root, $sum) 
                {
                    if (empty($root)) {
                        return false;
                    }

                    $queNode = $queVal = array();
                    array_push($queNode, $root);
                    array_push($queVal, $root->val);

                    while (!empty($queNode)) {
                        $tempNode = array_shift($queNode);
                        $tempVal = array_shift($queVal);

                        if (empty($tempNode->left) && empty($tempNode->right)) {
                            if ($tempVal == $sum) {
                                return true;
                            } else {
                                continue;
                            }
                        }

                        if (!empty($tempNode->left)) {
                            array_push($queNode, $tempNode->left);
                            array_push($queVal, $tempVal+$tempNode->left->val);
                        }

                        if (!empty($tempNode->right)) {
                            array_push($queNode, $tempNode->right);
                            array_push($queVal, $tempVal+$tempNode->right->val);
                        }
                    }
                    return false;
                }
            }
        ```



