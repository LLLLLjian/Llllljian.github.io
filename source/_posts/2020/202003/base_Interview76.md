---
title: Interview_总结 (76)
date: 2020-03-17
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-队列实现栈

<!-- more -->

#### Q
    使用队列实现栈的下列操作：

    push(x) -- 元素 x 入栈
    pop() -- 移除栈顶元素
    top() -- 获取栈顶元素
    empty() -- 返回栈是否为空
    注意:

    你只能使用队列的基本操作-- 也就是 push to back, peek/pop from front, size, 和 is empty 这些操作是合法的.
    你所使用的语言也许不支持队列. 你可以使用 list 或者 deque(双端队列)来模拟一个队列 , 只要是标准的队列操作即可.
    你可以假设所有操作都是有效的(例如, 对一个空的栈不会调用 pop 或者 top 操作)

> 还是先列一下解题思路
A1 : 两个队列,压入 -O(1), 弹出 -O(n)
A2 : 两个队列,压入 - O(n), 弹出 - O(1)
A3 : 一个队列, 压入 - O(n), 弹出 - O(1)zz

#### A1
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
                array_push($this->query1, $x);
            }

            /**
             * Removes the element on top of the stack and returns that element.
             * @return Integer
             */
            function pop() {
                while (count($this->query1) > 1) {
                    array_push($this->query2, array_shift($this->query1));
                }
                $temp = $this->query1;
                $this->query1 = $this->query2;
                $this->query2 = array();
                return array_shift($temp);
            }

            /**
             * Get the top element.
             * @return Integer
             */
            function top() {
                return end($this->query1);
            }

            /**
             * Returns whether the stack is empty.
             * @return Boolean
             */
            function empty() {
                if (empty($this->query1)) {
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

#### A2
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
                // 让每一个新元素从 q2 入队,同时把这个元素作为栈顶元素保存
                array_push($this->query2, $x);

                // 当 q1 非空（也就是栈非空）,我们让 q1 中所有的元素全部出队,再将出队的元素从 q2 入队
                while (!empty($this->query1)) {
                    array_push($this->query2, array_shift($this->query1));
                }
                // 我们通过将 q1, q2 互相交换的方式来避免把 q2 中的元素往 q1 中拷贝
                $this->query1 = $this->query2;
                $this->query2 = array();
            }

            /**
             * Removes the element on top of the stack and returns that element.
             * @return Integer
             */
            function pop() {
                return array_shift($this->query1);
            }

            /**
             * Get the top element.
             * @return Integer
             */
            function top() {
                return reset($this->query1);
            }

            /**
             * Returns whether the stack is empty.
             * @return Boolean
             */
            function empty() {
                if (empty($this->query1)) {
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

#### A3
    ```php
        class MyStack {
            public $query;
            /**
             * Initialize your data structure here.
             */
            function __construct() {
                $this->query = array();
            }

            /**
             * Push element x onto stack.
             * @param Integer $x
             * @return NULL
             */
            function push($x) {
                // 每当入队一个新元素的时候,我们可以把队列的顺序反转过来
                array_push($this->query, $x);
                $count = count($this->query);
                while ($count > 1) {
                    $temp = array_shift($this->query);
                    array_push($this->query, $temp);
                    $count--;
                }
            }

            /**
             * Removes the element on top of the stack and returns that element.
             * @return Integer
             */
            function pop() {
                return array_shift($this->query);
            }

            /**
             * Get the top element.
             * @return Integer
             */
            function top() {
                return reset($this->query);
            }

            /**
             * Returns whether the stack is empty.
             * @return Boolean
             */
            function empty() {
                if (empty($this->query)) {
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



