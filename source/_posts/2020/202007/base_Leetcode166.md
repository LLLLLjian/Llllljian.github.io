---
title: Leetcode_基础 (166)
date: 2020-07-16
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温栈队列

<!-- more -->

#### 包含 min 函数的栈
- 问题描述
    * 定义栈的数据结构, 请在该类型中实现一个能够得到栈最小元素的 min 函数
- 解题思路 
    * 利用一个辅助栈, 辅助栈的栈顶始终为最小值
    1. 入栈的时候：首先往空的数据栈里压入数字 3 , 此时 3 是最小值, 所以把最小值压入辅助栈.接下来往数据栈里压入数字 4 .由于 4 大于之前的最小值, 因此只要入数据栈, 不需要压入辅助栈.
    2. 出栈的时候：当数据栈和辅助栈的栈顶元素相同的时候, 辅助栈的栈顶元素出栈.否则, 数据栈的栈顶元素出栈.
    3. 获得栈顶元素的时候：直接返回数据栈的栈顶元素.
    4. 栈最小元素：直接返回辅助栈的栈顶元素
    ```php
        class MinStack {
            public $main;
            public $min;
            /**
             * initialize your data structure here.
             */
            function __construct() {
                $this->main = $this->min = array();
            }

            /**
             * @param Integer $x
             * @return NULL
             */
            function push($x) 
            {
                array_unshift($this->main, $x);

                if (empty($this->min) || $x <= current($this->min)) {
                    array_unshift($this->min, $x);
                }
            }

            /**
             * @return NULL
             */
            function pop() 
            {
                if (!empty($this->min) && current($this->main) == current($this->min)) {
                    array_shift($this->min);
                }
                return array_shift($this->main);
            }

            /**
             * @return Integer
             */
            function top() {
                return current($this->main);
            }

            /**
             * @return Integer
             */
            function getMin() {
                if (!empty($this->min)) {
                    return current($this->min);
                }
                return 0;
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

#### 栈的压入、弹出序列
- 问题描述
    * 输入两个整数序列, 第一个序列表示栈的压入顺序, 请判断第二个序列是否为该栈的弹出顺序.假设压入栈的所有数字均不相等.例如, 序列 {1,2,3,4,5} 是某栈的压栈序列, 序列 {4,5,3,2,1} 是该压栈序列对应的一个弹出序列, 但 {4,3,5,1,2} 就不可能是该压栈序列的弹出序列.
- 解题思路
    1. 建立一个辅助栈
    2. 把输入序列中的数字依次压入辅助栈, 并按照输出序列的顺序依次从辅助栈中弹出数字.
    3. 序列遍历完后, 栈为空, 则弹出序列为压入序列中的一个可能弹出序列

    ```php
        class Solution 
        {
            /**
             * @param Integer[] $pushed
             * @param Integer[] $popped
             * @return Boolean
             */
            function validateStackSequences($pushed, $poped) {
                $stack = [];
                $j = 0;

                $pushedLen = count($pushed);
                $popedLen = count($poped);

                for ($i = 0; $i < $pushedLen; $i++) {
                    $stack[] = $pushed[$i];
                    // end() 函数注意:返回最后一个元素的值, 或者如果是空数组则返回 FALSE.
                    while ($j < $popedLen && end($stack) === $poped[$j]) {
                        array_pop($stack);
                        $j++;
                    }
                }
                return empty($stack);
            }
        }
    ``` 

