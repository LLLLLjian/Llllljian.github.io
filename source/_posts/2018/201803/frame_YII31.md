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
    ```bash
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
    ```bash
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
    ```bash
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