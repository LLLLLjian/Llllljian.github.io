---
title: PHP_yaf框架 (3)
date: 2017-12-19
tags: YAF
toc: true
---

### 路由组件

    路由组件有两个部分：路由器(Yaf_Router)和路由协议(Yaf_Route_Abstract).

#### 路由器

    默认：Yaf_Router 
    路由器主要负责解析一个请求并且决定什么module、controller、action被请求；
    它同时也定义了一种方法来实现用户自定义路由，这也使得它成为最重要的一个MVC组组件.
    路由器主要负责管理和运行路由链,它根据路由协议栈倒序依次调用各个路由协议, 一直到某一个路由协议返回成功以后, 就匹配成功.

#### 路由协议

    默认：Yaf_Route_Abstract
    路由协议事实上主要负责匹配我们预先定义好的路由协议，
    默认是基于HTTP路由的, 它期望一个请求是HTTP请求并且请求对象是使用Yaf_Request_Http

<!-- more -->

- Yaf_Route_Static

```bash    
    <?php
     /**
      * 默认的路由协议Yaf_Route_Static, 就是分析请求中的request_uri, 在去除掉base_uri以后, 获取到真正的负载路由信息的request_uri片段, 
      * 具体的策略是, 根据"/"对request_uri分段, 依次得到Module,Controller,Action, 
      * 在得到Module以后, 还需要根据Yaf_Application::$modules来判断Module是否是合法的Module, 
      * 如果不是, 则认为Module并没有体现在request_uri中, 而把原Module当做Controller, 原Controller当做Action:
      *
      * 当只有一段路由信息的时候, 比如对于以下的例子, 请求的URI为/ap/foo, 
      * 则默认路由和下面要提到的Yaf_Route_Supervar会首先判断ap.action_prefer, 如果为真, 则把foo当做Action, 否则当做Controller
      */
     /**
      * 对于请求request_uri为"/ap/foo/bar/dummy/1"
      * base_uri为"/ap"
      * 则最后参加路由的request_uri为"/foo/bar/dummy/1"
      * 然后, 通过对URL分段, 得到如下分节
      * foo, bar, dummy, 1
      * 然后判断foo是不是一个合法的Module, 如果不是, 则认为结果如下:
      */
      array(
        'module'     => '默认模块',
        'controller' => 'foo',
        'action'     => 'bar',
        'params'     => array(
             'dummy' => 1,
        )
     )

     /**
      * 而如果在配置文件中定义了ap.modules="Index,Foo",
      * 则此处就会认为foo是一个合法模块, 则结果如下
      */
      array(
        'module'     => 'foo',
        'controller' => 'bar',
        'action'     => 'dummy',
        'params'     => array(
             1 => NULL,
        )
     )
```

- Yaf_Route_Simple

```bash
    <?php
     /**
      * Yaf_Route_Simple是基于请求中的query string来做路由的, 在初始化一个Yaf_Route_Simple路由协议的时候, 我们需要给出3个参数, 
      * 这3个参数分别代表在query string中Module, Controller, Action的变量名:
      *
      * 只有在query string中不包含任何3个参数之一的情况下, Yaf_Route_Simple才会返回失败, 将路由权交给下一个路由协议.
      */
     /**
      * 指定3个变量名
      */
      $route = new Yaf_Route_Simple("m", "c", "a");
      $router->addRoute("name", $route);
     /**
      * 对于如下请求: "http://domain.com/index.php?c=index&a=test"
      * 能得到如下路由结果
      */
    array(
        'module'     => '默认模块',
        'controller' => 'index',
        'action'     => 'test',
    )
```

- Yaf_Route_Supervar

```bash
    <?php
     /**
      * Yaf_Route_Supervar和Yaf_Route_Simple相似, 都是在query string中获取路由信息, 不同的是, 它获取的是一个类似包含整个路由信息的request_uri
      *
      * 在query string中不包含supervar变量的时候, Yaf_Route_Supervar会返回失败, 将路由权交给下一个路由协议.
      */
     /**
      * 指定supervar变量名
      */
     $route = new Yaf_Route_Supervar("r");
     $router->addRoute("name", $route);
     /**
      * 对于如下请求: "http://domain.com/index.php?r=/a/b/c"
      * 能得到如下路由结果
      */
     array(
        'module'     => 'a',
        'controller' => 'b',
        'action'     => 'c',
     )
```

- Yaf_Route_Map

```bash
    <?php
     /**
      * Yaf_Route_Map议是一种简单的路由协议, 它将REQUEST_URI中以'/'分割的节, 组合在一起, 形成一个分层的控制器或者动作的路由结果. 
      * Yaf_Route_Map的构造函数接受俩个参数, 第一个参数表示路由结果是作为动作的路由结果,还是控制器的路由结果.
      * 默认的是动作路由结果. 第二个参数是一个字符串, 表示一个分隔符, 如果设置了这个分隔符, 那么在REQUEST_URI中, 分隔符之前的作为路由信息载体, 而之后的作为请求参数.
      */
     /**
      * 对于请求request_uri为"/ap/foo/bar"
      * base_uri为"/ap"
      * 则最后参加路由的request_uri为"/foo/bar"
      * 然后, 通过对URL分段, 得到如下分节
      * foo, bar
      * 组合在一起以后, 得到路由结果foo_bar
      * 然后根据在构造Yaf_Route_Map的时候, 是否指明了控制器优先,
      * 如果没有, 则把结果当做是动作的路由结果
      * 否则, 则认为是控制器的路由结果
      * 默认的, 控制器优先为FALSE
      */
```

- Yaf_Route_Rewrite

```bash
    <?php
     //创建一个路由协议实例
     $route = new Yaf_Route_Rewrite(
     　　'product/:ident',
     　　array(
     　　　　'controller' => 'products',
     　　　　'action' => 'view'
     　　)
     );
     //使用路由器装载路由协议
     $router->addRoute('product', $route);

     //"http://domain.com/product/chocolate-bar/test/value1/another/value2"
     //根据上述路由 得到的参数为
     //ident = chocolate-bar
     //test = value1
     //another = value2
```

- Yaf_Route_Regex

```bash
    <?php
        //完成数字到字符变量的映射
        $route = new Yaf_Route_Regex( 'product/([a-zA-Z-_0-9]+)', array( 'controller' => 'products', 'action' => 'view'), array(1 => 'ident'));
        $router->addRoute('product', $route);
        //将变量1映射到ident变量名
```

- 自定义路由协议
申明自定义路由协议实现了Yaf_Route_Interface接口