---
title: Linux_基础 (61)
date: 2020-11-24
tags: Linux
toc: true
---

### Linux积累
    今日份学习shell脚本及免密登陆

<!-- more -->

#### 获取当前主机信息
- 目标
    * 获取到当前主机名称、IP、当前登陆用户
- 代码
    ```bash
        # !/bin/bash

        echo "hostname: `hostname`"
        default_ip=$(ifconfig|head -n 2|tail -n 1|cut -d ":" -f 2|cut -d " " -f 1)
        echo "ip: $default_ip"
        echo "username: `whoami`"
    ```

#### 随机获取可用端口号
- 目标
    * 获取指定范围内可用的随机端口
- 代码
    ```bash
        #!/bin/bash
        # @Desc 此脚本用于获取一个指定区间且未被占用的随机端口号

        PORT=0
        #判断当前端口是否被占用，没被占用返回0，反之1
        function Listening
        {
        TCPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "tcp" && $NF == "LISTEN" {print $0}' | wc -l`
        UDPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "udp" && $NF == "0.0.0.0:*" {print $0}' | wc -l`
        (( Listeningnum = TCPListeningnum + UDPListeningnum ))
        if [ $Listeningnum == 0 ]; then
            echo "0"
        else
            echo "1"
        fi
        }

        #指定区间随机数
        function random_range
        {
        shuf -i $1-$2 -n1
        }

        #得到随机端口
        function get_random_port
        {
        templ=0
        while [ $PORT == 0 ]; do
            temp1=`random_range $1 $2`
            if [ `Listening $temp1` == 0 ] ; then
                    PORT=$temp1
            fi
        done
        echo "$PORT"
        }

        get_random_port $1 $2
    ```

#### 免密登陆
- 目标
    * 就是为了让两个linux机器之间使用ssh不需要用户名和密码。采用了数字签名RSA或者DSA来完成这个操作
- 步骤
    1. 主机生成公钥 ssh-keygen -t rsa -P ''一路回车
    2. ssh-copy-id -i .ssh/id_rsa.pub  user_name@target_machine_ip
    3. 设置文件和目录权限
        ```bash
            chmod 600 authorized_keys
            chmod 700 -R .ssh
        ```
- 总结注意事项
1. 文件和目录的权限千万别设置成chmod 777.这个权限太大了，不安全，数字签名也不支持。我开始图省事就这么干了
2. 生成的rsa/dsa签名的公钥是给对方机器使用的。这个公钥内容还要拷贝到authorized_keys
3. linux之间的访问直接 ssh 机器ip
4. 某个机器生成自己的RSA或者DSA的数字签名，将公钥给目标机器，然后目标机器接收后设定相关权限（公钥和authorized_keys权限），这个目标机就能被生成数字签名的机器无密码访问了

