---
title: Leetcode_基础 (156)
date: 2020-06-16
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温链表

<!-- more -->

#### 使用链表实现大数加法
- 问题描述
    * 两个用链表代表的整数, 其中每个节点包含一个数字.数字存储按照在原来整数中相反的顺序, 使得第一个数字位于链表的开头.写出一个函数将两个整数相加, 用链表形式返回和
- 解题思想
    * 链表都慢慢往前走, 有进位加进位
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
                $temp0 = 0;

                if (($l1==null)&&($l2==null)) {
                    return $newList;
                }

                while (($l1 != null) && ($l2 != null)) {
                    $temp1 = $l1->val;
                    $temp2 = $l2->val;

                    $temp = $temp0 + $temp1 + $temp2;
                    if ($temp >= 10) {
                        $temp0 = 1;
                        $temp = $temp - 10;
                    } else {
                        $temp0 = 0;
                    }
                    $res->next = new ListNode($temp);
                    $res = $res->next;
                    $l1 = $l1->next;
                    $l2 = $l2->next;
                }

                while ($l1 != null) {
                    $temp1 = $l1->val;
                    $temp = $temp0 + $temp1;
                    if ($temp >= 10) {
                        $temp0 = 1;
                        $temp = $temp - 10;
                    } else {
                        $temp0 = 0;
                    }
                    $res->next = new ListNode($temp);
                    $res = $res->next;
                    $l1 = $l1->next;
                }

                while ($l2 != null) {
                    $temp2 = $l2->val;
                    $temp = $temp0 + $temp2;
                    if ($temp >= 10) {
                        $temp0 = 1;
                        $temp = $temp - 10;
                    } else {
                        $temp0 = 0;
                    }
                    $res->next = new ListNode($temp);
                    $res = $res->next;
                    $l2 = $l2->next;
                }

                if ($temp0 != 0) {
                    $res->next = new ListNode($temp0);
                    $res = $res->next;
                }

                return $newList->next;
            }
        }
    ```

#### 有序链表合并
- 问题描述
    * 有序链表合并
- 解题思路
    * 链表值比较, 小的往前走 直到一个走完
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
            function mergeTwoLists($l1, $l2) 
            {
                $tempList = new ListNode();
                $temp = $tempList;
                while (!empty($l1) && !empty($l2)) {
                    if ($l1->val > $l2->val) {
                        $temp->next = $l2;
                        $l2 = $l2->next;
                    } else {
                        $temp->next = $l1;
                        $l1 = $l1->next;
                    }
                    $temp = $temp->next;
                }

                if (!empty($l1)) {
                    $temp->next = $l1;
                }
                if (!empty($l2)) {
                    $temp->next = $l2;
                }
                return $tempList->next;
            }
        }
    ```

#### 删除链表的节点
- 问题描述
    * 删除链表的指定节点
- 解题思路
    * 
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
                } else {
                    return null;
                }
            }
        }
    ```



