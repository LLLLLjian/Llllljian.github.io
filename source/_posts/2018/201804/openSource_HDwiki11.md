---
title: HDwiki_源码分析 (11)
date: 2018-04-04
tags: HDwiki
toc: true
---

### 升级HDwiki6.0
    HDwiki5.1升级到6.0。

<!-- more -->

- 后台-模块/插件-网站语言编辑
- control/admin_language.php
- view/default/admin_language.htm
- 控制器action分析
    ```bash
        function dodefault()
        {
            根据前台下拉框中的值选择展示的语言类型.默认是前台语言包
            $this->view->setlang($this->setting['lang_name'], 'front');

            //timeoffset内容为数组，所以释放
            unset($this->view->lang['timeoffset']);

            如果没有查找内容,将$this->view->lang中的内容展示到页面上
            如果有查找内容,用正则查找lang中的value
            $pattern = '/(.*?)'.$keyword.'(.*?)/i';
            preg_match($pattern, $lang)
        }

        function doaddlang()
        {
            判断要写的是前台语言包还是后台语言包
            判断变量是否存在
            写入文件中
            $data = file::readfromfile(HDWIKI_ROOT.'/lang/zh/'.$langname);
            $con = '$lang[\''.$langvar."']='".str_replace("'", "\'", str_replace("\\", "\\\\", stripslashes($langcon)))."';\r\n?>";
            $content = str_replace('?>',$con,$data);
            file::writetofile(HDWIKI_ROOT.'/lang/zh/'.$langname,$content);
        }

        // 修改的 自己重写了一下 可以看下一篇
    ```

