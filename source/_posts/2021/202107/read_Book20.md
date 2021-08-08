---
title: 读书笔记 (20)
date: 2021-07-13
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 经典PaaS的记忆:作业副本与水平扩展
> Deployment 就需要遵循一种叫作“滚动更新”(rolling update)的方式, 来升级现有的容器.而这个能力的实现, 依赖的是 Kubernetes 项目中的一个非常重要的概念(API 对象): ReplicaSet.
> Deployment 控制 ReplicaSet(版本), ReplicaSet 控制 Pod(副本 数).这个两层控制关系一定要牢记
- ReplicaSet
    ```yaml
        apiVersion: apps/v1
        kind: ReplicaSet
        metadata:
            name: nginx-set
            labels:
                app: nginx
        spec:
            replicas: 3
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
                        image: nginx:1.7.9
    ```
- Deployment
    ```yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
            name: nginx-deployment
            labels:
                app: nginx
        spec:
            # 副本个数
            replicas: 3
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
                      image: nginx:1.7.9
                      ports:
                      - containerPort: 80
    ```
- Deployment+ReplicaSet+Pod
    ![Deployment+ReplicaSet+Pod](/img/20210713_1.png)
- 水平扩展
    ```bash
        $ kubectl scale deployment nginx-deployment --replicas=4 deployment.apps/nginx-deployment scaled
    ```
- 滚动更新
    ```bash
        # 创建nginx-deployment
        # –record 记录下每次操作所执行的命令,  以方便后面查看
        $ kubectl create -f nginx-deployment.yaml --record

        $ kubectl get deployments
        NAME             DESIRED    CURRENT UP-TO-DATE AVAILABLE AGE 
        nginx-deployment 3          0       0          0         1s

        # DESIRED:用户期望的 Pod 副本个数(spec.replicas 的值)
        # CURRENT:当前处于 Running 状态的 Pod 的个数
        # UP-TO-DATE:当前处于最新版本的 Pod 的个数, 所谓最新版本指的是 Pod 的 Spec 部分 与 Deployment 里 Pod 模板里定义的完全一致
        # AVAILABLE:当前已经可用的 Pod 的个数, 即:既是 Running 状态, 又是最新版本, 并 且已经处于 Ready(健康检查正确)状态的 Pod 的个数.

        $ kubectl rollout status deployment/nginx-deployment
        Waiting for rollout to finish: 2 out of 3 new replicas have been updated... deployment.apps/nginx-deployment successfully rolled out

        $ kubectl get deployments
        NAME             DESIRED    CURRENT UP-TO-DATE AVAILABLE AGE 
        nginx-deployment 3          3       3          3         20s

        $ kubectl get rs
        NAME                        DESIRED CURRENT READY AGE 
        nginx-deployment-3167673210 3       3       3     20s

        # 修改Etcd中API对象
        # kubectl edit 指令编辑完成后, 保存退出, Kubernetes 就会立刻触发“滚动更新”的过程
        $ kubectl edit deployment/nginx-deployment ...
        ...
            spec:
                containers:
                - name: nginx
                  image: nginx:1.9.1 # 1.7.9 -> 1.9.1
                  ports:
                  - containerPort: 80
        ...
        deployment.extensions/nginx-deployment edited

        # 通过 kubectl rollout status 指令查看 nginx-deployment 的状态变化
        $ kubectl rollout status deployment/nginx-deployment
        Waiting for rollout to finish: 2 out of 3 new replicas have been updated... deployment.extensions/nginx-deployment successfully rolled out

        # 通过kubectl describe deployment nginx-deployment可以查看整个“滚动更新”的流程
        $ kubectl describe deployment nginx-deployment

        # 在这个“滚动更新”过程完成之后, 你可以查看一下新、旧两个 ReplicaSet 的最终状态
        # 旧ReplicaSet(hash=3167673210)已经被“水平收缩”成了0个副本
        $ kubectl get rs
        NAME                        DESIRED CURRENT READY AGE 
        nginx-deployment-1764197365 3       3       3     6s 
        nginx-deployment-3167673210 0       0       0     30s
    ```
    * RollingUpdateStrategy可以控制每次滚到的数量
        ```yaml
            apiVersion: apps/v1
            kind: Deployment
            metadata:
                name: nginx-deployment
                labels:
                    app: nginx
            spec:
            ...
            strategy:
                type: RollingUpdate
                rollingUpdate:
                    # 这两个配置还可以用前面我们介绍的百分比形式来表示, 比如: maxUnavailable=50%, 指的是我们最多可以一次删除“50%*DESIRED 数量”个 Pod.
                    # 除了 DESIRED 数量之 外, 在一次“滚动”中, Deployment 控制器还可以创建多少个新 Pod 
                    maxSurge: 1
                    # 在一次“滚动”中, Deployment 控制器可以删除多少个旧 Pod
                    maxUnavailable: 1
        ```
    * ![Deployment+ReplicaSet+Pod](/img/20210713_2.png)
- Deployment对应用进行版本控制的具体原理
    ```bash
        # 把这个镜像名字修改成为了一个错误的名字, 比如:nginx:1.91.这样, 这个 Deployment 就会出现一个升级失败的版本
        $ kubectl set image deployment/nginx-deployment nginx=nginx:1.91 deployment.extensions/nginx-deployment image updated

        # 检查一下ReplicaSet的状态
        # 因为没有有效镜像nginx:1.91, 所以pod没有进入到READY状态
        $ kubectl get rs
        NAME                          DESIRED   CURRENT   READY   AGE
        nginx-deployment-1764197365   2         2         2       24s
        nginx-deployment-3167673210   0         0         0       35s
        nginx-deployment-2156724341   2         2         0       7s

        # 回滚到上一个版本
        $ kubectl rollout undo deployment/nginx-deployment
        deployment.extensions/nginx-deployment

        # 查看历史rs版本
        $ kubectl rollout history deployment/nginx-deployment deployments "nginx-deployment"
        REVISION CHANGE-CAUSE
        1        kubectl create -f nginx-deployment.yaml --record
        2        kubectl edit deployment/nginx-deployment
        3        kubectl set image deployment/nginx-deployment nginx=nginx:1.91

        # 通过这个 kubectl rollout history 指令, 看到每个版本对应的 Deployment 的 API 对象的细节
        $ kubectl rollout history deployment/nginx-deployment --revision=2

        # 回滚到指定版本
        # 在 kubectl rollout undo 命令行最后, 加上要回滚到的指定版本的版本号, 就可以回滚到指定版本了
        $ kubectl rollout undo deployment/nginx-deployment --to-revision=2 
        deployment.extensions/nginx-deployment

        # 能不能只生成一个rs
        # kubectl rollout pause可以让Deployment暂停
        $ kubectl rollout pause deployment/nginx-deployment deployment.extensions/nginx-deployment paused

        # kubectl rollout resume可以让Deployment恢复
        $ kubectl rollout resume deploy/nginx-deployment 
        deployment.extensions/nginx-deployment resumed
    ```
- 思考
    * 这样的话, 随着时间的推移会不会有很多rs
    * 可以使用spec.revisionHistoryLimit来限制Deployment保留的历史版本个数


