---
title: PHP_Yii框架 (10)
date: 2018-02-06
tags: Yii
toc: true
---

### 请求
    一个应用的请求是用 yii\web\Request 对象来表示的,该对象提供了诸如 请求参数（通常是GET参数或者POST参数）、HTTP头、cookies等信息

<!-- more -->

#### 请求参数
    ```php
        $request = Yii::$app->request;

        $get = $request->get(); 
        // 等价于: $get = $_GET;

        $id = $request->get('id');   
        // 等价于: $id = isset($_GET['id']) ? $_GET['id'] : null;

        $id = $request->get('id', 1);   
        // 等价于: $id = isset($_GET['id']) ? $_GET['id'] : 1;

        $post = $request->post(); 
        // 等价于: $post = $_POST;

        $name = $request->post('name');   
        // 等价于: $name = isset($_POST['name']) ? $_POST['name'] : null;

        $name = $request->post('name', '');   
        // 等价于: $name = isset($_POST['name']) ? $_POST['name'] : '';

        $request = Yii::$app->request;

        // 返回所有参数
        $params = $request->bodyParams;

        // 返回参数 "id"
        $param = $request->getBodyParam('id');
    ```

#### 请求方法
    ```php
        $request = Yii::$app->request;

        if ($request->isAjax) { /* 该请求是一个 AJAX 请求 */ }
        if ($request->isGet)  { /* 请求方法是 GET */ }
        if ($request->isPost) { /* 请求方法是 POST */ }
        if ($request->isPut)  { /* 请求方法是 PUT */ }
    ```

#### 请求URL
    ```php
        eg : http://example.com/admin/index.php/product?id=100

        yii\web\Request::url:返回 /admin/index.php/product?id=100, 此URL不包括host info部分.
        yii\web\Request::absoluteUrl:返回 http://example.com/admin/index.php/product?id=100, 包含host infode的整个URL.
        yii\web\Request::hostInfo:返回 http://example.com, 只有host info部分.
        yii\web\Request::pathInfo:返回 /product, 这个是入口脚本之后,问号之前（查询字符串）的部分.
        yii\web\Request::queryString:返回 id=100,问号之后的部分.
        yii\web\Request::baseUrl:返回 /admin, host info之后, 入口脚本之前的部分.
        yii\web\Request::scriptUrl:返回 /admin/index.php, 没有path info和查询字符串部分.
        yii\web\Request::serverName:返回 example.com, URL中的host name.
        yii\web\Request::serverPort:返回 80, 这是web服务中使用的端口.
    ```

#### HTTP头
    ```php
        // $headers 是一个 yii\web\HeaderCollection 对象
        $headers = Yii::$app->request->headers;

        // 返回 Accept header 值
        $accept = $headers->get('Accept');

        if ($headers->has('User-Agent')) { /* 这是一个 User-Agent 头 */ }

        // 返回 User-Agent 头
        $userAgent = $headers->get('userAgent');

        // 返回 Content-Type 头的值, Content-Type 是请求体中MIME类型数据
        $contentType = $headers->get('contentType');

        // 返回用户可接受的内容MIME类型. 返回的类型是按照他们的质量得分来排序的.得分最高的类型将被最先返回.
        $acceptableContentTypes = $headers->get('acceptableContentTypes');

        // 返回用户可接受的语言
        $acceptableLanguages = $headers->get('acceptableLanguages');
    ```

#### 客户端信息
    ```php
        //获取host name
        $userHost = Yii::$app->request->userHost;
        //获取客户机的IP地址
        $userIP = Yii::$app->request->userIP;
    ```

### 响应
    当应用完成处理一个请求后, 会生成一个response响应对象并发送给终端用户 响应对象包含的信息有HTTP状态码,HTTP头和主体内容等, 网页应用开发的最终目的本质上就是根据不同的请求构建这些响应对象

#### 状态码
    ```php
        //设置状态码为200
        Yii::$app->response->statusCode = 200;

        //如果指定请求失败,可以抛出相对应的HTTP异常
        throw new \yii\web\NotFoundHttpException; 状态码404
        yii\web\BadRequestHttpException:状态码 400.
        yii\web\ConflictHttpException:状态码 409.
        yii\web\ForbiddenHttpException:状态码 403.
        yii\web\GoneHttpException:状态码 410.
        yii\web\MethodNotAllowedHttpException:状态码 405.
        yii\web\NotAcceptableHttpException:状态码 406.
        yii\web\NotFoundHttpException:状态码 404.
        yii\web\ServerErrorHttpException:状态码 500.
        yii\web\TooManyRequestsHttpException:状态码 429.
        yii\web\UnauthorizedHttpException:状态码 401.
        yii\web\UnsupportedMediaTypeHttpException:状态码 415.

        //也可以新创建一个异常,带上状态码抛出
        throw new \yii\web\HttpException(402);
    ```

#### HTTP 头部
    ```php
        $headers = Yii::$app->response->headers;

        // 增加一个 Pragma 头,已存在的Pragma 头不会被覆盖.
        $headers->add('Pragma', 'no-cache');

        // 设置一个Pragma 头. 任何已存在的Pragma 头都会被丢弃
        $headers->set('Pragma', 'no-cache');

        // 删除Pragma 头并返回删除的Pragma 头的值到数组
        $values = $headers->remove('Pragma');
    ```

#### 响应主体
    ```php
        //在发送给终端用户之前需要格式化,应设置 format 和 data 属性,format 属性指定data中数据格式化后的样式
        $response = Yii::$app->response;
        $response->format = \yii\web\Response::FORMAT_JSON;
        $response->data = ['message' => 'hello world'];

        HTML: 通过 yii\web\HtmlResponseFormatter 来实现.
        XML: 通过 yii\web\XmlResponseFormatter来实现.
        JSON: 通过 yii\web\JsonResponseFormatter来实现.
        JSONP: 通过 yii\web\JsonResponseFormatter来实现.
        RAW: use this format if you want to send the response directly without applying any formatting.
    ```

#### 发送文件
    ```php
        // 小文件
        \Yii::$app->response->sendFile('path/to/file.txt');

        // 大文件
        \Yii::$app->response->sendStreamAsFile('path/to/file.txt');
    ```

#### 发送响应
