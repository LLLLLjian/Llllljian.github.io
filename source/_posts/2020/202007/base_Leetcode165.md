---
title: Leetcode_基础 (165)
date: 2020-07-15
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温栈队列

<!-- more -->

#### 用队列实现栈
- 问题描述
    * 用队列实现栈
- 解题思路
    * 两个队列实现
    * 入栈的时候就入队列1, 入栈顺序为12345, 队列中存放的顺序也是12345
    * 出栈的时候就从头弹出队列1, 弹到最后一个停止, 最后一个就是栈顶元素, 然后交换两个队列
    * 栈顶 获取队列的最后一个即可
    * 判断是否为空 判断队列1就可以
    ```php
        class MyStack {
            private $queue1;
            private $queue2;
            /**
            * Initialize your data structure here.
            */
            function __construct() {
                $this->queue1 = $this->queue2 = array();
            }

            /**
            * Push element x onto stack.
            * @param Integer $x
            * @return NULL
            */
            function push($x) 
            {
                array_push($this->queue1, $x);
            }

            /**
            * Removes the element on top of the stack and returns that element.
            * @return Integer
            */
            function pop() 
            {
                while (count($this->queue1) > 1) {
                    array_push($this->queue2, array_shift($this->queue1));
                }
                $res = array_shift($this->queue1);

                $this->queue1 = $this->queue2;
                $this->queue2 = array();
                return $res;
            }

            /**
            * Get the top element.
            * @return Integerå
            */
            function top() 
            {
                return end($this->queue1);
            }

            /**
            * Returns whether the stack is empty.
            * @return Boolean
            */
            function empty() {
                if (empty($this->queue1)) {
                    return true;
                } else {
                    return false;
                }
            }
        }

        /**
        * Your MyStack object will be instantiated and called as such:
        * $obj = MyStack();
        * $obj->push($x);
        * $ret_2 = $obj->pop();
        * $ret_3 = $obj->top();
        * $ret_4 = $obj->empty();
        */
    ```

#### 用栈实现队列
- 问题描述
    * 用栈实现队列
- 解题思路
    * 用两个栈实现
    * 入队时, push到instack中
    * 出队时, 若outstack为空, 将instack所有元素c弹出, push到outstack, outstack弹出栈顶元素, 若outstack不为空, outstack弹出栈顶元素
    ```php
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

