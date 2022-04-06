---
title: HDwiki_源码分析 (2)
date: 2018-03-23
tags: HDwiki
toc: true
---

### 5.1源码分析
    最新版本是6.0 还没有看.这里主要说一下HDwiki5.1 

<!-- more -->

#### 目录介绍
| 名称        | 类型   |  作用或意义  |
| --------    |:----: | :----:  |
| api   | 文件夹 | 接口相关 |
| control   | 文件夹 | 控制器 |
| data   | 文件夹 | 存放缓存、上传的附件、日志等信息 |
| install   | 文件夹 | 安装、初始化目录,上线时需删除 |
| js   | 文件夹 | 相关的js文件 |
| lang   | 文件夹 | 相关的语言文件,文字定义 |
| lib   | 文件夹 | 相关的操作类、封装的方法 |
| model   | 文件夹 | 模型 |
| plugins   | 文件夹 | 插件 |
| style   | 文件夹 | 相关的css文件及图片 |
| uploads   | 文件夹 | 上传的附件 |
| view   | 文件夹 | 视图 |
| config.php   | PHP程序文件 | 所有URL的入口 |
| index.php   | PHP程序文件 | 配置文件信息 |
| version.php   | PHP程序文件 | 版本文件信息 |

#### 请求生命周期
* 用户向入口文件index.php 发起请求.
* 加载hdwiki.class.php
* 解析url,加载对应的控制器文件,判断是否允许访问相应路由
* 加载base.class.php,初始化时间、用户、数据库等配置.
* 配合相应模块,加载相应的控制器以及视图

#### 请求
- 请求相关的代码在hdwiki.class.php init_request
- 源码分析
    ```php
        // url例子
        首页请求: /index.php
        百科分类的请求: /index.php?category
        排行榜的请求: /index.php?list
        按字母浏览的请求: /index.php?list-letter-H
        某个具体分类的请求: /index.php?category-view-1
        随便看看的请求: /index.php?doc-random
        首页右侧用户排行榜里面用户的请求: /index.php?user-space-1
        登录的请求: /index.php?user-login
        注册的请求: /index.php?user-register

        // 源码
        $pos = strpos($querystring , '.');
		if ($pos !== false) {
            // 去伪静态后缀
			$querystring = substr($querystring,0,$pos);
		}
        // 分割URL
		$this->get = explode('-' , $querystring);

        // 获取连接字符串属性
        if (count($this->get) <= 3 && count($_POST) == 0 && substr($querystring, 0, 6) == 'admin_' && substr($querystring, 0, 10) != 'admin_main'){
			$this->querystring = $querystring;
		}
		
        // get 数组至少要有两个元素.第一个元素默认为index,第二个元素默认为default.
		if(empty($this->get[0])){
			$this->get[0]='index';
		}
		if(empty($this->get[1])){
			$this->get[1]='default';
		}
		if(count($this->get)<2){
			exit(' Access Denied !');
		}

        // 加载相应的控制器文件
        $controlfile=HDWIKI_ROOT.'/control/'.$this->get[0].'.php';

        // 去调用相应的method
        $method = $this->get[1];
		$exemption=true; //免检方法的标志,免检方法不需要经过权限检测
		if('hd'!= substr($method, 0, 2)){
			$exemption=false;
			$method = 'do'.$this->get[1];
		}

        // 对上边URL的解析
        // control = index method = dodefault
        首页请求: /index.php 
        // control = category method = dodefault
        百科分类的请求: /index.php?category
        // control = list method = dodefault
        排行榜的请求: /index.php?list
        // control = list method = doletter  $this->get[2] = H
        按字母浏览的请求: /index.php?list-letter-H
        // control = category method = doview  $this->get[2] = 1
        某个具体分类的请求: /index.php?category-view-1
        ....
    ```