---
title: 读T代码 (04)
date: 2021-05-26
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### start_on_reboot.sh
- code
    ```bash
        #!/bin/sh
        # 非管理员不能开机自启动
        if [[ ${USER} != "root"  ]];then
            echo "you need to be root to run this shell"
            exit 1
        fi
        # 当前路径
        cur_path=`pwd`
        starter="test-agentd"
        # 当前文件夹是否在agent根目录中
        if [[ $cur_path =~ "test_agent" ]];then
            # new client
            start_cmd="sh start_agent.sh"
            stop_cmd="sh stop.sh"
        else
            echo "you should exec this shell in agent home dir"
            exit 1
        fi
        # 用sed将 starter文件中的START_CMD、STOP_CMD、HOME_DIR替换成正确的
        sed -i "s!START_CMD=.*!START_CMD=\"${start_cmd}\"!g" ${starter}
        sed -i "s!STOP_CMD=.*!STOP_CMD=\"${stop_cmd}\"!g" ${starter}
        sed -i "s!HOME_DIR=.*!HOME_DIR=\"${cur_path}\"!g" ${starter}
        chmod 755 ${starter}
        # 存在相同文件时强制覆盖
        cp -f ${starter} /etc/init.d/
        # 添加到系统服务中
        chkconfig --add ${starter}
        # 检查系统服务中是否添加成功
        result=`chkconfig --list | grep ${starter} | wc -l`
        if [[ result -eq 0 ]];then
            echo "install sys service failed"
        fi
    ```


