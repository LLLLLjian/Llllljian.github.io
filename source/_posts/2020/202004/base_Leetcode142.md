---
title: Leetcode_基础 (142)
date: 2020-04-28
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 链表划分
- Q
    * 已知链表头指针head与数值x, 将所有小于x的节点放在大于或等于x的节点前, 且保持这些节点原来的相对位置
    * ![链表划分](/img/20200428_1.png)
- A
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
             * @param Integer $x
             * @return ListNode
             */
            //2个辅助链表
            function partition($head, $x) 
            {
                $smallHead = new ListNode(0);
                $bigHead = new ListNode(0);
                $small = $smallHead;
                $big = $bigHead;
                while ($head) {
                $tmp = new ListNode($head->val);
                if ($head->val < $x) {
                    $small->next = $tmp;
                    $small = $small->next;
                } else {
                    $big->next = $tmp;
                    $big = $big->next;
                }
                $head = $head->next;
                }
                $small->next = $bigHead->next;
                return $smallHead->next;
            }
        }

    ```


