---
title: 读书笔记 (21)
date: 2021-07-14
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 深入理解StatefulSet(一):拓扑状态
- 引子: 先引入两个名词概念
    * 拓扑状态。这种情况意味着，应用的多个实例之间不是完全对等的关系。这些应用实例，必 须按照某些顺序启动，比如应用的主节点 A 要先于从节点 B 启动。而如果你把 A 和 B 两个 Pod 删除掉，它们再次被创建出来时也必须严格按照这个顺序才行。并且，新创建出来的 Pod，必须和原来 Pod 的网络标识一样，这样原先的访问者才能使用同样的方法，访问到 这个新 Pod。
    * 存储状态。这种情况意味着，应用的多个实例分别绑定了不同的存储数据。对于这些应用实 例来说，Pod A 第一次读取到的数据，和隔了十分钟之后再次读取到的数据，应该是同一 份，哪怕在此期间 Pod A 被重新创建过。这种情况最典型的例子，就是一个数据库应用的 多个存储实例。
- Headless Service
    ```bash
        # 标准的Headless Service对应的YAML文件
        apiVersion: v1
        kind: Service
        metadata:
            name: nginx
            labels:
                app: nginx
        spec:
            ports:
            - port: 80
              name: web
            # Service 被创建后并不会被分配一个 VIP(Virtual IP，即:虚拟 IP)，而是会以 DNS 记录 的方式暴露出它所代理的 Pod
            clusterIP: None
            selector:
                # 所有携带了 app=nginx 标签的 Pod，都会被这 个 Service 代理起来
                app: nginx
    ```
- StatefulSet
    ```BASH
        apiVersion: apps/v1
        kind: StatefulSet
        metadata:
            name: web
        spec:
            serviceName: "nginx"
            replicas: 2
            selector:
                matchLabels:
                    app: nginx
            template:
                metadata:
                    labels:
                        app: nginx
                spec:
                    containers:
                    - name: nginx
                      image: nginx:1.9.1 
                      ports:
                      - containerPort: 80
                        name: web
    ```







