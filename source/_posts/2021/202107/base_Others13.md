---
title: 杂项_总结 (13)
date: 2021-07-30
tags: Others
toc: true
---

### 杂项
    BNS与DNS

<!-- more -->

#### DNS
1. 什么是dns(domain name system)
    * 常说DNS解析, 其实DNS, 就是一个服务, 一个系统, 主要是提供通过域名可查找其对应的IP地址的功能
2. 如何查找对应的IP
    * 首先本机要知道DNS服务器的ip地址, 通过DNS服务器才能知道某个域名对应的ip是什. DNS服务器有可能是动态的, 只有每次上网的时候由网关分配, 也有可能事先就指定了固定地址. 在*nix系统中, DNS服务器的IP地址在/etc/resolv.conf中文件中. 
    * 通过指令dig +trace **www.xxxx.com**我们来看下百度的ip地址查找路径
    ```bash
        [root@Gin scripts]# dig www.cnblogs.com
 
        ; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.30.rc1.el6 <<>> www.cnblogs.com
        ;; global options: +cmd
        
        ##Dig的部分输出告诉我们一些有关于它的版本信息(version 9.2.3)和全局的设置选项, 如果+nocmd在命令行下是第一个参数的话, 那么这部分输出可以通过加+nocmd的方式查询出来
        
        ;; Got answer:
        ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41440
        ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
        
        ##在这里, Dig告诉我们一些从DNS返回的技术信息, 这段信息可以用选项 +no]comments来控制显示, 但是小心, 禁止掉comments也可能关闭一些其它的选项. 
        
        ;; QUESTION SECTION:
        ;www.cnblogs.com.               IN      A
        
        ##在这个查询段中, Dig显示出我们查询的输出, 默认的查询是查询A记录, 你可以显示或者禁止掉这些用+[no]question选项
        
        ;; ANSWER SECTION:
        www.cnblogs.com.        349     IN      A       42.121.252.58
        
        ##最后, 我们得到我们查询的结果. www.isc.org 的地址是204.152.184.8, 我不知道为什么你们更喜欢过滤掉这些输出, 但是你可以用+[no]answer保留这些选项. 
        
        ;; Query time: 149 msec
        ;; SERVER: 202.106.0.20#53(202.106.0.20)
        ;; WHEN: Sat Feb  4 15:26:43 2017
        ;; MSG SIZE  rcvd: 49
        
        ##最后一段默认输出包含了查询的统计数据, 可以用+[no]stats保留. 
    ```


#### BNS
> BNS概念太多了 我理解的bns 应该是一个虚拟的域名, 这个虚拟域名下绑定着一部分IP, 这就保证了 我只用关心BNS, 而不用关心背后的机器, 类似k8s的server


