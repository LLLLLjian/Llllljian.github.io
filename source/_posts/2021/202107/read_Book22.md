---
title: 读书笔记 (22)
date: 2021-07-15
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 深入理解StatefulSet(二):存储状态
- PVC
    * Persistent Volume Claim
- PV
    * Persistent Volume
- 为什么要有PVC和PV, 他们是什么
    * Volume需要在pod中挂载, 如果过多的在pod中添加了Volume卷的信息, 属于过度暴露, 但是如果引进了PVC和PV, 降低了用户声明和使用持久化Volume的门槛
- pvc.yaml
    ```yaml
        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
            name: pv-claim 
        spec:
            # 表示这个 Volume 的挂载方式是可读写, 并且只能被挂载在一个节点上而非 被多个节点共享
            accessModes:
            - ReadWriteOnce
            resources:
                requests:
                    # 表示我想要的 Volume 大小至少是 1 GB
                    storage: 1Gi
    ```
- pod.yaml
    ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
            name: pv-pod
        spec:
            containers:
                - name: pv-container
                  image: nginx
                  ports:
                    - containerPort: 80
                      name: "http-server"
                  volumeMounts:
                    - mountPath: "/usr/share/nginx/html"
                      name: pv-storage 
            volumes:
                - name: pv-storage
                  persistentVolumeClaim:
                    # PVC的名字是pv-claim
                    claimName: pv-claim
    ```
- pv.yaml
    ```yaml
        kind: PersistentVolume
        apiVersion: v1
        metadata:
            name: pv-volume
            labels:
                type: local
        spec:
            capacity:
                # PV的容量是10GB
                storage: 10Gi
            rbd:
                monitors:
                - '10.16.154.78:6789'
                - '10.16.154.82:6789'
                - '10.16.154.83:6789'
                pool: kube
                image: foo
                fsType: ext4
                readOnly: true
                user: admin
                keyring: /etc/ceph/keyring
                imageformat: "2"
                imagefeatures: "layering"
    ```
- statefulset.yaml
    ```yaml
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
                      volumeMounts:
                      - name: www
                        mountPath: /usr/share/nginx/html
            volumeClaimTemplates:
            - metadata:
                name: www
              spec:
                accessModes:
                - ReadWriteOnce
                resources:
                    requests:
                        storage: 1Gi
    ```
- bash
    ```bash
        $ kubectl create -f statefulset.yaml
        $ kubectl get pvc -l app=nginx
        NAME        STATUS      VOLUME              CAPACITY    ACCESSMODES     AGE
        www-web-0   Bound       pvc-15c268c7-b507   1Gi         RWO             48s
        www-web-1   Bound       pvc-15c268c7-b507   1Gi         RWO             48s

        # 在每个 Pod 的 Volume 目录里, 写入了一个 index.html 文件.这个文件的内容, 正是 Pod 的 hostname.比如, 我们在 web-0 的 index.html 里写入的内容就是 "hello web-0".
        $ for i in 0 1; do kubectl exec web-$i -- sh -c 'echo hello $(hostname) > /usr/share/nginx/html'

        # 在这个 Pod 容器里访问“http://localhost”, 你实际访问到的就是 Pod 里 Nginx 服务器进程, 而它会为你返回 /usr/share/nginx/html/index.html 里的内容
        $ for i in 0 1; do kubectl exec -it web-$i -- curl localhost; done 
        hello web-0
        hello web-1

        # 删除两个POD
        $ kubectl delete pod -l app=nginx
        pod "web-0" deleted
        pod "web-1" deleted

        # 在被重新创建出来的 Pod 容器里访问 http://localhost
        $ kubectl exec -it web-0 -- curl localhost
        hello web-0
    ```
- bash解释
    * 首先, 当你把一个 Pod, 比如 web-0, 删除之后, 这个 Pod 对应的 PVC 和 PV, 并不会被删 除, 而这个 Volume 里已经写入的数据, 也依然会保存在远程存储服务里(比如, 我们在这个 例子里用到的 Ceph 服务器).此时, StatefulSet 控制器发现, 一个名叫 web-0 的 Pod 消失了.所以, 控制器就会重新创建 一个新的、名字还是叫作 web-0 的 Pod 来, “纠正”这个不一致的情况.需要注意的是, 在这个新的 Pod 对象的定义里, 它声明使用的 PVC 的名字, 还是叫作:www- web-0.这个 PVC 的定义, 还是来自于 PVC 模板(volumeClaimTemplates), 这是 StatefulSet 创建 Pod 的标准流程.所以, 在这个新的 web-0 Pod 被创建出来之后, Kubernetes 为它查找名叫 www-web-0 的 PVC 时, 就会直接找到旧 Pod 遗留下来的同名的 PVC, 进而找到跟这个 PVC 绑定在一起的 PV.这样, 新的 Pod 就可以挂载到旧 Pod 对应的那个 Volume, 并且获取到保存在 Volume 里的 数据.

