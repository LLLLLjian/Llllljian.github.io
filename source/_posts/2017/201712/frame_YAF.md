---
title: PHP_yaf框架 (1)
date: 2017-12-15
tags: YAF
toc: true
---

## 关于yaf
    Yaf是一个C语言编写的PHP框架

## yaf特点
- 优点
    * 用C语言开发的PHP框架, 相比原生的PHP, 几乎不会带来额外的性能开销
    * 所有的框架类, 不需要编译, 在PHP启动的时候加载, 并常驻内存.
    * 更短的内存周转周期, 提高内存利用率, 降低内存占用率.
    * 灵巧的自动加载. 支持全局和局部两种加载规则, 方便类库共享.
    * 高性能的视图引擎.
    * 高度灵活可扩展的框架, 支持自定义视图引擎, 支持插件, 支持自定义路由等等.
    * 内建多种路由, 可以兼容目前常见的各种路由协议.
    * 强大而又高度灵活的配置文件支持. 并支持缓存配置文件, 避免复杂的配置结构带来的性能损失.
    * 在框架本身,对危险的操作习惯做了禁止.
    * 更快的执行速度, 更少的内存占用.
    * 自己的理解：性能高
- 缺点
    * C的扩展,致命性错误对C的要求很高

<!-- more -->

## yaf安装
- 说一下自己的安装过程.
- 通过phpinfo()查看其中的Thread Safety 查看是否线程安全,如果是enabled就下载Ts版的yaf扩展,否则就下载nts版
- 配置php.ini支持yaf扩展

```php
    [yaf]
    yaf.environ = product
    yaf.library = NULL
    yaf.cache_config = 0
    yaf.name_suffix = 1
    yaf.name_separator = ""
    yaf.forward_limit = 5
    yaf.use_namespace = 0
    yaf.use_spl_autoload = 0
    extension=yaf.so //关键步骤
```

- 重启服务器,在phpinfo()页面查找yaf,找到就是安装成功

## yaf设置

- 添加.htaccess文件,限制唯一访问入口为public/index.php,展示在其中的代码为RewriteRule .* index.php
- 修改index.php文件,定义APPLICATION常量

```php
    <?php
    define("APP_PATH",  realpath(dirname(__FILE__) . '/../')); /* 指向public的上一级 */
    $app  = new Yaf_Application(APP_PATH . "/conf/application.ini");
    $app->run();
```

- 在config目录中添加配置文件application.ini中定义directory

```php 
    [product]
    ;支持直接写PHP中的已定义常量
    application.directory=APPLICATION_PATH
    application.dispatcher.throwException=1
    application.dispatcher.catchException=0

    ;说明：如下的配置都是Ap的默认配置,可以省略
    
    ;加载第三方类库
    application.library=APPLICATION_PATH "/../library"
    application.bootstrap=APPLICATION_PATH"/Bootstrap.php"

    ;默认的Url前缀,不指定的时候,由Ap自行设计
    application.baseUri=""
    ;默认的脚本后缀名
    application.ext=php
    ;默认的视图文件后缀名
    application.view.ext=html
    ;默认的访问的模块
    application.dispatcher.defaultModuel=Default
    ;默认的访问的控制器
    application.dispatcher.defaultController=Index
    ;默认的访问的方法 
    application.dispatcher.defaultAction=index
    ;允许访问的模块
    application.modules=Index,Default
    ;默认配置结束

    [testing:product]
    [development : product]
    ;smarty模板设置
    ;设置左右边界符号
    smarty.left_delimiter   = "{"
    smarty.right_delimiter  = "}"
    ;设置模板目录
    smarty.template_dir     = APPLICATION_PATH "/views/"
    ;设置编译目录
    smarty.compile_dir      = APPLICATION_PATH "/../templates_c/"
    ;设置缓存文件夹
    smarty.cache_dir        = APPLICATION_PATH "/views/templates_d/"

    ;路由配置
    routes.regex.type="regex"
    routes.regex.match="#^/list/([a-z]+)[-]?(\d+)?(\.html)?$#"
    routes.regex.route.controller=Index
    routes.regex.route.action=page
    routes.regex.map.1=page
    routes.regex.map.2=page

    ;database config 数据库配置

    database.db_driver = "mysqli"  ;选择不同的数据库DB 引擎,一般默认mysqli,或者mysql,pdo
    ;主库配置
    database.default.db_type   = 1 ;0-单个服务器,1-读写分离,2-随机
    database.default.0.host = 127.0.0.1
    database.default.0.username = "root"
    database.default.0.password = ""
    database.default.0.database = ""
    database.default.0.charset = "utf8"  ;数据库编码
    database.default.0.pconnect = 0   ;是否持久链接
    ;从库配置
    database.default.1.host = 127.0.0.1
    database.default.1.username = "root"
    database.default.1.password = ""
    database.default.1.database = ""
    database.default.1.charset = "utf8"  ;数据库编码
    database.default.1.pconnect = 0   ;是否持久链接
```

