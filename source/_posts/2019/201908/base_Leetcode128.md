---
title: Leetcode_基础 (128)
date: 2019-08-19
tags: Leetcode
toc: true
---

### 删除链表的倒数第N个节点
    Leetcode学习-19

<!-- more -->

#### Q
    给定一个链表,删除链表的倒数第 n 个节点,并且返回链表的头结点.

    示例: 

    给定一个链表: 1->2->3->4->5, 和 n = 2.
    
    当删除了倒数第二个节点后,链表变为 1->2->3->5.
    说明: 给定的 n 保证是有效的.

#### A
    ```php
        class Solution {
            // 1.利用双指针的思想$curNode当前节点和$preNode前节点
            // 2.双指针的差距保持在$n的距离
            // 3.只遍历一遍链表,直到$curNode为空,跨越delNode节点,即删除节点
            function removeNthFromEnd($head, $n) {
                //双指针
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                $curNode = $preNode = $dummyHead;
                $count = 0;
                while($curNode->next){
                    $curNode = $curNode->next;
                    //移动双指针,直到指针距离 为 $n
                    if($count<$n){
                        $count++;
                    }else{
                        $preNode = $preNode->next;
                    }
                }
                $delNode = $preNode->next;          //遍历完后,$preNode指向待删除元素的前一元素
                $preNode->next = $delNode->next;    //跨越该元素即可删除待删除元素
                return $dummyHead->next;
            }
        }
    ```
