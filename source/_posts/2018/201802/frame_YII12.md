---
title: PHP_Yii框架 (12)
date: 2018-02-08
tags: Yii
toc: true
---

### 错误处理
- Yii 内置了一个error handler错误处理器,它使错误处理更方便, Yii错误处理器做以下工作来提升错误处理效果: 
    * 所有非致命PHP错误(如,警告,提示)会转换成可获取异常；
    * 异常和致命的PHP错误会被显示, 在调试模式会显示详细的函数调用栈和源代码行数.
    * 支持使用专用的 控制器操作 来显示错误；
    * 支持不同的错误响应格式；

<!-- more -->

- 使用错误处理器
    ```php
        return [
            'components' => [
                'errorHandler' => [
                    // 异常页面最多显示20行源代码
                    'maxSourceLines' => 20,
                    // 出现异常跳转的页面路由
                    'errorAction' => 'index/error'
                ],
            ],
        ];

        class IndexController extends Controller
        {
            public function actions()
            {
                return [
                    'error' => [
                        'class' => 'yii\web\ErrorAction',
                    ],
                ];
            }

            public function actionError()
            {
                $exception = Yii::$app->errorHandler->exception;
                if ($exception !== null) {
                    return $this->render('error', ['exception' => $exception]);
                }
            }
        }
    ```

- 自定义错误格式
    ```php
        return [
            // ...
            'components' => [
                'response' => [
                    'class' => 'yii\web\Response',
                    'on beforeSend' => function ($event) {
                        $response = $event->sender;
                        if ($response->data !== null) {
                            $response->data = [
                                'success' => $response->isSuccessful,
                                'data' => $response->data,
                            ];
                            $response->statusCode = 200;
                        }
                    },
                ],
            ],
        ];
    ```

### 日志
- 日志目标
    ```php
        return [
            // log 组件必须在 bootstrapping 期间就被加载,以便于它能够及时调度日志消息到目标里
            'bootstrap' => ['log'],
            'components' => [
                'log' => [
                    'targets' => [
                        [
                            // 将错误和警告层级的消息保存到数据库中
                            'class' => 'yii\log\DbTarget', // 在数据库表里储存日志消息
                            'levels' => ['error', 'warning'], // 等级为错误和警告
                        ],
                        [
                            //错误层级的消息并且是在以 yii\db\ 开头的分类下,并将它们发送到相应邮箱中
                            'class' => 'yii\log\EmailTarget', // 发送日志消息到预先指定的邮箱地址
                            'levels' => ['error'], // 等级为错误
                            'categories' => ['yii\db\*'], // 导出以什么开头的错误
                            'message' => [
                                'from' => ['log@example.com'], // 从哪个邮箱发出
                                'to' => ['admin@example.com', 'developer@example.com'], //发送到哪个邮箱
                                'subject' => 'Database errors at example.com', //邮件主题
                            ],
                        ],
                        [
                            // 将错误和警告层级的并且是 yii\db\开头和除了404之外的其他htttp错误保存到文件中
                            'class' => 'yii\log\FileTarget', // 保存日志消息到文件中
                            'levels' => ['error', 'warning'], // 等级为错误和警告
                            'categories' => [
                                'yii\db\*', // 导出以什么开头的错误
                                'yii\web\HttpException:*', // 导出以什么开头的错误
                            ],
                            'except' => [
                                'yii\web\HttpException:404', // 除了404错误
                            ],
                        ],
                        [
                            'class' => 'yii\log\FileTarget',
                            // 只有$_SERVER变量的值将被追加到消息日志中
                            'logVars' =>['$_SERVER'],
                            'maxFileSize' => 102400,//单位kb,这里是一个文件100M
                            'maxLogFiles' => 10,
                            'levels' => ['error', 'warning'],
                            'except' => [
                                'yii\web\HttpException:404',
                            ],
                        ],
                        [
                            'class' => 'yii\log\DbTarget',
                            // 禁止上下文信息包含
                            'logVars' =>[],
                            // error 当某些需要立马解决的致命问题发生的时候,调用此方法记录相关信息
                            // warning 当某些期望之外的事情发生的时候,使用该方法
                            // info 在某些位置记录一些比较有用的信息的时候使用
                            // trace 记录关于某段代码运行的相关消息.主要是用于开发环境
                            'levels' => ['info', 'error', 'trace', 'warning'],
                            'categories' => ['userOper'],
                            // 消息格式化-自定义的消息前缀
                            'prefix' => function($message) {
                                // 返回的日志前缀都加上当前用户的id
                                $user = \Yii::$app->has('user', TRUE) ? \Yii::$app->get('user') : null;
                                $userid = $user ? $user->getId(false) : '-';
                                return $userid;
                            },
                        ],
                    ],
                ],
            ],
        ];
    ```