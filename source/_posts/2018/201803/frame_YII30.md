---
title: PHP_Yii框架 (30)
date: 2018-03-16
tags: Yii
toc: true
---

### Html助手类
    在视图页面生成相应的html代码

<!-- more -->

#### 基础标签生成
- 可生成标签
    * 常使用的 : area、img、input、p、div
- 实例
    ```php
        // 视图页面使用
        use yii\helpers\Html;

        <?= Html::tag('p', Html::encode($model->classname), ['class' => 'classname']) ?>

        <?= Html::tag(
            'button', 
            Html::encode($model->classname), 
            [
                'class' => 'btn btn-danger', 
                'title' => $model->classnotice, 
                'data' => [ 'params' => ['id' => $model->id, 'name' => 'yii'], 'id' => $model->id, 'status' => 'ok']]) ?>

        <?php 
            $options = ['class' => 'btn btn-default'];

            if (($model->id)%2 == 1) {
                Html::removeCssClass($options, 'btn-default');
                // addCssClass防止重复类,会忽略数组格式中具有相同键
                Html::addCssClass($options, 'btn-success');
            }

            echo $model->id;
            echo Html::tag('div', 'Pwede na', $options);
        ?>


        // 效果
        <p class="classname">班级名称4</p>

        <button class="btn btn-danger" title="班级公告4" data-params='{"id":5,"name":"yii"}' data-id="5" data-status="ok">班级名称4</button>

        5<div class="btn btn-success">Pwede na</div>
        6<div class="btn btn-default">Pwede na</div>
    ```

#### 表单
- 说明
    * 这里说的只是针对HTML助手类的使用,视图页面中的ActiveForm是对Html助手类的一个封装
- 创建表单
    ```php
        // 视图页面
        <?= Html::beginForm(['order/update', 'id' => 123], 'post', ['enctype' => 'multipart/form-data']) ?>

        <?= Html::endForm() ?>

        // 页面输出
        <form action="/advanced/backend/web/order/update?id=123" method="post" enctype="multipart/form-data">
            <input name="_csrf-backend" value="68UHYvdskyBGql7sQ6_iE7B9DOE_GOIc0-WNu_E_Q4kAPyraraHSlITjmaUnua9_TRO1qQzYRZTYRpNU3exdEg==" type="hidden">
        </form>
    ```
- 按钮
    ```php
        // 视图页面
        <?= Html::button('Press me!', ['class' => 'btn btn-primary']) ?>
        <?= Html::submitButton('Submit', ['class' => 'btn btn-success']) ?>
        <?= Html::resetButton('Reset', ['class' => 'btn btn-warning']) ?>

        // 展示效果
        <button type="button" class="btn btn-primary">Press me!</button>
        <button type="submit" class="btn btn-success">Submit</button>
        <button type="reset" class="btn btn-warning">Reset</button>
    ```
- 输入栏
    ```php
        // 可使用的input类型
        yii\helpers\Html::buttonInput()
        yii\helpers\Html::submitInput()
        yii\helpers\Html::resetInput()
        yii\helpers\Html::textInput(), yii\helpers\Html::activeTextInput()
        yii\helpers\Html::hiddenInput(), yii\helpers\Html::activeHiddenInput()
        yii\helpers\Html::passwordInput() / yii\helpers\Html::activePasswordInput()
        yii\helpers\Html::fileInput(), yii\helpers\Html::activeFileInput()
        yii\helpers\Html::textarea(), yii\helpers\Html::activeTextarea()

        // 视图页面
        // type, input name, input value, options
        <?= Html::input('text', 'username', $model->classname, ['class' => $this->title]) ?>

        // type, model, model attribute name, options
        <?= Html::activeInput('text', $model, 'classname', ['class' => $this->title]) ?>

        <?= Html::radio('classname1', true, ['label' => 'classname']); ?>

        <?= Html::activeRadio($model, 'classname', ['class' => 'classname']); ?>

        <?= Html::checkbox('classname1', true, ['label' => 'classname']); ?>

        <?= Html::activeCheckbox($model, 'classname', ['class' => 'classname']); ?>

        // 展示效果
        <input type="text" class="班级名称4" name="username" value="班级名称4">

        <input type="text" id="banji-classname" class="班级名称4" name="Banji[classname]" value="班级名称4">

        <label>
            <input type="radio" name="classname1" value="1" checked> classname
        </label>

        <input type="hidden" name="Banji[classname]" value="0">
        <label>
            <input type="radio" id="banji-classname" class="classname" name="Banji[classname]" value="1"> 班级名称
        </label>

        <label>
            <input type="checkbox" name="classname1" value="1" checked> classname
        </label>

        <input type="hidden" name="Banji[classname]" value="0">
        <label>
            <input type="checkbox" id="banji-classname" class="classname" name="Banji[classname]" value="1"> 班级名称
        </label>
    ```
- 样式表和脚本
    ```php
        // 如果是IE5再添加ie5.css样式
        <?= Html::cssFile('@web/css/ie5.css', ['condition' => 'IE 5']) ?>

        <?= Html::jsFile('@web/js/main.js') ?>
    ```
- 超链接
    ```php
        <?= Html::a('Profile', ['user/view', 'id' => $model->sid], ['class' => 'profile-link']) ?>
        <?= Html::mailto('Contact us', 'admin@example.com') ?>

        <a class="profile-link" href="....../user/view?id=5">Profile</a>
        <a href="mailto:admin@example.com">Contact us</a>
    ```
- 图片
    ```php
        <?= Html::img('@web/images/logo.png', ['alt' => 'My logo']) ?>

        <img src="http://example.com/images/logo.png" alt="My logo" />
    ```
- 列表
    ```php
        // 控制器页面
        $array = [
            'a' => ['id' => 'a1', 'username' => 'a2', 'nickname' => 'a3'],
            'b' => ['id' => 'b1', 'username' => 'b2', 'nickname' => 'b3'],
            'c' => ['id' => 'c1', 'username' => 'c2', 'nickname' => 'b3']
        ];
        return $this->render('view', ['array' => $array]);

        // 视图页面 有序列表使用 Html::ol()
        <?= Html::ul($array, ['item' => function($item, $index) {
            return Html::tag(
                'li',
                $item['id'],
                ['class' => $index]
            );
        }]) ?>

        // 页面展示
        <ul>
            <li class="a">a1</li>
            <li class="b">b1</li>
            <li class="c">c1</li>
        </ul>
    ```
