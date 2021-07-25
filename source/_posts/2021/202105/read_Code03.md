---
title: 读T代码 (03)
date: 2021-05-25
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### stop.sh
- code
    ```bash
        #!/usr/bin/env bash
        WORK_DIR=`pwd`
        SLEEP_TIME=300
        PYTHON_HOME="${WORK_DIR}/venv/bin/python3"
        # 获取启动端口号
        port=`cat ${WORK_DIR}/.port 2>/dev/null`
        if [[ $?==0 ]];then
            PORT=${port}
        else
            # 没有值的话 说明agent没有启动
            echo "agent not start"
            exit 0
        fi

        # 守护进程
        client_process_name="${PYTHON_HOME} test_client.py"
        # 启动进程 先看看有没有指定端口启动的, 防止混布误杀
        daemon_name="start_agent.sh ${PORT}"
        daemon_id=`ps -ef | grep "${daemon_name}" |grep -v grep | awk -F' ' '{print \$2}'`
        if [[ -n ${daemon_id} ]];then
            echo "kill daemon process"
            ps -ef | grep "${daemon_name}" |grep -v grep | awk -F' ' '{print $2}' | xargs kill -9
        else
            # 如果没有这个进程说明启动的时候没有指定端口号
            daemon_name="start_agent.sh"
            daemon_id=`ps -ef | grep "${daemon_name}" |grep -v grep | awk -F' ' '{print \$2}'`
            if [[ -n ${daemon_id} ]];then
                echo "kill daemon process"
                ps -ef | grep "${daemon_name}" |grep -v grep | awk -F' ' '{print $2}' | xargs kill -9
            fi
        fi
        process_id=`ps -ef | grep "${client_process_name}" |grep -v grep | awk -F' ' '{print \$2}'`
        if [[ -n ${process_id} ]];then
            echo "kill agent process..."
            ps -ef | grep "test_client.py" |grep -v grep | awk -F' ' '{print $2}' | xargs kill -9
        fi
        echo "stop agent done."
    ```


