---
title: PHP_Yii框架 (31)
date: 2018-03-19
tags: Yii
toc: true
---

### Url助手类
    帮助我们更好的管理URL

<!-- more -->

#### 获取通用URL
    ```php
        $relativeHomeUrl = Url::home();
        // string(22) "/advanced/backend/web/"
        var_dump($relativeHomeUrl);
        $absoluteHomeUrl = Url::home(true);
        // string(43) "http://localhost:8080/advanced/backend/web/"
        var_dump($absoluteHomeUrl);       
        $httpsAbsoluteHomeUrl = Url::home('https');
        // string(44) "https://localhost:8080/advanced/backend/web/"
        var_dump($httpsAbsoluteHomeUrl);
        $relativeBaseUrl = Url::base();
        // string(21) "/advanced/backend/web"
        var_dump($relativeBaseUrl);
        $absoluteBaseUrl = Url::base(true);
        // string(42) "http://localhost:8080/advanced/backend/web"
        var_dump($absoluteBaseUrl);
        $httpsAbsoluteBaseUrl = Url::base('https');
        // string(43) "https://localhost:8080/advanced/backend/web" 
        var_dump($httpsAbsoluteBaseUrl);
    ```
#### 创建URL
    ```php
        // 控制器页面
        $url = Url::toRoute(['product/view', 'id' => 42]);
        // /advanced/backend/web/product/view?id=42
        var_dump($url);

        // 视图页面
        // html /advanced/backend/web/site/index 
        <?= Url::toRoute('site/index'); ?>

        // js /advanced/backend/web/site/index
        var url = '<?= Url::to(['site/index']) ?>';
        console.log(url);

        // js /advanced/backend/web/site/index
        var url = '<?= Url::toRoute(['site/index']) ?>';
        console.log(url);

        // js site/index
        // Url::to()要求一个路由必须用数组来指定.如果传的参数为字符串,它将会被直接当做URL
        var url = '<?= Url::to('site/index') ?>';
        console.log(url);         
    ```
#### 记住URL
    ```php
        public function actionIndex() 
        {
            ....
            // 记住当前 URL 
            Url::remember();
            ...
        }

        public function actionView($id) 
        {
            ...
            $url = Url::previous();
            // /advanced/backend/web/banji/index
            var_dump($url);exit;
            ...
        }

        // 类似的
        Url::remember(['product/view', 'id' => 42]);
        /advanced/backend/web/product/view?id=42
        Url::remember(['product/view', 'id' => 45], 'product');
        /advanced/backend/web/product/view?id=45

        // 可以结合header跳转,当发生错误的时候跳转回之前的页面
        header('Refresh:3,Url='.$productUrl);
    ```

#### 返回上一页
- 场景
    * xxx/make页面是从xxx/index页面点击跳转过去的,想在make页面添加一个返回上一页的链接
- 优劣分析
    * 1可以在任意一个action中写remember,根据不同的name去跳转.但命名注意不要重复
    * 2如果直接访问xxx/make,链接会失效
    * 3和4 相当于把url写死,后期要改的话可能比较费事
    * 5如果直接访问xxx/make,链接会失效
- 源码分析
    ```php
        public function actionIndex()
        {
            ...
            // 1.remember 记住当前url, 名称为xxx_index
            Url::remember('', 'xxx_index');
            ...
        }

        public function  actionMake()
        {
            ...
            $url1 = Url::previous("xxx_index");
            echo '<a href="'.$url1.'">返回上一页1</a>';

            $url2 = Yii::$app->request->getReferrer();
            echo '<a href="'.$url2.'">返回上一页2</a>';

            $url3 = Url::to(['xxx/index']);
            echo '<a href="'.$url3.'">返回上一页3</a>';

            $url4 = Url::toRoute(['xxx/index']);
            echo '<a href="'.$url4.'">返回上一页4</a>';

            $url5 = "javascript:history.go(-1)";
            echo '<a href="'.$url5.'">返回上一页5</a>';
            ...
        }
    ```