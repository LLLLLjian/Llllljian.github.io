---
title: Leetcode_基础 (134)
date: 2019-08-27
tags: Leetcode
toc: true
---

### 旋转链表
    Leetcode学习-61

<!-- more -->

#### Q
    给定一个链表,旋转链表,将链表每个节点向右移动 k 个位置,其中 k 是非负数.

    示例 1:

    输入: 1->2->3->4->5->NULL, k = 2
    输出: 4->5->1->2->3->NULL
    解释:
    向右旋转 1 步: 5->1->2->3->4->NULL
    向右旋转 2 步: 4->5->1->2->3->NULL
    示例 2:

    输入: 0->1->2->NULL, k = 4
    输出:2->0->1->NULL
    解释:
    向右旋转 1 步: 2->0->1->NULL
    向右旋转 2 步: 1->2->0->NULL
    向右旋转 3 步: 0->1->2->NULL
    向右旋转 4 步: 2->0->1->NULL

#### A
    ```php
        class Solution {
            // 1.头尾链接并计算出链表长度$len
            // 2.计算移动长度,$len = $len - ($k%$len) ,因为旋转次数=链表长度时,链表不变
            // 3.旋转链表
            function rotateRight($head, $k) {
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                //1.头尾链接并计算出链表长度
                $curNode = $head;
                $len = 1;
                while ($curNode->next) {        //计算链表长度
                    $curNode = $curNode->next;
                    $len++;
                }
                $curNode->next = $head;         //循环后curNode指向尾节点,进行头尾链接
                //2.计算移动长度
                $len = $len - ($k%$len);
                //3.旋转链表
                $tailNode = $curNode;           //指向尾节点,也是旋转链表完成后的最后一个节点
                $curNode = $head;               //指向当前的头节点,也是旋转链表完成后的第一个节点
                for($i = 0;$i<$len;++$i){
                    $curNode = $curNode->next;
                    $tailNode = $tailNode->next;
                }
                $tailNode->next = null;        //对尾指针进行封尾
                return $curNode;               //返回头节点进行遍历即可
            }
        }
    ```
