---
title: HDwiki_源码分析 (6)
date: 2018-03-28
tags: HDwiki
toc: true
---

### 文字及缓存数据设置
    前边写了控制器、模型、视图中使用lang及setting的用法,接下来说一下这些的设置

<!-- more -->

#### 文字lang
- 说明
    * 5.1版本中需要在代码中进行定义,6.0可以在后台页面中进行设置
- 前台文字
    * 位置 : lang/zh/front.php
    * 使用范围 : 前台相关控制器、模型、视图.默认是前台文字
    * 使用方式 : $this->view->setlang($this->setting['lang_name'], 'front');
- 后台文字
    * 位置 : lang/zh/front.php
    * 使用范围 : 后台相关控制器、模型、视图.
    * 使用方式 : $this->view->setlang($this->setting['lang_name'], 'back');
