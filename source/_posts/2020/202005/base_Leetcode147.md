---
title: Leetcode_基础 (147)
date: 2020-05-11
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 两两交换链表中的节点
    给定一个链表,两两交换其中相邻的节点,并返回交换后的链表.
    你不能只是单纯的改变节点内部的值,而是需要实际的进行节点交换.
    示例:
    给定 1->2->3->4, 你应该返回 2->1->4->3.
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
             * @return ListNode
             * 
             * 递归
             */
            function swapPairs($head) 
            {
                if (($head == null) || ($head->next == null)) {
                    return $head;
                } else {
                    $firstList = $head;
                    $secondList = $head->next;

                    $firstList->next = $this->swapPairs($secondList->next);
                    $secondList->next = $firstList;

                    return $secondList;
                }
            }

            /**
             * 迭代 
             */
            function swapPairs1($head) 
            {
                // 虚拟节点充当列表的head节点的prevNode,因此存储指向head节点的指针
                $clone = new ListNode(-1);
                $clone->next = $head;
                $prev = $clone;

                while (($head != null) && ($head->next != null)) {
                    // 要交换的节点
                    $firstList = $head;
                    $secondList = $head->next;

                    // 交换
                    $prev->next = $secondList;
                    $firstList->next = $secondList->next;
                    $secondList->next = $firstList;

                    // 为下一次交换重新初始化head和prev_节点
                    $prev = $firstList;
                    $head = $firstList->next;
                }

                return $clone->next;
            }
        }
    ```
