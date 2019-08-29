---
title: Leetcode_基础 (136)
date: 2019-08-29
tags: Leetcode
toc: true
---

### 奇偶链表
    Leetcode学习-328

<!-- more -->

#### Q
    给定一个单链表,把所有的奇数节点和偶数节点分别排在一起.请注意,这里的奇数节点和偶数节点指的是节点编号的奇偶性,而不是节点的值的奇偶性.

    请尝试使用原地算法完成.你的算法的空间复杂度应为 O(1),时间复杂度应为 O(nodes),nodes 为节点总数.

    示例 1:

    输入: 1->2->3->4->5->NULL
    输出: 1->3->5->2->4->NULL
    示例 2:

    输入: 2->1->3->5->6->4->7->NULL 
    输出: 2->3->6->7->1->5->4->NULL
    说明:

    应当保持奇数节点和偶数节点的相对顺序.
    链表的第一个节点视为奇数节点,第二个节点视为偶数节点,以此类推.

#### A
    ```php
        class Solution {
            // 1.构建双指针,一个指向奇节点,一个指向偶节点
            // 2.遍历链表
            // 3.将奇偶节点连接起来
            function oddEvenList($head) {
                if($head == null || $head->next == null){
                    return $head;
                }
                //初始化奇偶节点
                $oddNode = $head;
                $evenFirstNode = $evenNode = $head->next; //第一个偶节点
                //遍历链表
                while ($oddNode->next != null && $evenNode->next != null) {
                    $oddNode->next = $evenNode->next;  //偶节点的下一节点是奇节点
                    $oddNode = $oddNode->next;         //取新的奇节点
                    $evenNode->next = $oddNode->next;  //新的奇节点的下一节点是新的偶节点
                    $evenNode = $evenNode->next;       //取新的偶节点
                }
                //连接奇偶节点
                $oddNode->next = $evenFirstNode;
                return $head;
            }
        }
    ```
