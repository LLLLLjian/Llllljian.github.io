---
title: PHP_Yii框架 (1)
date: 2018-01-25
tags: Yii
toc: true
---

### 关于Yii
- Yii 是一个高性能，基于组件的 PHP 框架，用于快速开发现代 Web 应用程序。 名字 Yii （读作 易）在中文里有“极致简单与不断演变”两重含义， 也可看作 Yes It Is! 的缩写。

### Yii特点
- 最适合做什么
    * Yii 是一个通用的 Web 编程框架，即可以用于开发各种用 PHP 构建的 Web 应用。 因为基于组件的框架结构和设计精巧的缓存支持，它特别适合开发大型应用， 如门户网站、社区、内容管理系统（CMS）、 电子商务项目和 RESTful Web 服务等。
- 与其他框架相比
    * 实现了 MVC（Model-View-Controller）设计模式并基于该模式组织代码。
    * 代码简洁优雅
    * 是一个全栈框架，提供了大量久经考验，开箱即用的特性： 对关系型和 NoSQL 数据库都提供了查询生成器和 ActiveRecord；RESTful API 的开发支持；多层缓存支持，等等
    * 非常易于扩展
    * 高性能
    * 社区多,开发者团队持续跟进开发

<!-- more -->

### Yii安装
- 说一下自己的安装过程。
    * 通过归档文件安装
        * 从 yiiframework.com 下载归档文件。
        * 将下载的文件解压缩到 Web 访问的文件夹中。
        * 修改 config/web.php 文件，给 cookieValidationKey 配置项 添加一个密钥（若你通过 Composer 安装，则此步骤会自动完成）：
    * 通过 Composer 安装
        * 先安装Composer(如果已经安装请忽略) 
            ```bash 
                curl -sS https://getcomposer.org/installer | php
            ```
        * 全局安装 
            ```bash
                mv composer.phar /usr/local/bin/composer 使用 composer
            ```
        * 局部安装
            ```bash
                使用 php composer.phar 
            ```
        * 安装 Composer asset plugin， 它是通过 Composer 管理 bower 和 npm 包所必须的，此命令全局生效 
            ```bash
                composer global require "fxp/composer-asset-plugin:^1.3.1"
            ```
        * 将 basic-Yii 安装在名为 basic 的目录
            ```bash
                全局安装之后
                composer create-project --prefer-dist yiisoft/yii2-app-basic basic
            ```
        * 将 advanced-Yii 安装在上级目录中名为yii2 的目录中
            ```bash
                局部安装之后
                php composer.phar create-project --prefer-dist --stability=dev yiisoft/yii2-app-advanced ../yii2

                高级版安装完之后要进行初始化  
                cd yii2
                php init
            ```

### 目录说明
- 官方站点正在使用的目录结构
    ```bash
    advanced
        backend//后台
            assets//加载相关js,css
            codeception.yml
            config//后台基本环境配置
            controllers//后台控制器
            models//后台模型
            runtime//缓存相关
            tests
            views//后台视图
            web//入口文件和css，js文件存放位置
        .bowerrc
        codeception.yml
        common//公共特点，前端后端以及控制台共用
            codeception.yml
            config//公共配置
            fixtures
            mail
            models//模型
            tests
            widgets//插件
        composer.json
        composer.lock
        console//控制台，包含系统所需要的控制台命令
        environments
        frontend//前台
        .gitignore
        init
        init.bat
        LICENSE.md
        README.md
        requirements.php
        vagrant
        Vagrantfile
        vendor//框架源代码
        yii
        yii.bat
        yii_test
        yii_test.bat
    ```