---
title: 读T代码 (02)
date: 2021-05-24
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### start_agent.sh
- code
    ```bash
        #!/usr/bin/env bash
        WORK_DIR=`pwd`
        SLEEP_TIME=300
        PYTHON_HOME="${WORK_DIR}/venv/bin/python3"
        PORT=$1

        if [ "$PORT" == "" ];then
            # 在52705..52755区间内找一个没人用的端口号
            for PORT in {52705..52755};
            do
                # 查看端口是否被占用
                Pid=`/usr/sbin/lsof -i:$PORT | awk '{ print $1 " " $2 }'`
                if [ "$Pid" != "" ];then
                    echo "agent start failed. ${PORT} has been used"
                    continue
                else
                    break
                fi
            done;
        fi

        # 查看端口是否被占用
        Pid=`/usr/sbin/lsof -i:$PORT | awk '{ print $1 " " $2 }'`
        if [ "$Pid" != "" ];then
            echo "agent start failed. ${PORT} has been used"
            exit 1
        fi

        # 将启动端口放在当前目录的.port文件中
        echo ${PORT} > ${WORK_DIR}/.port
        client_process_name="${PYTHON_HOME} test_client.py"

        if [[ ${USER} != "root"  ]];then
            echo "user not root will skip start on reboot install"
        else
            # 如果不是user就无法开机自启动
            sh start_on_reboot.sh
        fi

        function start_thread(){
            process_id=`ps -ef | grep "${client_process_name}" |grep -v grep | awk -F' ' '{print $2}'`
            if [[ -n ${process_id} ]];then
                kill -9 ${process_id}
            fi
            sleep 3

            # 启动python脚步
            cd ${WORK_DIR}/src&&${client_process_name} ${PORT} 1>>${WORK_DIR}/run.log 2>&1 &

        }
        function main() {
            # 监控进程,检测更新
            echo -e "\n\n=============daemon start=================\n\n"
            date=`date "+%Y-%m-%d %H:%M:%S"`
            echo -e "now date is ${date}\n\n"
            while [[ 1 ]];do
                #check new_version
                if [[ -f ./.new_version ]];then
                    echo "detect new version, restart"
                    if [[ $? ]];then
                        # 更新版本并重启
                        start_thread
                        rm -f ./.new_version
                    else
                        echo "remove version file failed, plase check file auth"
                        break
                    fi
                fi
                # 如果agent挂了就重新拉起
                process_id=`ps -ef | grep "${client_process_name}" |grep -v grep | awk -F' ' '{print $2}'`
                if [[ -z ${process_id} ]];then
                    echo "process is dead,restart!"
                    start_thread
                    echo "start success"
                fi
                # 死循环休息五分钟
                sleep ${SLEEP_TIME}
            done
        }
        process_count=`ps -ef | grep "$client_process_name" |grep -v grep | wc -l`
        if [[ ${process_count} -gt 0 ]];then
            echo "daemon process already exist, run stop.sh first"
            exit 1
        fi
        main 2>&1 1>>${WORK_DIR}/run.log &
        echo "success"
    ```


