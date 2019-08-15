---
title: Leetcode_基础 (124)
date: 2019-08-13
tags: Leetcode
toc: true
---

### 反转链表 II
    Leetcode学习-24

<!-- more -->

#### Q
    给定一个链表,两两交换其中相邻的节点,并返回交换后的链表.

    示例:

    给定 1->2->3->4, 你应该返回 2->1->4->3

#### A
    ```php
        class Solution {
            // 1.初始化,构建一个虚拟头节点,$node1指向第一个要交换的节点,$node2指向第二个要交换的节点,$curNode要进行交换部分的前一节点
            // 2.改变$node1的下一节点为$node2的下一节点,$node2指向第一个要交换的节点$node1,$curNode的下一节点指向$node2,因为$node2调换到了前面
            // 3.$curNode继续指向下一次交换的前一节点,即$node1位置,根据$curNode继续循环,直到链表遍历完毕
            function swapPairs($head) {
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                $curNode = $dummyHead;
                while ($curNode->next && $curNode->next->next) {
                    $node1 = $curNode->next;    //第 1 个要交换的节点
                    $node2 = $node1->next;      //第 2 个要交换的节点
                    $node1->next = $node2->next;//1.先指向下一节点,否则后面会改变
                    $node2->next = $node1;      //2.node2指向node1
                    $curNode->next = $node2;    //3.前一节点,指向node2
                    $curNode = $node1;          //4.curNode指向下一次交换的前一节点
                }
                return $dummyHead->next;
            }
        }
    ```
