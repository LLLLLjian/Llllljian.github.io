---
title: PHP_Yii框架 (6)
date: 2018-02-01
tags: Yii
toc: true
---

### 过滤器
    过滤器是控制器动作执行之前或之后执行的对象

<!-- more -->

#### 使用过滤器
- 预过滤
    * 按顺序执行应用主体中behaviors()列出的过滤器.
    * 按顺序执行模块中behaviors()列出的过滤器.
    * 按顺序执行控制器中behaviors()列出的过滤器.
    * 如果任意过滤器终止动作执行, 后面的过滤器(包括预过滤和后过滤）不再执行.
- 成功通过预过滤后执行动作.
- 后过滤
    * 倒序执行控制器中behaviors()列出的过滤器.
    * 倒序执行模块中behaviors()列出的过滤器.
    * 倒序执行应用主体中behaviors()列出的过滤器
```php
    //基本模板
    public function behaviors() 
    {
        return [

        ];
    }
```
```php
    方式1:
    <?php 
    namespace common\lib;

    class TimeStampBehavior extends \yii\behaviors\TimestampBehavior 
    {
        public $createdAtAttribute = 'ctime';

        puclic $updatedAtAttribute = 'mtime';
    }
    ?>

    <?php 
    namespace common\lib;

    class CreatorOrUpdaterBehavior extends \yii\behviors\BlameableBehavior 
    {
        public $createdByAttribute = 'creator';

        public $updatedByAttribute = 'updater';
    }
    ?>

    <?php 
    namespace common\models\activeRecord;

    use Yii;
    use yii\db\ActiveRecord;
    use common\lib\TimeStampBehavior;
    use common\lib\CreatorOrUpdaterBehavior;
    
    class xxxx extends ActiveRecord 
    {
        public static function tableName()
        {
            return 'xxxx';
        }

        public function rules() 
        {
            return [];
        }

        public function behaviors()
        {
            return [
                TimeStampBehavior::className()
                CreatorOrUpdaterBehavior::className()
            ];
        }
    }
    ?>
```
```php
    //方式2:
    <?php

    namespace common\models;

    use Yii;
    use yii\behaviors\TimestampBehavior;
    use yii\behaviors\BlameableBehavior;

    class xxxx extends \yii\db\ActiveRecord
    {

        public static function tableName()
        {
            return 'xxxx';
        }

        public function behaviors()
        {
            return [
                [
                    'class'=>TimestampBehavior::className(),
                    'attributes'=>[
                        ActiveRecord::EVENT_BEFORE_INSERT => ['ctime','mtime'],
                        ActiveRecord::EVENT_BEFORE_UPDATE => ['mtime'],
                    ]
                ],
                [
                    'class' => BlameableBehavior::className(),
                    'createdByAttribute' => 'creator',
                    'updatedByAttribute' => 'updater',
                ]
            ];
        }

        public function rules()
        {
            return [];
        }
```

#### 创建过滤器
    ```php
        namespace app\components;

        use Yii;
        use yii\base\ActionFilter;

        class ActionTimeFilter extends ActionFilter
        {
            private $_startTime;

            public function beforeAction($action)
            {
                $this->_startTime = microtime(true);
                return parent::beforeAction($action);
            }

            public function afterAction($action, $result)
            {
                $time = microtime(true) - $this->_startTime;
                Yii::trace("Action '{$action->uniqueId}' spent $time second.");
                return parent::afterAction($action, $result);
            }
        }
    ```

#### 核心过滤器
- AccessControl
    ```php
        //允许所有访客(还未经认证的用户）执行 login 和 signup 动作. 
        //roles 选项包含的问号 ? 是一个特殊的标识,代表”访客用户”.
        //允许已认证用户执行 logout 动作.@是另一个特殊标识, 代表”已认证用户”.
        use yii\web\Controller;
        use yii\filters\AccessControl;

        class SiteController extends Controller
        {
            public function behaviors()
            {
                return [
                    'access' => [
                        'class' => AccessControl::className(),
                        'only' => ['login', 'logout', 'signup'],
                        'rules' => [
                            [
                                'allow' => true,
                                'actions' => ['login', 'signup'],
                                'roles' => ['?'],
                            ],
                            [
                                'allow' => true,
                                'actions' => ['logout'],
                                'roles' => ['@'],
                            ],
                        ],
                    ],
                ];
            }
            // ...
        }
    ```
- 认证方法过滤器
    ```php
        use yii\filters\auth\HttpBasicAuth;

        public function behaviors()
        {
            return [
                'basicAuth' => [
                    'class' => HttpBasicAuth::className(),
                ],
            ];
        }
    ```
- ContentNegotiator
    ```php
        //配置ContentNegotiator支持JSON和XML 响应格式和英语(美国）和德语
        use yii\filters\ContentNegotiator;
        use yii\web\Response;

        public function behaviors()
        {
            return [
                [
                    'class' => ContentNegotiator::className(),
                    'formats' => [
                        'application/json' => Response::FORMAT_JSON,
                        'application/xml' => Response::FORMAT_XML,
                    ],
                    'languages' => [
                        'en-US',
                        'de',
                    ],
                ],
            ];
        }
    ```
- HttpCache 
    ```php
        use yii\filters\HttpCache;

        public function behaviors()
        {
            return [
                [
                    'class' => HttpCache::className(),
                    'only' => ['index'],
                    'lastModified' => function ($action, $params) {
                        $q = new \yii\db\Query();
                        return $q->from('user')->max('updated_at');
                    },
                ],
            ];
        }
    ```
- PageCache
    ```php
        //PageCache应用在 index 动作, 缓存整个页面 60 秒或 post 表的记录数发生变化
        use yii\filters\PageCache;
        use yii\caching\DbDependency;

        public function behaviors()
        {
            return [
                'pageCache' => [
                    'class' => PageCache::className(),
                    'only' => ['index'],
                    'duration' => 60,
                    'dependency' => [
                        'class' => DbDependency::className(),
                        'sql' => 'SELECT COUNT(*) FROM post',
                    ],
                    'variations' => [
                        \Yii::$app->language,
                    ]
                ],
            ];
        }
    ```
- RateLimiter
- VerbFilter 
    ```php
        //VerbFilter检查请求动作的HTTP请求方式是否允许执行, 如果不允许,会抛出HTTP 405异常. 如下示例,VerbFilter指定CRUD动作所允许的请求方式
        use yii\filters\VerbFilter;

        public function behaviors()
        {
            return [
                'verbs' => [
                    'class' => VerbFilter::className(),
                    'actions' => [
                        'index'  => ['get'],
                        'view'   => ['get'],
                        'create' => ['get', 'post'],
                        'update' => ['get', 'put', 'post'],
                        'delete' => ['post', 'delete'],
                    ],
                ],
            ];
        }
    ```
- Cors