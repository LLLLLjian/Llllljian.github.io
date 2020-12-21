---
title: Hadoop_基础 (05)
date: 2020-11-27
tags: Hadoop
toc: true
---

### 快来跟我一起学HDFS
    还需要学一下大数据
    先看看Hadoop

<!-- more -->

#### HDFS写操作(宏观)
1. 客户端向HDFS发送写数据请求
    ```bash
        hdfs dfs -put xxx.zip /study/
    ```
2. HDFS通过rpc调用nn的create方法
    * nn首先检查是否有足够的空间权限等条件创建这个文件, 或者这个路径是否已经存在
        * 有: nn创建一个空的Entry对象, 并返回成功状态给HDFS
        * 无: 直接抛出异常, 并给予客户端错误提示信息
3. DFS如果接受到成功状态, 会创建一个对象FSDataOutputStream的对象给客户端使用
4. 客户端需要向NN询问第一个Block存放的位置(node1 node2 node8)
5. 需要将客户端和DN创建连接
    * pipeline管道
        * 客户端和node1创建Socket连接
        * node1和node2创建Socket连接
        * node2和node8创建Socket连接
6. 客户端将文件按照块Bolck切分数据, 但是按照packet(默认64k)发送数据
7. 客户端通过pipeline管道开始使用FSDataOutputStream对象将数据输出
    * 客户端首先将一个packet发送给node1, 同时给予node1一个ack状态
    * node1接受数据之后会将数据继续传递给node2, 同时给予node2一个ack状态
    * node2接受数据之后会将数据继续传递给node8, 同时给予node8一个ack状态
    * node8将这个packet接受完之后会响应ack=true给node2
    * 同理node2响应给node1, node1会响应给客户端
8. 客户端接到成功的状态之后会继续传递下一个packet给node1, 直到所有的packet都发送完成
9. 如果客户端接受到最后一个packet的成功状态, 说明当前Block传输完成
10. 客户端会将这个消息传递给NN, NN确认传输完成
    * NN会将Block的信息记录到Entry
    * Block1 (node1 node2 node8)
    * Block2 (node1 node8 node9)
    * ....
11. 客户端会继续向NN询问第二个块的存放位置
12. 关闭FSDataOutputStream

#### HDFS写操作(微观)






