---
title: Leetcode_基础 (138)
date: 2020-04-20
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### Q
    链表反转

#### A
    ```php
        function reverseList($head)
        {
            // 我们可以申请两个指针, 第一个指针叫 prev, 最初是指向 null 的.
            // 第二个指针 cur 指向 head, 然后不断遍历 cur.
            // 每次迭代到 cur, 都将 cur 的 next 指向 pre, 然后 pre 和 cur 前进一位.
            // 都迭代完了 (cur 变成 null 了), pre 就是最后一个节点了.
            $prev = null;
            $cur = $head;
            while (!empty($cur)) {
                $next = $cur->next;
                $cur->next = $prev;
                $prev = $cur;
                $cur = $next;
            }

            return $prev;
        }
    ```
