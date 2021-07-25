---
title: 读T代码 (01)
date: 2021-05-21
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### install.sh
- code
    ```bash
        #!/bin/sh
        # 当前的路径
        WORK_DIR=`pwd`
        # 当前的agent
        PNAME=${WORK_DIR}/'agent'
        # 是否指定了启动端口
        PORT=$1
        if [[ -z "${PORT}" ]];then
            # 没有指定的话 默认为52000
            PORT=52000
        fi

        # 查看进程是否存在
        running_count=`ps -ef | grep PNAME | grep -v grep | wc -l`        
        if [[ $running_count > 0 ]];then
            echo "there is already agent."
            exit 1
        fi

        # 如果端口号没传就自己找一个
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

        # wget nginx文件服务器下的压缩包并解压, 将整个文件夹权限改为755
        chmod -R 755 agent
        # cd到该文件夹下并执行停止脚本
        cd agent && sh stop.sh ${PORT}

        # 判断一下执行当前shell脚本的用户是否为root
        if [[ ${USER} != "root"  ]];then
            echo "user not root will skip start on reboot install"
        else
            # 只有root用户才能设置开机自启动
            sh start_on_reboot.sh
        fi

        # 使用PORT启动agent
        sh start_agent.sh ${PORT}
        count=0
        # 试着向启动的agent发送三次请求
        while [[ ${count} -lt 3 ]]
        do
            count=$[$count+1]
            sleep 4
            echo "try to connect with client, $count times"
            # 
            curl -s http://localhost:${PORT} > /dev/null
        done
        # $? 上一个命令的返回结果 非0表示失败了
        if [[ $? != 0 ]];then
            echo "agent start failed."
            exit 1
        else
            # agent启动成功了, 启动的端口是PORT
            echo "install agent success, agent start on port:${PORT}"
            # 删除安装文件及压缩包
            cd ${WORK_DIR}&&rm -f ./agent.tar.gz&&rm -f ./install_agent.sh
        fi
    ```


