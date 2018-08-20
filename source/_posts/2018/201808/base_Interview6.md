---
title: Interview_总结 (6)
date: 2018-08-18
tags: Interview
toc: true
---

### 逻辑与算法
    学习笔记总结
    
<!-- more -->

#### 数据结构
- 常见数据结构
    * Array 
        * 数组是最简单而且应用最广泛的数据结构
        * 使用连续内存空间来存储
        * 存放相同类型或着衍生类型的元素（PHP数组比较特别,可以存放八种数据类型)
        * 通过下标来访问
    * Set
        * 集合
        * 保存不重复的元素
    * Map
        * 字典
        * 就是PHP关联数组,以Key/Value形式存储
    * Stack
        * 栈
        * 存储数据是先进先出,栈只有一个出口,只能从栈顶部添加和删除元素
    * Heap
        * 堆
        * 子节点的键值和索引总小于他的父节点
    * list
        * 线性表,由零个或多个数据元素组成的有序序列
        * 线性表是一个序列,在PHP中就是索引数组
    * Queue
        * 队列
        * 先进先出,并发中使用,可以安全地将对象从一个任务传给另一个任务,可以使用PHP数组模拟

#### 编码题
    ```php
        q : 不使用PHP内置函数的前提下,实现字符串翻转

        a : 
        function str_rev($str)
        {
            for ($i = 0; true; $i++) {
                if (!isset($str[$i])) {
                    break;
                }
            }

            $return = '';
            for ($j=$i-1;$j>=0;$j--) {
                $return .= $str[$j];
            }
            return $return;
        }
    ```
