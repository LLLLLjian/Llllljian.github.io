---
title: PHP_ThinkPHP框架 (2)
date: 2019-04-09
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-控制器
    PHP框架学习之路

<!-- more -->

#### 控制器初始化
- __construct
    * 控制器类没有继承\think\Controller类
    * eg
        ```php
            namespace app\index\controller;

            class Index
            {
                public function __construct()
                {
                    echo "__construct";
                }
            }
        ```
- _initialize
    * 控制器类继承了\think\Controller类
    * eg
        ```php
            namespace app\index\controller;

            use think\Controller;

            class Index extends Controller
            {

                public function _initialize()
                {
                    echo '_initialize';
                }
            }
        ```
- 分析
    ```php
        /**
         * 架构函数
         * @param Request    $request     Request对象
         * @access public
         */
        public function __construct(Request $request = null)
        {
            if (is_null($request)) {
                $request = Request::instance();
            }
            $this->view    = View::instance(Config::get('template'), Config::get('view_replace_str'));
            $this->request = $request;

            // 控制器初始化
            if (method_exists($this, '_initialize')) {
                $this->_initialize();
            }
        }
    ```

#### 前置操作
    可以为某个或者某些操作指定前置执行的操作方法,设置 beforeActionList 属性可以指定某个方法为其他方法的前置操作,数组键名为需要调用的前置方法名,无值的话为当前控制器下所有方法的前置方法.['except' => '方法名,方法名']表示这些方法不使用前置方法,['only' => '方法名,方法名']表示只有这些方法使用前置方法
- eg
    ```php
        namespace app\index\controller;
        use think\Controller;

        class Index extends Controller
        {
            protected $beforeActionList = [
                'first',
                'second' => ['except'=>'hello'],
                'three' => ['only'=>'hello,data'],
            ];

            protected function first()
            {
                echo 'first';
            }

            protected function second()
            {
                echo 'second';
            }
            
            protected function three()
            {
                echo 'three';
            }

            public function hello()
            {
                return 'hello';
            }
            public function data()
            {
                return 'data';
            }
        }

        访问http://localhost/index.php/index/Index/hello
        输出结果是
        first
        three
        hello
        
        访问http://localhost/index.php/index/Index/data
        输出结果是：
        first
        second
        three
        data
    ```

#### 空操作
    空操作是指系统在找不到指定的操作方法的时候,会定位到空操作(_empty)方法来执行,利用这个机制,可以实现错误页面和一些URL的优化
- eg
    ```php
        <?php
        namespace app\index\controller;

        class City
        {
            public function _empty($name)
            {
                //把所有城市的操作解析到city方法
                return $this->showCity($name);
            }

            //注意 showCity方法 本身是 protected 方法
            protected function showCity($name)
            {
                //和$name这个城市相关的处理
                return '当前城市' . $name;
            }
        }

        当访问
        index/city/shenzhen/
        index/city/shagnhai/
        index/city/beijing/

        页面展示结果
        当前城市:shenzhen
        当前城市:shanghai
        当前城市:beijing
    ```


