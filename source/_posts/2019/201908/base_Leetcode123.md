---
title: Leetcode_基础 (123)
date: 2019-08-12
tags: Leetcode
toc: true
---

### 反转链表 II
    Leetcode学习-92

<!-- more -->

#### Q
    反转从位置 m 到 n 的链表.请使用一趟扫描完成反转.

    说明:  1 ≤ m ≤ n ≤ 链表长度.

    示例:

    输入: 1->2->3->4->5->NULL, m = 2, n = 4
    输出: 1->4->3->2->5->NULL

#### A
    ```php
        class Solution {
            function reverseBetween($head, $m, $n) {
                if($m == $n) return $head;
                //建立一个虚拟头节点
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                $curNode = $dummyHead;
                //找到前一节点
                for($i = 0;$i<$m-1;++$i){
                    $curNode = $curNode->next;
                }
                $revesePreNode = $curNode;        //不需要翻转的前面部分的最后一个节点
                $revesedTailNode = $curNode->next;//开始翻转的第一个节点=>翻转后的最后一个节点
                //开始交换
                $preNode = null;
                $curNode = $curNode->next;   
                //交换过程
                for($i = $i+1;$i<=$n;++$i){
                    $nextNode = $curNode->next;
                    $curNode->next = $preNode;
                    $preNode = $curNode;
                    $curNode = $nextNode;
                }
                $revesePreNode->next = $preNode;
                $revesedTailNode->next = $curNode;
                return $dummyHead->next;
            }
        }
    ```
