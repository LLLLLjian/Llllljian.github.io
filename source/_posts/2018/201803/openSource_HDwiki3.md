---
title: HDwiki_源码分析 (3)
date: 2018-03-24
tags: HDwiki
toc: true
---

### control
    MVC中的控制器control 主要负责业务逻辑部分,所有的功能逻辑全部在此实现,控制器对整个功能负责,它调用模型(model)的方法实现它需要的功能,调用视图(view)的方法来显示数据.

    控制器(control)文件存放于 control/文件夹中,命名基本以功能为主,例如doc.php表示就是词条相关的控制器,user.php就是用户相关的控制

<!-- more -->

#### 基本结构
    ```php
        !defined('IN_HDwiki') && exit('Access Denied');

        // 所有类名都叫control 继承 base类
        class control extends base
        {
            // 构造函数 类似于__construct 起初始化作用
            function control(& $get,& $post)
            {
                // 调用父类的构造函数初始化用户,模板,风格,语言等等数据,每个control类都需要这样调用
                $this->base($get, $post);
                // 调用父类的load方法载入user模型(model).按需加载
                $this->load('user');
            }

            // 一般都要添加的方法 用于指定$this->get[1]为空时的操作
            function dodefault
            {
                // 从前台lang或者后台lang中取对应文字
                $categoryNotExist = $this->view->lang['categoryNotExist'];

                // 从缓存文件/data/cache/setting.php中取hottaf
                $hottag = $this->setting['hottag'];

                // 获取当前用户ip
                $ip = $this->ip;

                // 获取当前用户
                $userInfo = $this->user;

                // 处理时间格式
                $date = $this->date(time());

                // $_ENV['user']相当于实例化了user模型,使用了该模型中的get_user方法
                $user = $_ENV['user']->get_user($uid);
                // 类似smarty的传递变量和指定视图文件
                $this->view->assign('user', $user); 
                $this->view->display('space');

                // 通过block加载space
                $_ENV['block']->view('space');
            }
        }
        ?>
    ```
