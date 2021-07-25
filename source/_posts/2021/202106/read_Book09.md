---
title: 读书笔记 (09)
date: 2021-06-28
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
- Kubernetes的整体架构
    * ![Kubernetes的整体架构](/img/20210628_1.png)
    * master节点
        * APIServer
        * kubernetes/cmd/kube-apiserver/app/server.go
        * kubernetes/pkg/apiserver/
        * kube-scheduler
        * kubernetes/plugin/cmd/kube-scheduler/app/server.go
        * kubernetes/plugin/pkg/scheduler/
        * kube-controller-manager
        * kubernetes/cmd/kube-controller-manager/app/controllermanager.go
        * kubernetes/pkg/controller
    * 工作节点
        * kubelet
        * kubernetes/cmd/kubelet/app/server.go
        * kubernetes/pkg/kubelet/
        * kube-proxy
        * kubernetes/cmd/kube-proxy/app/server.go
        * kubernetes/pkg/proxy/



