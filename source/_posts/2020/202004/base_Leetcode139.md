---
title: Leetcode_基础 (139)
date: 2020-04-21
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### Q
    已知链表头节点指针head,将链表从位置m到n逆序
    1->2->3->4->5->null m=2 n=4
    1->4->3->2->5->null

#### A
    ```php
        function reverseBetween($head, $m, $n)
        {
            // 关键节点1 逆置段头节点
            // 关键节点2 逆置前头节点=逆置后尾节点
            // 关键节点3 逆置前尾节点=逆置后头节点
            // 关键节点4 逆置段尾节点
            
            // 1. 先计算出要逆置的节点的个数
            $revLen = $n - $m + 1;
            $prev = null;
            $res = $head;
            // 2. 将链表第一个改为节点2
            while (!empty($head) && ($m>1)) {
                $prev = $head;
                $head = $head->next;
                $m-=1;
            }
            $node2 = $head;

            // 3.开始逆置
            $newHead = null;
            while (!empty($head) && ($revLen > 0)) {
                $next = $head->next;
                $head->next = $newHead;
                $newHead = $head;
                $head = $next;
                $revLen -= 1;
            }

            $node2->next = $head;
            // 4. 如果prev不为空, 说明不是从第一个节点开始的
            if (!empty($prev)) {
                $prev->next = $newHead;
            } else {
                $res = $newHead;
            }
            return $res;
        }
    ```
