---
title: PHP_Yii框架 (8)
date: 2018-02-03
tags: Yii
toc: true
---

### 前端资源
    Yii中的资源是和Web页面相关的文件，可为CSS文件，JavaScript文件，图片或视频等， 资源放在Web可访问的目录下，直接被Web服务器调用

<!-- more -->

#### 资源包
    Yii在资源包中管理资源，资源包简单的说就是放在一个目录下的资源集合， 当在视图中注册一个资源包， 在渲染Web页面时会包含包中的CSS和JavaScript文件
- 定义资源包
    * 资源包指定为继承yii\web\AssetBundle的PHP类， 包名为可自动加载的PHP类名， 在资源包类中，要指定资源所在位置， 包含哪些CSS和JavaScript文件以及和其他包的依赖关系
        ```bash
            <?php

            namespace app\assets;

            use yii\web\AssetBundle;

            class AppAsset extends AssetBundle
            {
                public $basePath = '@webroot';
                public $baseUrl = '@web';
                public $css = [
                    'css/site.css',
                ];
                public $js = [
                ];
                //依赖关系，先加载依赖关系中的资源，再加载$css $js
                public $depends = [
                    'yii\web\YiiAsset',
                    'yii\bootstrap\BootstrapAsset',
                ];
            }
        ```
    * 当根目录不能被Web访问时该属性应设置，否则，应设置 basePath 属性和baseUrl。 路径别名 可在此处使用
    * 当指定sourcePath 属性， 资源管理器 会发布包的资源到一个可Web访问并覆盖该属性， 如果你的资源文件在一个Web可访问目录下，应设置该属性，这样就不用再发布了。 路径别名 可在此处使用
    * 和 basePath 类似， 如果你指定 sourcePath 属性， 资源管理器 会发布这些资源并覆盖该属性，路径别名 可在此处使用。
    * 注意正斜杠"/"应作为目录分隔符， 每个JavaScript文件可指定为以下两种格式之一：
        ```bash
            相对路径表示为本地JavaScript文件 (如 js/main.js)，文件实际的路径在该相对路径前加上yii\web\AssetManager::$basePath，文件实际的URL 在该路径前加上yii\web\AssetManager::$baseUrl。
            绝对URL地址表示为外部JavaScript文件，如 http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js 或 //ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js.
        ```
    * 该数组格式和 js 相同
    * jsOptions: 当调用yii\web\View::registerJsFile()注册该包 每个 JavaScript文件时， 指定传递到该方法的选项
    * cssOptions: 当调用yii\web\View::registerCssFile()注册该包 每个 css文件时， 指定传递到该方法的选项
    * 指定传递到该方法的选项，仅在指定了 sourcePath属性时使用
- 资源位置
    * 源资源 : 资源文件和PHP源代码放在一起，不能被Web直接访问，为了使用这些源资源， 它们要拷贝到一个可Web访问的Web目录中 成为发布的资源，这个过程称为发布资源，随后会详细介绍。
    * 发布资源 : 资源文件放在可通过Web直接访问的Web目录中；
    * 外部资源 : 资源文件放在与你的Web应用不同 的Web服务器上
- 资源依赖
    资源依赖主要通过yii\web\AssetBundle::$depends 属性来指定，在AppAsset 示例中，资源包依赖其他两个资源包： yii\web\YiiAsset 和 yii\bootstrap\BootstrapAsset 也就是该资源包的CSS和JavaScript文件要在这两个依赖包的文件包含 之后 才包含
- 资源选项

#### 自定义加载
- 文件加载在head中,只要在视图页面直接引入即可
    ```bash
        AppAsset::register($this);  
        //css定义一样  
        $this->registerCssFile('@web/css/font-awesome.min.css',['depends'=>['api\assets\AppAsset']]);  
        
        $this->registerJsFile('@web/js/jquery-ui.custom.min.js',['depends'=>['api\assets\AppAsset']]);  
    ```
- 文件加载在body中,需要通过资源依赖
    ```bash
        //在/assets/AppAsset.php中定义
        //定义按需加载JS方法，注意加载顺序在最后  
        public static function addScript($view, $jsfile) 
        {  
            //api替换为自己的模板APP.如advance 替换为frountend或backend
            $view->registerJsFile($jsfile, [AppAsset::className(), 'depends' => 'api\assets\AppAsset']);  
        }  

        //在视图中使用
        AppAsset::register($this);  
        //只在该视图中使用非全局的jui   
        AppAsset::addScript($this,'@web/js/jquery-ui.custom.min.js');  
    ```

### 扩展
- 核心扩展
    * yiisoft/yii2-apidoc : 提供了一个可扩展的、高效的 API 文档生成器。核心框架的 API 文档也是用它生成的。
    * yiisoft/yii2-authclient : 提供了一套常用的认证客户端，例如 Facebook OAuth2 客户端、GitHub OAuth2 客户端。
    * yiisoft/yii2-bootstrap : 提供了一套挂件，封装了 Bootstrap 的组件和插件。
    * yiisoft/yii2-codeception : 提供了基于 Codeception 的测试支持。
    * yiisoft/yii2-debug : 提供了对 Yii 应用的调试支持。当使用该扩展是， 在每个页面的底部将显示一个调试工具条。 该扩展还提供了一个独立的页面，以显示更详细的调试信息。
    * yiisoft/yii2-elasticsearch : 提供对 Elasticsearch 的使用支持。它包含基本的查询/搜索支持， 并实现了 Active Record 模式让你可以将活动记录 存储在 Elasticsearch 中。
    * yiisoft/yii2-faker : 提供了使用 Faker 的支持，为你生成模拟数据。
    * yiisoft/yii2-gii : 提供了一个基于页面的代码生成器，具有高可扩展性，并能用来快速生成模型、 表单、模块、CRUD等。
    * yiisoft/yii2-httpclient : provides an HTTP client.
    * yiisoft/yii2-imagine : 提供了基于 Imagine 的常用图像处理功能。
    * yiisoft/yii2-jui : 提供了一套封装 JQuery UI 的挂件以及它们的交互。
    * yiisoft/yii2-mongodb : 提供了对 MongoDB 的使用支持。它包含基本 的查询、活动记录、数据迁移、缓存、代码生成等特性。
    * yiisoft/yii2-redis : 提供了对 redis 的使用支持。它包含基本的 查询、活动记录、缓存等特性。
    * yiisoft/yii2-smarty : 提供了一个基于 Smarty 的模板引擎。
    * yiisoft/yii2-sphinx : 提供了对 Sphinx 的使用支持。它包含基本的 查询、活动记录、代码生成等特性。
    * yiisoft/yii2-swiftmailer : 提供了基于 swiftmailer 的邮件发送功能。
    * yiisoft/yii2-twig : 提供了一个基于 Twig 的模板引擎。