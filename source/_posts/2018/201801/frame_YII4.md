---
title: PHP_Yii框架 (4)
date: 2018-01-30
tags: Yii
toc: true
---

### 模型
- 模型是 MVC 模式中的一部分, 是代表业务数据、规则和逻辑的对象
- 可通过继承 yii\base\Model 或它的子类定义模型类, 基类yii\base\Model支持许多实用的特性
- 模型是代表业务数据、规则和逻辑的中心地方,通常在很多地方重用, 在一个设计良好的应用中,模型通常比 控制器代码多.
    * 可包含属性来展示业务数据;
    * 可包含验证规则确保数据有效和完整;
    * 可包含方法实现业务逻辑;
    * 不应直接访问请求,session和其他环境数据, 这些数据应该由控制器传入到模型;
    * 应避免嵌入HTML或其他展示代码,这些代码最好在 视图中处理;
    * 单个模型中避免太多的 场景.

<!-- more -->

#### 属性 
    模型通过 属性 来代表业务数据,每个属性像是模型的公有可访问属性, yii\base\Model::attributes() 指定模型所拥有的属性.
    可像访问一个对象属性一样访问模型的属性,也可像访问数组单元项一样访问属性
    代表可像普通类属性或数组 一样被访问的业务数据;

- 定义属性
    ```php
        namespace app\models;

        use yii\base\Model;

        class ContactForm extends Model
        {
            public $name;
            public $email;
            public $subject;
            public $body;
        }
    ```

- 属性标签
    ```php
        namespace app\models;

        use yii\base\Model;

        class ContactForm extends Model
        {
            public $name;
            public $email;
            public $subject;
            public $body;

            public function attributeLabels()
            {
                return [
                    'name' => 'Your name',
                    'email' => 'Your email address',
                    'subject' => 'Subject',
                    'body' => 'Content',
                ];
            }

            //如果应用支持多语言的情况下
            public function attributeLabels()
            {
                return [
                    'name' => \Yii::t('app', 'Your name'),
                    'email' => \Yii::t('app', 'Your email address'),
                    'subject' => \Yii::t('app', 'Subject'),
                    'body' => \Yii::t('app', 'Content'),
                ];
            }
        }
    ```

#### 场景
    不同的场景下模型中使用不同的业务规则和逻辑
```php
    两种设置场景的方法

    // 场景作为属性来设置
    $model = new User;
    $model->scenario = 'login';

    // 场景通过构造初始化配置来设置
    $model = new User(['scenario' => 'login']);
```
```php
    namespace app\models;

    use yii\db\ActiveRecord;

    class User extends ActiveRecord
    {
        const SCENARIO_LOGIN = 'login';
        const SCENARIO_REGISTER = 'register';

        public function scenarios()
        {
            $scenarios = parent::scenarios();
            $scenarios[self::SCENARIO_LOGIN] = ['username', 'password'];
            $scenarios[self::SCENARIO_REGISTER] = ['username', 'email', 'password'];
            return $scenarios;
        }
    }
```

#### 验证规则
    当模型接收到终端用户输入的数据, 数据应当满足某种规则(称为 验证规则, 也称为 业务规则)
    可调用 yii\base\Model::validate() 来验证接收到的数据, 该方法使用yii\base\Model::rules()申明的验证规则来验证每个相关属性,如果没有找到错误,会返回 true, 否则它会将错误保存在 yii\base\Model::errors 属性中并返回false
```php
    //controller.php
    $model = new \app\models\ContactForm;

    // 用户输入数据赋值到模型属性
    $model->attributes = \Yii::$app->request->post('ContactForm');

    if ($model->validate()) {
        // 所有输入数据都有效 all inputs are valid
    } else {
        // 验证失败: $errors 是一个包含错误信息的数组
        $errors = $model->errors;
    }


    //models.php
    //如果没有指定 on 属性,规则会在所有场景下应用
    public function rules()
    {
        return [
            // 在"register" 场景下 username, email 和 password 必须有值
            [['username', 'email', 'password'], 'required', 'on' => 'register'],

            // 在 "login" 场景下 username 和 password 必须有值
            [['username', 'password'], 'required', 'on' => 'login'],
        ];
    }
```

#### 块赋值
```php
    块赋值只用一行代码将用户所有输入填充到一个模型,非常方便, 它直接将输入数据对应填充到 yii\base\Model::attributes() 属性

    //写法1
    $model = new \app\models\ContactForm;
    $model->attributes = \Yii::$app->request->post('ContactForm');

    //写法2
    $model = new \app\models\ContactForm;
    $data = \Yii::$app->request->post('ContactForm', []);
    $model->name = isset($data['name']) ? $data['name'] : null;
    $model->email = isset($data['email']) ? $data['email'] : null;
    $model->subject = isset($data['subject']) ? $data['subject'] : null;
    $model->body = isset($data['body']) ? $data['body'] : null;
```

#### 安全属性
    块赋值只应用在安全属性上
    只要出现在活动验证规则中的属性都是安全的.

#### 非安全属性
```php
    //yii\base\Model::scenarios() 方法提供两个用处: 定义哪些属性应被验证,定义哪些属性安全
    public function scenarios()
    {
        return [
            //username,password可以被块赋值,secret则需要明确赋值($model->secret = $secret;)
            'login' => ['username', 'password', '!secret'],
        ];
    }
```

#### 字段
    通过覆盖 fields() 来增加、删除、重命名和重定义字段
    数据库中的字段 对应 页面上展示的名称
```php
    // 明确列出每个字段,特别用于你想确保数据表或模型
    // 属性改变不会导致你的字段改变(保证后端的API兼容).
    public function fields()
    {
        return [
            // 字段名和属性名相同
            'id',

            // 字段名为 "email",对应属性名为 "email_address"
            'email' => 'email_address',

            // 字段名为 "name", 值通过PHP代码返回
            'name' => function () {
                return $this->first_name . ' ' . $this->last_name;
            },
        ];
    }

    // 过滤掉一些字段,特别用于
    // 你想继承父类实现并不想用一些敏感字段
    public function fields()
    {
        $fields = parent::fields();

        // 去掉一些包含敏感信息的字段
        unset($fields['auth_key'], $fields['password_hash'], $fields['password_reset_token']);

        return $fields;
    }
```

