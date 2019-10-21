---
title: PHP_ThinkPHP框架 (6)
date: 2019-04-12
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-模板
    PHP框架学习之路

<!-- more -->

#### 模板渲染
    fetch('[模板文件]'[,'模板变量(数组)'])
- list
    * 不带任何参数 : 自动定位当前操作的模板文件
    * \[模块@]\[控制器/]\[操作] : 常用写法,支持跨模块
    * 完整的模板文件名 : 直接使用完整的模板文件名(包括模板后缀)

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
- 系统变量输出
    * 普通的模板变量需要首先赋值后才能在模板中输出,但是系统变量则不需要,可以直接在模板中输出,系统变量的输出通常以**{$Think** 打头
    * eg
        ```php
            {$Think.server.script_name} // 输出$_SERVER['SCRIPT_NAME']变量
            {$Think.session.user_id} // 输出$_SESSION['user_id']变量
            {$Think.get.pageNumber} // 输出$_GET['pageNumber']变量
            {$Think.cookie.name} // 输出$_COOKIE['name']变量
        ```
- 常量输出
    * {$Think.const.APP_PATH} || {$Think.APP_PATH}
- 配置输出
    * {$Think.config.default_module}
    * {$Think.config.default_controller}
- 语言变量
    * {$Think.lang.page_error}
    * {$Think.lang.var_error}

#### 请求参数
    模板支持直接输出 Request 请求对象的方法参数,用法为$Request.方法名.参数
- eg
    ```php
        // 调用Request对象的get方法 传入参数为id
        {$Request.get.id}
        // 调用Request对象的param方法 传入参数为name
        {$Request.param.name}
        // 调用Request对象的param方法 传入参数为user.nickname
        {$Request.param.user.nickname}
        // 调用Request对象的root方法
        {$Request.root}
        // 调用Request对象的root方法,并且传入参数true
        {$Request.root.true}
        // 调用Request对象的path方法
        {$Request.path}
        // 调用Request对象的module方法
        {$Request.module}
        // 调用Request对象的controller方法
        {$Request.controller}
        // 调用Request对象的action方法
        {$Request.action}
        // 调用Request对象的ext方法
        {$Request.ext}
        // 调用Request对象的host方法
        {$Request.host}
        // 调用Request对象的ip方法
        {$Request.ip}
        // 调用Request对象的header方法
        {$Request.header.accept-encoding}
    ```

#### 使用运算符
- list
    <table><tr><th>运算符</th><th>使用示例</th></tr><tr><td>+</td><td>{$a+$b}</td></tr><tr><td>-</td><td>{$a-$b}</td></tr><tr><td>*</td><td>{$a*$b}</td></tr><tr><td>/</td><td>{$a/$b}</td></tr><tr><td>%</td><td>{$a%$b}</td></tr><tr><td>++</td><td>{$a++} 或 {++$a}</td></tr><tr><td>--</td><td>{$a--} 或 {--$a}</td></tr><tr><td>综合运算</td><td>{$a+$b*10+$c}</td></tr></table>

#### 三元运算
- 三元运算符
    ```php
        {$status? '正常' : '错误'}
        {$info['status']? $info['msg'] : $info['error']}
        {$info.status? $info.msg : $info.error }
    ```
- isset
    * {$varname.aa ?? 'xxx'}
    * =====
    * <?php echo isset($varname['aa']) ? $varname['aa'] : '默认值'; ?>
- empty
    * {$varname?='xxx'}
    * =====
    * <?php if(!empty($name)) echo 'xxx'; ?>

#### 模板布局
- 全局配置方式
    ```php
        config.php
        'template' => [
            // 开启模板布局
            'layout_on' => true,
            // 模板布局位置
            'layout_name' => 'layout',
            // 替换字符串
            'layout_item' => '{__REPLACE__}'
        ]

        application/index/view/layout.html
        {include file="public/header" /}
        {__REPLACE__}
        {include file="public/footer" /}
    ```
- 模板标签方式
    * 普通输出模板
        * {layout name="layout" /}
    * 使用其他的布局模板
        * {layout name="newlayout" /}
    * 指定要替换的特定字符串
        * {layout name="Layout/newlayout" replace="[__REPLACE__]" /}
- 使用layout控制模板布局
    ```php
        namespace app\index\controller;
        
        use think\Controller;
        
        class User extends Controller
        {
            public function add()
            {
                // 模板输出启用了布局模板,并且采用默认的layout布局模板.
                $this->view->engine->layout(true);
                // 要使用不同的布局模板,可以动态的指定布局模板名称
                //$this->view->engine->layout('Layout/newlayout');
                // 动态关闭当前模板的布局功能
                //$this->view->engine->layout(false);
                return $this->fetch('add');
            }
        }
    ```


