---
title: Leetcode_基础 (155)
date: 2020-06-15
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温链表

<!-- more -->

#### 输出单链表倒数第K个节点
- 问题描述
    * 题目：输入一个单链表, 输出此链表中的倒数第 K 个节点.(去除头结点, 节点计数从 1 开始)
- 解题思想
    * 双指针, 一快一慢, 快的先走k步, 然后快和慢一起走, 快和慢之间的差距一直是k, 当快走到终点的时候, 慢就是倒数第k个节点
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
             * @param Integer $k
             * @return ListNode
             */
            function getKthFromEnd($head, $k) 
            {
                $fast = $slow = $head;

                while ($k > 0) {
                    $k -= 1;
                    $fast = $fast->next;
                }

                while (!empty($fast)) {
                    $fast = $fast->next;
                    $slow = $slow->next;
                }

                return $slow;
            }
        }
    ```

#### 判断链表是否有环
- 问题描述
    * 判断链表是否有环
- 解题思想
    * 龟兔赛跑, 快慢指针, 快指针每次走两步,  慢指针每次走一步,  如果有环, 他们一定会相遇
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
            function hasCycle($head) 
            {
                $fast = $slow = $head;

                while (!empty($fast)) {
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                    if ($fast->val == $slow->val) {
                        return true;
                    }
                }
                return false;
            }
        }
    ```

#### 定位环入口
- 问题描述
    * 已经有环了,  那你能不能找到环入口
- 解题思路
    * ![环状链表示意图](/img/20200615_1.png)
    * 起始点为A 入环点为B 相遇位置为C 环长为R
    * 慢指针走的路程为 AB + BC
    * 快指针走的路程是 AB + BC + nR
    * 快指针的路程是慢指针路程的二倍且R = (BC + CB)
    * 综上可得 AB = CB
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
            function hasCycle($head) 
            {
                $fast = $slow = $head;

                while (!empty($fast)) {
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                    if ($fast->val == $slow->val) {
                        break;
                    }
                }
                while ($slow != $cur) {
                    $slow = $slow->next;
                    $cur = $cur->next;
                }
                return $cur;
            }
        }
    ```

#### 求环长
- 问题描述
    * 入环口都知道了 你还能不知道环长?
- 解题思路
    * 当快慢指针首次相遇之后, 他们第二次相遇时,  慢指针所走的距离就是环长
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
            function hasCycle($head) 
            {
                $fast = $slow = $head;

                while (!empty($fast)) {
                    $fast = $fast->next->next;
                    $slow = $slow->next;
                    if ($fast->val == $slow->val) {
                        break;
                    }
                }
                
                $slow = $slow->next;
                $fast = $fast->next->next;
                $len = 1;
                while ($fast != $slow) {
                    $slow = $slow->next;
                    $fast = $fast->next->next;
                    $len++;
                }
                return $len;
            }
        }
    ```

#### 求链表长度
- 问题描述
    * 求有环单链表的链表长
- 解题思路
    * 起点到环入口的距离+环长





