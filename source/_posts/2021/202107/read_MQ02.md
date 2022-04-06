---
title: 消息中间件 (02)
date: 2021-07-20
tags: 
    - MQ
    - RabbitMQ
toc: true
---

### 跟着项目学习系列
    项目中用到RabbitMQ了,  那我肯定要学一下鸭


<!-- more -->


#### 什么是RabbitMQ
> RabbitMQ是实现AMQP(高级消息队列协议)的消息中间件的一种, 最初起源于金融系统, 用于在分布式系统中存储转发消息, 在易用性、扩展性、高可用性等方面表现不俗.消息中间件主要用于组件之间的解耦, 消息的发送者无需知道消息使用者的存在, 反之亦然

#### RabbitMQ基本概念
- 整体结构图
    ![RabbitMQ整体结构图](/img/20210720_1.png)
- 概念说明
    * Broker: 简单来说就是消息队列服务器实体.
    * Exchange: 消息交换机, 它指定消息按什么规则, 路由到哪个队列.
    * Queue: 消息队列载体, 每个消息都会被投入到一个或多个队列.
    * Binding: 绑定, 它的作用就是把exchange和queue按照路由规则绑定起来.
    * Routing Key: 路由关键字, exchange根据这个关键字进行消息投递.
    * vhost: 虚拟主机, 一个broker里可以开设多个vhost, 用作不同用户的权限分离.
    * producer: 消息生产者, 就是投递消息的程序.
    * consumer: 消息消费者, 就是接受消息的程序.
    * channel: 消息通道, 在客户端的每个连接里, 可建立多个channel, 每个channel代表一个会话任务.

#### RabbitMQ生产/消费流程
> 生产者将消息发送到Exchange, 由Exchange将消息路由到一个或多个Queue中(或者丢弃), 在绑定(Binding)Exchange与Queue的同时, 一般会指定一个binding key；消费者将消息发送给   Exchange时, 一般会指定一个routing key；当binding key与routing key相匹配时, 消息将会被路由到对应的Queue中. 

#### RabbitMQ特点
- 可靠性(Reliability)
    * RabbitMQ 使用一些机制来保证可靠性, 如持久化、传输确认、发布确认.
- 灵活的路由(Flexible Routing)
    * 在消息进入队列之前, 通过 Exchange 来路由消息的.对于典型的路由功能, RabbitMQ 已经提供了一些内置的 Exchange 来实现.针对更复杂的路由功能, 可以将多个 Exchange 绑定在一起, 也通过插件机制实现自己的 Exchange .
- 消息集群(Clustering)
    * 多个 RabbitMQ 服务器可以组成一个集群, 形成一个逻辑 Broker .
- 高可用(Highly Available Queues)
    * 队列可以在集群中的机器上进行镜像, 使得在部分节点出问题的情况下队列仍然可用.
- 多种协议(Multi-protocol)
    * RabbitMQ 支持多种消息队列协议, 比如 STOMP、MQTT 等等.
- 多语言客户端(Many Clients)
    * RabbitMQ 几乎支持所有常用语言, 比如 Java、.NET、Ruby 等等.
- 管理界面(Management UI)
    * RabbitMQ 提供了一个易用的用户界面, 使得用户可以监控和管理消息 Broker 的许多方面.
- 跟踪机制(Tracing)
    * 如果消息异常, RabbitMQ 提供了消息跟踪机制, 使用者可以找出发生了什么.
- 插件机制(Plugin System)
    * RabbitMQ 提供了许多插件, 来从多方面进行扩展, 也可以编写自己的插件.
