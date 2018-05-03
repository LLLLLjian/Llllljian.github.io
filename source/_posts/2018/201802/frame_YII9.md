---
title: PHP_Yii框架 (9)
date: 2018-02-05
tags: Yii
toc: true
---

### 请求处理
- 运行机制概述
    * 用户提交指向 入口脚本 web/index.php 的请求。
    * 入口脚本会加载 配置数组 并创建一个 应用 实例用于处理该请求。
    * 应用会通过 request（请求） 应用组件 解析被请求的 路由。
    * 应用创建一个 controller（控制器） 实例具体处理请求。
    * 控制器会创建一个 action（动作） 实例并为该动作执行相关的 Filters（访问过滤器）。
    * 如果任何一个过滤器验证失败，该动作会被取消。
    * 如果全部的过滤器都通过，该动作就会被执行。
    * 动作会加载一个数据模型，一般是从数据库中加载。
    * 动作会渲染一个 View（视图），并为其提供所需的数据模型。
    * 渲染得到的结果会返回给 response（响应） 应用组件。
    * 响应组件会把渲染结果发回给用户的浏览器。

<!-- more -->

#### 路由
- 传入的请求被解析为一个路由和相关的查询参数
- 创建与解析路线相对应的控制器动作以处理该请求
	* 将该应用程序设置为当前模块。
	* 检查当前模块的控制器映射是否包含当前ID。如果是这样，将根据地图中找到的控制器配置创建控制器对象，并且将采取步骤5来处理路线的其余部分。
	* 检查ID是否指向当前模块的yii \ base \ Module :: modules属性中列出的模块。如果是这样，则根据在模块列表中找到的配置创建模块，并且将采取步骤2在新创建的模块的上下文中处理路线的下一部分。
	* 将ID作为控制器ID并创建一个控制器对象。用路线的其余部分进行下一步。
	* 控制器在其动作映射中查找当前ID 。如果找到，它会根据地图中找到的配置创建一个操作。否则，控制器将尝试创建一个内联动作，该动作由与当前动作ID相对应的动作方法定义。
- 缺省路由
    * 如果传入请求并没有提供一个具体的路由,就返回默认值,可以在应用配置中设置默认路由
    ```bash
        return [
            // ...
            'defaultRoute' => 'main/index',
        ];
    ```
- 全拦截路由
    * 设置所有的请求都显示相同的信息页，可以在应用配置中直接设置
    ```bash
        return [
            // ...
            'catchAll' => ['site/offline'],
        ];
    ```

#### 创建网址
    Yii提供了一个辅助方法yii \ helpers \ Url :: to（），根据给定的路由及其关联的查询参数创建各种URL
- 如果路由是空字符串，则将使用当前请求的yii \ web \ Controller :: route ;
- 如果路由根本不包含任何斜线，则它被认为是当前控制器的动作ID，并且会以当前控制器的yii \ web \ Controller :: uniqueId值作为前缀。
- 如果路由没有前导斜杠，则认为该路由是相对于当前模块的路由，并且会以当前模块的yii \ base \ Module :: uniqueId值作为前缀
```bash
    //假定使用的是默认URL格式[无模块]
    use yii\helpers\Url;

    //当前路由
    echo Url::to();

    //  /index.php?r=post%2Findex
    echo Url::to(['post/index']);

    //  /index.php?r=post%2Fview&id=100
    echo Url::to(['post/view', 'id' => 100]);

    // 创建一个锚点相关的url /index.php?r=post%2Fview&id=100#content
    echo Url::to(['post/view', 'id' => 100, '#' => 'content']);

    // 创建一个绝对路径的URL: http://www.xxxxx.com/index.php?r=post%2Findex
    echo Url::to(['post/index'], true);

    // 使用HTTPS方式创建绝对URL: https://www.xxxxx.com/index.php?r=post%2Findex
    echo Url::to(['post/index'], 'https');
```
```bash
    //假定使用的是默认URL格式[当前模块是admin当前控制器post]
    use yii\helpers\Url;

    // 当前路由
    echo Url::to(['']);

    // action
    echo Url::to(['index']);

    // controller/action
    echo Url::to(['post/index']);

    // module/controller
    echo Url::to(['/post/index']);

    // /index.php?r=post%2Findex
    echo Url::to(['@posts']);
```

#### URL美化
    应用程序配置中配置组件
```bash
    [
        'components' => [
            'urlManager' => [
                //强制 切换对应url
                'enablePrettyUrl' => true,
                //是否应将条目甲苯包含在创建的url
                'showScriptName' => false,
                //是否启用严格请求解析
                'enableStrictParsing' => false,
                //允许URL管理器识别请求的URL，并创建带有.html后缀的URL
                //当配置了URL后缀时,如果请求的URL没有后缀,它将被视为无法识别的URl
                'suffix' => '.html',
                //网站规则
                'rules' => [
                    // 命名参数
                    [
                        //eg： index.php/posts/2018/php => 路由为post/index,year=2018,category=php 
                        'posts/<year:\d{4}>/<category>' => 'post/index',
                        //eg： index.php/posts => 路由为post/index
                        'posts' => 'post/index',
                        //eg： index.php/post/100 => 路由为post/view,id=100
                        'post/<id:\d+>' => 'post/view',
                    ],
                    // 参数化路线
                    [
                        //eg： index.php/posts：page是1，tag是''。
                        //eg： index.php/posts/2：page是2，tag是''。
                        //eg： index.php/posts/2/news：page是2，tag是'news'。
                        //eg： index.php/posts/news：page是1，tag是'news'。
                        'pattern' => 'posts/<page:\d+>/<tag>',
                        'route' => 'post/index',
                        'defaults' => ['page' => 1, 'tag' => ''],
                    ],
                    // HTTP方法
                    [
                        // HTTP 方法为 PUT|POST情况的请求 index.php/post/100 => 路由为post/create,id=100
                        'PUT,POST post/<id:\d+>' => 'post/create',
                        'DELETE post/<id:\d+>' => 'post/delete',
                        // HTTP 方法为 GET情况的请求 index.php/post/100 => 路由为post/view,id=100
                        'post/<id:\d+>' => 'post/view',
                    ]
                ],
            ],
        ],
    ]
```
