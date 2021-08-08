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
    * 拓扑状态.这种情况意味着, 应用的多个实例之间不是完全对等的关系.这些应用实例, 必须按照某些顺序启动, 比如应用的主节点 A 要先于从节点 B 启动.而如果你把 A 和 B 两个 Pod 删除掉, 它们再次被创建出来时也必须严格按照这个顺序才行.并且, 新创建出来的 Pod, 必须和原来 Pod 的网络标识一样, 这样原先的访问者才能使用同样的方法, 访问到这个新 Pod.
    * 存储状态.这种情况意味着, 应用的多个实例分别绑定了不同的存储数据.对于这些应用实 例来说, Pod A 第一次读取到的数据, 和隔了十分钟之后再次读取到的数据, 应该是同一 份, 哪怕在此期间 Pod A 被重新创建过.这种情况最典型的例子, 就是一个数据库应用的 多个存储实例.
- Service详解
    * Service 是 Kubernetes 项目中用来将一组 Pod 暴露给外界访问的一种机制.比如, 一个 Deployment 有 3 个 Pod, 那么我就可以定义一个 Service.然后, 用户只要能访问到这个 Service, 它就能访问到某个具体的 Pod
    * 访问方式1
        * 是以 Service 的 VIP(Virtual IP, 即:虚拟 IP)方式.比如:当我访问 10.0.23.1 这个 Service 的 IP 地址时, 10.0.23.1 其实就是一个 VIP, 它会把请求转发到该 Service 所代理的某一个 Pod 上
    * 访问方式2
        * 以 Service 的 DNS 方式.比如:这时候, 只要我访问“my-svc.my- namespace.svc.cluster.local”这条 DNS 记录, 就可以访问到名叫 my-svc 的 Service 所代理 的某一个 Pod
            * 第一种处理方法, 是 Normal Service.这种情况下, 你访问“my-svc.my- namespace.svc.cluster.local”解析到的, 正是my-svc 这个 Service 的 VIP, 后面的流程就跟 VIP 方式一致了.
            * 第二种处理方法, 正是 Headless Service.这种情况下, 你访问“my-svc.my- namespace.svc.cluster.local”解析到的, 直接就是 my-svc 代理的某一个 Pod 的 IP 地址.可 以看到, 这里的区别在于, Headless Service 不需要分配一个 VIP, 而是可以直接以 DNS 记录的方式解析出被代理 Pod 的 IP 地址.
- Headless Service
    ```yaml
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
            # 这个 Service 被创建后并不会被分配一个 VIP, 而是会以 DNS 记录 的方式暴露出它所代理的 Pod
            clusterIP: None
            selector:
                # # 所有携带了 app=nginx 标签的 Pod, 都会被这 个 Service 代理起来
                app: nginx
    ```
- StatefulSet
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
    ```
- 运行示例
    ```bash
        $ kubectl create -f svc.yaml
        $ kubectl get service nginx
        NAME    TYPE        CLUSTER-IP EXTERNAL-IP  PORT(S)     AGE 
        nginx   ClusterIP   None       <none>       80/TCP      10s
        $ kubectl create -f statefulset.yaml 
        $ kubectl get statefulset web
        NAME    DESIRED     CURRENT     AGE 
        web     2           1           19s
        $ kubectl get pods -w -l app=nginx
        NAME    READY   STATUS      RESTARTS    AGE 
        web-0   0/1     Pending     0           0s
        web-0   0/1     Pending     0           0s
        web-0   0/1     ContainerCreating   0   0s
        web-0   1/1     Running     0           19s
        web-1   0/1     Pending     0           0s
        web-1   0/1     Pending     0           0s
        web-1   0/1     ContainerCreating   0   0s
        web-1   1/1     Running     0           20s
        $ kubectl exec web-0 -- sh -c 'hostname'
        web-0
        $ kubectl exec web-1 -- sh -c 'hostname'
        web-1
        $ kubectl run -i --tty --image busybox dns-test --restart=Never --rm /bin/sh
        $ nslookup web-0.nginx
        Server:   10.0.0.10
        Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

        Name:   web-0.nginx
        Address 1: 10.244.1.7

        $ nslookup web-1.nginx
        Server:   10.0.0.10
        Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

        Name:   web-1.nginx
        Address 1: 10.244.2.7
    ```
- 总结
    * StatefulSet 这个控制器的主要作用之一, 就是使用 Pod 模板创建 Pod 的时候,  对它们进行编号, 并且按照编号顺序逐一完成创建工作.而当 StatefulSet 的“控 制循环”发现 Pod 的“实际状态”与“期望状态”不一致, 需要新建或者删除 Pod 进行“调谐”的时候, 它会严格按照这些 Pod 编号的顺序, 逐一完成这些操作.



