---
title: Leetcode_基础 (151)
date: 2020-05-15
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 移除重复节点
    编写代码,移除未排序链表中的重复节点.保留最开始出现的节点.
    示例1:
    输入: [1, 2, 3, 3, 2, 1]
    输出: [1, 2, 3]
    示例2:
    输入: [1, 1, 1, 1, 2]
    输出: [1, 2]
    提示: 
    链表长度在[0, 20000]范围内.
    链表元素在[0, 20000]范围内.
    进阶: 
    如果不得使用临时缓冲区,该怎么解决？
- A
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val) { $this->val = $val; }
         * }
         */
        class Solution 
        {
            /**
             * @param ListNode $head
             * @return ListNode
             */
            function removeDuplicateNodes($head) 
            {  
                $cur = $head;
                $arr = array();
            
                while(($cur != null) && ($cur->next != null)) {
                    $arr[$cur->val] = 1;
                    if(isset($arr[$cur->next->val])) {
                        $cur->next = $cur->next->next;  
                    } else {
                        $cur = $cur->next;
                    }
                }
                return $head;
            }

            function removeDuplicateNodes1($head) 
            {
                $cur = $head;
      
                while ($cur != null) {
                    $temp = $cur;
                    while ($temp->next != null) {
                        if ($temp->next->val == $cur->val) { 
                            $temp->next = $temp->next->next;
                        } else{
                            $temp = $temp->next;
                        }
                    }
                    $cur = $cur->next;
                }

                return $head;
            }
        }
    ```

