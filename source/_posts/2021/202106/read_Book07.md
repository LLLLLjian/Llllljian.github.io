---
title: 读书笔记 (07)
date: 2021-06-24
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 一切皆容器:Kubernetes
> Kubernetes == K8s
- pod使用实例
    ```bash
        kubectl create -f obj.json
        pod "podtest" created
    ```
    * obj.json
        ```bash
            {
                # pod对象
                "kind": "Pod",
                # 客户端使用的服务端API版本是v1
                "apoVersion": "v1",
                "metadata": {
                    # pod的名称, 在同一个namespace下唯一
                    "name": "podtest",
                    # pod所在的namespace
                    "namespace": "default",
                    "labels": {
                        "name": "redis-master"
                    }
                },
                "spec": {
                    "containers": [
                        {
                            # 容器名, 唯一标示容器, 在同一个pod内必须独一无二
                            "name": "master1",
                            # 容器使用的Docker镜像名
                            "image": "k8stest/redis:test",
                            # 启动Docker容器时运行的命令
                            "command": []
                            # 端口映射, 容器打开的所有端口
                            "ports": [
                                {
                                    # 容器监听的端口号
                                    "containerPort": 6379,
                                    # 容器端口在宿主机上的端口映射
                                    "hostPort": 6388,
                                    # 端口类型
                                    "protocol": "TCP",
                                    # 在容器运行前设置的环境变量
                                    "env": []
                                }
                            ]
                        },
                        {
                            "name": "master2",
                            "image": "k8stest/sshd:test",
                            "ports": [
                                {
                                    "containerPort": 22,
                                    "hostPort": 8888
                                }
                            ]
                        }
                    ],
                    # pod内容器重启策略, 包括三种策略: Always、OnFailure、Never
                    "RestartPolicy": ""
                }
            }
        ```
- replication controller设计解读
    * 它决定了一个pod有多少同时运行的副本, 并保证这些副本的期望状态与当前状态一致.所以, 如果创建了一个pod并且在希望该pod是持续运行的应用时\[即仅适用于重启策略(RestartPolicy)为Always的pod],一般都推荐同时给pod创建一个replication controller, 让这个controller一直守护pod, 直到pod被删除
    * pod状态值
        <table><tbody><tr><td>状态</td><td>描述</td></tr><tr><td>Running　　　　　　</td><td>该 Pod 已经绑定到了一个节点上, Pod 中所有的容器都已被创建.至少有一个容器正在运行, 或者正处于启动或重启状态.</td></tr><tr><td>Pending</td><td>Pod 已被 Kubernetes 系统接受, 但有一个或者多个容器镜像尚未创建.等待时间包括调度 Pod 的时间和通过网络下载镜像的时间, 这可能需要花点时间.创建pod的请求已经被k8s接受, 但是容器并没有启动成功, 可能处在：写数据到etcd, 调度, pull镜像, 启动容器这四个阶段中的任何一个阶段, pending伴随的事件通常会有：ADDED, Modified这两个事件的产生</td></tr><tr><td>Succeeded</td><td>Pod中的所有的容器已经正常的自行退出, 并且k8s永远不会自动重启这些容器, 一般会是在部署job的时候会出现.</td></tr><tr><td>Failed</td><td>Pod 中的所有容器都已终止了, 并且至少有一个容器是因为失败终止.也就是说, 容器以非0状态退出或者被系统终止.</td></tr><tr><td>Unknown</td><td>出于某种原因, 无法获得Pod的状态, 通常是由于与Pod主机通信时出错.</td></tr></tbody></table>
    * pod状态流转
        ![pod状态流转](/img/20210624_1.png)
    * eg
        ```bash
            {
                # 客户端使用的服务端API版本是v1
                "apiVersion": "v1",
                # replication controller对象
                "kind": "ReplicationController",
                "metadata": {
                    "name": "redis-controller",
                    # replication controller自身的
                    "labels": {
                        "name": "redis"
                    }
                },
                "spec": {
                    # pod副本数为1
                    "replicas": 1,
                    "selector": {
                        # 控制所有labels为{"name": "redis"}的pod
                        "name": "redis"
                    },
                    "template": {
                        "metadata": {
                            # replication controller管理的pod的
                            "labels": {
                                "name": "redis"
                            }
                        },
                        "spec": {
                            "containers": [
                                {
                                    "name": "redis",
                                    "image": "k8stest/redis:test",
                                    "imagePullPolicy": "IfNotPresent",
                                    "ports": [
                                        {
                                            # 容器监听的端口号
                                            "containerPort": 6379,
                                            # 容器端口在宿主机上的端口映射
                                            "hostPort": 6388
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                }
            }
        ```




