---
title: Leetcode_基础 (52)
date: 2019-05-09
tags: Leetcode
toc: true
---

### 回文链表
    Leetcode学习-234

<!-- more -->

#### Q
    请判断一个链表是否为回文链表.

    示例 1:

    输入: 1->2
    输出: false
    示例 2:

    输入: 1->2->2->1
    输出: true
    进阶：
    你能否用 O(n) 时间复杂度和 O(1) 空间复杂度解决此题？

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
             * @return Boolean
             */
            function isPalindrome($head) {
                // 用isset的原因 $head->val可能为0
                while(isset($head->val)) {
                    $tempArr[] = $head->val;
                    $head = $head->next;
                }
                
                $tempArr1 = array_reverse($tempArr);
                return ($tempArr == $tempArr1);
            }
        }
    ```
