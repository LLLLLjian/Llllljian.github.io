---
title: 读书笔记 (18)
date: 2021-07-09
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 深入解析Pod对象(二):使用进阶
> Projected Volume, “投射数据卷”. 它的作用是为容器提供预先定义好的数据.所以,从容器的角度来看,这些 Volume 里的信息就是仿佛是被 Kubernetes“投 射”(Project)进入容器当中的

##### Kubernetes支持的Projected Volume
1. Secret
    * 把Pod想要访问的加密数据, 存放到 Etcd 中.然后可以通过在 Pod 的容器里挂载 Volume 的方式,访问到这些 Secret 里保存的信息了
    ```bash
        # 存放数据库的Credential信息
        apiVersion: v1
        kind: Pod
        metadata:
            name: test-projected-volume 
        spec:
            containers:
            - name: test-secret-volume
                image: busybox
                args:
                - sleep
                - "86400" 
                volumeMounts:
                - name: mysql-cred
                    mountPath: "/projected-volume"
                    readOnly: true
            volumes:
            - name: mysql-cred
                projected:
                    # 数据来源
                    sources:
                    - secret:
                        name: user
                    - secret:
                        name: pass
    
        $ cat ./username.txt
        admin
        $ cat ./password.txt
        c1oudc0w!
        $ kubectl create secret generic user --from-file=./username.txt
        $ kubectl create secret generic pass --from-file=./password.txt

        $ kubectl get secrets
        NAME    TYPE    DATA    AGE
        user    Opaque  1       51s
        pass    Opaque  1       51s

        $ kubectl create -f test-projected-volume.yaml
        $ kubectl exec -it test-projected-volume -- /bin/sh 
        $ ls /projected-volume/
        user
        pass
        $ cat /projected-volume/user
        admin
        $ cat /projected-volume/pass
        c1oudc0w!
    ```
    ```yaml
        # 创建secret方法2
        apiVersion: v1
        kind: Secret
        metadata:
            name: mysecret
        type: Opaque
        data:
            # Secret 对象要求这些数据必须是经过 Base64 转码的,以免出现明文密码的安全隐患
            # $ echo -n 'admin' | base64 
            # YWRtaW4=
            user: YWRtaW4=
            # $ echo -n '1f2d1e2e67df' | base64
            # MWYyZDFlMmU2N2Rm
            pass: MWYyZDFlMmU2N2Rm
    ```
2. ConfigMap
    * 它与 Secret 的区别在于,ConfigMap 保存的是不需要加密的、 应用所需的配置信息.而 ConfigMap 的用法几乎与 Secret 完全相同:你可以使用 kubectl create configmap 从文件或者目录创建 ConfigMap,也可以直接编写 ConfigMap 对象的 YAML 文件
    ```bash
        # .properties 文件的内容
        $ cat example/ui.properties
        color.good=purple
        color.bad=yellow
        allow.textmode=true
        how.nice.to.look=fairlyNice
        
        # 从.properties 文件创建 ConfigMap
        $ kubectl create configmap ui-config --from-file=example/ui.properties

        # 查看这个 ConfigMap 里保存的信息 (data)
        # kubectl get -o yaml 这样的参数,会将指定的 Pod API 对象以 YAML 的方式展示出来
        $ kubectl get configmaps ui-config -o yaml 
        apiVersion: v1
        data:
            ui.properties: |
                color.good=purple
                color.bad=yellow
                allow.textmode=true
                how.nice.to.look=fairlyNice
        kind: ConfigMap
        metadata:
            name: ui-config
            ...
    ```
3. Downward API
    * 让 Pod 里的容器能够直接获取到这个 Pod API 对象本身的信息
    ```bash
        # 在这个 Pod 的 YAML 文件中,定义了一个简单的容器,声明了一个 projected 类型的 Volume.只不过这次 Volume 的数据来源,变成了 Downward API.而这个 Downward API Volume,则声明了要暴露 Pod 的 metadata.labels 信息给容器.通过这样的声明方式,当前 Pod 的 Labels 字段的值,就会被 Kubernetes 自动挂载成为容器里的 /etc/podinfo/labels 文件.而这个容器的启动命令,则是不断打印出 /etc/podinfo/labels 里的内容.所以,当我创建了这个 Pod 之后,就可以通过 kubectl logs 指令,查看到这些 Labels 字段被打印出来
        apiVersion: v1
        kind: Pod
        metadata:
            name: test-downwardapi-volume labels:
            zone: us-est-coast
            cluster: test-cluster1
            rack: rack-22
        spec:
        containers:
        - name: client-container
        image: k8s.gcr.io/busybox
        command: ["sh", "-c"]
        args:
        - while true; do
            if [[ -e /etc/podinfo/labels ]]; then
                echo -en '\n\n'; cat /etc/podinfo/labels; fi;
                sleep 5;
            done;
        volumeMounts:
        - name: podinfo
        mountPath: /etc/podinfo
        readOnly: false 
        volumes:
        - name: podinfo
        projected:
        sources:
        - downwardAPI:
        items:
        - path: "labels"
        fieldRef:
        fieldPath: metadata.labels

        $ kubectl create -f dapi-volume.yaml
        $ kubectl logs test-downwardapi-volume
        cluster="test-cluster1"
        rack="rack-22"
        zone="us-est-coast"
    ```
4. ServiceAccountToken
    * 就是 Kubernetes 系统内置的一种“服务账户”,它是 Kubernetes 进行权限分配的对象
    * 像这样的 Service Account 的授权信息和文件,实际上保存在它所绑定的一个特殊的 Secret 对象里 的.这个特殊的 Secret 对象,就叫作ServiceAccountToken.任何运行在 Kubernetes 集群上的 应用,都必须使用这个 ServiceAccountToken 里保存的授权信息,也就是 Token,才可以合法地 访问 API Server.

##### 容器健康检查
> 在 Kubernetes 中,你可以为 Pod 里的容器定义一个健康检查“探针”(Probe).这样, kubelet 就会根据这个 Probe 的返回值决定这个容器的状态,而不是直接以容器进行是否运行(来 自 Docker 返回的信息)作为依据.这种机制,是生产环境中保证应用健康存活的重要手段.
- eg
    ```yaml
        apiVersion: v1
        kind: Pod
        metadata:
            labels:
            test: liveness
            name: test-liveness-exec
        spec:
            containers:
                - name: liveness 
            image: busybox
            args:
                - /bin/sh
                - -c
                # 在 /tmp 目录下创 建了一个 healthy 文件,以此作为自己已经正常运行的标志.而 30 s 过后,它会把这个文件删除 掉.
                - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
            # 健康检查
            livenessProbe:
            # 健康检查的类型是exec
            exec:
            command:
                # 在容器启动后,在容器里面执行一句“cat /tmp/healthy”.这时,如果这个文件存在,这条命令的返回值就是 0,Pod 就会认为这个容器不仅已经启动,而且是健康的.
                - cat
                - /tmp/healthy
            # 在容器启动 5 s 后开始执行
            initialDelaySeconds: 5
            # 每 5 s 执行一次
            periodSeconds: 5

            # 健康检查的方式还可以是 暴露一个健康检查URL
            livenessProbe:
            httpGet:
            path: /healthz
            port: 8080
            httpHeaders:
            - name: X-Custom-Header
            value: Awesome
            initialDelaySeconds: 3
            periodSeconds: 3

            # 健康检查的方式还可以是 直接让健康检查去检测应用的监听端口
            livenessProbe:
            tcpSocket:
            port: 8080
            initialDelaySeconds: 15
            periodSeconds: 20
    ```

##### 恢复机制
> restartPolicy.它是 Pod 的 Spec 部分的一个 标准字段(pod.spec.restartPolicy),默认值是 Always,即:任何时候这个容器发生了异常,它 一定会被重新创建.
- restartPolicy选项
    * Always:在任何情况下,只要容器不在运行状态,就自动重启容器;
    * OnFailure: 只在容器 异常时才自动重启容器
        * 一个 Pod,它只计算 1+1=2,计算完成输出结果后退出,变成 Succeeded 状态.这时,你 如果再用 restartPolicy=Always 强制重启这个 Pod 的容器,就没有任何意义了.
    * Never: 从来不重启容器
        * 关心这个容器退出后的上下文环境,比如容器退出后的日志、文件和目录,就需要将 restartPolicy 设置为 Never.因为一旦容器被自动重新创建,这些内容就有可能丢失掉了(被垃圾 回收了).
- restartPolicy和Pod里容器的状态,以及Pod状态的对应关系
    1. 只要 Pod 的 restartPolicy 指定的策略允许重启异常的容器(比如:Always),那么这个 Pod 就会保持 Running 状态,并进行容器重启.否则,Pod 就会进入 Failed 状态 .
    2. 对于包含多个容器的 Pod,只有它里面所有的容器都进入异常状态后,Pod 才会进入 Failed 状 态.在此之前,Pod 都是 Running 状态.此时,Pod 的 READY 字段会显示正常容器的个数





