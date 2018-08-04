---
title: PHP_Yii框架 (35)
date: 2018-08-03 17:00:00
tags: Yii
toc: true
---

### 页面布局选择及标签属性选择
    对页面使用的布局进行设置

<!-- more -->

#### 页面布局选择
- 1.通过控制器成员变量设置
    ```php
        public $layout = false;//不使用布局
        public $layout = 'main';//设置使用的布局文件(@app/views/layouts/main.php)
    ```
- 2.通过控制器方法设置
    ```php
        $this->layout = false;
        $this->layout = 'main';
    ```
- 3.在视图文件中设置
    ```php
        $this->context->layout = false;
        $this->context->layout = 'main';
    ```
- 使用优先级
    * 方法3 > 方法2 > 方法1

#### 标签属性选择
- 1.默认情况下,属性标签通过yii\base\Model::generateAttributeLabel()方法自动从属性名生成.它会自动将驼峰式大小写变量名转换为多个首字母大写的单词, 例如username转换为Username,firstName转换为First Name.
- 2.在对应模型类文件中使用attributeLabels()方法设置：
    ```php
        namespace app\models;
        use yii\db\ActiveRecord;

        class User extends ActiveRecord 
        {
            public $username;
            public $password;
            public $email;

            public function attributeLabels() 
            {
                return [
                    'username' => '用户名',
                    'password' => '密码',
                    'email' => '邮箱',
                ];
            }

        }
    ```
- 3.在视图文件中使用label()方法设置：
    ```php    
        <?= $form->field($model, 'username')->label('用户名') ?>
        <?= $form->field($model, 'password')->label('密码') ?>
        <?= $form->field($model, 'email')->label('邮箱') ?>
    ```
- 展示优先级
    * 方法3 > 方法2 > 方法1
