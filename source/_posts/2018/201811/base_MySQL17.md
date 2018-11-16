---
title: MySQL_基础 (17)
date: 2018-11-05
tags: MySQL
toc: true
---

### MySQL字符集与乱码解析
    突然觉得应该系统地再去学一遍MySQL，从零开始.

<!-- more -->

#### 字符集简介
    字符(Character)是各种文字和符号的总称，包括各国家文字、标点符号、图形符号、数字等
    字符集(Character set)是多个字符的集合，字符集种类较多，每个字符集包含的字符个数不同，常见字符集名称：ASCII字符集、GB2312字符集、BIG5字符集、 GB18030字符集、Unicode字符集等
    字符编码（Character encoding）是把字符集中的某个字符编码为指定字符集中字符，以便文本在计算机中存储和通过通信网络的传递

#### MySQL字符集
- MySQL环境变量
    * Session会话变量(有效期为当前会话结束之前)
        ```sql
            show variables like '%char%'

            set character_set_server=utf8;
        ```
    * Global全局变量(有效期为MySQL重启之前)
        ```sql
            show global variables like '%char%'

            set global character_set_database=utf8;
        ```
    * 永久修改Global的值
        ```bash
            vim /etc/my.cnf

            [mysqld]
            character-set-server=utf8 
            [client]
            default-character-set=utf8 
            [mysql]
            default-character-set=utf8
        ```
- MySQL字符集
    * character_set_client：客户端使用的字符集，当客户端向服务器发送请求时，请求以客户端字符集进行编码。
    * character_set_connection ：客户端/数据库建立的通信连接使用的字符集，MySQL服务器接收客户端的查询请求后，将其转换为character_set_connection变量指定的字符集。
    * character_set_database：数据库服务器中某个数据库的字符集，如果没有默认数据库字符集，使用 character_set_server指定的字符集。
    * character_set_results：数据库给客户端返回时的字符集，MySQL数据库把结果集和错误信息转换为character_set_results指定的字符集，并发送给客户端。
    * character_set_server：数据库服务器的字符集，内部操作字符集。
    * character_set_system：系统元数据（字段名等）使用的字符集

#### MySQL产生乱码的产生
- 原因
    * 存入和取出时对应环节的编码不一致。
    * 如果两个字符集之间无法进行无损编码转换，一定会出现乱码
