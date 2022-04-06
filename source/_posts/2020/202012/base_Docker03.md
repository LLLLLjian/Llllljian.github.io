---
title: Docker_基础 (03)
date: 2020-12-31
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    快来学Docker容器！！！

<!-- more -->

#### 先说说我要做的事
> 我的程序运行在docker环境里, 我现在想把我在docker的日志拿出来,  也想传点东西进docker里, 快来学cp

#### 学习笔记
1. 从容器里面拷文件到宿主机
    * 需要执行的命令
        ```bash
            docker cp 容器名: 要拷贝的文件在容器里面的路径       要拷贝到宿主机的相应路径
        ```
    * eg
        ```bash
            # 假设容器名为testtomcat,要从容器里面拷贝的文件路为: /usr/local/tomcat/webapps/test/js/test.js,  现在要将test.js从容器里面拷到宿主机的/opt路径下面
            docker cp testtomcat:/usr/local/tomcat/webapps/test/js/test.js /opt
        ```
2. 从宿主机拷文件到容器里面
    * 需要执行的命令
        ```bash
            docker cp 要拷贝的文件路径 容器名: 要拷贝到容器里面对应的路径
        ```
    * eg
        ```bash
            # 假设容器名为testtomcat,现在要将宿主机/opt/test.js文件拷贝到容器里面的/usr/local/tomcat/webapps/test/js路径下面
            docker cp /opt/test.js testtomcat:/usr/local/tomcat/webapps/test/js
        ```






