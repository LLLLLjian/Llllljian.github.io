---
title: DataStructure_基础 (28)
date: 2019-12-24
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[栈排序]

<!-- more -->

#### 栈排序
- Q
    * 使用一个辅助栈完成原始栈的排序: 栈顶到栈底从大到小
    * 允许使用一个辅助栈, 可以申请变量, 但不能使用其他数据结构
- 解题思路
    * 假设待排序栈标价为Stack, 辅助栈的标记为SortedStack.首先, Stack栈的栈顶元素(标记为curElement)出栈, 然后尝试将其压入SortedStack栈, 但需要遵从以下限制: 
        * SortedStack栈为空, 直接压入；
        * SortedStack栈非空, 且curElement <= SortedStack.peek(), 将curELement压入；
        * SortedStack栈非空, 但curElement > SortedStack.peek(), 此时需要持续弹出SortedStack栈的顶元素直至元素curElement <= SortedStack栈最新的顶元素
- A1
    ```php
        class SortedStack 
        {
            private $stack;
            private $sortedStack;

            /**
             *
             */
            function __construct()
            {
                $this->stack = $this->sortedStack = array();
            }

            /**
             * @param Integer $val
             * @return NULL
             */
            function push($val)
            {
                $max = empty($this->stack) ? 999999999 : current($this->stack);
                $min = empty($this->sortedStack) ? -999999999 : current($this->sortedStack);
                while (true) {
                    if ($val > $max) {
                        array_unshift($this->sortedStack, array_shift($this->stack));
                        $max = empty($this->stack) ? 999999999 : current($this->stack);
                    } elseif ($val < $min) {
                        array_unshift($this->stack, array_shift($this->sortedStack));
                        $min = empty($this->sortedStack) ? -999999999 : current($this->sortedStack);
                    } else {
                        array_unshift($this->stack, $val);
                        break;
                    }
                }
            }

            /**
             * @return NULL
             */
            function pop() 
            {
                // 将辅助栈元素push回原始栈
                while (!empty($this->sortedStack)) {
                    array_unshift($this->stack, array_shift($this->sortedStack));
                }

                if (!empty($this->stack)) {
                    array_shift($this->stack);
                }
            }

            /**
             * @return Integer
             */
            function peek() 
            {
                // 将辅助栈元素push回原始栈
                while (!empty($this->sortedStack)) {
                    array_unshift($this->stack, array_shift($this->sortedStack));
                }

                return empty($this->stack) ? -1 : current($this->stack);
            }

            /**
             * @return Boolean
             */
            function isEmpty() 
            {
                return empty($this->stack) && empty($this->sortedStack);
            }
        }
    ```
- A2
    ```php
        function sortStack($arr)
        {
            $sortedStack = array();
            while (!empty($arr)) {
                $curElement = array_shift($arr);
                while (!empty($sortedStack) && $curElement > current($sortedStack)) {
                    array_unshift($arr, array_shift($sortedStack));
                }
                array_unshift($sortedStack, $curElement);
            }
            while (!empty($sortedStack)) {
                array_unshift($arr, array_shift($sortedStack));
            }
            return $arr;
        }
    ```

