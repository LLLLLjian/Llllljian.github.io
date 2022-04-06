---
title: 读书笔记 (08)
date: 2021-06-25
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
- service
    * 或许定名weiproxy或router更贴切
    * 需要一个代理来确保需要使用pod的应用不需要知晓pod的真实IP地址
    * 需要一个代理来为这些pod做负载均衡
    * eg
        ```bash
            {
                # 本service会将外部流量转发到所有label匹配"app": "MyApp"的pod的9376TCP端口上
                "kind": "Service",
                "apiVersion": "v1",
                "metadata": {
                    "name": "my-service",
                    "label": {
                        "environment": "testing"
                    }
                },
                "spec": {
                    "selector": {
                        "app": "MyApp"
                    },
                    "ports": {
                        "protocol": "TCP",
                        "port": 80,
                        "targetPort": 9376
                    }
                }
            }
        ```
- replica set
    * 可以认为是replication controller的升级版, 用于保证与label selector匹配的pod数量维持在期望状态
    * 区别在于, replica set引入了对基于子集的selector查询条件, 而replication controller仅支持基于值相等的selector条件查询
- configMap
    * ConfigMap是存储通用的配置变量的, 类似于配置文件, 使用户可以将分布式系统中用于不同模块的环境变量统一到一个对象中管理；而它与配置文件的区别在于它是存在集群的“环境”中的, 并且支持K8S集群中所有通用的操作调用方式.从数据角度来看, ConfigMap的类型只是键值组, 用于存储被Pod或者其他资源对象(如RC)访问的信息.这与secret的设计理念有异曲同工之妙, 主要区别在于ConfigMap通常不用于存储敏感信息, 而只存储简单的文本信息
    * 创建pod时, 对configmap进行绑定, pod内的应用可以直接引用ConfigMap的配置.相当于configmap为应用/运行环境封装配置.pod使用ConfigMap, 通常用于: 设置环境变量的值、设置命令行参数、创建配置文件.
    * 创建configMap
        ```bash
            [llllljian@llllljian-virtual-machine configmap]$ ll
            game.properties
            ui.properties

            [llllljian@llllljian-virtual-machine configmap]$ cat game.properties
            enemies=aliens
            lives=3
            enemies.cheat=true
            enemies.cheat.level=noGoodRotten
            secret.code.passphrase=UUDDLRLRBABAS
            secret.code.allowed=true
            secret.code.lives=30

            [llllljian@llllljian-virtual-machine configmap]$ cat ui.properties
            color.good=purple
            color.bad=yellow
            allow.textmode=true
            how.nice.to.look=fairlyNice

            [llllljian@llllljian-virtual-machine configmap]$ kubect; create configmap game-config --from-file=configmap
            [llllljian@llllljian-virtual-machine configmap]$ kubectl get configmaps game-config -o yaml
            apiVersion: v1
            data:
                game.properties: |
                    enemies=aliens
                    lives=3
                    enemies.cheat=true
                    enemies.cheat.level=noGoodRotten
                    secret.code.passphrase=UUDDLRLRBABAS
                    secret.code.allowed=true
                    secret.code.lives=30
                ui.properties: |
                    color.good=purple
                    color.bad=yellow
                    allow.textmode=true
                    how.nice.to.look=fairlyNice
            kind: ConfigMap
            metadata:
                creationTimestemp: 2021-0625T03:05:42Z
                name: game-config
                namespace: defalut
                resourceVersion: "33156"
                selfLink: /api/v1/namespaces/default/configmaps/game-config
                uid: be9c299b-1980-11e6-9b70-001c42708c0c

            [llllljian@llllljian-virtual-machine configmap]$ kubectl create configmap game-config-2 --from-file=configmap/game.properties

            [llllljian@llllljian-virtual-machine configmap]$ kubectl create configmap game-config-3 --from-file=game-special.how=configmap/game.properties

            [llllljian@llllljian-virtual-machine configmap]$ kubectl create configmap special-config --from-literal=special.how=very --from-literal=special.type=charm

            [llllljian@llllljian-virtual-machine configmap]$ kubectl get configmaps special-config -o yaml
            apiVersion: v1
            data:
                special.how: very
                special.type: charm
            kind: configMap
            metadata:
                creationTimestemp: 2021-0625T03:08:42Z
                name: special-config
                namespace: defalut
                resourceVersion: "33175"
                selfLink: /api/v1/namespaces/default/configmaps/special-config
                uid: 2beb23c3-1981-11e6-9b70-001c42708c0c
        ```
    * 使用configMap 
        ```bash
            # 通过环境变量调用 
            [llllljian@llllljian-virtual-machine ~]$ cat depi-test-pod.yaml
            apiVersion: v1
            kind: Pod
            metadata:
                name: dapi-test-pod
            spec:
                containers:
                    - name: test-container
                      image: gcr.io/google_containers/busybox
                      command: ["/bin/sh", "-c", "env"]
                      env:
                          - name: SPECIAL_LEVEL_KEY
                            valueFrom:
                                configMapKeyRef:
                                    name: special-config
                                    key: special.how
                          - name: SPECIAL_TYEP_KEY
                            valueFrom:
                                configMapKeyRef:
                                    name: special-config
                                    key: special.type
                resetartPolicy: Never

            [llllljian@llllljian-virtual-machine ~]$ kubectl logs dapi-test-pod
            ...
            SPECIAL_TYPE_KEY=charm
            ...
            SPECIAL_LEVEL_KEY=very
            ...

            # 设置命令行参数
            [llllljian@llllljian-virtual-machine ~]$ cat depi-test-pod1.yaml
            apiVersion: v1
            kind: Pod
            metadata:
                name: dapi-test-pod1
            spec:
                containers:
                    - name: test-container
                      image: gcr.io/google_containers/busybox
                      command: ["/bin/sh", "-c", "echo $(SPECIAL_LEVEL_KEY) $(SPECIAL_TYEP_KEY)"]
                      env:
                          - name: SPECIAL_LEVEL_KEY
                            valueFrom:
                                configMapKeyRef:
                                    name: special-config
                                    key: special.how
                          - name: SPECIAL_TYEP_KEY
                            valueFrom:
                                configMapKeyRef:
                                    name: special-config
                                    key: special.type
                resetartPolicy: Never

            # volume plugin
            [llllljian@llllljian-virtual-machine ~]$ cat depi-test-pod2.yaml
            apiVersion: v1
            kind: Pod
            metadata:
                name: dapi-test-pod2
            spec:
                containers:
                    - name: test-container
                      image: gcr.io/google_containers/busybox
                      command: ["/bin/sh", "cat", "/etc/config/special.how"]
                      volumeMounts:
                    - name: config-volume
                      moutPath: /etc/config
                volumes:
                    - name: config-volume
                      configMap:
                        name: special-config
                restartPolicy: Never

            # 还可以指定items字段下的路径
            [llllljian@llllljian-virtual-machine ~]$ cat depi-test-pod3.yaml
            apiVersion: v1
            kind: Pod
            metadata:
                name: dapi-test-pod3
            spec:
                containers:
                    - name: test-container
                      image: gcr.io/google_containers/busybox
                      command: ["/bin/sh", "cat", "/etc/config/path/to/special-key"]
                      volumeMounts:
                    - name: config-volume
                      moutPath: /etc/config
                volumes:
                    - name: config-volume
                      configMap:
                        name: special-config
                        items:
                        - key: special.how
                            path: path/to/special-key
                restartPolicy: Never
        ```
    * 使用ConfigMap的限制条件
        1. ConfigMap必须在Pod之前创建
        2. ConfigMap受Namespace限制, 只有处于相同Namespaces中的Pod可以引用它
        3. ConfigMap 中的配额管理还未能实现
        4. kubelet只支持可以被API Server管理的Pod使用ConfigMap