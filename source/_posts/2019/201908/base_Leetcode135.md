---
title: Leetcode_基础 (135)
date: 2019-08-28
tags: Leetcode
toc: true
---

### 两数相加 II
    Leetcode学习-445

<!-- more -->

#### Q
    给定两个非空链表来代表两个非负整数.数字最高位位于链表开始位置.它们的每个节点只存储单个数字.将这两数相加会返回一个新的链表.

    你可以假设除了数字 0 之外,这两个数字都不会以零开头.

    进阶:

    如果输入链表不能修改该如何处理？换句话说,你不能对列表中的节点进行翻转.

    示例:

    输入: (7 -> 2 -> 4 -> 3) + (5 -> 6 -> 4)
    输出: 7 -> 8 -> 0 -> 7

#### A
    ```php
        class Solution {
            // 1.遍历两个链表,将链表的值存储在辅助数据结构栈中
            // 2.进行类似大数相加的加法过程
            function addTwoNumbers($l1, $l2) {
                //借助栈的数据结构
                $num1 = $num2 = [];
                //压栈过程
                while ($l1) {
                    array_unshift($num1, $l1->val);
                    $l1 = $l1->next;
                }
                while ($l2) {
                    array_unshift($num2, $l2->val);
                    $l2 = $l2->next;
                }
                $flag = 0;  //进位标识符
                $len = max(count($num1),count($num2));
                //初始化结果链表头节点,出栈加法过程
                $preNode = null;
                for($i = 0;$i<$len;++$i){
                    $add1 = $num1[$i] ? $num1[$i]:0;
                    $add2 = $num2[$i] ? $num2[$i]:0;
                    $sum = $add1 + $add2 + $flag;
                    if($sum>=10){
                        $flag = 1;
                        $sum -= 10;
                    }else{
                        $flag = 0;
                    }
                    //从后往前的链表构建过程
                    $curNode = new ListNode($sum);
                    $curNode->next = $preNode;
                    $preNode = $curNode;
                }
                if($flag == 1){
                    $curNode = new ListNode(1);
                    $curNode->next = $preNode;
                }
                return $curNode;
            }
        }
    ```
