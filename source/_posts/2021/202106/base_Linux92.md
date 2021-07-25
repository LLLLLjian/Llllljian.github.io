---
title: Linux_基础 (92)
date: 2021-06-04
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### Linux中设置服务自启动的三种方式
1. ln -s 建立启动软连接
2. chkconfig 命令行运行级别设置
3. ntsysv 伪图形运行级别设置

#### ubuntu下没有chkconfig
- Q
    ```bash
        [ubuntu@llllljian-cloud-tencent init.d 20:50:31 #52]$ chkconfig
        chkconfig: command not found

        [ubuntu@llllljian-cloud-tencent init.d 20:50:35 #53]$ sudo apt-get install sysv-rc-conf
        ....

        sudo sysv-rc-conf --list
        sudo sysv-rc-conf llllljian on

        sudo sysv-rc-conf  进入工具管理界面 注意的是 X代表的是启用服务
    ```
