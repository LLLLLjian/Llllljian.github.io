---
title: 读书笔记 (19)
date: 2021-07-12
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 编排其实很简单:谈谈“控制器”模型
- 回顾nginx-deployment
    ````yaml
        # 确保携带了 app=nginx 标签的 Pod 的个数,永 远等于 spec.replicas 指定的个数,即 2 个.
        apiVersion: apps/v1
        kind: Deployment
        metadata:
            name: nginx-deployment
        spec:
            selector:
                matchLabels:
                    app: nginx
            replicas: 2
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
- Deployment对控制器模型的实现
    1. Deployment 控制器从 Etcd 中获取到所有携带了“app: nginx”标签的 Pod,然后统计它们 的数量,这就是实际状态;
    2. Deployment 对象的 Replicas 字段的值就是期望状态;
    3. Deployment 控制器将两个状态做比较,然后根据比较结果,确定是创建 Pod,还是删除已有 的 Pod
        ```bash
            # go语言伪代码
            for {
                实际状态 := 获取集群中对象 X 的实际状态(Actual State) 
                期望状态 := 获取集群中对象 X 的期望状态(Desired State) 
                if 实际状态 == 期望状态{
                    什么都不做
                } else {
                    执行编排动作,将实际状态调整为期望状态
                } 
            }
        ```
- Deployment简单总结
    * ![Deployment简单总结](/img/20210712_1.png)


