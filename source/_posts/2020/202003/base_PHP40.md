---
title: PHP_基础 (40)
date: 2020-03-03
tags: PHP 
toc: true
---

### 命令空间namespace
    命名空间我不太懂, 只是简单的会用

<!-- more -->

#### 概述
- 什么是命名空间
    * 从广义上来说, 命名空间是一种封装事物的方法.在很多地方都可以见到这种抽象概念.例如, 在操作系统中目录用来将相关文件分组, 对于目录中的文件来说, 它就扮演了命名空间的角色.具体举个例子, 文件 foo.txt 可以同时在目录/home/greg 和 /home/other 中存在, 但在同一个目录中不能存在两个 foo.txt 文件.另外, 在目录 /home/greg 外访问 foo.txt 文件时, 我们必须将目录名以及目录分隔符放在文件名之前得到 /home/greg/foo.txt.这个原理应用到程序设计领域就是命名空间的概念
- 可以解决的问题
    * 用户编写的代码与PHP内部的或第三方的类、函数、常量、接口名字冲突
    * 为很长的标识符名称创建一个别名的名称, 提高源代码的可读性

#### 内部实现
> 命名空间的实现实际比较简单, 当声明了一个命名空间后, 接下来编译类、函数和常量时会把类名、函数名和常量名统一加上命名空间的名称作为前缀存储, 也就是说声明在命名空间中的类、函数和常量的实际名称是被修改过的, 这样来看他们与普通的定义方式是没有区别的, 只是这个前缀是内核帮我们自动添加的, 
```php
    //ns_define.php
    namespace com\aa;
    const MY_CONST = 1234;
    function my_func(){ /* ... */ }
    class my_class { /* ... */ }

    // 最终MY_CONST、my_func、my_class在EG(zend_constants)、EG(function_table)、EG(class_table)中的实际存储名称被修改为: com\aa\MY_CONST、com\aa\my_func、com\aa\my_class.
```













