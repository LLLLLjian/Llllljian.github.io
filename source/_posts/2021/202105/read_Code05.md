---
title: 读T代码 (05)
date: 2021-05-27
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### test_agent
- code
    ```bash
        #!/bin/bash
        # chkconfig: 2345 90 25
        # description: test_agent
        # processname: test_agent

        # 上边四行注释是必须的
        # chkconfig 中2345是默认启动级别
        # 90是启动优先级(数字越小, 启动优先级别越高), 25是停止优先级(数字越小, 关闭优先级别越高)
        # description 文件说明
        # processname 进程名称

        # functions这个脚本是给/etc/init.d里边的文件使用的, 提供了一些基础的功能
        . /etc/init.d/functions
        # 默认值,  会在启动前被替换成正确的值
        HOME_DIR="/home/work/test_agent"
        START_CMD="sh start_test.sh"
        STOP_CMD="sh stop.sh"

        # 启动
        start() {
            echo -n $"Starting test agent: "
            cd ${HOME_DIR}
            eval ${START_CMD}
            RETVAL=$?
            echo
        }

        # 停止
        stop() {
            echo -n $"Shutting down test agent: "
            cd ${HOME_DIR}
            eval ${STOP_CMD}
            RETVAL=$?
            echo
        }

        # case选择
        case "$1" in
            start)
                start
            ;;
            stop)
                stop
            ;;
            restart|reload)
                stop
                start
            ;;
            status)
                pid=`ps -ef | grep $HOME_DIR | wc -l`
                if [[ pid == 0 ]];then
                    echo "service has stoped"
                    RETVAL=1
                else
                    echo "service is running"
                    RETVAL=0
                fi
            ;;
            *)
                echo $"Usage: $0 {start|stop|restart|status}"
                exit 1
        esac

        # 退出
        exit $RETVAL
    ```


