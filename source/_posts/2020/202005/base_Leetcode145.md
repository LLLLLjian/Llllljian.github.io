---
title: Leetcode_基础 (145)
date: 2020-05-07
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 删除链表的倒数第N个节点
    给定一个链表,删除链表的倒数第 n 个节点,并且返回链表的头结点.
    示例：
    给定一个链表: 1->2->3->4->5, 和 n = 2.
    当删除了倒数第二个节点后,链表变为 1->2->3->5.
    说明：
    给定的 n 保证是有效的.
    进阶：
    你能尝试使用一趟扫描实现吗？
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
             * @param Integer $n
             * @return ListNode
             * 
             * fast比slow多走n步, 然后fast再和slow一起走, 那fast走到最后, slow就走到了n前边
             */
            function removeNthFromEnd($head, $n) 
            {
                if ($head==null) {
                    return $head;
                } 
                //设置一个默认的节点
                $dumbNode = new ListNode(0);
                $dumbNode->next = $head;
                $fast = $slow = $dumbNode;
                //让fast比slow先走n+1步
                while ($n+1) {
                    $fast = $fast->next;
                    $n--;
                }     
                //fast走到尾部的时候slow就是要删除节点的前一个节点
                while ($fast!==null) {
                    $slow = $slow->next;
                    $fast = $fast->next;
                }
                //将slow的next指针指到next->next,即可删除slow的next
                $slow->next = $slow->next->next;
                
                return $dumbNode->next;
            }

            /**
             * 先得出链表长度, 然后找到n前边
             */
            function removeNthFromEnd1($head, $n) 
            {
                $dumb = new ListNode(0);
                $dumb->next = $head;
                $length = 0;
                $first = $head;
                while($first!==null){
                    $length++;
                    $first = $first->next;
                }

                $first = $dumb;
                $length -= $n;
                while($length){
                    $length--;
                    $first = $first->next;
                }
            
                $first->next = $first->next->next;
                return $dumb->next;
            }
        }
    ```
