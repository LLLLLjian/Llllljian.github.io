---
title: Leetcode_基础 (141)
date: 2020-04-27
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 链表求环
- Q
    * 已知链表中可能有环, 若有环就返回环起始节点, 否则返回null
- 解题思路
    * ![环起始节点](/img/20200427_1.png)
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
             * @return Boolean
             */
            function hasCycle($head)
            {
                if($head==null || $head->next==null){
                    return false;
                }
                $slow=$head;
                $fast=$head->next;
                while($slow!=$fast){
                    if($fast==null || $fast->next==null){
                        return false;
                    }
                    $slow=$slow->next;
                    $fast=$fast->next->next;
                }
                return true;
            }

            function detectCycle($head) 
            {
                //此处为第一步 快慢同时走,然后找出相遇点
                $fast = $head;
                $slow = $head;

                //找相遇点
                while(true){
                    //走到头了 或者 单个链表
                    if($fast == null && $fast->next == null) return null;
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                    if($fast === $slow) break; //找到相遇点 相遇点为slow
                }

                $fast = $head;//fast从头开始走

                //直到相遇
                while($fast != $slow){
                    $slow = $slow->next;
                    $fast = $fast->next;
                }

                return $fast;
            }
        }
    ```