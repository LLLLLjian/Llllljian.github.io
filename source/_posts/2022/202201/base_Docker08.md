---
title: Docker_基础 (8)
date: 2022-01-10
tags: 
    - Docker
    - MongoDB
toc: true
---

### Docker+mongoDB
    mongo服务搭建(docker环境)

<!-- more -->

#### 搭建
1. 下载官方提供的mongo镜像
    ```bash
        docker pull mongo
    ```
2. 在宿主机新建文件夹,用于映射mongo的数据存储位置
    ```bash
        mkdir /home/mongo-data
    ```
3. 创建mongo容器并端口映射
    ```bash
        docker run --name mongo_test -p 8003:27017 -v /home/mongo-data:/data/db -d mongo
    ```
4. 测试是否成功启动
    ```bash
        docker exec -it {容器ID} /bin/bash
        # 进入容器之后查看mongo进程
        ps aux
        # 输入mongo进入数据库命令行模式, 查看dbs
        > show dbs
        admin   0.000GB
        config   0.000GB
        local   0.000GB
    ```
5. 验证是否可以远程连接
    ```python
        import pymongo
 
        myclient = pymongo.MongoClient("mongodb://127.0.0.1:8003")
        print(myclient)
        print(myclient.list_database_names())
    ```
6. 开启访问验证
> mongodb密码和传统数据如mysql等有些区别：mongodb的用户名和密码是基于特定数据库的, 而不是基于整个系统的.所以所有数据库db都需要设置密码
    ```bash
        # 进入admin数据库
        use admin
        # 创建管理员账户
        db.createUser(
            {
                user: "root",
                pwd: "root",
                roles: [
                    {
                        role: "userAdminAntDatabase",
                        db: "admin"
                    }
                ]
            }
        )

        # 验证创建用户是否成功, 如果返回1, 则表示创建成功
        db.auth("root", "root")
        # 修改配置 /etc/mongod.conf
        # 添加
        security:
            authorization: enabled
    ```
7. mongo配置
    ```bash
        [root@xxxxxx mongo-data]# cat mongo.conf
        bind_ip=0.0.0.0
        port=27017
        dbpath=/data/db
        logpath=/data/dbmongodb.log
        logappend=true
        auth=true
    ```




