---
title: Leetcode_基础 (76)
date: 2019-06-10 12:00:00
tags: Leetcode
toc: true
---

### 记录速率限制器
    Leetcode学习-359

<!-- more -->

#### Q
    设计一个记录系统每次接受信息并保存时间戳,然后让我们打印出该消息,前提是最近10秒内没有打印出这个消息
    
    Example:
    Logger logger = new Logger();
    // logging string "foo" at timestamp 1
    logger.shouldPrintMessage(1, "foo"); returns true; 
    // logging string "bar" at timestamp 2
    logger.shouldPrintMessage(2,"bar"); returns true;
    // logging string "foo" at timestamp 3
    logger.shouldPrintMessage(3,"foo"); returns false;
    // logging string "bar" at timestamp 8
    logger.shouldPrintMessage(8,"bar"); returns false;
    // logging string "foo" at timestamp 10
    logger.shouldPrintMessage(10,"foo"); returns false;
    // logging string "foo" at timestamp 11
    logger.shouldPrintMessage(11,"foo"); returns true;

#### A
    ```php
        class Logger {
            public $map;

            public function __construct() {
                $this->map = array();
            }

            public function shouldPrintMessage($timestamp, $message) {
                if (!array_key_exists($message, $this->map) || $timestamp - $this->map[$message] >= 10) {
                    $this->map[$message] = $timestamp;
                    return true;
                }
                return false;
            }
        }

        $a = new Logger();
        var_dump($a->shouldPrintMessage(1, "foo"));echo "<br />";
        var_dump($a->shouldPrintMessage(2, "bar"));echo "<br />";
        var_dump($a->shouldPrintMessage(3, "foo"));echo "<br />";
        var_dump($a->shouldPrintMessage(8, "bar"));echo "<br />";
        var_dump($a->shouldPrintMessage(10, "foo"));echo "<br />";
        var_dump($a->shouldPrintMessage(11, "foo"));echo "<br />";

        bool(true) 
        bool(true) 
        bool(false) 
        bool(false) 
        bool(false) 
        bool(true) 
    ```
