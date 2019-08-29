---
title: Leetcode_基础 (132)
date: 2019-08-23
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

#### A
    ```php
        class Solution {
            // 1.快慢指针找出中间节点,快指针每次走两个,慢指针走一格
            // 2.翻转后边部分
            // 3.一一比较,得出结果
            function isPalindrome($head) {
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                //快满指针取中间位置
                $centerNode = $doubleNode = $dummyHead;
                while($doubleNode->next){
                    $centerNode = $centerNode->next;
                    $doubleNode = $doubleNode->next->next;
                }
                //翻转后边部分
                $preNode = null;                //前节点
                $curNode = $centerNode->next;   //后部分的第一个节点
                while ($curNode) {
                    $nextNode = $curNode->next;
                    $curNode->next = $preNode;
                    $preNode = $curNode;
                    $curNode = $nextNode;
                }
                //一一比较
                $curNode = $dummyHead->next;
                //遍历结束,$preNode指向反转后,后面部分的第一个节点
                while ($curNode && $preNode) {
                    if($curNode->val != $preNode->val){
                        return false;
                    }
                    $curNode = $curNode->next;
                    $preNode = $preNode->next;
                }
                return true;
            }
        }
    ```
