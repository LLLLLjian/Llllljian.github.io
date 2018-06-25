---
title: Apache_基础 (5)
date: 2018-06-23
tags: Apache
toc: true
---

### LAMP
    Ubuntu17.04下安装LAMP

<!-- more -->

#### L
    Linux系统
    进行更新操作.sudo apt-get update
- 安装
    ```bash
        [llllljian@llllljian-virtual-machine ~ 21:35:35 #3]$ sudo apt-get update
        ...
        无法解析域名“xxxxx.com”
        ...

        进到Ubuntu桌面, 系统设置-软件和更新-下载自-其它站点-选择最佳服务器-保存-更新
        重新执行sudo apt-get update即可,就完成了第一步操作
    ```
    
#### A
    Apache服务器
    进行安装操作sudo apt-get install apache2
- 安装
    ```bash
        [llllljian@llllljian-virtual-machine ~ 21:43:05 #6]$ sudo apt-get install apache2

        [llllljian@llllljian-virtual-machine var 22:09:49 #42]$ sudo vim /etc/apache2/apache2.conf
        <Directory /var/www/>   =>  <Directory /var/apache/>

        [llllljian@llllljian-virtual-machine var 22:10:54 #51]$ sudo vim /etc/apache2/sites-available/000-default.conf
        DocumentRoot /var/www/html   =>  DocumentRoot /var/apache/html

        [llllljian@llllljian-virtual-machine var 22:22:34 #58]$ sudo cp -r /var/www/ /var/apache
        
        [llllljian@llllljian-virtual-machine etc 22:36:45 #104]$ sudo /etc/init.d/apache2 restart
        [ ok ] Restarting apache2 (via systemctl): apache2.service.
        
        打开浏览器访问http://127.0.0.1/
    ```

#### M
    MySQL数据库
    进行安装操作
- 安装
    ```bash
        [llllljian@llllljian-virtual-machine ~ 22:43:52 #2]$ sudo apt-get install mysql-server

        [llllljian@llllljian-virtual-machine ~ 22:48:49 #10]$ mysql_secure_installation
        
        Securing the MySQL server deployment.

        Enter password for user root:

        VALIDATE PASSWORD PLUGIN can be used to test passwords
        and improve security. It checks the strength of password
        and allows the users to set only those passwords which are
        secure enough. Would you like to setup VALIDATE PASSWORD plugin?

        Press y|Y for Yes, any other key for No: N
        Using existing password for root.
        Change the password for root ? ((Press y|Y for Yes, any other key for No) :

        ... skipping.
        By default, a MySQL installation has an anonymous user,
        allowing anyone to log into MySQL without having to have
        a user account created for them. This is intended only for
        testing, and to make the installation go a bit smoother.
        You should remove them before moving into a production
        environment.

        Remove anonymous users? (Press y|Y for Yes, any other key for No) : Y
        Success.


        Normally, root should only be allowed to connect from
        'localhost'. This ensures that someone cannot guess at
        the root password from the network.

        Disallow root login remotely? (Press y|Y for Yes, any other key for No) : Y
        Success.

        By default, MySQL comes with a database named 'test' that
        anyone can access. This is also intended only for testing,
        and should be removed before moving into a production
        environment.


        Remove test database and access to it? (Press y|Y for Yes, any other key for No) : Y
        - Dropping test database...
        Success.

        - Removing privileges on test database...
        Success.

        Reloading the privilege tables will ensure that all changes
        made so far will take effect immediately.

        Reload privilege tables now? (Press y|Y for Yes, any other key for No) : Y
        Success.

        All done!
        [llllljian@llllljian-virtual-machine ~ 22:49:41 #11]$ mysql -u root -p
        Enter password:
        Welcome to the MySQL monitor.  Commands end with ; or \g.
        Your MySQL connection id is 8
        Server version: 5.7.17-0ubuntu1 (Ubuntu)

        Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

        Oracle is a registered trademark of Oracle Corporation and/or its
        affiliates. Other names may be trademarks of their respective
        owners.

        Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

        mysql> exit
        Bye
    ```

#### P
    PHP编程语言
    进行安装操作sudo apt-get install php7.0
- 安装
    ```bash
        [llllljian@llllljian-virtual-machine run 23:02:02 #64]$ apt-cache search php- | less
        
        [llllljian@llllljian-virtual-machine run 23:06:33 #65]$ sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql

        [llllljian@llllljian-virtual-machine ~ 23:33:03 #11]$ php /var/apache/html/info.php
        phpinfo()
        PHP Version => 7.0.15-1ubuntu4

        打开浏览器访问http://127.0.0.1/info.php

        安装phpadmin
        [llllljian@llllljian-virtual-machine ~ 23:41:09 #17]$ sudo apt-get install phpmyadmin

        [llllljian@llllljian-virtual-machine ~ 23:44:43 #19]$ sudo cp /etc/phpmyadmin/apache.conf /etc/apache2/conf-enabled/phpmyadmin.conf

        [llllljian@llllljian-virtual-machine html 23:50:46 #38]$ sudo ln -s /usr/share/phpmyadmin phpmyadmin
        
        打开浏览器访问http://127.0.0.1/phpmyadmin/
    ```

#### 查看安装版本
    ```bash
        [llllljian@llllljian-virtual-machine html 23:56:08 #41]$ ps aux | grep apache
        root      1179  0.0  2.8 135228 29076 ?        Ss   11:29   0:00 /usr/sbin/apache2 -k start
        www-data  6698  0.0  2.1 137848 22456 ?        S    11:43   0:00 /usr/sbin/apache2 -k start
        www-data  6699  0.1  2.3 138020 24132 ?        S    11:43   0:00 /usr/sbin/apache2 -k start
        www-data  6700  0.0  1.5 137796 15904 ?        S    11:43   0:00 /usr/sbin/apache2 -k start
        www-data  6703  0.1  2.2 137848 23372 ?        S    11:43   0:00 /usr/sbin/apache2 -k start
        www-data  6704  0.0  2.3 137848 24212 ?        S    11:43   0:00 /usr/sbin/apache2 -k start
        www-data  9232  0.0  2.3 137848 23976 ?        S    11:45   0:00 /usr/sbin/apache2 -k start
        www-data  9295  0.2  2.3 137856 24232 ?        S    11:51   0:00 /usr/sbin/apache2 -k start
        www-data  9296  0.0  1.5 137804 15880 ?        S    11:51   0:00 /usr/sbin/apache2 -k start
        www-data  9298  0.1  2.2 137848 23376 ?        S    11:51   0:00 /usr/sbin/apache2 -k start
        www-data  9299  0.0  0.9 135284  9352 ?        S    11:51   0:00 /usr/sbin/apache2 -k start
        lllllji+  9310  0.0  0.0   5140   856 pts/1    S+   11:56   0:00 grep --color=auto apache

        [llllljian@llllljian-virtual-machine html 23:56:26 #42]$ ps aux | grep mysql
        mysql     1051  0.2  4.6 549436 47476 ?        Ssl  11:29   0:04 /usr/sbin/mysqld
        lllllji+  9312  0.0  0.0   5140   852 pts/1    S+   11:56   0:00 grep --color=auto mysql

        [llllljian@llllljian-virtual-machine share 00:07:22 #10]$ sudo /etc/init.d/apache2 stop
        [ ok ] Stopping apache2 (via systemctl): apache2.service.

        [llllljian@llllljian-virtual-machine share 00:08:35 #12]$ sudo /etc/init.d/mysql stop
        [ ok ] Stopping mysql (via systemctl): mysql.service.

        Apache 启动 sudo /etc/init.d/apache2 start
        Apache 重启 sudo /etc/init.d/apache2 restart
        Apache 关闭 sudo /etc/init.d/apache2 stop

        mysql 启动 sudo /etc/init.d/mysql start
        mysql 重启 sudo /etc/init.d/mysql restart
        mysql 关闭 sudo /etc/init.d/mysql stop

        查看版本
        [llllljian@llllljian-virtual-machine share 00:11:00 #14]$ uname -a
        Linux llllljian-virtual-machine 4.10.0-19-generic #21-Ubuntu SMP Thu Apr 6 17:03:14 UTC 2017 i686 i686 i686 GNU/Linux
        
        [llllljian@llllljian-virtual-machine share 00:12:52 #17]$ cat /etc/issue
        Ubuntu 17.04 \n \l

        [llllljian@llllljian-virtual-machine share 00:13:21 #19]$ apache2  -v
        Server version: Apache/2.4.25 (Ubuntu)
        Server built:   2017-02-10T16:53:43

        [llllljian@llllljian-virtual-machine share 00:13:40 #21]$ mysql -V
        mysql  Ver 14.14 Distrib 5.7.17, for Linux (i686) using  EditLine wrapper

        [llllljian@llllljian-virtual-machine share 00:14:17 #25]$ php -v
        PHP 7.0.15-1ubuntu4 (cli) (built: Feb 28 2017 21:33:59) ( NTS )
        Copyright (c) 1997-2017 The PHP Group
        Zend Engine v3.0.0, Copyright (c) 1998-2017 Zend Technologies
        with Zend OPcache v7.0.15-1ubuntu4, Copyright (c) 1999-2017, by Zend Technologies

        vim ~/.bashrc
        
        ...
        alias apache2S='sudo /etc/init.d/apache2 start'
        alias apache2R='sudo /etc/init.d/apache2 restart'
        alias apache2E='sudo /etc/init.d/apache2 stop'

        alias mysql5S='sudo /etc/init.d/mysql start'
        alias mysql5R='sudo /etc/init.d/mysql restart'
        alias mysql5E='sudo /etc/init.d/mysql stop'
        ...

        source !$
    ```