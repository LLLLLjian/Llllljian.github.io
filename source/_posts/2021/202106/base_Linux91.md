---
title: Linux_基础 (91)
date: 2021-06-03
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### chkconfig
- 语法
    * chkconfig (选项)
- 选项
    * –add: 增加所指定的系统服务, 让chkconfig指令得以管理它, 并同时在系统启动的叙述文件内增加相关数据；
    * –del: 删除所指定的系统服务, 不再由chkconfig指令管理, 并同时在系统启动的叙述文件内删除相关数据；
    * –level<等级代号>: 指定读系统服务要在哪一个执行等级中开启或关毕.
    * --list [name]:  显示所有运行级系统服务的运行状态信息(on或off).如果指定了name, 那么只显示指定的服务在不同运行级的状态.
- 等级代号列表
    * 等级0表示: 表示关机
    * 等级1表示: 单用户模式
    * 等级2表示: 无网络连接的多用户命令行模式
    * 等级3表示: 有网络连接的多用户命令行模式
    * 等级4表示: 不可用
    * 等级5表示: 带图形界面的多用户模式
    * 等级6表示: 重新启动
- 新增一个服务
    1. 服务脚本必须放在 /etc/init.d/ 目录下；
    2. 使用命令 chkconfig --add service_name 在 chkconfig 工具列表中添加此服务;
    3. 使用命令 chmod 755 service_name 赋予执行权限；
    4. 使用命令chkconfig --level 35 service_name on 更改启动级别.
- 启动脚本
    ```bash
        # !/bin/bash
        # chkconfig: 2345 80 90
        # description:auto_run
    ```
    * 第一行, 告诉系统使用的shell
    * 第二行, chkconfig后面有三个参数2345,80和90告诉chkconfig程序, 需要在rc2.d~rc5.d目录下, 创建名字为 S80auto_run的文件连接, 连接到/etc/rc.d/init.d目录下的的auto_run脚本.第一个字符是S, 系统在启动的时候, 运行脚本auto_run, 就会添加一个start参数, 告诉脚本, 现在是启动模式.同时在rc0.d和rc6.d目录下, 创建名字为K90auto_run的文件连接, 第一个字符为K, 系统在关闭系统的时候, 会运行auto_run, 添加一个stop, 告诉脚本, 现在是关闭模式.
    * 注意上面的三行中, 第二, 第三行是必须的, 否则在运行chkconfig –add auto_run时, 会报错.
    * 80 数字越小 启动优先级别越高
    * 90 数字越小 关闭优先级别越高
- eg
1. 列出所有服务
    ```bash
        chkconfig --list
    ```
2. 增加服务 llllljian
    ```bash
        chkconfig --add llllljian
    ```
3. 删除服务 llllljian
    ```bash
        chkconfig --del llllljian
    ```
4. 设置 llllljian 服务 在 2 3 4 5 运行基本下都是 on (开启)状态
    ```bash
        chkconfig --level llllljian 2345 on 
    ```
5. 列出 llllljian 的 服务设置情况
    ```bash
        chkconfig --list llllljian
    ```
6. 设置服务 llllljian 所有运行等级下都是启动 
    ```bash
        chkconfig llllljian on
    ```
7. llllljian
    ```bash
        #!/bin/bash
        # chkconfig: 2345 10 90
        # description: llllljian
        start() {
                echo "Starting"

        }

        stop() {
                echo "Stop"
        }
        reload() {
        echo "Reload"
        }

        case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;

        restart)
                stop
                start
                ;;

        *)
        echo $"Usage: $prog {start|stop|restart}"
                RETVAL=2
        esac
    ```


