---
title: Leetcode_基础 (42)
date: 2019-04-23
tags: Leetcode
toc: true
---

### 移除链表元素
    Leetcode学习-203

<!-- more -->

#### Q
    删除链表中等于给定值 val 的所有节点
    示例:

    输入: 1->2->6->3->4->5->6, val = 6
    输出: 1->2->3->4->5

#### A
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val) { $this->val = $val; }
         * }
         */
        class Solution {
            /**
             * @param ListNode $head
             * @param Integer $val
             * @return ListNode
             */
            function removeElements($head, $val) 
            {
                if (!$head) {
                    return $head;
                }
                $head->next = $this->removeElements($head->next, $val);
                return $head->val == $val ? $head->next : $head;
            }
        }
    ```
