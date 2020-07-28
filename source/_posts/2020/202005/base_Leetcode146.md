---
title: Leetcode_基础 (146)
date: 2020-05-08
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 删除链表的倒数第N个节点
    给定一个排序链表,删除所有重复的元素,使得每个元素只出现一次.
    示例 1:
    输入: 1->1->2
    输出: 1->2
    示例 2:
    输入: 1->1->2->3->3
    输出: 1->2->3
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
             * 通过将结点的值与它之后的结点进行比较来确定它是否为重复结点.如果它是重复的,我们更改当前结点的 next 指针,以便它跳过下一个结点并直接指向下一个结点之后的结点
             */
            function deleteDuplicates($head) 
            {
                $cur = $head;
                if ($cur != null) {
                    while (($cur != null) && ($cur->next != null)) {
                        if ($cur->val == $cur->next->val) {
                            $cur->next = $cur->next->next;
                        } else {
                            $cur = $cur->next;
                        }
                    }
                    return $head;
                } else {
                    return null;
                }
            }
        }
    ```
