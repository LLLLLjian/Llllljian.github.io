---
title: PHP_ThinkPHP框架 (5)
date: 2019-04-11
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-视图
    PHP框架学习之路

<!-- more -->

视图实例化
模板引擎
模板赋值
模板渲染
输出替换

#### 内置模板引擎
    在应用配置文件中配置template参数
- eg
    ```php
        'template' => [
            // 模板引擎类型 支持 php think 支持扩展
            'type' => 'Think',
            // 模板路径
            'view_path' => './template/',
            // 模板后缀
            'view_suffix' => 'html',
            // 模板文件名分隔符
            'view_depr' => DS,
            // 模板引擎普通标签开始标记
            'tpl_begin' => '{',
            // 模板引擎普通标签结束标记
            'tpl_end' => '}',
            // 标签库标签开始标记
            'taglib_begin' => '{',
            // 标签库标签结束标记
            'taglib_end' => '}',
        ],
    ```

#### 模板赋值
- assign方法
    * eg
        ```php
            namespace index\app\controller;
            class Index extends \think\Controller
            {
                public function index()
                {
                    // 模板变量赋值
                    $this->assign('name','ThinkPHP');
                    $this->assign('email','thinkphp@qq.com');
                    // 或者批量赋值
                    $this->assign([
                        'name' => 'ThinkPHP',
                        'email' => 'thinkphp@qq.com'
                    ]);
                    // 模板输出
                    return $this->fetch('index');
                }
            }
        ```
- 传入参数方法
    * eg
        ```php
            namespace app\index\controller;
            class Index extends \think\Controller
            {
                public function index()
                {
                    return $this->fetch('index', [
                        'name' => 'ThinkPHP',
                        'email' => 'thinkphp@qq.com'
                    ]);
                }
            }
        ```
- 助手函数
    * eg
        ```php
            class Index extends \think\Controller
            {
                public function index()
                {
                    return view('index', [
                        'name' => 'ThinkPHP',
                        'email' => 'thinkphp@qq.com'
                    ]);
                }
            }
        ```

#### 模板渲染
    fetch('[模板文件]'[,'模板变量（数组）'])
- list
    * 不带任何参数 : 自动定位当前操作的模板文件
    * \[模块@]\[控制器/]\[操作] : 常用写法,支持跨模块
    * 完整的模板文件名 : 直接使用完整的模板文件名（包括模板后缀）

#### 输出替换
    支持对视图输出的内容进行字符替换
- 控制器替换
    ```php
        namespace index\app\controller;
        class Index extends \think\Controller
        {
            public function index()
            {
                $this->assign('name','thinkphp');
                return $this->fetch('index',[],['__PUBLIC__'=>'/public/']);
            }
        }
    ```
- 配置替换
    ```php
        'view_replace_str' => [
            '__PUBLIC__'=>'/public/',
            '__ROOT__' => '/',
        ]
    ```

#### 系统变量



