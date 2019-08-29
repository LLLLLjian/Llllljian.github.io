---
title: Leetcode_基础 (131)
date: 2019-08-22
tags: Leetcode
toc: true
---

### 分隔链表
    Leetcode学习-86

<!-- more -->

#### Q
    给定一个链表和一个特定值 x,对链表进行分隔,使得所有小于 x 的节点都在大于或等于 x 的节点之前.

    你应当保留两个分区中每个节点的初始相对位置.

    示例:

    输入: head = 1->4->3->2->5->2, x = 3
    输出: 1->2->2->4->3->5

#### A
    ```php
        class Solution {
            // 1.构建大小指针
            // 2.遍历链表
            // 3.连接大小指针
            function partition($head, $x) {
                $curNode = $head;
                $smallNode = $bigNode = $bigFirstNode = null;     //构建大小指针
                while ($curNode) {
                    //属于小的一侧
                    if($curNode->val < $x){       
                        if(is_null($smallNode)){        //初始化小节点
                            $smallNode = $curNode;     
                            $head = $smallNode;        
                        }else{
                            $smallNode->next = $curNode;//找到下一个小的节点
                            $smallNode = $curNode;
                        }
                    }else{    
                    //属于大的一侧        
                        if(is_null($bigNode)){          //初始化大节点
                            $bigNode = $curNode;
                            $bigFirstNode = $bigNode;   //大的一侧的第一个节点
                        }else{
                            $bigNode->next = $curNode;  //找到下一个小的节点
                            $bigNode = $curNode;
                        }
                    }
                    $curNode = $curNode->next;
                }
                $smallNode->next = $bigFirstNode;       //大小侧的连接
                $bigNode->next = null;                  //封闭尾节点
                return $head;
            }
        }
    ```
