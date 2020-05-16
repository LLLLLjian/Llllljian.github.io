---
title: DataStructure_基础 (27)
date: 2019-12-23
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[最小栈的实现]

<!-- more -->

#### 最小栈的实现
- Q
    * 设计一个栈，其拥有常规的入栈、出栈操作外，需要额外具备获取最小元素的功能
    * 要求这三个方法的时间复杂度都是O(1)
- 解题思路
    * 一个元素压入原始栈时，条件性压入辅助栈（目的是保存当前原始栈中值最小的元素）；元素弹出原始栈时，同样需要条件性弹出辅助栈的栈顶元素（目的是确保辅助栈的栈顶元素是当前原始栈中值最小的元素
    * 元素进栈操作
        1. 辅助栈MinStack为空。
        * 元素首先压入原始栈MainStack，而后直接压入辅助栈MinStack。
        2. 辅助栈MinStack非空。
        * 元素首先压入原始栈MainStack，而后判断该元素是否需要压入辅助栈MinStack。此时分以下两种情况：a. 新入栈元素大于等于辅助栈栈顶元素。该元素不会被压入辅助栈. b. 新入栈元素小于等于辅助栈栈顶元素。该元素需要被压入辅助栈。
    * 元素出栈操作
        * 出栈操作相对简单：首先弹出原始栈的栈顶元素，当该栈顶元素等于辅助栈的栈顶元素时，弹出辅助栈的栈顶元素，以此来保证辅助栈的栈顶元素永远是原始栈当前元素中最小的元素
- A
    ```php
        class EnhancedStack
        {
            private $mainStack;
            private $minStack;

            public function __construct()
            {
                $this->mainStack = $this->minStack = array();
            }

            /**
             * 入栈
             */
            public function push($value)
            {
                array_unshift($this->mainStack, $value);
                if (empty($this->minStack) || $value <= current($this->minStack)) {
                    array_unshift($this->minStack, $value);
                }
            }

            /**
             * 出栈
             */
            public function pop()
            {
                if (current($this->mainStack) == current($this->minStack)) {
                    array_shift($this->minStack);
                }

                return array_shift($this->mainStack);
            }

            /**
             * 获取最小值
             */
            public function getMin()
            {
                if (empty($this->mainStack)) {
                    return "栈已经空了, 没有最小值";
                }
                return current($this->minStack);
            }

            /**
             * 打印栈中内容
             */
            public function varDump($key=1)
            {
                if ($key == 1) {
                    return $this->mainStack;
                }
                if ($key == 2) {
                    return $this->minStack;
                }
            }
        }

        $temp = new EnhancedStack();
        $temp->push(3);
        $temp->push(8);
        $temp->push(5);
        $temp->push(6);
        $temp->push(9);
        $temp->push(1);
        $temp->push(0);
        $temp->push(2);

        var_dump($temp->getMin());
        $temp->pop();
        var_dump($temp->varDump(1));
        $temp->pop();
        $temp->push(2);
        var_dump($temp->getMin());
    ```


