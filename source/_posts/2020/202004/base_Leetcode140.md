---
title: Leetcode_基础 (140)
date: 2020-04-22
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### Q
    已知链表A的头节点headA,链表B的头节点headB,两个链表相交,求两链表交点对应的节点
    要求1: 如果两个链表没有交点则返回null
    要求2: 在求交点的过程中, 不可以破坏链表的结构或者修改链表的数据域
    要求3: 可以确保传入的链表A和链表B没有环
    要求4: 实现算法尽可能使时间复杂度为O(n), 空间复杂度O(1)

#### A
    ```php
        // 可以理解成两个人速度一致, 走过的路程一致.那么肯定会同一个时间点到达终点.如果到达终点的最后一段路两人都走的话,那么这段路上俩人肯定是肩并肩手牵手的
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
             * @param ListNode $headA
             * @param ListNode $headB
             * @return ListNode
             */
            function getIntersectionNode($headA, $headB) {
                $lenA = $this->getListLen($headA);
                $lenB = $this->getListLen($headB);

                if ($lenA > $lenB) {
                    $headA = $this->getRealList($headA, $lenA-$lenB);
                } elseif ($lenB > $lenA) {
                    $headB = $this->getRealList($headB, $lenB-$lenA);
                }

                while (!empty($headA) && !empty($headB)) {
                    if ($headA === $headB) {
                        return $headA;
                    }
                    $headA = $headA->next;
                    $headB = $headB->next;
                }
                return null;
            }

            function getListLen($head)
            {
                $len = 0;
                while (!empty($head)) {
                    $len += 1;
                    $head = $head->next;
                } 
                return $len;
            }

            function getRealList($head, $diffLen)
            {
                while (!empty($head) && !empty($diffLen)) {
                    $head = $head->next;
                    $diffLen -= 1;
                }
                return $head;
            }
        }
    ```



