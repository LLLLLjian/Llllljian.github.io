---
title: Leetcode_基础 (32)
date: 2019-03-26
tags: Leetcode
toc: true
---

### 最小栈
    Leetcode学习-155

<!-- more -->

#### Q
    设计一个支持 push,pop,top 操作,并能在常数时间内检索到最小元素的栈.

    push(x) -- 将元素 x 推入栈中.
    pop() -- 删除栈顶的元素.
    top() -- 获取栈顶元素.
    getMin() -- 检索栈中的最小元素.
    示例:

    MinStack minStack = new MinStack();
    minStack.push(-2);
    minStack.push(0);
    minStack.push(-3);
    minStack.getMin();   --> 返回 -3.
    minStack.pop();
    minStack.top();      --> 返回 0.
    minStack.getMin();   --> 返回 -2.

#### A
    ```php
       class MinStack {
            /**
             * initialize your data structure here.
             */
            function __construct() {
                $this->list = [];
                $this->min = NULL;
            }
            
            private function calcMin() {
                $this->min = min($this->list);
            }
        
            /**
             * @param Integer $x
             * @return NULL
             */
            function push($x) {
                $this->list[] = $x;
                $this->calcMin();
                return NULL;
            }
        
            /**
             * @return NULL
             */
            function pop() {
                array_pop($this->list);
                $this->calcMin();
                return NULL;
            }
        
            /**
             * @return Integer
             */
            function top() {
                return end($this->list);
            }
        
            /**
             * @return Integer
             */
            function getMin() {
                return $this->min;
            }
        }

        /**
         * Your MinStack object will be instantiated and called as such:
         * $obj = MinStack();
         * $obj->push($x);
         * $obj->pop();
         * $ret_3 = $obj->top();
         * $ret_4 = $obj->getMin();
         */
    ```
