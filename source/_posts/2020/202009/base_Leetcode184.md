---
title: Leetcode_基础 (184)
date: 2020-09-25
tags: Leetcode
toc: true
---

### 今日被问傻系列
    leetcode-2. 两数相加

<!-- more -->

#### 两数相加
- Q
    ```
        给定两个非空链表来代表两个非负整数.数字最高位位于链表开始位置.它们的每个节点只存储单个数字.将这两数相加会返回一个新的链表.
        你可以假设除了数字 0 之外, 这两个数字都不会以零开头.
        示例:
        输入: (7 -> 2 -> 4 -> 3) + (5 -> 6 -> 4)
        输出: 7 -> 8 -> 0 -> 7
    ```
- T
    * 思路其实很简单, 就是分别把两个链表的结点先存放到两个栈中, 因为链表的最高位是在链表的最开始的位置, 所以存放到栈中之后, 栈底是高位, 栈顶是个位(也是低位), 然后两个栈中的元素再相加, 因为栈是先进后出的, 最先出来的肯定是个位(也是低位), 最后出来的肯定是高位, 也就是这两个数是从个位开始相加, 这也符合加法的运算规律
- A
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val = 0, $next = null) {
         *         $this->val = $val;
         *         $this->next = $next;
         *     }
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
                $arr1 = $arr2 = array();
                while(isset($l1->val)) {
                    array_push($arr1, $l1->val);
                    $l1 = $l1->next;
                }
                while(isset($l2->val)) {
                    array_push($arr2, $l2->val);
                    $l2 = $l2->next;
                }

                $sum = 0;
                $resNode = new ListNode(0);
                $res = $resNode;
                while(!empty($arr1) || !empty($arr2) || ($sum == 1)) {
                    if (!empty($arr1)) {
                        $sum += array_shift($arr1);
                    }
                    if (!empty($arr2)) {
                        $sum += array_shift($arr2);
                    }
                    if ($sum >= 10) {
                        $resNode->next = new ListNode($sum-10);
                        $sum = 1;
                    } else {
                        $resNode->next = new ListNode($sum);
                        $sum = 0;
                    }
                    $resNode = $resNode->next;
                }
                return $res->next;
            }
        }
    ```

