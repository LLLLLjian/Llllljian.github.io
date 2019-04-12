---
title: PHP_ThinkPHP框架 (1)
date: 2019-03-29 17:00:00
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-基础
    PHP框架学习之路

<!-- more -->

#### 安装
- 需要的服务器环境
    * PHP版本大于5.4
    * PDO PHP Extension
    * MBstring PHP Extension
    * CURL PHP Extension
- 官网下载
    * http://thinkphp.cn提供了稳定版本或者带扩展完整版本的下载
- Composer下载
    * composer create-project topthink/think=5.0.* tp5 --prefer-dist
- Git下载
    * 首先克隆下载应用项目仓库
        * git clone https://github.com/top-think/think tp5
    * 然后切换到 tp5 目录下面，再克隆核心框架仓库：
        * git clone https://github.com/top-think/framework thinkphp
    * 需要更新核心框架的时候,切换到thinkPHP的核心目录下
        * git pull https://github.com/top-think/framework
- 检测是否安装成功
    * http://localhost/tp5/public/

#### 开发规范
- 目录和文件
    * 目录使用小写+下划线；
    * 类库、函数文件统一以 .php 为后缀；
    * 类的文件名均以命名空间定义，并且命名空间的路径和类库文件所在路径一致；
    * 类文件采用驼峰法命名（首字母大写），其它文件采用小写+下划线命名；
    * 类名和类文件名保持一致，统一采用驼峰法命名（首字母大写）；
- 函数和类、属性命名
    * 类的命名采用驼峰法（首字母大写），例如 User 、 UserType ，默认不需要添加后缀，例如
    * UserController 应该直接命名为 User ；
    * 函数的命名使用小写字母和下划线（小写字母开头）的方式，例如 get_client_ip ；
    * 方法的命名使用驼峰法（首字母小写），例如 getUserName ；
    * 属性的命名使用驼峰法（首字母小写），例如 tableName 、 instance ；
    * 以双下划线“__”打头的函数或方法作为魔术方法，例如 __call 和 __autoload ；
- 常量和配置
    * 常量以大写字母和下划线命名，例如 APP_PATH 和 THINK_PATH ；
    * 配置参数以小写字母和下划线命名，例如 url_route_on 和 url_convert ；
- 数据表和字段
    * 数据表和字段采用小写加下划线方式命名，并注意字段名不要以下划线开头，例如 think_user 表和
    * user_name 字段，不建议使用驼峰和中文作为数据表字段命名。

#### 目录结构
    project 应用部署目录 
    ├─application 应用目录（可设置）
    │ ├─common 公共模块目录（可更改）
    │ ├─index 模块目录(可更改)
    │ │ ├─config.php 模块配置文件
    │ │ ├─common.php 模块函数文件
    │ │ ├─controller 控制器目录
    │ │ ├─model 模型目录
    │ │ ├─view 视图目录
    │ │ └─ ... 更多类库目录
    │ ├─command.php 命令行工具配置文件
    │ ├─common.php 应用公共（函数）文件
    │ ├─config.php 应用（公共）配置文件
    │ ├─database.php 数据库配置文件
    │ ├─tags.php 应用行为扩展定义文件
    │ └─route.php 路由配置文件 
    ├─extend 扩展类库目录（可定义） 
    ├─public WEB 部署目录（对外访问目录）
    │ ├─static 静态资源存放目录(css,js,image)
    │ ├─index.php 应用入口文件
    │ ├─router.php 快速测试文件
    │ └─.htaccess 用于 apache 的重写 
    ├─runtime 应用的运行时目录（可写，可设置） 
    ├─vendor 第三方类库目录（Composer） 
    ├─thinkphp 框架系统目录
    │ ├─lang 语言包目录
    │ ├─library 框架核心类库目录
    │ │ ├─think Think 类库包目录
    │ │ └─traits 系统 Traits 目录
    │ ├─tpl 系统模板目录
    │ ├─.htaccess 用于 apache 的重写
    │ ├─.travis.yml CI 定义文件
    │ ├─base.php 基础定义文件
    │ ├─composer.json composer 定义文件
    │ ├─console.php 控制台入口文件
    │ ├─convention.php 惯例配置文件
    │ ├─helper.php 助手函数文件（可选）
    │ ├─LICENSE.txt 授权说明文件
    │ ├─phpunit.xml 单元测试配置文件
    │ ├─README.md README 文件
    │ └─start.php 框架引导文件 
    ├─build.php 自动生成定义文件（参考） 
    ├─composer.json composer 定义文件 
    ├─LICENSE.txt 授权说明文件
