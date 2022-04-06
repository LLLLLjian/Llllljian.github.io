---
title: MySQL_基础 (55)
date: 2021-03-04
tags: MySQL
toc: true
---

### 更好的理解MySQL
    mysql创建新用户并授权

<!-- more -->

#### 创建用户
- eg
    ```sql
        # 建立的用户名为test,密码为123的用户,
        # localhost限制在固定地址localhost登陆
        CREATE USER test@localhost IDENTIFIED BY '123456';

        # 创建远程连接用户
        create user test2 identified by '123456';
    ```
    ![创建用户](/img/20210304_1.png)

#### 授权
- 说明
    ```sql
        GRANT privileges ON databasename.tablename TO 'username'@'host'
    ```
    * privileges: 用户的操作权限,如SELECT , INSERT , UPDATE 等.如果要授予所的权限则使用 ALL
    * databasename: 数据库名
    * tablename: 表名,如果要授予该用户对所有数据库和表的相应操作权限则可用\*表示, 如*.*
    * username 指定用户
    * host 允许的ip地址, % 代表这个用户允许从任何地方登录
- eg
    ```sql
        GRANT INSERT,DELETE,UPDATE,SELECT ON test.* TO 'test'@'localhost';

        grant all privileges on *.* to 'test2'@'%'identified by '123456' with grant option;

        # 设置完权限记得刷新用户权限相关表
        flush privileges;
    ```

#### 设置与更改用户密码
- eg
    ```sql
        SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword')

        # 如果是当前登陆用户
        SET PASSWORD = PASSWORD("newpassword");

        # 例如: 
        SET PASSWORD FOR 'test2'@'%' = PASSWORD("123456");

        update mysql.user set password=password('新密码') where User="phplamp" and Host="localhost";
    ```

#### 允许远程访问
- eg
    ```bash
        # 默认绑定了本地ip,不接受其他来源
        # bind-address           = 127.0.0.1
        # 注释掉这行之后再重启mysql
    ```

#### 删除用户
- eg
    ```sql
        delete from user where User='test' and Host='localhost';
    ```


