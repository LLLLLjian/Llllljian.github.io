---
title: Leetcode_基础 (179)
date: 2020-09-17
tags: Leetcode
toc: true
---

### 开拓新题
    序列化二叉树

<!-- more -->

#### 二叉树的序列化与反序列化
- 问题描述
   > 你可以将以下二叉树：
               1
              / \
             2   3
                / \
               4   5
    序列化为 "[1,2,3,null,null,4,5]"
- 解题思路
    * 层序遍历， null也要遍历出来
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
        class Codec 
        {
            function __construct() 
            {
                
            }
        
            /**
            * @param TreeNode $root
            * @return String
            */
            public function serialize($root)
            {
                if ($root === null) return '';
                // BFS
                $queue = new SplQueue();
                $queue->enqueue($root);
                $ans = [];
                while (!$queue->isEmpty()) {
                    $node = $queue->dequeue();
                    // 空节点也要添加
                    if ($node->val === null) {
                        $ans[] = 'null';
                    } else {
                        $ans[] = $node->val;
                        $queue->enqueue($node->left);
                        $queue->enqueue($node->right);
                    }
                }

                return implode(',', $ans);
            }

            /**
            * @param String $data
            * @return TreeNode
            */
            public function deserialize($data)
            {
                $n = strlen($data);
                if ($n == 0) return null;
                $arr = explode(',', $data);
                $queue = new SplQueue();
                $root = new TreeNode($arr[0]);
                $queue->enqueue($root);
                // 数组下标
                $cur = 1;
                while (!$queue->isEmpty()) {
                    // 由于空节点也添加进了数组，所以数组内连续三个节点的顺序肯定是 父节点->左子节点-> 右子节点
                    $curNode = $queue->dequeue();
                    if ($arr[$cur] !== 'null') {
                        $curNode->left = new TreeNode($arr[$cur]);
                        $queue->enqueue($curNode->left);
                    }
                    $cur++;
                    if ($arr[$cur] !== 'null') {
                        $curNode->right = new TreeNode($arr[$cur]);
                        $queue->enqueue($curNode->right);
                    }
                    $cur++;
                }

                return $root;
            }
        }

        /**
        * Your Codec object will be instantiated and called as such:
        * $ser = Codec();
        * $deser = Codec();
        * $data = $ser->serialize($root);
        * $ans = $deser->deserialize($data);
        */
    ```

