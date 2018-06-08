---
title: PHP_Yii框架 (23)
date: 2018-03-07
tags: Yii
toc: true
---

### DetailView
    主要使用在views\xxx\view.php,展示某一条记录的详细信息

<!-- more -->

#### 方式1
- 说明
    * 通过在继承AR的类中书写关联关系,相当于对每一个message中都添加了对应的用户的属性receUsername、sendUsername,而nickname是其中的一个属性
- 基本查询次数
    * SELECT * FROM `message` WHERE `id`='6'
    * SELECT nickname FROM `user` WHERE `id`=1
    * SELECT * FROM `user` WHERE `id`=2
- 使用实例
    ```php
    // view.php
        use yii\widgets\DetailView;

        <?= DetailView::widget([
            'model' => $model,
            'attributes' => [
                'id',
                [
                    // 关联表数据展示
                    'attribute' => 'senderid',
                    // 对应的是继承AR类的Message中的getSendUsername方法
                    'value' => $model->sendUsername->nickname,
                ],
                [
                    // 关联表数据展示
                    'attribute' => 'receiverid',
                    // 对应的是继承AR类的Message中的getReceUsername方法
                    'value' => $model->receUsername->nickname,
                ],
                'sendmsg',
                'sendtime:datetime',
            ],
        ]) ?>

    // Message.php
        class Message extends \yii\db\ActiveRecord
        {
            public function getSendUsername()
            {
                // SELECT nickname
                return $this->hasOne(User::className(), ['id' => 'senderid'])->select("nickname");
            }

            public function getReceUsername()
            {
                // SELECT * 
                return $this->hasOne(User::className(), ['id' => 'receiverid']);
            }
        }   
    ```

#### 方式2
- 说明
    * 通过关联属性去关联表中获取所需的关联属性
- 基本查询次数
    * SELECT * FROM `liuyan` WHERE `id`='1'
    * SELECT `nickname` FROM `user` WHERE `id`=17
- 使用实例
    ```php
    // view.php
        use yii\widgets\DetailView;

        <?= DetailView::widget([
            'model' => $model,
            'attributes' => [
                'id',
                [
                    'attribute' => 'lyid',
                    'value' => function($searchModel) {
                        return User::getUserinfoByid($searchModel->lyid, 'nickname')['nickname'];
                    }
                ],
                'lycontent : ntext',
                'lytime : datetime',
                [
                    'attribute' => 'ispublic',
                    'value' => function($searchModel){
                        return Liuyan::$ispublic[$searchModel->ispublic];
                    }
                ],
            ],
        ]) ?>

    // Liuyan.php
        class Liuyan extends \yii\db\ActiveRecord
        {
            static public $ispublic = array(
                //1公开,0隐藏
                0 => '隐藏',
                1 => '公开',
            )
        }

    // User.php
        class User extends \yii\db\ActiveRecord
        {
            static public function getUserinfoByid($id, $field = "*")
            {
                return User::find()->select([$field])->where(['id' => $id])->one();
            }
        }
    ```
