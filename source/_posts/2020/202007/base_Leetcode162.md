---
title: Leetcode_基础 (162)
date: 2020-07-01
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温树

<!-- more -->

#### 二叉树的层序遍历1
- 问题描述
    * 层序遍历 [3,9,20,15,7]
- 解题思路
    * 首先申请一个新的队列, 记为queue；
    * 将头结点head压入queue中；
    * 每次从queue中出队, 记为node, 然后打印node值, 如果node左孩子不为空, 则将左孩子入队；如果node的右孩子不为空, 则将右孩子入队；
    * 重复步骤3, 直到queue为空.
    ```php
        function levelOrder($root)
        {
            $res = $tempArr = array();
            if (!empty($root)) {
                $tempArr[] = $root;

                while (!empty($tempArr)) {
                    $tempArr1 = array_shift($tempArr);
                    $res[] = $tempArr1->val;

                    if (!empty($tempArr1->left)) {
                        $tempArr[] = $tempArr1->left;
                    }
                    if (!empty($tempArr1->right)) {
                        $tempArr[] = $tempArr1->right;
                    }
                }
            }
            return $res;
        }
    ```

#### 二叉树的层序遍历2
- 问题描述
    * 层序遍历 [[3],[9,20],[15,7]]
- 解题思路
    * 整体方向没变, 只是加了一个level来存储是第几层的元素
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
             * @return Integer[][]
             */
            function levelOrder($root) 
            {
                $res = $arr = [];
                if($root ==null){
                    return $res;
                }
                array_push($arr,$root);
                $level = 0;
                while($count = count($arr)){
                    for($i=$count;$i>0;$i--){
                        $node = array_shift($arr);//先入先出
                        $res[$level][] = $node->val;
                        if($node->left !=null) array_push($arr,$node->left);
                        if($node->right !=null) array_push($arr,$node->right);
                    }
                    $level++;
                }
                return $res;
            }

            /**
             * @param TreeNode $root
             * @return Integer[][]
             */
            function levelOrder($root)
            {
                $res = [];
                $this->level($root, 0, $res);
                return $res;
            }

            function level($root,$level,&$res)
            {
                if($root == null){
                    return null;
                }
                $res[$level][]= $root->val;
                $level++;
                if ($root->left !=null) {
                    $this->level($root->left, $level, $res);
                }
                if ($root->right !=null) {
                    $this->level($root->right, $level, $res);
                }
            }
        }
    ```

