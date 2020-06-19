---
title: Interview_总结 (65)
date: 2020-02-21
tags: Interview
toc: true
---

### 笔试总结
    链表反转, 之前一直以为自己已经掌握这道题了, 最近面试才发现自己掌握的还是有问题, 记录改正一下

<!-- more -->

#### 链表反转
- Q
> 1 -> 2 -> 3 -> 4 -> 5 ->null 变成 5->4->3->2->1->NULL
- A
    ```php
        class Solution
        {
            /**
             * 迭代解法
             * 
             * @param ListNode $head
             * @return ListNode
             */
            function reverseList($head)
            {
                // double pointer
                // 我们可以申请两个指针, 第一个指针叫 prev, 最初是指向 null 的.
                // 第二个指针 cur 指向 head, 然后不断遍历 cur.
                // 每次迭代到 cur, 都将 cur 的 next 指向 pre, 然后 pre 和 cur 前进一位.
                // 都迭代完了 (cur 变成 null 了), pre 就是最后一个节点了.
                $prev = null;
                $cur = $head;
                while ($cur) {
                    $next = $cur->next;
                    $cur->next = $prev;
                    $prev = $cur;
                    $cur = $next;
                }

                return $prev;
            }

            /**
             * 递归解法
             * 
             * @param ListNode $head
             * @return ListNode
             */
            // 明确递归函数的含义：传入一个链表(或片段), 将其反转, 并返回链表头元素
            // 所以, 完全反转以后, 原来的最后一个元素就变为了链表头元素
            function reverseList($head) {
                if ($head === null || $head->next === null) return $head;
                $last = $this->reverseList($head->next);
                $head->next->next = $head;
                $head->next = null;
                return $last;
            }
        }
    ```





