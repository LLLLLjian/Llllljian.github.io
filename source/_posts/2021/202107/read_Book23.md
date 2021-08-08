---
title: 读书笔记 (23)
date: 2021-07-16
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 深入理解StatefulSet(二):储存效果

首先, StatefulSet 的控制器直接管理的是 Pod.这是因为, StatefulSet 里的不同 Pod 实例,  不再像 ReplicaSet 中那样都是完全一样的, 而是有了细微区别的.比如, 每个 Pod 的 hostname、名字等都是不同的、携带了编号的.而 StatefulSet 区分这些实例的方式, 就是通 过在 Pod 的名字里加上事先约定好的编号.
其次, Kubernetes 通过 Headless Service, 为这些有编号的 Pod, 在 DNS 服务器中生成带有 同样编号的 DNS 记录.只要 StatefulSet 能够保证这些 Pod 名字里的编号不变, 那么 Service 里类似于 web-0.nginx.default.svc.cluster.local 这样的 DNS 记录也就不会变, 而这条记录解 析出来的 Pod 的 IP 地址, 则会随着后端 Pod 的删除和再创建而自动更新.这当然是 Service 机制本身的能力, 不需要 StatefulSet 操心.
最后, StatefulSet 还为每一个 Pod 分配并创建一个同样编号的 PVC.这样, Kubernetes 就可 以通过 Persistent Volume 机制为这个 PVC 绑定上对应的 PV, 从而保证了每一个 Pod 都拥有 一个独立的 Volume.
在这种情况下, 即使 Pod 被删除, 它所对应的 PVC 和 PV 依然会保留下来.所以当这个 Pod 被重新创建出来之后, Kubernetes 会为它找到同样编号的 PVC, 挂载这个 PVC 对应的 Volume, 从而获取到以前保存在 Volume 里的数据.




