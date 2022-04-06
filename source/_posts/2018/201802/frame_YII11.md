---
title: PHP_Yii框架 (11)
date: 2018-02-07
tags: Yii
toc: true
---

#### session 
    在纯 PHP 中,可以分别使用全局变量 $_SESSION 和 $_COOKIE 来访问,Yii 将 session 和 cookie 封装成对象并增加一些功能, 可通过面向对象方式访问它们

<!-- more -->

- 开启和关闭session
    ```php
        //多次调用open() 和close() 方法并不会产生错误, 因为方法内部会先检查session是否已经开启
        $session = Yii::$app->session;

        // 检查session是否开启 
        if ($session->isActive) ...

        // 开启session
        $session->open();

        // 关闭session
        $session->close();

        // 销毁session中所有已注册的数据
        $session->destroy();
    ```

- 访问session数据
    ```php
        // 当使用 session 组件访问 session 数据时候, 如果 session 没有开启会自动开启, 
        // $_SESSION 不同,$_SESSION 要求先执行 session_start().
        $session = Yii::$app->session;

        // 获取session中的变量值,以下用法是相同的: 
        $language = $session->get('language');
        $language = $session['language'];
        $language = isset($_SESSION['language']) ? $_SESSION['language'] : null;

        // 设置一个session变量,以下用法是相同的: 
        $session->set('language', 'en-US');
        $session['language'] = 'en-US';
        $_SESSION['language'] = 'en-US';

        // 删除一个session变量,以下用法是相同的: 
        $session->remove('language');
        unset($session['language']);
        unset($_SESSION['language']);

        // 检查session变量是否已存在,以下用法是相同的: 
        if ($session->has('language')) ...
        if (isset($session['language'])) ...
        if (isset($_SESSION['language'])) ...

        // 遍历所有session变量,以下用法是相同的: 
        foreach ($session as $name => $value) ...
        foreach ($_SESSION as $name => $value) .
    ```

#### cookies

- 读取Cookies 
    ```php
        // 从 "request" 组件中获取 cookie 集合(yii\web\CookieCollection)
        $cookies = Yii::$app->request->cookies;

        // 获取名为 "language" cookie 的值,如果不存在,返回默认值 "en"
        $language = $cookies->getValue('language', 'en');

        // 另一种方式获取名为 "language" cookie 的值
        if (($cookie = $cookies->get('language')) !== null) {
            $language = $cookie->value;
        }

        // 可将 $cookies 当作数组使用
        if (isset($cookies['language'])) {
            $language = $cookies['language']->value;
        }

        // 判断是否存在名为"language" 的 cookie
        if ($cookies->has('language')) ...
        if (isset($cookies['language'])) ...
    ```

- 发送Cookies
    ```php
        // 从 "response" 组件中获取 cookie 集合(yii\web\CookieCollection)
        $cookies = Yii::$app->response->cookies;

        // 在要发送的响应中添加一个新的 cookie
        $cookies->add(new \yii\web\Cookie([
            'name' => 'language',
            'value' => 'zh-CN',
        ]));

        // 删除一个 cookie
        $cookies->remove('language');
        // 等同于以下删除代码
        unset($cookies['language']);
    ```