---
title: DataStructure_基础 (12)
date: 2019-10-14
tags: DataStructure
toc: true
---

### 算法--队列
    算法--队列

<!-- more -->

#### 队列
- 是什么
    * 队列（queue）是一种先进先出的、操作受限的线性表
    * 必须从队尾插入新元素,队列中的元素只能从队首出
- 顺序队列
    * 用数组实现的队列
- 链式队列
    * 用链表实现的队列
- 循环队列
    * 和顺序队列类似, 都是用数组实现, 但它能更有效率的利用数组空间,且不需要移动数据.
    * 判断队列为空的条件是：head==tail
    * 判断队满的公式应该是：(tail+1)%n=head
- 优先队列

#### demo1
- Q
    * 使用栈实现队列的下列操作：push(x) -- 将一个元素放入队列的尾部; pop() -- 从队列首部移除元素; peek() -- 返回队列首部的元素; empty() -- 返回队列是否为空.
- A
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

#### demo2
- Q
    * 使用队列来实现堆栈的下列操作：push(x) -- 元素 x 入栈; pop() -- 移除栈顶元素; top() -- 获取栈顶元素; empty() -- 返回栈是否为空
- A
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
