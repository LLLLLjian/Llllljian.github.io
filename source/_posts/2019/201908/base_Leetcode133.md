---
title: Leetcode_基础 (133)
date: 2019-08-26
tags: Leetcode
toc: true
---

### 重排链表
    Leetcode学习-143

<!-- more -->

#### Q
    给定一个单链表 L：L0→L1→…→Ln-1→Ln ,
    将其重新排列后变为： L0→Ln→L1→Ln-1→L2→Ln-2→…

    你不能只是单纯的改变节点内部的值,而是需要实际的进行节点交换.

    示例 1:    给定链表 1->2->3->4, 重新排列为 1->4->2->3.

    示例 2:    给定链表 1->2->3->4->5, 重新排列为 1->5->2->4->3.

#### A
    ```php
        class Solution {
            // 1.快慢指针找出中间节点,快指针每次走两个,慢指针走一格
            // 2.翻转后边部分,区分出两条单链表
            // 3.一一链接,得出结果
            function reorderList($head) {
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                //快慢指针取中间位置
                $centerNode = $doubleNode = $dummyHead;
                while($doubleNode->next){
                    $centerNode = $centerNode->next;
                    $doubleNode = $doubleNode->next->next;
                }
                //翻转后边部分
                $preNode = null;
                $curNode = $centerNode->next;
                while ($curNode) {
                    $nextNode = $curNode->next;
                    $curNode->next = $preNode;
                    $preNode = $curNode;
                    $curNode = $nextNode;
                }
                /**
                * 将前部分的链表封尾,就完成构建两条链表
                * head -> 1 -> 2 -> 3 -> end 
                * head-> 5 -> 4 -> end
                */
                $centerNode->next = null;
                //两两合并,初始化两个链表的头节点
                $curNode = $dummyHead->next;
                $revNode = $preNode;
                while ($revNode) {
                    //存下一节点
                    $curNextNode = $curNode->next;
                    $revNextNode = $revNode->next;
        
                    //交换节点
                    $curNode->next = $revNode;
                    $revNode->next = $curNextNode;
        
                    //重新定义节点
                    $curNode = $curNextNode;
                    $revNode = $revNextNode;
                }
                return $dummyHead->next;
            }
        }
    ```
