---
title: PHP_Yii框架 (5)
date: 2018-01-31
tags: Yii
toc: true
---

### 视图
- 内容
    * 应主要包含展示代码，如HTML, 和简单的PHP代码来控制、格式化和渲染数据；
    * 不应包含执行数据查询代码，这种代码放在模型中；
    * 应避免直接访问请求数据，如 \$_GET, $_POST，这种应在控制器中执行， 如果需要请求数据，应由控制器推送到视图。
    * 可读取模型属性，但不应修改它们
- 遵循方法
    * 使用 布局 来展示公共代码（如，页面头部、尾部）；
    * 将复杂的视图分成几个小视图，可使用上面描述的渲染方法将这些 小视图渲染并组装成大视图；
    * 创建并使用 小部件 作为视图的数据块；
    * 创建并使用助手类在视图中转换和格式化数据。

<!-- more -->

#### 创建视图
```bash
    <?php
    use yii\helpers\Html;
    use yii\widgets\ActiveForm;

    /* @var $this yii\web\View */
    /* @var $form yii\widgets\ActiveForm */
    /* @var $model app\models\LoginForm */

    $this->title = 'Login';
    ?>
    <h1><?= Html::encode($this->title) ?></h1>

    <p>Please fill out the following fields to login:</p>

    <?php $form = ActiveForm::begin(); ?>
        <?= $form->field($model, 'username') ?>
        <?= $form->field($model, 'password')->passwordInput() ?>
        <?= Html::submitButton('Login') ?>
    <?php ActiveForm::end(); ?>
```

#### 渲染视图
- 控制器中渲染
    * render(): 渲染一个 视图名 并使用一个 布局 返回到渲染结果。
    * renderPartial(): 渲染一个 视图名 并且不使用布局
    * renderAjax(): 渲染一个 视图名 并且不使用布局， 并注入所有注册的JS/CSS脚本和文件，通常使用在响应AJAX网页请求的情况下。别名下的视图文件。
    ```bash
        namespace app\controllers;

        use Yii;
        use app\models\Post;
        use yii\web\Controller;
        use yii\web\NotFoundHttpException;

        class PostController extends Controller
        {
            public function actionView($id)
            {
                $model = Post::findOne($id);
                if ($model === null) {
                    throw new NotFoundHttpException;
                }

                // 渲染一个名称为"view"的视图并使用布局
                return $this->render('view', [
                    'model' => $model,
                ]);
            }
        }
    ```
- 小部件中渲染
    * render(): 渲染一个 视图名.
    * 别名下的视图文件。
    ```bash
        namespace app\components;

        use yii\base\Widget;
        use yii\helpers\Html;

        class ListWidget extends Widget
        {
            public $items = [];

            public function run()
            {
                // 渲染一个名为 "list" 的视图
                return $this->render('list', [
                    'items' => $this->items,
                ]);
            }
        }
    ```
- 视图中渲染
    * render(): 渲染一个 视图名.
    * renderAjax(): 渲染一个 视图名 并注入所有注册的JS/CSS脚本和文件，通常使用在响应AJAX网页请求的情况下。
    * 别名下的视图文件
    ```bash
        <?= $this->render('_overview') ?>
    ```
- 其他地方渲染
    ```bash
        //在任何地方都可以通过表达式 Yii::$app->view 访问 view 应用组件

        // 显示视图文件 "@app/views/site/license.php"
        echo \Yii::$app->view->renderFile('@app/views/site/license.php');

        系统定义的路径别名

        复制代码
        @yii ——框架的目录。
        @app——当前正在运行的应用程序的基本路径。
        @common -公共文件目录。
        @frontend——前端web应用程序目录。
        @backend ——后端web应用程序目录。
        @console -控制台目录。
        @runtime——当前正在运行的web应用程序的运行时目录
        @vendor ——基础框架目录。
        @web ——当前正在运行的web应用程序的url
        @webroot——当前正在运行的web应用程序的web根目录。
    ```
- 视图名
    * 视图名可省略文件扩展名，这种情况下使用 .php 作为扩展， 视图名 about 对应到 about.php 文件名
    * 视图文件对应在view/控制器名/文件夹内
- 视图中访问数据
    ```bash
        echo $this->render('report', [
            'foo' => 1,
            'bar' => 2,
        ]);
    ```
- 视图间共享数据
    ```bash
        $this->params['breadcrumbs'][] = 'About Us';

        <?= yii\widgets\Breadcrumbs::widget([
            'links' => isset($this->params['breadcrumbs']) ? $this->params['breadcrumbs'] : [],
        ]) ?>
    ```

#### 布局
    布局是一种特殊的视图，代表多个视图的公共部分
    模块中使用的布局应存储在 yii\base\Module::basePath模块目录下的views/layouts路径下， 
    可配置yii\base\Module::layoutPath来自定义应用或模块的布局默认路径。

#### 使用视图组件     
- 主题 : 允许为你的Web站点开发和修改主题；
- 片段缓存 : 允许你在Web页面中缓存片段；
- 客户脚本处理 : 支持CSS 和 JavaScript 注册和渲染；
- 资源包处理 : 支持 资源包的注册和渲染；
- 模板引擎 : 允许你使用其他模板引擎，如 Twig, Smarty。
- 设置页面标题
    ```bash
        <?php
            $this->title = 'My page title';
        ?>

        <head>
            <title><?= Html::encode($this->title) ?></title>
        </head>
    ```
- 注册Meta元标签
    ```bash
        <?php
            $this->registerMetaTag(['name' => 'keywords', 'content' => 'yii, framework, php']);
        ?>
    ```
- 注册链接标签
    ```bash
        $this->registerLinkTag([
            'title' => 'Live News for Yii',
            'rel' => 'alternate',
            'type' => 'application/rss+xml',
            'href' => 'http://www.yiiframework.com/rss.xml/',
        ]);
    ```