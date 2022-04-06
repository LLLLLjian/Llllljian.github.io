---
title: MySQL_基础 (82)
date: 2021-11-05
tags: MySQL
toc: true
---

### 更好的理解MySQL
    Mysql备份

<!-- more -->

#### MySQL数据备份
> 在操作数据过程中, 可能会导致数据错误, 甚至数据库奔溃, 而有效的定时备份能很好地保护数据库
- mysqldump命令备份数据
    ```bash
        #MySQLdump常用
        mysqldump -u root -p --databases 数据库1 数据库2 > xxx.sql
    ```
- mysqldump常用操作示例
    ```bash
        # 备份全部数据库的数据和结构
        mysqldump -uroot -p123456 -A > /data/mysqlDump/mydb.sql

        # 备份全部数据库的结构(加 -d 参数)
        mysqldump -uroot -p123456 -A -d > /data/mysqlDump/mydb.sql

        # 备份全部数据库的数据(加 -t 参数)
        mysqldump -uroot -p123456 -A -t > /data/mysqlDump/mydb.sql

        # 备份单个数据库的数据和结构(,数据库名mydb)
        mysqldump -uroot-p123456 mydb > /data/mysqlDump/mydb.sql

        # 备份单个数据库的结构
        mysqldump -uroot -p123456 mydb -d > /data/mysqlDump/mydb.sql

        # 备份单个数据库的数据
        mysqldump -uroot -p123456 mydb -t > /data/mysqlDump/mydb.sql

        # 备份多个表的数据和结构(数据, 结构的单独备份方法与上同)
        mysqldump -uroot -p123456 mydb t1 t2 > /data/mysqlDump/mydb.sql

        # 一次备份多个数据库
        mysqldump -uroot -p123456 --databases db1 db2 > /data/mysqlDump/mydb.sql
    ```
- 还原 MySQL 备份内容
    ```bash
        # 在系统命令行中
        mysql -uroot -p123456 < /data/mysqlDump/mydb.sql

        # 在登录进入mysql系统中,通过source指令找到对应系统中的文件进行还原
        mysql> source /data/mysqlDump/mydb.sql
    ```
- 定时备份及维护固定数量备份文件
    ```bash
        #!/bin/bash

        # 保存备份个数, 备份31天数据
        number=31
        # 备份保存路径
        backup_dir=/root/mysqlbackup
        # 日期
        dd=`date +%Y-%m-%d-%H-%M-%S`
        # 备份工具
        tool=mysqldump
        # 用户名
        username=root
        # 密码
        password=TankB214
        # 将要备份的数据库
        database_name=edoctor

        #如果文件夹不存在则创建
        if [ ! -d $backup_dir ];
        then     
            mkdir -p $backup_dir;
        fi

        # 简单写法 mysqldump -u root -p123456 users > /root/mysqlbackup/users-$filename.sql
        $tool -u $username -p$password $database_name > $backup_dir/$database_name-$dd.sql

        # 写创建备份日志
        echo "create $backup_dir/$database_name-$dd.dupm" >> $backup_dir/log.txt

        # 找出需要删除的备份
        delfile=`ls -l -crt $backup_dir/*.sql | awk '{print $9 }' | head -1`

        # 判断现在的备份数量是否大于$number
        count=`ls -l -crt $backup_dir/*.sql | awk '{print $9 }' | wc -l`

        if [ $count -gt $number ]
        then
            # 删除最早生成的备份, 只保留number数量的备份
            rm $delfile
            # 写删除文件日志
            echo "delete $delfile" >> $backup_dir/log.txt
        fi
    ```




















