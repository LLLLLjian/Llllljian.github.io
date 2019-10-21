---
title: PHP_Yii框架 (26)
date: 2018-03-12
tags: Yii
toc: true
---

### 安全_授权
    授权是指验证用户是否允许做某件事的过程.Yii提供两种授权方法： 存取控制过滤器(ACF)和基于角色的存取控制(RBAC)

<!-- more -->

#### 授权
- ACF
    * 存取控制过滤器[ACF]
    ```php
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
                                // 允许
                                'allow' => true,
                                // 允许访问的action
                                'actions' => ['login', 'signup'],
                                // 未登录用户
                                'roles' => ['?'],
                            ],
                            [
                                'allow' => true,
                                'actions' => ['logout'],
                                // 已登录用户
                                'roles' => ['@'],
                            ],
                            [
                                // allow : 指定该规则是 允许[true] 还是 拒绝[false]
                                'allow' => true/false

                                // actions : 指定该规则用于匹配哪些动作. 它的值应该是动作方法的ID数组.
                                // 匹配比较是大小写敏感的.
                                // 如果该选项为空,或者不使用该选项, 意味着当前规则适用于所有的动作
                                'actions' => '',

                                // controllers : 指定该规则用于匹配哪些控制器. 它的值应为控制器ID数组.
                                // 匹配比较是大小写敏感的.
                                // 如果该选项为空,或者不使用该选项, 则意味着当前规则适用于所有的动作.
                                // 这个选项一般是在控制器的自定义父类中使用才有意义
                                'controllers' => '',

                                // roles : 指定该规则用于匹配哪些用户角色. 系统自带两个特殊的角色,通过 yii\web\User::isGuest 来判断
                                // ? : 用于匹配访客用户 (未经认证)
                                // @ : 用于匹配已认证用户
                                'roles' => [''],

                                // ips : 指定该规则用于匹配哪些 yii\web\Request::userIP . 
                                // IP地址可在其末尾包含通配符 * 以匹配一批前缀相同的IP地址
                                //  如果该选项为空或者不使用该选项,意味着该规则适用于所有角色.
                                'ips' => '',

                                // verbs : 指定该规则用于匹配哪种请求方法(例如GET, POST). 
                                // 大小写不敏感
                                'verbs' => '',

                                // matchCallback : 指定一个PHP回调函数用于 判定该规则是否满足条件
                                'matchCallback' => function($rule, $action) {
                                    return ...;
                                }
                            ],
                        ],
                        'denyCallback' => function ($rule, $action) {
                            throw new \Exception('You are not allowed to access this page');
                        }
                    ],
                    'verbs' => [
                        'class' => VerbFilter::className(),
                        'actions' => [
                            // action为delete 只支持post
                            'delete' => ['POST'],
                        ],
                    ],
                ];
            }
            // ...
        }
    ```
- RBAC
    * 基于角色的存取控制[RBAC]
    * 配置RBAC
        * 使用PhpManager : 使用PHP脚本存放授权数据[角色少,改动不频繁]
            ```php
                return [
                    // advanced高级版写在common/config/main.php
                    'components' => [
                        'authManager' => [
                            'class' => 'yii\rbac\PhpManager',
                        ],
                    ],
                ];
            ```
            yii\rbac\PhpManager 默认将 RBAC 数据保存在 @app/rbac 目录下的文件中. 如果权限层次数据在运行时会被修改,需确保WEB服务器进程对该目录和其中的文件有写权限.
        * 使用DbManager : 使用数据库存放授权数据[角色多,改动频繁]
            ```php
                return [
                    // ...
                    'components' => [
                        'authManager' => [
                            'class' => 'yii\rbac\DbManager',
                            // uncomment if you want to cache RBAC items hierarchy
                            // 'cache' => 'cache',
                        ],
                        // ...
                    ],
                ];
            ```
            * DbManager 使用4个数据库表存放它的数据：
            **itemTable** ：该表存放角色和权限.默认表名为 "auth_item" .
            **itemChildTable** ：该表存放授权条目的层次关系.默认表名为 "auth_item_child".
            **assignmentTable** ：该表存放授权条目对用户的指派情况.默认表名为 "auth_assignment".
            **ruleTable** ：该表存放规则.默认表名为 "auth_rule".
    * 使用RBAC
        * 可以通过\Yii::$app->authManager访问 authManager
