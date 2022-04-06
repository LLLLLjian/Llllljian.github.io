---
title: Interview_总结 (75)
date: 2020-03-16
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-栈实现队列

<!-- more -->

#### Q
    使用栈实现队列的下列操作: 

    push(x) -- 将一个元素放入队列的尾部.
    pop() -- 从队列首部移除元素.
    peek() -- 返回队列首部的元素.
    empty() -- 返回队列是否为空.
    示例:

    MyQueue queue = new MyQueue();

    queue.push(1);
    queue.push(2);  
    queue.peek();  // 返回 1
    queue.pop();   // 返回 1
    queue.empty(); // 返回 false
    说明:

    你只能使用标准的栈操作 -- 也就是只有 push to top, peek/pop from top, size, 和 is empty 操作是合法的.
    你所使用的语言也许不支持栈.你可以使用 list 或者 deque(双端队列)来模拟一个栈,只要是标准的栈操作即可.
    假设所有操作都是有效的 (例如,一个空的队列不会调用 pop 或者 peek 操作).

> 这次不能直接背答案了 要记录一下思考的过程
利用两个栈来实现队列,第一个栈利用push()方法存放所有数据；
当实现pop() 方法是将一个栈中的元素(利用栈后进先出的特点)弹入第二个栈中,此时pop()方法直接返回第二个栈中的元素；执行完毕后将第二个栈的元素全部推入第一个栈中
查看栈中的第一个元素直接查看第一个栈中的第一个元素
确认栈是否为空直接查看第一个栈的长度是否为空

#### A
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









