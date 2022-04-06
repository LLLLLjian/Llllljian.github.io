---
title: DataStructure_基础 (18)
date: 2019-12-10
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之栈

<!-- more -->

#### 栈
    栈是一种线性数据结构, 栈中的元素只能先进后出, 最早进入的元素存放的位置叫做栈底, 最后进入的元素存放的位置叫做栈顶
- 入栈
    * push
    * 将新元素放入栈中, 新元素的位置将成为新的栈顶
- 出栈
    * pop
    * 将栈顶元素弹出, 出栈元素的前一个元素将会称为新的栈顶
- 使用队列来实现堆栈的下列操作
    * push(x) -- 元素 x 入栈; pop() -- 移除栈顶元素; top() -- 获取栈顶元素; empty() -- 返回栈是否为空
    ```php
        class MyStack {
            public $query1;
            public $query2;

            /**
            * Initialize your data structure here.
            */
            function __construct() {
                $this->query1 = array();
                $this->query2 = array();
            }
        
            /**
            * Push element x onto stack.
            * @param Integer $x
            * @return NULL
            */
            function push($x) {
                if (empty($this->query1) && empty($this->query2)) {
                    array_push($this->query1, $x);
                    return;
                }
                
                if (empty($this->query1)) {
                    array_push($this->query1, $x);
                    
                    while (!empty($this->query2)) {
                        array_unshift($this->query1, array_pop($this->query2));
                    }
                } else {
                    array_push($this->query2, $x);
                    
                    while (!empty($this->query1)) {
                        array_unshift($this->query2, array_pop($this->query1));
                    }
                }
            }
        
            /**
            * Removes the element on top of the stack and returns that element.
            * @return Integer
            */
            function pop() {
                if (empty($this->query1)) {
                    return array_pop($this->query2);
                } else {
                    return array_pop($this->query1);
                }
            }
        
            /**
            * Get the top element.
            * @return Integer
            */
            function top() {
                if (empty($this->query1)) {
                    return reset($this->query2);
                } else {
                    return reset($this->query1);
                }
            }
        
            /**
            * Returns whether the stack is empty.
            * @return Boolean
            */
            function emptyForQ() {
                if (empty($this->query1) && empty($this->query2)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```


