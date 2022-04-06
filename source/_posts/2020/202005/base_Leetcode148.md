---
title: Leetcode_基础 (148)
date: 2020-05-12
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 从尾到头打印链表
    输入一个链表的头节点,从尾到头反过来返回每个节点的值(用数组返回).
    示例 1: 
    输入: head = [1,3,2]
    输出: [2,3,1]
    限制: 
    0 <= 链表长度 <= 10000
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
             * @return Integer[]
             * 
             * 反转输出
             */
            function reversePrint($head) 
            {
                $res = array();
                $newHead = $this->reverseList($head);

                while ($newHead != null) {
                    $res[] = $newHead->val;
                    $newHead = $newHead->next;
                }
                return $res;
            }

            function reverseList($head)
            {
                if ($head != null) {
                    $cur =$head;
                    $prev = null;
                    while ($cur != null) {
                        $next = $cur->next;
                        $cur->next = $prev;
                        $prev = $cur;
                        $cur = $next;
                    }
                    return $prev;
                }
            }

            /**
             * 循环入栈
             */
            function reversePrint1($head) 
            {
                $res = array();

                while ($head != null) {
                    array_unshift($res, $head->val);
                    $head = $head->next;
                }
                return $res;
            }
        }
    ```
