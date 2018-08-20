---
title: Interview_总结 (3)
date: 2018-08-15
tags: Interview
toc: true
---

### PHP基础知识点
    学习笔记总结

<!-- more -->

#### PHP值的传递
- 普通传值
    * 传值以后,是不同的地址名称,指向不同的内存实体
- 引用传值
    * 传引用后,是不同的地址名称,但都指向同一个内存实体;改变其中一个,另外一个就也被改变
- 踩坑
    ```php
        $a = 1;
        $b = &$a;
        unset($a);
        echo $b; 

        // 输出结果 1
    ```

#### 常量及数据类型
- 字符串的定义方式及各自区别
    * 单引号：不能解析变量,只能解析单引号(\')和反斜线(\\)转义字符,比双引号效率高
    * 双引号：解析变量(可使用{}括起来),能解析所有转义字符
    * heredoc：功能类似双引号（用于大字符串)
    * newdoc: 功能类似单引号
- 数据类型
    * 浮点数一般不能用于比较和运算,因为浮点数不是精确的
    * false的七种情况
        * 0
        * 0.0
        * '0'
        * ''
        * NULL
        * false
        * array()
    * 超全局变量[九种]
        * $GLOBALS
        * $_GET
        * $_POST
        * $_SERVER
        * $_SESSION
        * $_COOKIE
        * $_FILES
        * $_ENV
        * $_REQUEST
- 常量定义
    * define
        * 函数,不能定义类常量
    * const
        * 语言结构

#### 运算符
- PHP错误运算符@
    * 当将其放置在一个PHP表达式之前,该表达式可能产生的任何错误信息都将被忽略掉
- 运算符的优先级
    * [递增/递减] > [!] > [算术运算符] > [大小比较] > [(不)相等比较] > [引用] > [^] > [|] > [逻辑与&&] > [逻辑或||] > [三目] > [赋值] > [and] > [xor] > [or]

#### 流程控制
- PHP遍历数组的三种方式
    * for循环
        * 只能遍历索引数组
    * foreach循环
        * 能遍历关联数组和索引数组
        * foreach循环遍历数组前,会对数组进行reset()操作
    * while、each()、list()组合
        * 能遍历关联数组和索引数组
        * while、each()、list()组合则不会进行reset()操作
- PHP分支结构
    * if...elseif... 
        * 可能性大的放在前面
    * switch...case...
        * 判断参数的数据类型只能是整形、浮点、字符串
        * switch要比if性能高

#### 正则表达式
- 分隔符
    * 正斜线 /
    * hash符 #
    * 取反符号 ~
- 通用原子
    * \d 匹配数字
    * \D 匹配一个非数字字符
    * \w 匹配数字、字母、下划线
    * \W 匹配任何非单词字符
    * \s 匹配空格
    * \S 匹配任何非空白字符
- 元字符：
    * 量词
        * ? 零次或一次
        * \+ 一次或多次
        * \* 零次或多次
        * {n} 匹配确定的n次
        * {n,} 至少匹配n次
        * {n,m} 最少匹配n次且最多匹配m次
    * 通配符
        * . 匹配除"\n"之外的任何单个字符
    * 范围匹配
        * [] 字符集合
        * [-] 字符范围
        * [^] 除字符集合
- 模式修正符
    * i 不区分(ignore)大小写
    * m 多(more)行匹配
    * U 只匹配最近的一个字符串;不重复匹配 
    * g 全局(global)匹配

#### 文件及目录处理
- 打开文件函数
    * fopen()
- 读取文件函数
    * fgets() 读取一行
    * fgetc() 读取字符
- 写入文件函数
    * fwrite()/fputs()
- 关闭文件函数
    * fclose()
- 其它操作文件方式
    * file_put_contents()
    * file_get_contents()
- 目录操作函数
    * 目录名称
        * basename()
        * dirname()
        * pathinfo()
    * 目录读取
        * opendir()
        * readdir()
        * closedir()
        * rewinddir()
    * 目录删除
        * rmdir()
    * 目录创建
        * mkdir()
- 目录遍历
    ```php
        function loopDir($dir)
        {
            if (is_dir($dir)) {
                if ($handle = opendir($dir)) {
                    while (false !== ($file = readdir($handle))) {
                        if ($file != "." && $file != "..") {
                            echo $file.'\n';
                            if (filetype($dir.DIRECTORY_SEPARATOR.$file === 'dir')) {
                                loopDir($dir.DIRECTORY_SEPARATOR.$file);
                            }
                        }
                    }
                }
            } else {
                echo basename($file).'\n';
            }
        }
    ```
