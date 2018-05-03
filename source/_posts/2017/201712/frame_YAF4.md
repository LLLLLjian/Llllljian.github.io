---
title: PHP_yaf框架 (4)
date: 2017-12-20
tags: YAF
toc: true
---

### MVC

#### M Model 模型
```bash
    在控制器中，调用数据，我们先将它实例化一个模型
    $userModel=new UserModel();
    echo $userModel->getUserInfo(1);

    当我们在控制器中实例化一个不存在的模型类的时候，yaf就会在application的models下寻找这个模型类
    模型类文件名不需要带Model后缀，类文件如下

    class UserModel 
    {
        /**
        * 通过id获取用户相关信息
        * $id int 用户id
        */
        public function getUserInfoById($id)
        {
            return "hi.user,id=".$id;
        }
    }
```

<!-- more -->

#### V View 视图
```bash
    默认开始模板渲染，不使用模板如下
    Yaf_Dispatcher::getInstance()->autoRender(false); 
    或者
    $dispatcher->getInstance()->disableView();

    默认模板文件后缀为phtml，修改默认模板文件后缀，修改application.ini
    application.view.ext = "html"

    控制器中使用
    其它参数
    assign 相当于变量赋值

    $this->getView()->assign('user','lvtao'); //模板文件中直接用php语法输出
    render 渲染结果

    echo $this->getView()->render('User/index.phtml');
    display 渲染并输出

    $this->getView()->display('User/index.phtml');
    setScriptPath 设置模板的基目录

    $this->getView()->setScriptPath('/template/index.phtml');
    getScriptPath 获取当前模板路径 直接输出，不需要参数
    __set 为视图引擎分配一个模板变量, 在视图模板中可以直接通过${$name}获取模板变量值

    $this->getView()->name = "value";
    __get 获取视图引擎的一个模板变量值

    echo $this->_view->name;
    get 获取视图引擎的一个模板变量值

    echo $this->_view->get("name");
```

#### C Controller 控制器
```bash
    位置：controllers下
    默认index.php
    我们访问的时候相当于访问的是"www.demo/module/controller/action" 对应的三个index就是模块、控制器、动作
    命名规则：控制器文件名不需要以Controller结尾，要继承Yaf_controller_Abstract抽象类，类名需要以Controller结尾，方法需要以Action结尾 

    Class userController extends Yaf_controller_Abstract
    {
        public function indexAction ()
        {
            
        }
    }

    如果在application.ini中定义了模块功能，则需要在modules目录下建立模块目录(首字母大写)，再建controllers目录
```

### 异常和错误
- 异常模式
    在app;ocation.ini中设置application.dispatcher.catchException
    或者可通过Yaf_Dispatcher::catchException(true))开启的情况下, 当Yaf遇到未捕获异常的时候, 就会把运行权限, 交给当前模块的Error Controller的Error Action动作, 而异常或作为请求的一个参数, 传递给Error Action.

    在Error Action中可以通过$request->getRequest()->getParam("exception")获取当前发生的异常.

    ```bash
        <?php

        /**
         * 当有未捕获的异常, 则控制流会流到这里
         */
        class ErrorController extends Yaf_Controller_Abstract 
        {
            /**
             * 此时可通过$request->getException()获取到发生的异常
             */
            public function errorAction() 
            {
                $exception = $this->getRequest()->getException();
                
                try {
                    throw $exception;
                } catch (Yaf_Exception_LoadFailed $e) {
                    //加载失败
                } catch (Yaf_Exception $e) {
                    //其他错误
                }
            }
        }
    ```
- 错误模式

