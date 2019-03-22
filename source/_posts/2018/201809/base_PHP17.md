---
title: PHP_基础 (17)
date: 2018-09-17
tags: PHP 
toc: true
---

### 数据结构与算法总结
    栈-先进后出

<!-- more -->

#### 数组类型入栈与出栈
- 首入栈
    ```php
        $queue = array("0", "1");
        array_unshift($queue, "2", "3");
        print_r($queue);
        // array(0=>2, 1=>3, 2=>0, 3=>1)
    ```
- 末入栈
    ```php
        $stack = array("0", "1");
        array_push($stack, "2", "3");
        print_r($stack);
        // array(0=>0, 1=>1, 2=>2, 3=>3)
    ```
- 首出栈
    ```php
        $stack = array("0", "1", "2", "3"); 
        echo array_shift($stack)."/n"; //0
        print_r($stack); 
    ```
- 末出栈
    ```php
        $stack = array("0", "1", "2", "3"); 
        echo array_pop($stack)."/n"; // 3
        print_r($stack); 
    ```

