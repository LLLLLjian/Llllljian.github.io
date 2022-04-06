---
title: Interview_总结 (43)
date: 2019-10-17
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题

<!-- more -->

#### 问题1
- Q
    * 输入: (2 -> 4 -> 3) + (5 -> 6 -> 4); 输出: 7 -> 0 -> 8; 原因: 342 + 465 = 807
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
        class Solution {

            /**
            * @param ListNode $l1
            * @param ListNode $l2
            * @return ListNode
            */
            function addTwoNumbers($l1, $l2) {
                $pre = new ListNode(0);
                $cur = $pre;
                $temp1 = $temp2 = 0;
                $n1 = $n2 = 0;
                while(isset($l1->val)) {
                    $temp1 += $l1->val * pow(10, $n1);
                    $l1 = $l1->next;
                    $n1+=1;
                }
                while(isset($l2->val)) {
                    $temp2 += $l2->val * pow(10, $n2);
                    $l2 = $l2->next;
                    $n2+=1;
                }
                $temp3 = $temp1 + $temp2;
                $temp3 = strval($temp3);
                $temp3Len = strlen($temp3);
                for ($i=$temp3Len-1;$i>=0;$i--) {
                    $cur->next = new ListNode($temp3[$i]);
                    $cur = $cur->next;
                }
                return $pre->next;
            }
        }
    ```


#### 问题1进阶
- Q
    * 问题1的解答存在的问题 :  PHP对长度特别大的数字计算加减法的时候会出现精度不准的情况, 所以导致部分例子得不到正确的答案
    * 对问题1进行重写, 改编自java版.
- A
    ```php
        // 解题思路
        // 将两个链表看成是相同长度的进行遍历,如果一个链表较短则在前面补 0,比如 987 + 23 = 987 + 023 = 1010
        // 每一位计算的同时需要考虑上一位的进位问题,而当前位计算结束后同样需要更新进位值
        // 如果两个链表全部遍历完毕后,进位值为 1,则在新链表最前方添加节点 1
        // 小技巧: 对于链表问题,返回结果为头结点时,通常需要先初始化一个预先指针 pre,该指针的下一个节点指向真正的头结点head.使用预先指针的目的在于链表初始化时无可用节点值,而且链表构造过程需要指针移动,进而会导致头指针丢失,无法返回结果.
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
            * @param ListNode $l1
            * @param ListNode $l2
            * @return ListNode
            */
            function addTwoNumbers($l1, $l2) {
                $pre = new ListNode(0);
                $cur = $pre;
                $carry = 0;
                while(l$l1 != null || $l2 != null) {
                    $x = $l1 == null ? 0 : $l1->val;
                    $y = $l2 == null ? 0 : $l2->val;
                    $sum = $x + $y + $carry;
                    
                    $carry = floor($sum / 10);
                    $sum = $sum % 10;
                    $cur->next = new ListNode($sum);

                    $cur = $cur->next;
                    if($l1 != null)
                        $l1 = $l1->next;
                    if($l2 != null)
                        $l2 = $l2->next;
                }
                if($carry == 1) {
                    $cur->next = new ListNode($carry);
                }
                return $pre->next;
            }
        }
    ```