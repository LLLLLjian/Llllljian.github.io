---
title: Leetcode_基础 (150)
date: 2020-05-14
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 链表中倒数第k个节点
    输入一个链表,输出该链表中倒数第k个节点.为了符合大多数人的习惯,本题从1开始计数,即链表的尾节点是倒数第1个节点.例如,一个链表有6个节点,从头节点开始,它们的值依次是1、2、3、4、5、6.这个链表的倒数第3个节点是值为4的节点.
    示例：
    给定一个链表: 1->2->3->4->5, 和 k = 2.
    返回链表 4->5.
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
             * @param Integer $k
             * @return ListNode
             */
            function getKthFromEnd($head, $k) 
            {
                $slow = $head;
                $fast = $head;

                while ($k>0) {
                    $fast = $fast->next;
                    $k-=1;
                }
                while (($fast != null) && ($slow != null)) {
                    $fast = $fast->next;
                    $slow = $slow->next;
                }
                return $slow;
            }

            function getKthFromEnd1($head, $k) 
            {
                $slow = $head;
                $fast = $head;
                $t = 0;
                while ($fast != null) {
                    if ($t >= $k) {
                        $slow = $slow->next;
                    }
                    $fast = $fast->next;
                    $t++;
                }
            }
        }
    ```

