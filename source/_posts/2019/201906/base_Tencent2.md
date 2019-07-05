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
    记录一下自己的腾讯云服务器

<!-- more -->

#### 安装easywechat
- 操作
    ```bash
        sudo composer require overtrue/wechat:~4.0 -vvv

        sudo vim server.php

        cat server.php
        $timestamp = $_GET['timestamp'];
        $nonce = $_GET['nonce'];
        $token = 'llllljian';
        $signature = $_GET['signature'];
        $array = array($timestamp,$nonce,$token);
        //2.将排序后的三个参数拼接之后用sha1加密
        $tmpstr = implode('',$array);
        $tmpstr = sha1($tmpstr);
        //3.将加密后的字符串与signature进行对比，判断该请求是否来自微信
        if($tmpstr == $signature){
            header('content-type:text');
            echo $_GET['echostr'];
            exit;
        }
    ```

#### 关联到微信公众平台
    微信公众平台创建账号流程就不详细写了
- 开发:基本设置
    * 服务器地址(URL)
        * 只支持80端口,不用写端口号, 默认http是80端口, https是443端口
    

