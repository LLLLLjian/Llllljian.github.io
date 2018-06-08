---
title: HDwiki_源码分析 (5)
date: 2018-03-27
tags: HDwiki
toc: true
---

### view
    MVC中的视图view 主要负责页面显示部分,所有的页面显示全部在此实现,视图对整个页面负责,它通过control的调用来显示页面和数据.

    视图(view)类template.class.php路径/lib/template.class.php, 视图类在每个control类的父类(base.calss.php)的构造函数中初始化,主要有以下几个部分,包括设置语言,设置风格,传递变量,显示最终页面,其中前两个在初始化时已被设置,在控制器(control)用的一般就是传递变量和显示最终页面两个部分

    视图(view)文件存放于 view/default/文件夹中,如果自己新添加新的模板,可以存放于不同的文件夹,例如 view/mediawiki/文件夹下,命名基本以功能为主,例如viewdoc.thm表示就是浏览词条的页面,

<!-- more -->

#### 基本结构
    ```php
        // 控制器中
        // 将$navigation变量的值传递给navigation,页面中可以直接调用nvaigation
        $this->view->assign('navigation',$navigation);
        // 调用视图文件viewdoc.htm文件并显示最终页面
        $this->view->display('viewdoc'); 
    ```

#### 语法
    ```php
        1.引入其它视图文件
        {template header}

        2.循环控制器返回的数组
        <!--{loop $doclist  $doc}-->
            <li>$doc['title']</li>
        <!--{/loop}-->

        3.判断语句if
        <!--{if $tag == 1}-->
            <li>显示一个东西</li>
        <!--{/if}-->

        4.使用lang中的文字
        {lang cateforyDoc}

        5.使用setting中的缓存数据
        {$setting[site_name]}
    ```