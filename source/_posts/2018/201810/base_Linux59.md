---
title: Linux_基础 (59)
date: 2018-10-15
tags: Linux
toc: true
---

### Linux切换用户
    在Linux系统中,由于root的权限过大,一般情况都不使用它.只有在一些特殊情况下才采用登录root执行管理任务,一般情况下临时使用root权限多采用su和sudo命令

<!-- more -->

#### sudo
    sudo是一种权限管理机制,依赖于/etc/sudoers,其定义了授权给哪个用户可以以管理员的身份能够执行什么样的管理命令
- 格式
    * sudo -u USERNAME COMMAND
- 使用者
    * 默认情况下,系统只有root用户可以执行sudo命令.需要root用户通过使用visudo命令编辑sudo的配置文件/etc/sudoers,才可以授权其他普通用户执行sudo命令

#### su
    su为switch user,即切换用户的简写
- 格式
    * su -l USERNAME(-l为login,即登陆的简写)
    * su USERNAME
        * 如果不指定USERNAME(用户名),默认即为root,所以切换到root的身份的命令即为: su -root或su -,su root 或su
    * 差异
        * su -,su -l或su --login 命令改变身份时,也同时变更工作目录,以及HOME,SHELL,USER,LOGNAME.此外,也会变更PATH变量.用su -命令则默认转换成成root用户了.
        * 不带参数的“su命令”不会改变当前工作目录以及HOME,SHELL,USER,LOGNAME.只是拥有了root的权限而已
- 使用情况
    * su -使用root的密码
    * sudo su使用用户密码
