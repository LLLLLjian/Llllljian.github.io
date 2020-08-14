---
title: Leetcode_基础 (157)
date: 2020-06-17
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温链表

<!-- more -->

#### 从尾到头打印链表
- 问题描述
    * 输入一个链表的头节点, 从尾到头反过来返回每个节点的值(用数组返回).
- 解题思路
    * 链表反转之后正序输出
    * 数组入栈
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

            function reversePrint1($head) 
            {
                $res = array();

                if ($head != null) {
                    while ($head != null) {
                        array_unshift($res, $head->val);
                        $head = $head->next;
                    }
                }

                return $res;
            }
        }
    ```

#### 反转链表
- 问题描述
    * 反转一个单链表
- 解题思路
    * 反转就完事了
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
            function reverseList($head) 
            {
                if ($head != null) {
                    $cur = $head;
                    $prev = null;

                    while ($cur != null) {
                        $next = $cur->next;
                        $cur->next = $prev;
                        $prev = $cur;
                        $cur = $next;
                    }

                    return $prev;
                }
                return $head;
            }
        }
    ```


