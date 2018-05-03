---
title: PHP_Yii框架 (18)
date: 2018-02-28
tags: Yii
toc: true
---

#### 输入验证
    对用户输入的内容始终保持怀疑态度,后台需要经过验证之后再进行处理
    ```bash
        // 调用 yii\base\Model::validate() 方法验证用户输入的内容。
        // 该方法会返回一个布尔值，指明是否通过验证。
        // 若没有通过，可以通过 yii\base\Model::errors 属性获取相应的报错信息
        $model = new \app\models\ContactForm();

        // populate model attributes with user inputs
        $model->load(\Yii::$app->request->post());
        // which is equivalent to the following:
        // $model->attributes = \Yii::$app->request->post('ContactForm');

        if ($model->validate()) {
            // all inputs are valid
        } else {
            // validation failed: $errors is an array containing error messages
            $errors = $model->errors;
        }
    ```
<!-- more --> 

#### 声明规则
    可以在继承Model的xxxForm中重写rule
    ```bash
        public function rules()
        {
            return [
                [
                    // 指定属性
                    ['attribute1', 'attribute2', ...],
                    // 验证规则
                    'validator',
                    // 验证场景
                    'on' => ['scenario1', 'scenario2', ...],
                    'property1' => 'value1', 'property2' => 'value2', ...
                ]
            ];
        }
    ```
    
#### 创建验证器
- 行内验证器
    ```bash
        use yii\base\Model;

        class MyForm extends Model
        {
            public $country;
            public $token;

            public function rules()
            {
                return [
                    // an inline validator defined as the model method validateCountry()
                    ['country', 'validateCountry'],

                    // an inline validator defined as an anonymous function
                    ['token', function ($attribute, $params) {
                        // ctype_alnum 判断是否是字母和数字或字母数字的组合
                        if (!ctype_alnum($this->$attribute)) {
                            // 验证失败的话会调用 yii\base\Model::addError()保存错误信息到模型
                            $this->addError($attribute, 'The token must contain letters or digits.');
                        }
                    }],
                ];
            }

            public function validateCountry($attribute, $params)
            {
                if (!in_array($this->$attribute, ['USA', 'Web'])) {
                    $this->addError($attribute, 'The country must be either "USA" or "Web".');
                }
            }
        }
    ```
- 独立验证器
    ```bash
        namespace app\models;

        use Yii;
        use yii\base\Model;
        use app\components\validators\CountryValidator;

        class EntryForm extends Model
        {
            public $name;
            public $email;
            public $country;

            public function rules()
            {
                return [
                    [['name', 'email'], 'required'],
                    ['country', CountryValidator::className()],
                    ['email', 'email'],
                ];
            }
        }


        namespace app\components;

        use yii\validators\Validator;

        class CountryValidator extends Validator
        {
            public function validateAttribute($model, $attribute)
            {
                if (!in_array($model->$attribute, ['USA', 'Web'])) {
                    $this->addError($model, $attribute, 'The country must be either "USA" or "Web".');
                }
            }
        }
    ```