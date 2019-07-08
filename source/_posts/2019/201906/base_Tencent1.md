---
title: Tencent_基础 (1)
date: 2019-06-24
tags: 
    - Tencent
    - Linux
toc: true
---

### 腾讯云操作
    腾讯云服务器配置

<!-- more -->

#### 更改主机名
- 操作
    ```bash
        [ubuntu@llllljian-cloud-tencent ~ 17:12:49 #5]$ sudo vim /etc/hostname

        [ubuntu@llllljian-cloud-tencent ~ 17:12:54 #6]$ cat /etc/hostname
        llllljian-cloud-tencent
    ```
- 结果
    ```bash
        [ubuntu@llllljian-cloud-tencent ~ 17:13:39 #8]
    ```

#### 添加新用户
- 操作
    ```bash
        [ubuntu@llllljian-cloud-tencent ~ 17:16:03 #5]$ sudo vim /etc/sudoers

        [ubuntu@llllljian-cloud-tencent ~ 17:16:42 #8]$ sudo tail -n 2 /etc/sudoers
        ubuntu  ALL=(ALL:ALL) NOPASSWD: ALL
        llllljian  ALL=(ALL:ALL) NOPASSWD: ALL

        [ubuntu@llllljian-cloud-tencent ~ 17:18:42 #9]sudo useradd llllljian -m

        [ubuntu@llllljian-cloud-tencent ~ 17:20:42 #10]sudo vim /etc/passwd
        
        [ubuntu@llllljian-cloud-tencent ~ 18:01:02 #10]$ cat /etc/passwd | grep llllljian
        llllljian:x:1000:1000::/home/llllljian:/bin/bash
    ```
- 结果

#### 公共alias设置
- 操作
    ```bash
        # 将公共别名命令写到系统配置中
        [llllljian@llllljian-cloud-tencent ~ 18:52:36 #5]$ sudo vim /etc/bash.bashrc

        # 个人配置中加载系统配置
        [llllljian@llllljian-cloud-tencent ~ 18:54:38 #7]$ tail -n 1 .bashrc
        . /etc/bash.bashrc
    ```
- 结果
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 18:55:48 #9]$ alias c
        alias c='clear'
    ```

#### Composer重新安装
- 操作
    ```bash
        # 不要用apt安装composer 版本太低 会出现问题
        # 安装之后先卸载
        [ubuntu@llllljian-cloud-tencent ~ 19:13:36 #4]$ sudo apt-get remove composer
        [ubuntu@llllljian-cloud-tencent ~ 19:15:20 #5]$ php7.0 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        sudo php7.0 composer-setup.php
        sudo php7.0 -r "unlink('composer-setup.php');"
        sudo mv composer.phar /usr/local/bin/composer
    ```
