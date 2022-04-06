---
title: Interview_总结 (58)
date: 2019-11-20
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * 什么是四次挥手
- A
    * ![四次挥手](/img/20191120_1.png)
    * 我要和你断开链接；好的, 断吧.我也要和你断开链接；好的, 断吧
    * 第一次挥手: Client将FIN置为1, 发送一个序列号seq给Server；进入FIN_WAIT_1状态；
    * 第二次挥手: Server收到FIN之后, 发送一个ACK=1, acknowledge number=收到的序列号+1；进入CLOSE_WAIT状态.此时客户端已经没有要发送的数据了, 但仍可以接受服务器发来的数据.
    * 第三次挥手: Server将FIN置1, 发送一个序列号给Client；进入LAST_ACK状态；
    * 第四次挥手: Client收到服务器的FIN后, 进入TIME_WAIT状态；接着将ACK置1, 发送一个acknowledge number=序列号+1给服务器；服务器收到后, 确认acknowledge number后, 变为CLOSED状态, 不再向客户端发送数据.客户端等待2*MSL(报文段最长寿命)时间后, 也进入CLOSED状态.完成四次挥手.

#### 问题2
- Q
    * 问题1扩展, 为什么不能把服务器发送的ACK和FIN合并起来, 变成三次挥手(CLOSE_WAIT状态意义是什么)
- A
    * 因为服务器收到客户端断开连接的请求时, 可能还有一些数据没有发完, 这时先回复ACK, 表示接收到了断开连接的请求.等到数据发完之后再发FIN, 断开服务器到客户端的数据传送.

#### 问题3
- Q
    * 问题1扩展, 如果第二次挥手时服务器的ACK没有送达客户端, 会怎样
- A
    * 客户端没有收到ACK确认, 会重新发送FIN请求.

#### 问题4
- Q
    * 客户端TIME_WAIT状态的意义是什么
- A
    * 第四次挥手时, 客户端发送给服务器的ACK有可能丢失, TIME_WAIT状态就是用来重发可能丢失的ACK报文.如果Server没有收到ACK, 就会重发FIN, 如果Client在2*MSL的时间内收到了FIN, 就会重新发送ACK并再次等待2MSL, 防止Server没有收到ACK而不断重发FIN.
    * MSL(Maximum Segment Lifetime), 指一个片段在网络中最大的存活时间, 2MSL就是一个发送和一个回复所需的最大时间.如果直到2MSL, Client都没有再次收到FIN, 那么Client推断ACK已经被成功接收, 则结束TCP连接.


