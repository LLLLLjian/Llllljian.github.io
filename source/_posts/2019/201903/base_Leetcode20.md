---
title: Leetcode_基础 (20)
date: 2019-03-07
tags: Leetcode
toc: true
---

###  删除排序链表中的重复元素
    Leetcode学习-83

<!-- more -->

#### Q
    给定一个排序链表,删除所有重复的元素,使得每个元素只出现一次.

    示例 1:

    输入: 1->1->2
    输出: 1->2
    示例 2:

    输入: 1->1->2->3->3
    输出: 1->2->3

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
            * @return ListNode
            */
            function deleteDuplicates($head) {
                $temp = $head;
                if (empty($head)) {
                    return "";
                }
                if (empty($head->next)) {
                    return $head;
                }
                while (!empty($temp->next)) {
                    if ($temp->val == $temp->next->val) {
                        $temp->next = $temp->next->next;
                    } else {
                        $temp = $temp->next;
                    }
                        
                    if (empty($temp)) {
                        break;
                    }
                }
                    
                return $head;
            }
        }
    ```
