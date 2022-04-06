---
title: PHP_基础 (1)
date: 2017-12-21
tags: PHP
toc: true
---

- PHP: Hypertext Preprocessor: 超文本预处理器: 开源通用脚本语言

## 语言参考

### 类型

- Boolean 布尔型
    **语法** :  使用关键字 TRUE 或 FALSE.两个都不区分大小写. 
    **判断** :  is_bool
    **转化** :  强制转化 (bool)  转化 boolval()

    ```php
        <?php
        /**
        * 以下值为false,其余的都是true
        *  布尔值 FALSE 本身  
        *  整型值 0(零)  
        *  浮点型值 0.0(零)  
        *  空字符串,以及字符串 "0"  
        *  不包括任何元素的数组  
        *  不包括任何成员变量的对象(仅 PHP 4.0 适用)  
        *  特殊类型 NULL(包括尚未赋值的变量)  
        *  从空标记生成的 SimpleXML 对象 
        */
        var_dump((bool) "");        // bool(false)
        var_dump((bool) 1);         // bool(true)
        var_dump((bool) -2);        // bool(true)
        var_dump((bool) "foo");     // bool(true)
        var_dump((bool) 2.3e5);     // bool(true)
        var_dump((bool) array(12)); // bool(true)
        var_dump((bool) array());   // bool(false)
        var_dump((bool) "false");   // bool(true)
    ```

<!-- more -->

- Integer 整型
    **语法** :  整型值可以使用十进制,十六进制,八进制或二进制表示,前面可以加上可选的符号(/- 或者 /+).
    **语法** :  要使用八进制表达,数字前必须加上 0(零).
    **语法** :  要使用十六进制表达,数字前必须加上 0x.
    **语法** :  要使用二进制表达,数字前必须加上 0b. 
    **语法** :  整型数的字长和平台有关
    **语法** :  如果向八进制数传递了一个非法数字(即 8 或 9),则后面其余数字会被忽略
    **语法** :  如果给定的一个数超出了 integer 的范围,将会被解释为 float.同样如果执行的运算结果超出了 integer 范围,也会返回 float. 
    **语法** :  PHP 中没有整除的运算符,值可以舍弃小数部分强制转换为 integer,或者使用 round() 函数可以更好地进行四舍五入
    **判断** :  is_int
    **转化** :  强制转化 (int)  转化 intval()
    **转化** :  从布尔值转换 : FALSE 将产生出 0,TRUE 将产生出 1. 
    **转化** :  从浮点型转换 : 当从浮点数转换成整数时,将向下取整. 超出范围则结果为未定义(不要将未知的分数强制转换为 integer,这样有时会导致不可预料的结果) 

- Float 浮点型 
    **语法** :  浮点数 float,双精度数 double 或实数 real
    **判断** :  is_float
    **判断** :  一般不要比较浮点数大小,非要比较的话abs(差值)和0.0001进行比较
    **转化** :  强制转化 (float)  转化 floatval()
    **转化** :  从字符串转化 :  先将值转换成整型,然后再转换成浮点
    **转化** :  从对象转化 :  会发出一条 E_NOTICE 错误消息

- String 字符串 
    **语法** :  四种表达方式  单引号;双引号;heredoc 语法结构;nowdoc 语法结构(自 PHP 5.3.0 起) 
    **判断** :  is_string
    **转化** :  强制转化 (string)  转化 strval()

- Array 数组 
    **语法** :  定义数组 array()或者[]
    **判断** :  is_array
    **转化** :  强制转化 (array)

- Object 对象
    **语法** :  要创建一个新的对象 object,使用 new 语句实例化一个类:  
    **判断** :  is_object
    **转化** :  强制转化 (object)

- Resource 资源类型 

- NULL 
    **语法** :  NULL 类型只有一个值,就是不区分大小写的常量 NULL. 
    **语法** :  被赋值为 NULL. 
    **语法** :  被 unset(). 
    **语法** :  尚未被赋值. 
    **判断** :  is_null
    **转化** :  使用 (unset) $var 将一个变量转换为 null 将不会删除该变量或 unset 其值.仅是返回 NULL 值而已. 

- Callback 回调类型 

### 变量
    区分大小写
    正则为: [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*
    传值赋值  引用赋值

- 预定义变量 
    **$GLOBALS** : 引用全局作用域中可用的全部变量 : 一个包含了全部变量的全局组合数组.变量的名字就是数组的键.
    **$_COOKIE** : 通过 HTTP Cookies 方式传递给当前脚本的变量的数组. 
    **$_ENV** : 通过环境方式传递给当前脚本的变量的数组. 
    **$_FILES** : 通过 HTTP POST 方式上传到当前脚本的项目的数组. 
    **$_GET** : 通过 URL 参数传递给当前脚本的变量的数组. 
    **$_POST** : 通过 HTTP POST 方法传递给当前脚本的变量的数组. 
    **$_REQUEST** : 默认情况下包含了\$\_GET,\$\_POST 和 \$\_COOKIE 的数组. 
    **$_SERVER** : 包含了诸如头信息(header)、路径(path)、以及脚本位置(script locations)等等信息的数组
    **$_SESSION** : 当前脚本可用 SESSION 变量的数组

- 变量范围 
    **global 关键字**
    **使用静态变量**

- 可变变量
