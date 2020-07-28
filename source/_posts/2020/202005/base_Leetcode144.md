---
title: Leetcode_基础 (144)
date: 2020-05-06
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 两数相加
    给出两个 非空 的链表用来表示两个非负的整数.其中,它们各自的位数是按照 逆序 的方式存储的,并且它们的每个节点只能存储 一位 数字.
    如果,我们将这两个数相加起来,则会返回一个新的链表来表示它们的和.
    您可以假设除了数字 0 之外,这两个数都不会以 0 开头.
    示例：
    输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
    输出：7 -> 0 -> 8
    原因：342 + 465 = 807
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
             * @param ListNode $l1
             * @param ListNode $l2
             * @return ListNode
             */
            function addTwoNumbers($l1, $l2) 
            {
                $newList = new ListNode(0);
                $res = $newList;
                $temp = 0;

                if (($l1==null)&&($l2==null)) {
                    return $newList;
                }

                while ($l1!=null&&$l2!=null) {
                    $tempStr = $l1->val + $l2->val + $temp;

                    if ($tempStr>=10) {
                        $temp = 1;
                        $res->next = new ListNode($tempStr - 10);
                    } else {
                        $temp = 0;
                        $res->next = new ListNode($tempStr);
                    }
                    $res = $res->next;
                    $l1 = $l1->next;
                    $l2 = $l2->next;
                }

                if ($l1!=null) {
                    while ($l1!=null) {
                        $tempStr = $l1->val + $temp;
                        if ($tempStr>=10) {
                            $temp = 1;
                            $res->next = new ListNode($tempStr - 10);
                        } else {
                            $temp = 0;
                            $res->next = new ListNode($tempStr);
                        }
                        $res = $res->next;
                        $l1 = $l1->next;
                    }
                }

                if ($l2!=null) {
                    while ($l2!=null) {
                        $tempStr = $l2->val + $temp;
                        if ($tempStr>=10) {
                            $temp = 1;
                            $res->next = new ListNode($tempStr - 10);
                        } else {
                            $temp = 0;
                            $res->next = new ListNode($tempStr);
                        }
                        $res = $res->next;
                        $l2 = $l2->next;
                    }
                }

                if (!empty($temp)) {
                    $res->next = new ListNode($temp);
                    $res = $res->next;
                }
                return $newList->next;
            }
        }
    ```
