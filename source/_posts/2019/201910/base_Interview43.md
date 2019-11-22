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
    * 输入：(2 -> 4 -> 3) + (5 -> 6 -> 4); 输出：7 -> 0 -> 8; 原因：342 + 465 = 807
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