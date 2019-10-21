---
title: PHP_Yii框架 (25)
date: 2018-03-09
tags: Yii
toc: true
---

### 安全_认证
    认证是鉴定用户身份的过程.它通常使用一个标识符 (如用户名或电子邮件地址)和一个加密令牌(比如密码或者存取令牌)来 鉴别用户身份.认证是登录功能的基础

<!-- more -->

#### 认证
- 应用配置
    ```php
        return [
            'components' => [
                'user' => [
                    'class'=>'yii\web\User',
                    'identityClass' => 'common\models\User',
                    // 允许自动登录
                    'enableAutoLogin' => true,
                    'identityCookie' => ['name' => '_identity1', 'httpOnly' => true],
                    'loginUrl' => ['user/login', 'ref' => 1],
                    // 允许登录的时间
                    'authTimeout' => 1800,
                ],
            ],
        ];
    ```
- common\models\User.php
    ```php
        // 实现认证逻辑的类,通常用关联了持久性存储的用户信息的AR模型Active Record实现
        class User extends ActiveRecord implements IdentityInterface
        {
            public static function tableName()
            {
                return 'user';
            }

            // 生成随机的auth_key,用于cookie登陆. 新增的时候添加auth_key字段
            public function beforeSave($insert)
            {
                if (parent::beforeSave($insert)) {
                    if ($this->isNewRecord) {
                        $this->auth_key = \Yii::$app->security->generateRandomString();
                    }
                    return true;
                }
                return false;
            }

            // 根据给到的ID查询身份
            public static function findIdentity($id)
            {
                return static::findOne($id);
            }

            // 根据token查询身份
            public static function findIdentityByAccessToken($token, $type = null)
            {
                return static::findOne(['access_token' => $token]);
            }

            // 当前用户ID
            public function getId()
            {
                return $this->id;
            }

            // 获取当前用户的(cookie)认证密钥
            public function getAuthKey()
            {
                return $this->auth_key;
            }

            // 验证当前用户的认证密匙
            public function validateAuthKey($authKey)
            {
                return $this->getAuthKey() === $authKey;
            }
        }
    ```
- yii\web\User.php
    * EVENT_BEFORE_LOGIN：在登录 yii\web\User::login() 时引发. 如果事件句柄将事件对象的 isValid 属性设为 false, 登录流程将会被取消.
    * EVENT_AFTER_LOGIN：登录成功后引发.
    * EVENT_BEFORE_LOGOUT：注销 yii\web\User::logout() 前引发. 如果事件句柄将事件对象的 isValid 属性设为 false, 注销流程将会被取消.
    * EVENT_AFTER_LOGOUT：成功注销后引发.
    ```php
        // 当前用户的身份实例.未认证用户则为 Null .
        $identity = Yii::$app->user->identity;

        // 当前用户的ID. 未认证用户则为 Null .
        $id = Yii::$app->user->id;

        // 判断当前用户是否是游客(未认证的)
        $isGuest = Yii::$app->user->isGuest;

        // 使用指定用户名获取用户身份实例.
        // 请注意,如果需要的话您可能要检验密码
        $identity = User::findOne(['username' => $username]);

        // 登录用户
        Yii::$app->user->login($identity);
    ```