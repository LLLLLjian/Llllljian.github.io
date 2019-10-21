---
title: Tencent_基础 (7)
date: 2019-07-08
tags: 
    - Tencent
    - Linux
    - Wechat
    - ThinkPHP
    - Mongo
toc: true
---

### 命令行生成文件
    快速生成模块控制器模型

<!-- more -->

#### 快速生成模块
- 生成单个模块
    ```php
        // 生成test模块
        php think build --module test
    ```
- 批量生成模块
    ```bash
        cat build.php
        return [
            // 定义demo模块的自动生成
            'demo'   => [
                // 表示生成文件(不定义默认会生成 config.php 文件)
                '__file__'   => ['tags.php', 'user.php', 'hello.php'],
                // 表示生成目录(支持多级目录)
                '__dir__'    => ['config', 'controller', 'model', 'view'],
                // 生成controller类
                'controller' => ['Index', 'Test', 'UserType'],
                // 生成model类
                'model'      => [],
                // 生成html文件(支持子目录)
                'view'       => ['index/index'],
            ],    
            
            // 定义test模块的自动生成
            'test'=>[
                '__dir__'   =>  ['config','controller','model','widget'],
                'controller'=>  ['Index','Test','UserType'],
                'model'     =>   ['User','UserType'],
                'view'      =>  ['index/index','index/test'],
            ],
        ];

        php think build
    ```

#### 快速生成控制器
- 生成普通的控制器
    ```php
        // 生成index模块下的Blog控制器类库文件
        php think make:controller index/Blog
    ```
- 生成带后缀的控制器
    ```php
        // 生成index模块下的BlogController控制器类库文件
        php think make:controller index/BlogController
    ```
- 生成空的控制器
    ```php
        php think make:controller index/Blog --plain
    ```

#### 快速生成模型
- 生成普通的模型
    ```php
        // 生成index模块下的Blog模型类库文件
        php think make:model index/Blog
    ```
- 生成带后缀的模型
    ```php
        // 生成index模块下的BlogController模型类库文件
        php think make:model index/BlogController
    ```
- 生成空的模型
    ```php
        php think make:model index/Blog --plain
    ```