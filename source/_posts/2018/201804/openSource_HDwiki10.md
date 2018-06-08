---
title: HDwiki_源码分析 (10)
date: 2018-04-03
tags: HDwiki
toc: true
---

### 开发遇到的问题
    写一些自己开发遇到的问题

<!-- more -->

#### 上传非图片文件后缀及位置问题
- 场景
    * 非图片上传会上传到data/attachment中并且后缀会改成attach
- 修改结果
    * 和图片统一放到upload中,使用原后缀
- 代码修改
    ```php
        // control/attachment.php/doupload old
        $destfile = 'data/attachment/'.date('y-m').'/'.date('Y-m-d').'_'.util::random(10).'.attach';
        file::createaccessfile('data/attachment/'.date('y-m').'/');
        $result = file::uploadfile(
            $_FILES['attachment']['tmp_name'][$i],
            $destfile,
            $this->setting['attachment_size'],
            0);

        // control/attachment.php/doupload new
        $destfile = $_ENV['attachment']->makepath($extname);
        $result = file::uploadfile(
            $_FILES['attachment']['tmp_name'][$i],
            $destfile,
            $this->setting['attachment_size'],
            0);

        // model/attachment.class.php/upload_attachment old
        $destfile = 'data/attachment/'.date('y-m').'/'.date('Y-m-d').'_'.util::random(10).'.attach';
        file::createaccessfile('data/attachment/'.date('y-m').'/');
        $result = file::uploadfile(
            $_FILES['attachment']['tmp_name'][$i],
            $destfile,
            $this->base->setting['attachment_size'],
            0);

        // model/attachment.class.php/upload_attachment new
        $destfile = $_ENV['attachment']->makepath($extname);
        $result = file::uploadfile(
            $_FILES['attachment']['tmp_name'][$i],
            $destfile,
            $this->base->setting['attachment_size'],
            0);
    ```

#### php5.4|5.5版本安装之后空白问题
- 场景
    * 安装完成之后页面显示空白
- 修改结果
    * index.php中将错误开启.去除控制器中的构造方法中的&[5.4开始不支持参数中带&]
    * 控制器中代码修改可以使用编辑器的全局搜索和替换
- 代码修改
    ```php
        // index.php
        error_reporting(All);

        // lib/string.class.php
        静态方法前添加static关键字

        // control/xxx.php old
        $this->base( & $get, &$post);

        // control/xxx.php new
        $this->base($get, $post);
    ```