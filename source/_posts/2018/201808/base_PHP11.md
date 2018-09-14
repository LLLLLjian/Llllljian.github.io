---
title: PHP_基础 (11)
date: 2018-08-29
tags: PHP 
toc: true
---

### 了解include(_once)与require(_once)
    之前使用过于片面,这次项目中引用的时候没有结束PHP导致出错,详细了解一下include(_once)与require(_once)

<!-- more -->

#### 作用及用法
    可以减少代码的重复 
    include(_once)（"文件的路径"）与require(_once)（"文件的路径"）      

#### 理解
    就是用包含进来的文件中的内容代替 include(_once),require(_once)那一行  

#### 注意
    include/require 包含进来的文件必须要加<?php ?>因为在包含时,首先理解文件内容是普通字符串,碰到<?php ?> 标签时,才去解释    

#### 路径
    可以用绝对路径,也可以用相对路径；windows下正反斜线都可以,linux下只认正斜线,所以最好用正斜线   

#### 区别    
- include是包含的意思,找不到文件时,会报warning的错误,然后程序继续往下执行    
- require是必须的意思,找不到文件时,会报fatal error （致命错误）,程序停止往下执行
- 加once后,系统会进行判断,如果已经包含,则不会再包含第二次
- eg
    ```php
        a.php
        <?php 
            $a++ ;
        ?>

        b.php
        <?php
            $a=5; 
            require_once（"a.php"）; 
            echo $a;
            
            require_once（"a.php"）; 
            echo $a;
        ?>
    ```

#### 取舍
    比如是系统配置,缺少了,网站不让运行,自然用require,如果是某一段统计程序,少了,对网站只是少统计人数罢了,不是必须要的,可以用include      
    而加不加once是效率上的区别,加上once,虽然系统帮你考虑了只加载一次,但系统的判断会是效率降低,因此,更应该在开发之初,就把目录结构调整好,尽量不要用_once的情况.   

#### 特殊用法
    利用include/require返回被包含页面的返回值
    a.php页面中: ..... return $value; b.php页面中:$v = include("a.php"); <!--[endif]--> 这个用法在做网站配置的时候会偶尔碰到！