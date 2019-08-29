---
title: Leetcode_基础 (127)
date: 2019-08-16
tags: Leetcode
toc: true
---

### 删除排序链表中的重复元素 II
    Leetcode学习-82

<!-- more -->

#### Q
    给定一个排序链表,删除所有含有重复数字的节点,只保留原始链表中 没有重复出现 的数字.

    示例 1:

    输入: 1->2->3->3->4->4->5
    输出: 1->2->5
    示例 2:

    输入: 1->1->1->2->3
    输出: 2->3

#### A
    ```php
        class Solution {
            // 1.构建虚拟头节点、遍历一遍链表    
            // 2.当无重复时,正常遍历  
            // 3.当找到重复元素时,二层遍历,直到找到不重复的元素,$curNode->next指向该元素
            function deleteDuplicates($head) {
                //建立一个虚拟头节点
                $dummyHead = new ListNode(null);
                $dummyHead->next = $head;
                $curNode = $dummyHead;
                while ($curNode->next) {
                    $val = $curNode->next->val;
                    $end = $curNode->next;
                    //判断是否有重复元素
                    if($end->next && $end->next->val == $val){
                        //有则二层遍历,直到找到不是该值的节点
                        while ($end->next && $end->next->val == $val) {
                            $end = $end->next;
                        }
                        $curNode->next = $end->next;
                    }else{
                        $curNode = $curNode->next;
                    }
                }
                return $dummyHead->next;
            }
        }
    ```
