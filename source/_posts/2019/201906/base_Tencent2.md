---
title: Tencent_基础 (2)
date: 2019-06-25
tags: 
    - Tencent
    - Linux
    - Wechat
toc: true
---

### 腾讯云操作
    easywechat基本使用

<!-- more -->

#### 安装easywechat
- 操作
    ```bash
        sudo composer require overtrue/wechat:~4.0 -vvv
    ```

#### 关联到微信公众平台
    微信公众平台创建账号流程就不详细写了
- 开发:基本设置
    * 服务器地址(URL)
        * 只支持80端口,不用写端口号, 默认http是80端口, https是443端口
        * http://xxx.xx.xx.xxx/server.php
    * 令牌(Token)
        * 自己定义的
    * 点击保存之前需要在server.php中设置如下代码, 网上的说法是 验证token 让微信和服务器知道 你是你
- server.php
    ```php
        $timestamp = $_GET['timestamp'];
        $nonce = $_GET['nonce'];
        $token = 'llllljian';
        $signature = $_GET['signature'];
        $array = array($timestamp,$nonce,$token);
        //2.将排序后的三个参数拼接之后用sha1加密
        $tmpstr = implode('',$array);
        $tmpstr = sha1($tmpstr);
        //3.将加密后的字符串与signature进行对比,判断该请求是否来自微信
        if($tmpstr == $signature){
            header('content-type:text');
            echo $_GET['echostr'];
            exit;
        }
    ```
- 现在应该可以保存成功了, 否则就要看nginx访问日志了

#### easywechat配置
- config
    ```php
        $config = array(
            'app_id' => '你的开发者ID',
            'secret' => '你的开发者密码',
            'token' => '你的token',
            'response_type' => 'array',
            /**
            * 日志配置
            *
            * level: 日志级别, 可选为：debug/info/notice/warning/error/critical/alert/emergency
            * path：日志文件位置(绝对路径!!!),要求可写权限
            */
            'log' => array(
                'default' => 'dev', // 默认使用的 channel,生产环境可以改为下面的 prod
                'channels' => array(
                    // 测试环境
                    'dev' => array(
                        'driver' => 'single',
                        'permission' => 0777,
                        'path' => '/tmp/easywechat-dev/easywechat_'.date('Ymd').'.log',
                        'level' => 'debug',
                    ),
                    // 生产环境
                    'prod' => array(
                        'driver' => 'daily',
                        'permission' => 0777,
                        'path' => '/tmp/easywechat-prod/easywechat_'.date('Ymd').'.log',
                        'level' => 'info',
                    ),
                ),
            ),
        );
    ```

#### 完整server.php
- server.php
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 09:50:07 #2]$ cat /var/nginx/html/server.php
        <?php
        /**
        * File Name: server.php
        * Author: llllljian
        * mail: 18634678077@163.com
        * Created Time: Thu 27 Jun 2019 01:38:41 PM CST
        **/

        /*
        $timestamp = $_GET['timestamp'];
        $nonce = $_GET['nonce'];
        $token = 'llllljian';
        $signature = $_GET['signature'];
        $array = array($timestamp,$nonce,$token);
        //2.将排序后的三个参数拼接之后用sha1加密
        $tmpstr = implode('',$array);
        $tmpstr = sha1($tmpstr);
        //3.将加密后的字符串与signature进行对比,判断该请求是否来自微信
        if($tmpstr == $signature){
            header('content-type:text');
            echo $_GET['echostr'];
            exit;
        }
        */
        include __DIR__ . '/vendor/autoload.php';
        use EasyWeChat\Factory;
        use EasyWeChat\Kernel\Messages\Image;

        $config = array(
            'app_id' => 'wx6aa46abea55484a7',
            'secret' => 'c1090ce59a68cd8b9be5c3539b72d29d',
            'token' => 'llllljian',
            'response_type' => 'array',
            /**
            * 日志配置
            *
            * level: 日志级别, 可选为：debug/info/notice/warning/error/critical/alert/emergency
            * path：日志文件位置(绝对路径!!!),要求可写权限
            */
            'log' => array(
                'default' => 'dev', // 默认使用的 channel,生产环境可以改为下面的 prod
                'channels' => array(
                    // 测试环境
                    'dev' => array(
                        'driver' => 'single',
                        'permission' => 0777,
                        'path' => '/tmp/easywechat-dev/easywechat_'.date('Ymd').'.log',
                        'level' => 'debug',
                    ),
                    // 生产环境
                    'prod' => array(
                        'driver' => 'daily',
                        'permission' => 0777,
                        'path' => '/tmp/easywechat-prod/easywechat_'.date('Ymd').'.log',
                        'level' => 'info',
                    ),
                ),
            ),
        );

        $app = Factory::officialAccount($config);

        $app->server->push(function ($message) {
            switch ($message['MsgType']) {
                case 'event':
                    return '收到事件消息';
                    break;
                case 'text':
                    return '收到文字消息';
                    break;
                case 'image':
                    return '收到图片消息';
                    break;
                case 'voice':
                    return '收到语音消息';
                    break;
                case 'video':
                    return '收到视频消息';
                    break;
                case 'location':
                    return '收到坐标消息';
                    break;
                case 'link':
                    return '收到链接消息';
                    break;
                case 'file':
                    return '收到文件消息';
                // ... 其它消息
                default:
                    return '收到其它消息';
                    break;
            }
        });


        $response = $app->server->serve();

        // 将响应输出
        $response->send();
    ```