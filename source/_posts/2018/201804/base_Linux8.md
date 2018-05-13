---
title: Linux_基础 (8)
date: 2018-04-19
tags: Linux
toc: true
---

### /etc/passwd文件详解
    /etc/passwd文件是关于系统管理员对用户管理时的相关文件
    用户的信息都存放在/etc/passwd中
    用户主要的配置文件有/etc/passwd和/etc/shadow,其中/etc/shadow是/etc/passwd的加密文件

<!-- more -->

#### 内容格式
- 注册名：口令：用户标识号：组标识号：用户名：用户主目录：命令解释程序 
    * LOGNAME:PASSWORD:UID:GID:USERINFO:HOME:SHELL
    * 注册名(login_name)
        * 用于区分不同的用户。在同一系统中注册名是惟一的。在很多系统上，该字段被限制在8个字符(字母或数字)的长度之内；并且要注意，通常在Linux系统中对字母大小写是敏感的。
    * 口令(passwd)
        * 系统用口令来验证用户的合法性。超级用户root或某些高级用户可以使用系统命令passwd来更改系统中所有用户的口令，普通用户也可以在登录系统后使用passwd命令来更改自己的口令
    * 用户标识号(UID)
        * UID是一个数值，是Linux系统中惟一的用户标识，用于区别不同的用户。在系统内部管理进程和文件保护时使用 UID字段。
    * 组标识号(GID)
        * 这是当前用户的缺省工作组标识。具有相似属性的多个用户可以被分配到同一个组内，每个组都有自己的组名，且以自己的组标 识号相区分。像UID一样，用户的组标识号也存放在passwd文件中。
    * 用户名(user_name)
        * 包含有关用户的一些信息 
    * 用户主目录(home_directory)
        * 该字段定义了个人用户的主目录，当用户登录后，他的Shell将把该目录作为用户的工作目录
        * 在Unix/Linux系统中，超级用户root的工作目录为/root；而其它个人用户在/home目录下均有自己独立的工作环境，系统在该目录下为每个用户配置了自己的主目录。
        * 个人用户的文件都放置在各自的主目录下
    * 命令解释程序(Shell)
        * Shell是当用户登录系统时运行的程序名称，通常是一个Shell程序的全路径名
- 代码实例
    ```bash
        ...
        LOGNAME llllljian
        PASSWORD x,记录在/etc/shadow中
        UID 1000
        GID 1000
        USERINFO Llllljian,,,
        HOME /home/llllljian
        SHELL /bin/bash
        llllljian:x:1000:1000:Llllljian,,,:/home/llllljian:/bin/bash

        LOGNAME guest-joye7p
        PASSWORD x,！
        UID 999
        GID 999
        USERINFO 访客
        HOME /tmp/guest-joye7p
        SHELL /bin/bash
        guest-joye7p:x:999:999:访客:/tmp/guest-joye7p:/bin/bash
        ... 
    ```
