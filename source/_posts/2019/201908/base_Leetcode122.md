---
title: Leetcode_基础 (122)
date: 2019-08-09
tags: Leetcode
toc: true
---

### 反转链表 
    Leetcode学习-206

<!-- more -->

#### Q
    反转一个单链表.

    示例:
    输入: 1->2->3->4->5->NULL
    输出: 5->4->3->2->1->NULL

#### A
    ```php
        class Solution {
            // 初始化时,$preNode指向空指针,$curNode指向$head,$nextNode保存下一节点
            // 改变当前指针$curNode的下一节点,指向前一节点$preNode
            // 第2步循环,直到链表遍历完毕
            function reverseList($head) {
                $preNode = null; //前一节点
                $curNode = $head;//当前节点
                while ($curNode) {
                    $next = $curNode->next;//保存下一节点
                    $curNode->next = $preNode;
                    $preNode = $curNode;
                    $curNode = $next;
                }
                return $preNode;
            }
        }
    ```
