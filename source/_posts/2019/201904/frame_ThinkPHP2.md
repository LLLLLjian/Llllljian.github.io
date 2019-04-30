---
title: PHP_ThinkPHP框架 (2)
date: 2019-04-08
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-配置
    PHP框架学习之路

<!-- more -->

#### 配置优先级
1. 动态配置
2. 模块配置
3. 应用配置
4. 惯例配置

#### 配置的加载顺序
1. 惯例配置
2. 再加载tags.php(行为钩子)
3. common.php(加载公共文件)
4. helper.php(助手函数)
5. middleware.php(全局中间件)
6. provider.php(自定义容器)
7. 最后应用配置

#### 动态配置
    动态配置主要用于我们对当前控制器或者是某个方法页面进行动态的配置改变或动态的配置设置
- eg
    ```php
        <?php 
        namespace app\index\controller;
        
        class Index
        {
            public function __construct()
            {
                config('before', 'beforeAction');
            }

            // before配置只出现在当前文件中
            public function index()
            {
                var_dump(config());
            }
        }
    ```
- 注意
    * 在控制器类的构造方法中进行动态配置的时候,该配置在该控制器下的所有方法中都有效.如果在控制器的某个方法中进行动态配置时,仅在该方法中有效

#### 模块配置
    仅设定的模块有效
1. 在conf目录下创建与模块名相同的文件夹
2. 在该文件夹下创建一个config.php 写在该文件中的配置,仅对该模块名对应模块有效

#### 应用配置
    应用配置是对整个应用目录有效,也就是说,在当前应用下的所有模块都可以使用当前配置

#### 惯例配置
    配置文件位置:/根目录/think/convention.php

