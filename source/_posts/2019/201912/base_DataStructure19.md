---
title: DataStructure_基础 (19)
date: 2019-12-11
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之队列

<!-- more -->

#### 队列
    队列是一种线性数据结构 他的特性和行驶车辆的单行隧道类似 队列中的元素只能先入先出, 队列的出口端叫对头 入口端叫队尾
- 入队
    * 把新元素放入队列中, 只允许在队尾的位置放入元素, 新元素会成为新的队尾
- 出队
    * 把元素移出队列, 只允许在队头一侧移出元素, 出队元素的后一个元素会成为新的对头
- 用栈实现队列
    * 使用栈实现队列的下列操作: push(x) -- 将一个元素放入队列的尾部; pop() -- 从队列首部移除元素; peek() -- 返回队列首部的元素; empty() -- 返回队列是否为空.
    ```php
        // 栈 FILO
        // 队列 FIFO
        class MyQueue {
            public $in;
            public $out;
            /**
            * Initialize your data structure here.
            */
            function __construct() {
                $this->in = array();
                $this->out = array();
            }
        
            /**
            * Push element x to the back of queue.
            * @param Integer $x
            * @return NULL
            */
            function push($x) {
                array_unshift($this->in, $x);
                return;
            }
        
            /**
            * Removes the element from in front of queue and returns that element.
            * @return Integer
            */
            function pop() {
                if (!empty($this->out)) {
                    // 出队栈不为空时,直接从出队栈中移除栈顶元素
                    return array_shift($this->out);
                } else {
                    // 出队栈为空时,从入队栈中依次将元素放入出队栈
                    while (!empty($this->in)) {
                        array_unshift($this->out, array_shift($this->in));
                    }
                    // 放完后,从出队栈依次将栈顶元素弹出
                    return array_shift($this->out);
                }
            }
        
            /**
            * Get the front element.
            * @return Integer
            */
            function peek() {
                if (!empty($this->out)) {
                    // 出队栈不为空时,直接从出队栈中得到栈顶元素
                    return reset($this->out);
                } else {
                    // 出队栈为空时,从入队栈中依次将栈顶元素放入出队栈
                    while (!empty($this->in)) {
                        array_unshift($this->out, array_shift($this->in));
                    }
                    // 放完后,从出队栈得到栈顶元素
                    return reset($this->out);
                }
            }
        
            /**
            * Returns whether the queue is empty.
            * @return Boolean
            */
            function empty() {
                return empty($this->in) && empty($this->out);
            }
        }
    ```
