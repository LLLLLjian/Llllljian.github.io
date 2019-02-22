---
title: Smarty_基础 (1)
date: 2018-11-29
tags: Smarty
toc: true
---

### Smarty基础
    Smarty的基本使用与总结

<!-- more -->

#### 简介
    Smarty是PHP的一个引擎模板,可以更好的进行逻辑与显示的分离,即我们常说的MVC,这个引擎的作用就是将C分离出来
    环境需求：PHP5.2或者更高版本

#### 安装
    在网上下载Smarty包直接将其解压,我们需要的仅仅是里面的libs文件夹.Libs文件里面都是库文件,我们不应该修改里面的任何内容.解压完毕后就直接将libs文件夹放入到我们需要使用的网站根目录

#### 默认设置
- template_dir
    * 模板目录变量
    * 默认情况下,目录是：“./templates“
- compile_dir
    * 定位编译模板的目录名字
    * 默认情况下,目录是：“./templates_c“
- config_dir
    * 存放模板配置文件的目录
    * 默认情况下,目录是：“./configs”
- cache_dir
    * 存放缓存文件的目录
    * 默认情况下,目录是：“./cache“
- plugins_dir
    * 定义Smarty寻找所需插件的目录
    * 默认情况下,目录是：“./plugins“


