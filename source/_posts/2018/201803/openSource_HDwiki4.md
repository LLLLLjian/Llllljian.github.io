---
title: HDwiki_源码分析 (4)
date: 2018-03-26
tags: HDwiki
toc: true
---

### models
    MVC中的模型model 主要负责功能部分,绝大部分的功能在此实现,模型对整个功能负责,它能调用数据库或者缓存文件得到数据.

    模型(model)文件存放于 model文件夹中,命名基本以功能为主,例如doc.class.php表示就是词条相关的模型,user.class.php就是用户相关的模型

<!-- more -->

#### 基本结构
    ```php
        !defined('IN_HDwiki') && exit('Access Denied');

        // 每个model类的名称均是 文件名 + models
        class usermodel 
        {
            var $db;
            var $base;
            // 构造函数 类似于__construct 起初始化作用
            function usermodel(&$base) 
            {
                // 将base.class.php中的内容加载到$this->base中
                $this->base = $base;
                // 数据库设置
                $this->db = $base->db;
            }

            function get_user($field,$value)
            {
                return $this->db->fetch_first("SELECT * FROM ".DB_TABLEPRE."user WHERE $field='$value'");
            }

           function somefunction() 
           {
               // 获取lang中的文字
               $codeError = $this->base->view->lang['codeError'];

               // 获取setting中的缓存设置
               $langName = $this->base->setting['lang_name'];
           }
        }
        ?>
    ```