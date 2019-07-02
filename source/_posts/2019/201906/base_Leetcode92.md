---
title: Leetcode_基础 (92)
date: 2019-06-20 12:00:00
tags: Leetcode
toc: true
---

### N叉树的层序遍历
    Leetcode学习-429

<!-- more -->

#### Q
    给定一个 N 叉树，返回其节点值的层序遍历。 (即从左到右，逐层遍历)。

    例如，给定一个 3叉树 :

     



     

    返回其层序遍历:

    [
        [1],
        [3,2,4],
        [5,6]
    ]
     

    说明:

    树的深度不会超过 1000。
    树的节点总数不会超过 5000。

#### A
    ```php
        /*
        // Definition for a Node.
        class Node {
            public $val;
            public $children;

            @param Integer $val 
            @param list<Node> $children 
            function __construct($val, $children) {
                $this->val = $val;
                $this->children = $children;
            }
        }
        */
        class Solution {
            public $res = array();
            /**
            * @param Node $root
            * @return Integer[][]
            */
            function levelOrder($root) {
                if (empty($root)) {
                    return $this->res;
                }
                $this->dfs($root, 0);
                return $this->res;
            }
            
            function dfs($root, $level) {
                if(empty($root)) {
                    return;
                }

                $this->res[$level][] = $root->val;
                if (!empty($root->children)) {
                    foreach ($root->children as $value) {
                        $this->dfs($value, $level+1);
                    }
                }
            }
        }
    ```
