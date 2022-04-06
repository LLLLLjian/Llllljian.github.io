---
title: Leetcode_基础 (125)
date: 2019-08-14
tags: Leetcode
toc: true
---

### k个一组翻转链表
    Leetcode学习-25

<!-- more -->

#### Q
    给出一个链表,每 k 个节点一组进行翻转,并返回翻转后的链表.

    k 是一个正整数,它的值小于或等于链表的长度.如果节点总数不是 k 的整数倍,那么将最后剩余节点保持原有顺序.

    示例 :

    给定这个链表: 1->2->3->4->5

    当 k = 2 时,应当返回: 2->1->4->3->5

    当 k = 3 时,应当返回: 3->2->1->4->5

#### A
    ```php
        class Solution {
            // 1.检测是否满足翻转条件  
            // 2.保存所需指针  
            // 3.进行翻转
            function reverseKGroup($head, $k) {
                //链表
                //建立一个虚拟头节点
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                $curNode = $dummyHead;
                while ($curNode->next) {
                    //检测是否满足翻转条件
                    $checkNode = $curNode->next;
                    for($i = 1;$i<$k;++$i){
                        if(is_null($checkNode->next)){
                            return $dummyHead->next;
                        }
                        $checkNode = $checkNode->next;
                    }
                    //保存所需节点
                    $revesedTailNode  = $checkNode->next;    //开始翻转的第一个节点=>翻转后的最后一个节点
                    $revesePreNode = $curNode;               //不需要翻转的前面部分的最后一个节点
                    $reverseNode = $curNode = $curNode->next;//开始交换的第一个节点
                    $secondNode = $curNode->next;            //开始交换的第二个节点
                    $nextNode = $secondNode->next;           //保存下一节点
                    //交换过程
                    for($i = 1;$i<$k;++$i){
                        $secondNode->next = $curNode;
                        $curNode = $secondNode;
                        $secondNode = $nextNode;
                        $nextNode = $nextNode->next;
                    }
                    $revesePreNode->next = $curNode;         //$curNode最终指向交换区间的最后一个节点=>捋顺后的第一个节点
                    $reverseNode->next = $revesedTailNode;
                    $curNode = $reverseNode;
                }
                return $dummyHead->next;
            }
        }
    ```
