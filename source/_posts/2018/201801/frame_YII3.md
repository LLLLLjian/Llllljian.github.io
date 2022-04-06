---
title: PHP_Yii框架 (3)
date: 2018-01-29
tags: Yii
toc: true
---

### 控制器

- 控制器作用
    * 可访问、请求数据;
    * 可根据请求数据调用 模型 的方法和其他服务组件
    * 可使用 视图 构造响应;
    * 不应处理应被模型处理的请求数据;
    * 应避免嵌入HTML或其他展示代码,这些代码最好在 视图中处理

<!-- more -->

- 控制器生命周期
    * 前提 : 处理一个请求时,应用主体 会根据请求 路由创建一个控制器, 控制器经过以下生命周期来完成请求
    * 在控制器创建和配置后,yii\base\Controller::init() 方法会被调用
    * 控制器根据请求操作ID创建一个操作对象
        * 如果操作ID没有指定,会使用default action ID默认操作ID
        ```php
            定义在应用配置中
            [
                'defaultRoute' => 'index',
            ]
        ```
        * 如果在action map找到操作ID, 会创建一个独立操作,如果操作ID对应操作方法,会创建一个内联操作
        * 否则会抛出yii\base\InvalidRouteException异常
    * 控制器按顺序调用应用主体、模块(如果控制器属于模块)、 控制器的 beforeAction() 方法
        * 如果任意一个调用返回false,后面未调用的beforeAction()会跳过并且操作执行会被取消； action execution will be cancelled.
        * 默认情况下每个 beforeAction() 方法会触发一个 beforeAction 事件,在事件中你可以追加事件处理操作
    * 控制器执行操作
        * 请求数据解析和填入到操作参数
    * 控制器按顺序调用控制器、模块(如果控制器属于模块)、应用主体的 afterAction() 方法
        * 默认情况下每个 afterAction() 方法会触发一个 afterAction 事件, 在事件中你可以追加事件处理操作、
    * 应用主体获取操作结果并赋值给响应.

- 控制器类命名
    * 将用正斜杠区分的每个单词第一个字母转为大写.注意如果控制器ID包含正斜杠, 只将最后的正斜杠后的部分第一个字母转为大写
    * 去掉中横杠,将正斜杠替换为反斜杠;
    * 增加Controller后缀;
    * 在前面增加controller namespace控制器命名空间

- 创建动作
    * 创建操作可简单地在控制器类中定义所谓的 操作方法 来完成
    * 操作方法必须是以action开头的公有方法. 
    * 操作方法的返回值会作为响应数据发送给终端用户
    ```php
        定义了两个操作 index 和 hello-world:

        namespace app\controllers;

        use yii\web\Controller;

        class SiteController extends Controller
        {
            public function actionIndex()
            {
                return $this->render('index');
            }

            public function actionHelloWorld()
            {
                return 'Hello World';
            }
        }
    ```

- 动作ID
    * 操作通常是用来执行资源的特定操作,因此, 操作ID通常为动词,如view, update等

- 内联动作
    * 将每个单词的第一个字母转为大写;
    * 去掉中横杠;
    * 增加action前缀
    * eg : index 转成 actionIndex, hello-world 转成 actionHelloWorld

- 动作结果
    * 返回值可为 响应 对象,作为响应发送给终端用户

- 动作参数
    *  参数值从请求中获取,
    * 对于Web applications网页应用, 每个动作参数的值从$_GET中获得,参数名作为键； 
    * 对于console applications控制台应用, 动作参数对应命令行参数

- 默认动作
    * 每个控制器都有一个由 yii\base\Controller::$defaultAction 属性指定的默认操作, 
    * 当路由 只包含控制器ID, 会使用所请求的控制器的默认操作.默认操作默认为 index,
    * 如果想修改默认操作,代码如下: 
    ```php
        namespace app\controllers;

        use yii\web\Controller;

        class SiteController extends Controller
        {
            public $defaultAction = 'home';

            public function actionHome()
            {
                return $this->render('home');
            }
        }
    ```
