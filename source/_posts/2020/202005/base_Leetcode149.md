---
title: Leetcode_基础 (149)
date: 2020-05-13
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 删除链表的节点
    给定单向链表的头指针和一个要删除的节点的值,定义一个函数删除该节点.
    返回删除后的链表的头节点.
    注意: 此题对比原题有改动
    示例 1:
    输入: head = [4,5,1,9], val = 5
    输出: [4,1,9]
    解释: 给定你链表中值为 5 的第二个节点,那么在调用了你的函数之后,该链表应变为 4 -> 1 -> 9.
    示例 2:
    输入: head = [4,5,1,9], val = 1
    输出: [4,5,9]
    解释: 给定你链表中值为 1 的第三个节点,那么在调用了你的函数之后,该链表应变为 4 -> 5 -> 9.
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
             * @param Integer $val
             * @return ListNode
             * 
             * 双指针
             */
            function deleteNode($head, $val) 
            {
                if ($head != null) {
                    if ($head->val == $val) {
                        return $head->next;
                    } else {
                        $cur = $head;
                        $se = $cur->next;

                        while ($se != null) {
                            if($se->val == $val){
                                $cur->next = $se->next;
                                $se = null;
                                break;
                            }
                            $cur = $se;
                            $se = $se->next; 
                        }
                        return $head;
                    }
                } else {
                    return null;
                }
            }

            /**
             * 单指针
             */
            function deleteNode1($head, $val) 
            {
                if ($head != null) {
                    if ($head->val == $val) {
                        return $head->next;
                    } else {
                        $cur = $head;
                        while ($cur->next != null) {
                            if ($cur->next->val == $val) {
                                $cur->next = $cur->next->next;
                                break;
                            }
                            $cur = $cur->next;
                        }
                        return $head;
                    }
                }
            }
        }
    ```
