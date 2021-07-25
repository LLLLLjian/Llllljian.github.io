---
title: MySQL_基础 (54)
date: 2021-03-03
tags: MySQL
toc: true
---

### 更好的理解MySQL
    忘记root密码了怎么办

<!-- more -->

#### 自定义mysql密码
1. 停止mysql服务
    ```bash
        systemctl stop mysqld.service
    ```
2. 设置mysql无密码登录
    ```bash
        vim  /etc/my.cnf

        skip-grant-tables
    ```
3. 重启mysql服务
    ```bash
        systemctl  start  mysqld.service
    ```
4. 登录mysql
    ```bash
        # 不用输入密码 回车就行
        mysql -u root -p
    ```
5. 修改密码
    ```sql
        mysql> USE mysql;
        mysql> UPDATE user SET password=PASSWORD(‘root’)WHERE user=’root’;
        or
        mysql> update user set password=password("root") where user="root";
        or
        mysql> update mysql.user set authentication_string=password('root') where user='root' ;
        mysql> flush privileges
    ```
6. 回滚操作2
7. 重启mysql并使用新的账号密码登陆
    ```bash
        systemctl restart mysqld.service
        mysql -u root -p
    ```



