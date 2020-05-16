---
title: Interview_总结 (54)
date: 2019-11-13
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * 你用什么方法检查PHP脚本的执行效率（通常是脚本执行时间）和数据库SQL的效率（通常是数据库Query时间），并定位和分析脚本执行和数据库查询的瓶颈所在？
- A
    * PHP脚本的执行效率
        * 代码脚本里计时；
        * xdebug统计函数执行次数和具体时间进行分析，最好使用工具winCacheGrind分析；
        * 在线系统用strace跟踪相关进程的具体系统调用
        ```php
            microtime(true); // 计算脚本执行之间
            memory_get_usage(); // 获取当前进程的内存占用量，单位为字节
        ```
    * 数据库SQL的效率
        * sql的explain(mysql)，启用slow query log记录慢查询；
        * 通常还要看数据库设计是否合理，需求是否合理等。

#### 问题2
- Q
    * 什么是引用变量。用什么符号来表示引用变量
    ```php
        $data = ['a', ,'b', 'c'];

        foreach ($data as $key=>$val) {
            $val = &$data[$key];
        }
        程序运行时每一次循环结束后变量$data的值是什么 请解释
        程序执行完之后, $data的值是什么 请解释
    ```
- A
    * 概念
        * 在PHP中引用意味着用不同的名字访问同一个变量内容
    * 定义方式
        * 使用&符号
    * 解题
        ![问题2解题思路](/img/20191113_1.png)
        ![问题2解题思路](/img/20191113_2.png)

#### 问题3
- Q
    * PHP的字符串的定义方式及各自区别
- A
    * 单引号
        * 单引号不能解析变量
        * 单引号不能解析转义字符, 只能解析单引号和反斜线本身
        * 变量和变量, 变量和字符串, 字符串和字符串之间可以用.连接
    * 双引号
        * 双引号可以解析变量, 变量可以使用特殊字符和{}包含
        * 双引号可以解析所有转义字符
        * 也可以用.来连接
    * heredoc和newdoc
        * Heredoc类似于双引号
        * newdoc类似于单引号
        * 两者都用来处理大文本

#### 问题4
- Q
    * PHP数据类型
- A
    * 浮点类型
        * 浮点类型不能运用到比较运算符中
    * 布尔类型
        * false的七种情况[0, 0.0, ' ', '0', false, array(), null]
    * 数组类型
        * 超全局数组
            * $_SERVER['SERVER_ADDR'] -- 当前运行脚本所在的服务器的 IP 地址
            * $_SERVER['SERVER_NAME'] -- 返回当前主机名
            * $_SERVER['REQUEST_TIME'] -- 请求开始时的时间戳
            * $$_SERVER['QUERY_STRING'] -- 查询（query）的字符串（URL 中第一个问号 ? 之后的内容）
            * $_SERVER['HTTP_REFERER'] -- 链接到当前页面的前一页面的 URL 地址
            * $_SERVER['HTTP_USER_AGENT'] -- 返回用户使用的浏览器信息
            * $_SERVER['REMOTE_ADDR'] -- 正在浏览当前页面用户的 IP 地址
            * $_SERVER['REQUEST_URI'] -- 访问此页面所需的 URI。例如，“/index.html”
    * 常量
        * const define
        * const更快, 是语言结构, define是函数