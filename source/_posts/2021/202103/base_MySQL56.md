---
title: MySQL_基础 (56)
date: 2021-03-05
tags: MySQL
toc: true
---

### 更好的理解MySQL
    mysql启动脚本(shell)

<!-- more -->

#### 故事背景
> 之前启动mysql都是通过系统命令systemctl start mysqld.service, 但docker里systemctl不能用,有点懵,但是我们有mysql_start.sh

#### mysql_start.sh
- eg
    ```bash
        [root@xxxxx master]# cat mysql_start.sh
        /mysql/libexec/mysqld --defaults-file=/mysql/etc/my.cnf --basedir=/mysql --datadir=/mysql/data --plugin-dir=/mysql/lib/plugin --log-error=/mysql/log/mysql.err --pid-file=/mysql/data/mysql.pid --socket=/mysql/tmp/mysql.sock --port=4307  --user=root &
    ```
- 参数解释
    * --defaults-file //默认配置文件
    * --basedir mysql安装目录
    * --datadir 数据文件目录
    * --plugin-dir 插件文件夹
    * --log-error //写错误日志的文件名
    * --pid-file //进程ID文件名
    * --socket //unix的socket文件
    * --port //端口号
    * --user 以某个系统用户启动服务器

#### wsgi_start.sh
- eg
    ```bash
        [root@xxxxx master]# cat wsgi_start.sh
        uwsgi --ini ./uwsgi/uwsgi.ini
    ```

#### wsgi_stop.sh
- eg
    ```bash
        [root@xxxxx master]# cat wsgi_stop.sh
        uwsgi --stop ./uwsgi/uwsgi.pid
    ```

#### shell_lib.sh
- eg
    ```bash
        [root@xxxxx nginx]# cat shell_lib.sh
        #!/bin/bash

        WORK_PATH=`pwd`

        function is_nginx_alive()
        {
            cd ${WORK_PATH}

            local nginx_pid=`cat logs/nginx.pid 2>/dev/null`
            if [[ "${nginx_pid}" == "" ]];then
                # 进程pid不存在、反馈1
                echo "nginx is dead"
                return 1
            else
                # 进程pid文件存在,判断文件和路径是否匹配
                local nginx_path=`ls -l /proc/${nginx_pid}/cwd 2>/dev/null | awk '{print $11}'`
                if [[ "${nginx_path}" == "${WORK_PATH}" ]];then
                    echo -e "nginx is \033[32malive\033[0m"
                    return 0
                else
                    # 进程路径和当前路径不匹配
                    echo -e "nginx is \033[31mdead\033[0m"
                    return 1
                fi
            fi
        }

        function is_all_port_listen()
        {
            local dest_port=`grep "listen" conf/*.conf |awk '{print $3}'|awk -F";" '{print $1}'|uniq|sort`

            local nginx_pid=`cat logs/nginx.pid 2>/dev/null`
            if [[ "${nginx_pid}" == "" ]];then
                # 进程pid不存在、反馈1
                return 1
            fi

            # 获得所有的nginx进程id
            local pid_list=`ps -ef|grep ${nginx_pid}|grep -v grep|awk '{print $2}'`

            local not_listen_port=""
            for each_port in ${dest_port[@]};
            do
                # 依次判断每个需要监听的端口,进程是否存在、且是当前nginx进程
                local listen_pid=`netstat -na -p 2>/dev/null|grep ${each_port} |grep LISTEN|awk '{print $7}'|awk -F"/" '{print $1}'`
                if [ "${listen_pid}" != "" ];then
                    if [[ "${pid_list}" =~ "${listen_pid}" ]];then
                        continue
                    else
                        not_listen_port="${not_listen_port} ${each_port}"
                    fi
                else
                    not_listen_port="${not_listen_port} ${each_port}"
                fi
            done

            # 如果有端口未被正常监听、报错误
            if [[ "${not_listen_port}" == "" ]];then
                echo -e "all port is \033[32mLISTEN\033[0m"
                return 0
            else
                echo -e "not all port is \033[31mLISTEN\033[0m, please check port \033[31m${not_listen_port}\033[0m"
                return 1
            fi
        }

        function start()
        {
            cd ${WORK_PATH}

            export LD_LIBRARY_PATH=./openresty/luajit/lib:./openresty/lualib:${LD_LIBRARY_PATH}
            ./openresty/nginx/sbin/nginx -p `pwd` -c conf/nginx.conf

            is_nginx_alive
            is_all_port_listen
        }

        function stop()
        {
            cd ${WORK_PATH}

            export LD_LIBRARY_PATH=./openresty/luajit/lib:./openresty/lualib:${LD_LIBRARY_PATH}
            ./openresty/nginx/sbin/nginx -p `pwd` -c conf/nginx.conf -s stop

            is_nginx_alive
            is_all_port_listen
        }

        function reload()
        {
            cd ${WORK_PATH}

            export LD_LIBRARY_PATH=./openresty/luajit/lib:./openresty/lualib:${LD_LIBRARY_PATH}
            ./openresty/nginx/sbin/nginx -p `pwd` -c conf/nginx.conf -s reload

            is_nginx_alive
            is_all_port_listen
        }

        function split_log()
        {
            cd ${WORK_PATH}

            local today=$(date +%Y-%m-%d)
            mkdir -p ./logs/backup
            mv ./logs/access.log ./logs/backup/access.log.${today}
            mv ./logs/error.log ./logs/backup/error.log.${today}

            find ./logs/backup -mtime +30 -name "*.log.*" 2>/dev/null | xargs rm -rf

            kill -USR1 $(cat ./logs/nginx.pid)
            if [ $? -eq 0 ];then
                echo "split log succ"
                echo -e "split log \033[32msucc\033[0m"
            else
                echo -e "split log \033[31mfail\033[0m"
            fi

            is_nginx_alive
            is_all_port_listen
        }
    ```

#### nginx_start.sh
- eg
    ```bash
        [root@xxxxx nginx]# cat start.sh
        #!/bin/bash
        source ./shell_lib.sh

        # 修改nginx配置文件中的uwsgi的sock路径
        sock_path="`pwd`/../master/uwsgi/uwsgi.sock"
        sock_path=`echo ${sock_path//\//\\\/}`
        static_path="`pwd`/../master/static/"
        static_path=`echo ${static_path//\//\\\/}`
        sed -i "s/.*uwsgi_pass.*/            uwsgi_pass unix:\/\/${sock_path};/g" conf/nginx.conf
        sed -i "s/.*alias.*/            alias ${static_path};/g" conf/nginx.conf

        start
    ```

#### nginx_stop.sh
- eg
    ```bash
        [root@xxxxx nginx]# cat stop.sh
        #!/bin/bash
        source ./shell_lib.sh

        stop
    ```


