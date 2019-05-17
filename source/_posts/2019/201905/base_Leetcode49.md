---
title: Leetcode_基础 (49)
date: 2019-05-06
tags: Leetcode
toc: true
---

### 翻转二叉树
    Leetcode学习-226

<!-- more -->

#### Q
    使用队列实现栈的下列操作：

    push(x) -- 元素 x 入栈
    pop() -- 移除栈顶元素
    top() -- 获取栈顶元素
    empty() -- 返回栈是否为空
    注意:

    你只能使用队列的基本操作-- 也就是 push to back, peek/pop from front, size, 和 is empty 这些操作是合法的。
    你所使用的语言也许不支持队列。 你可以使用 list 或者 deque（双端队列）来模拟一个队列 , 只要是标准的队列操作即可。
    你可以假设所有操作都是有效的（例如, 对一个空的栈不会调用 pop 或者 top 操作）

#### A
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

        $obj = new MyStack();
        $obj->push("1");
        $obj->push("2");
        $obj->push("3");
        $obj->push("4");
        $obj->push("5");
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        var_dump($obj->top());
        echo "<br />";
        var_dump($obj->emptyForQ());
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        $obj->pop();
        var_dump($obj->query1, $obj->query2);
        echo "<br />";
        var_dump($obj->emptyForQ());
        echo "<br />";

        array(5) { [0]=> string(1) "1" [1]=> string(1) "2" [2]=> string(1) "3" [3]=> string(1) "4" [4]=> string(1) "5" } array(0) { } 
        array(4) { [0]=> string(1) "1" [1]=> string(1) "2" [2]=> string(1) "3" [3]=> string(1) "4" } array(0) { } 
        array(3) { [0]=> string(1) "1" [1]=> string(1) "2" [2]=> string(1) "3" } array(0) { } 
        string(1) "1" 
        bool(false) 
        array(2) { [0]=> string(1) "1" [1]=> string(1) "2" } array(0) { } 
        array(1) { [0]=> string(1) "1" } array(0) { } 
        array(0) { } array(0) { } 
        array(0) { } array(0) { } 
        bool(true) 
    ```
