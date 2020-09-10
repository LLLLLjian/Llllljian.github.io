---
title: Leetcode_基础 (172)
date: 2020-07-28
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-链表

<!-- more -->

#### 开胃菜1: 有序数组变成平衡搜索二叉树
- 问题描述
    * 有序数组变成平衡二叉树
- 解题思路
    * 我选择递归, 先找到跟节点, 也就是1/2节点, 然后比他小的去左子树, 比他大的去右子树
    ```php
        class TreeNode
        {
            public $val;
            public $left;
            public $right;
            
            public function __construct($val)
            {
                $this->val = $val;
            }
        }

        function sortedArrayToBST($arr)
        {
            if (emtpy($arr)) {
                return null;
            }
            $start = 0;
            $end = count($arr) - 1;
            $mid = ceil(($start + $end)/2);

            $root = new TreeNode($arr[$mid]);
            $root->left = sortedArrayToBST(array_slice($arr, 0, $mid));
            $root->left = sortedArrayToBST(array_slice($arr, $mid+1));
            return $root;
        }
    ```

#### 开胃菜2: 链表的中间结点
- 问题描述
    * 给定一个带有头结点 head 的非空单链表,返回链表的中间结点.如果有两个中间结点,则返回第二个中间结点
- 解题思路
    * 快慢指针, 一个走1一个走2, 等2走完的时候 1刚好到中间
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val) { $this->val = $val; }
         * }
         */
        class Solution 
        {
            /**
             * @param ListNode $head
             * @return ListNode
             */
            function middleNode($head) 
            {
                $fast = $head;
                $slow = $head;
                while (!empty($fast) && !empty($fast->next)) {
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                }
                return $slow;
            }
        }
    ```

#### 正菜: 有序链表转换二叉搜索树
- 问题描述
- 解题思路
    * 把开胃菜1、开胃菜2结合一下就好了
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val = 0, $next = null) {
         *         $this->val = $val;
         *         $this->next = $next;
         *     }
         * }
         */
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
             * @param ListNode $head
             * @return TreeNode
             */
            function sortedListToBST($head)
            {
                if (empty($head)) {
                    return null;
                }
                if (empty($head->next)) {
                    return new TreeNode($head->val);
                }

                // 快慢指针找中间节点
                $fast = $head;
                $slow = $head;
                $pre = null;
                while (!empty($fast) && !empty($fast->next)) {
                    $pre = $slow;
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                }
                $pre->next = null;

                $root = new TreeNode($slow->val);
                $root->left = $this->sortedListToBST($head);
                $root->right = $this->sortedListToBST($slow->next);
                return $root;
            }
        }
    ```
