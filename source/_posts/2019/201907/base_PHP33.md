---
title: PHP_基础 (33)
date: 2019-07-17
tags: PHP 
toc: true
---

### PHP文件路径获取文件名
    今天要往日志表里记录执行的文件的时候发现自己不太熟悉获取当前文件名的方式, 记录一下

<!-- more -->

#### 物理截取
- eg
    ```php
        $file = '/www/htdocs/inc/lib.inc.php';
        $file = __FILE__;

        $filename = basename($file);
        echo $filename, '<br/>';//  lib.inc.php
        $filename = str_replace(strrchr($filename, '.'), '', $filename);
        echo $filename, '<br/>';//  lib.inc
    ```

#### 使用pathinfo
- eg
    ```php
        $file = '/www/htdocs/inc/lib.inc.php';
        $file = __FILE__;
        $path_parts = pathinfo($file);

        echo '目录名称' . $path_parts['dirname'], '<br/>';  //  /www/htdocs/inc
        echo '文件全名' . $path_parts['basename'], '<br/>'; //  lib.inc.php
        echo '文件后缀' . $path_parts['extension'], '<br/>';//  php
        echo '文件名称' . $path_parts['filename'], '<br/>'; //  lib.inc         // PHP >= 5.2.0
        echo '目录名称' . pathinfo($file, PATHINFO_DIRNAME), '<br/>';  //  /www/htdocs/inc
        echo '文件全名' . pathinfo($file, PATHINFO_BASENAME), '<br/>'; //  lib.inc.php
        echo '文件后缀' . pathinfo($file, PATHINFO_EXTENSION), '<br/>';//  php
        echo '文件名称' . pathinfo($file, PATHINFO_FILENAME), '<br/>'; //  lib.inc         // PHP >= 5.2.0
    ```


