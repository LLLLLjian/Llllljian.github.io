---
title: MySQL_基础 (53)
date: 2021-03-02
tags: MySQL
toc: true
---

### 更好的理解MySQL
    CentOS7安装mysql5.7.27教程

<!-- more -->

#### 安装教程
1. 下载 MySQL yum包
    ```bash
        wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
    ```
2. 安装MySQL源
    ```bash
        rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
    ```
3. 安装MySQL服务端,需要等待一些时间
    ```bash
        yum install -y mysql-community-server
    ```
4. 启动MySQL
    ```bash
        systemctl start mysqld.service
    ```
5. 检查是否启动成功
    ```bash
        systemctl status mysqld.service
    ```
6. 获取临时密码,MySQL5.7为root用户随机生成了一个密码
    ```bash
        grep 'temporary password' /var/log/mysqld.log 
    ```
7. 通过临时密码登录MySQL,进行修改密码操作
    ```bash
        mysql -uroot -p
    ```
8. 设置mysql密码规则
    ```sql
        mysql> set global validate_password_policy=0;
        mysql> set global validate_password_length=1;
        mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'yourpassword';
    ```
9. 授权其他机器远程登录
    ```sql
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'yourpassword' WITH GRANT OPTION;

        # 更新授权表,使更改生效
        FLUSH PRIVILEGES;
    ```
10. 开启开机自启动
    ```bash
        systemctl enable mysqld
        systemctl daemon-reload
    ```
11. 设置MySQL的字符集为UTF-8,令其支持中文
    ```bash
        vim /etc/my.cnf

        # For advice on how to change settings please see
        # http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
        
        [mysql]
        default-character-set=utf8
        
        [mysqld]
        datadir=/var/lib/mysql
        socket=/var/lib/mysql/mysql.sock
        default-storage-engine=INNODB
        character_set_server=utf8
        
        symbolic-links=0
        
        log-error=/var/log/mysqld.log
        pid-file=/var/run/mysqld/mysqld.pid
    ```





