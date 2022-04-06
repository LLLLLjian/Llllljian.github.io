---
title: PHP_Yii框架 (33)
date: 2018-03-21
tags: Yii
toc: true
---

###  yii使用小技巧
    写一些yii使用的小技巧

<!-- more -->

#### 表单相关
- 表单验证,两个参数中至少需要一个
    ```php
        public function rules()
        {
            return [
                [['card_id', 'card_code'], 
                function ($attribute, $param) {
                    //两个参数中至少需要一个
                    if (empty($this->card_code) && empty($this->card_id)) {
                        $this->addError($attribute, 'card_id/card_code至少要填一个');
                    }
                }, 
                'skipOnEmpty' => false],
            ];
        }
    ```
- 去除首尾空格 
    ```php
        public function rules()
        {
            return [[title', 'content'],'trim']];
        }
    ```
- 检查字段是否存在
    ```php
        // uid字段对应User表中的id字段.检测uid在User表中是否存在 
        public function rules()
        {
            return [
                ...
                [['uid'], 'exist',
                    'targetClass' => User::className(),
                    'targetAttribute' => 'id',
                    'message' => '此{attribute}不存在.'
                ],
                ...
            ];
        }
    ```
- 获取save()失败的原因
    ```php
        echo array_values($model->getFirstErrors())[0];exit;
        var_dump($model->getErrors());
        exit;
    ```
- 为某些action关闭csrf验证
    ```php
        1.新建一个Behavior[后期方便维护]
        use Yii;
        use yii\base\Behavior;
        use yii\web\Controller;

        class NoCsrf extends Behavior
        {
            public $actions = [];
            public $controller;
            public function events()
            {
                return [Controller::EVENT_BEFORE_ACTION => 'beforeAction'];
            }
            public function beforeAction($event)
            {
                $action = $event->action->id;
                if(in_array($action, $this->actions)){
                    $this->controller->enableCsrfValidation = false;
                }
            }    
        }

        // 在对应控制器中添加Behavior
        public function behaviors()
        {
            return [
                'csrf' => [
                    'class' => NoCsrf::className(),
                    'controller' => $this,
                    'actions' => [
                        'action-name'
                    ]
                ]
            ];
        }

        2. 直接在控制器中写[适用于单个]
        public function beforeAction($action) 
        {  
            // 获取当前行为名称
            $currentaction = $action->id; 
            // 定义需要关闭csrf的action名      
            $novalidactions = ['dologin'];  
        
            if(in_array($currentaction,$novalidactions)) {
                $action->controller->enableCsrfValidation = false;  
            }  
            parent::beforeAction($action);  
        
            return true;  
        }  
    ```

#### 数据查询
- where多条件
    ```php
        User::find()->where(['and', ['xxx' => 0, 'yyy' => 2], ['>', 'zzz', $time]]);

        // 相当于
        SELECT * FROM user WHERE xxx = 0 AND yyy = 2 AND zzz > $time
    ```
- SQL随机取十个
    ```php         
        User::find()->select('ID, City,State,StudentName')
                    ->from('student')                               
                    ->where(['IsActive' => 1])
                    ->andWhere(['not', ['State' => null]])
                    ->orderBy(['rand()' => SORT_DESC])
                    ->limit(10);
    ```
- like查询
    ```php
        ['like', 'name', 'tester'] 会生成 name LIKE '%tester%'.

        ['like', 'name', '%tester', false] => name LIKE '%tester'

        $query = User::find()->where(['LIKE', 'name', $id.'%', false]);
    ```
- 获取sql语句
    ```php
        $query = User::find(1);// SELECT * FROM user WHERE id = 1

        $commandQuery = clone $query;
        // 输出SQL语句
        echo $commandQuery->createCommand()->getRawSql(); 
    ```
- 不为空查询
    ```php
        $userInfoArr = User::find()->where(['not' => ['realname' => null]])
                                   ->asArray()
                                   ->all();
    ```

#### MySQL处理
- 清除表结构缓存
    ```php
        // 清除指定表结构缓存数据
        Yii::$app->db->getSchema()->refreshTableSchema($tableName);

        // 清理所有表结构缓存数据
        Yii::$app->db->getSchema()->refresh();
    ```
- 字段去重 
    ```php
        1.groupBy
        static::find()->where(['user_id' => $user_id,])
                      ->groupBy('uuid')
                      ->asArray()
                      ->all();
        2.distinct
        static::find()->select(['uuid'])
                      ->where(['user_id' => $user_id,])
                      ->distinct()
                      ->asArray()
                      ->all();
    ```
- 关于事务
    ```php
        Yii::$app->db->transaction(function() {
            $order = new Order($customer);
            $order->save();
            $order->addItems($items);
        });

        // 这相当于下列的代码: 
        $transaction = Yii::$app->db->beginTransaction();
        try {
            $order = new Order($customer);
            $order->save();
            $order->addItems($items);
            $transaction->commit();
        } catch (\Exception $e) {
            $transaction->rollBack();
            throw $e;
        }
    ```
- 批量插入数据
    ```php
        1.clone
        $model = new User();
        foreach($data as $attributes)
        {
            $_model = clone $model;
            $_model->setAttributes($attributes);
            $_model->save();
        }

        2.设置isNewRecord 
        $model = new User();
        foreach($data as $attributes)
        {
            $model->isNewRecord = true;
            $model->setAttributes($attributes);
            $model->save() && $model->id = 0;
        }
    ```

#### 前端展示
- 生成URL
    ```php
        Html::a("链接1", \yii\helpers\Url::toRoute(['product/view', 'id' => 42]);
        Html::a("链接1", \yii\helpers\Url::Yii::$app->urlManager->createUrl(['product/view', 'id' => 42]);
    ```
- 在一个控制器中调用其他控制器的action方法
    ```php
        Yii::$app->runAction('new_controller/new_action', $params);

        $this->redirect(array('/site/contact','id'=>12));
    ```

#### 其它
- 获取当前控制器及action
    ```php
        1.在控制器中
        // 控制器名 
        $controller = $this->id;
        // action名
        $action = $this->action->id;

        2.在视图中
        $controller = Yii::$app->controller->id;
        $action = Yii::$app->controller->action->id;
    ```