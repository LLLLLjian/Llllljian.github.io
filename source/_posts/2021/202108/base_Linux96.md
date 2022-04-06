---
title: Linux_基础 (96)
date: 2021-08-18
tags: Linux
toc: true
---

### Linux积累
    iptables防火墙

<!-- more -->

#### 防火墙管理工具
> 众所周知, 相较于企业内网, 外部的公网环境更加恶劣, 罪恶丛生. 在公网与企业内网之间充当保护屏障的防火墙, 虽然有软件或硬件之分, 但主要功能都是依据策略对穿越防火墙自身的流量进行过滤. 防火墙策略可以基于流量的源目地址、端口号、协议、应用等信息来定制, 然后防火墙使用预先定制的策略规则监控出入的流量, 若流量与某一条策略规则相匹配, 则执行相应的处理, 反之则丢弃. 这样一来, 就可以保证仅有合法的流量在企业内网和外部公网之间流动了. 

![防火墙作为公网与内网之间的保护屏障](/img/20210818_1.png)

#### Iptables

##### 策略与规则链
> 防火墙会从上至下的顺序来读取配置的策略规则, 在找到匹配项后就立即结束匹配工作并去执行匹配项中定义的行为(即放行或阻止). 如果在读取完所有的策略规则之后没有匹配项, 就去执行默认的策略. 一般而言, 防火墙策略规则的设置有两种: 一种是“通”(即放行), 一种是“堵”(即阻止). 当防火墙的默认策略为拒绝时(堵), 就要设置允许规则(通), 否则谁都进不来；如果防火墙的默认策略为允许时, 就要设置拒绝规则, 否则谁都能进来, 防火墙也就失去了防范的作用. 
- iptables服务把用于处理或过滤流量的策略条目称之为规则, 多条规则可以组成一个规则链, 而规则链则依据数据包处理位置的不同进行分类, 具体如下:
    * 在进行路由选择前处理数据包(PREROUTING)
    * 处理流入的数据包(INPUT)
    * 处理流出的数据包(OUTPUT)
    * 处理转发的数据包(FORWARD)
    * 在进行路由选择后处理数据包(POSTROUTING)

一般来说, 从内网向外网发送的流量一般都是可控且良性的, 因此我们使用最多的就是INPUT规则链, 该规则链可以增大黑客人员从外网入侵内网的难度. 

比如在您居住的社区内, 物业管理公司有两条规定: 禁止小商小贩进入社区；各种车辆在进入社区时都要登记. 显而易见, 这两条规定应该是用于社区的正门的(流量必须经过的地方), 而不是每家每户的防盗门上. 根据前面提到的防火墙策略的匹配顺序, 可能会存在多种情况. 比如, 来访人员是小商小贩, 则直接会被物业公司的保安拒之门外, 也就无需再对车辆进行登记. 如果来访人员乘坐一辆汽车进入社区正门, 则“禁止小商小贩进入社区”的第一条规则就没有被匹配到, 因此按照顺序匹配第二条策略, 即需要对车辆进行登记. 如果是社区居民要进入正门, 则这两条规定都不会匹配到, 因此会执行默认的放行策略. 

但是, 仅有策略规则还不能保证社区的安全, 保安还应该知道采用什么样的动作来处理这些匹配的流量, 比如“允许”、“拒绝”、“登记”、“不理它”. 这些动作对应到iptables服务的术语中分别是ACCEPT(允许流量通过)、REJECT(拒绝流量通过)、LOG(记录日志信息)、DROP(拒绝流量通过). “允许流量通过”和“记录日志信息”都比较好理解, 这里需要着重讲解的是REJECT和DROP的不同点. 就DROP来说, 它是直接将流量丢弃而且不响应；REJECT则会在拒绝流量后再回复一条“您的信息已经收到, 但是被扔掉了”信息, 从而让流量发送方清晰地看到数据被拒绝的响应信息. 

我们来举一个例子, 让各位读者更直观地理解这两个拒绝动作的不同之处. 比如有一天您正在家里看电视, 突然听到有人敲门, 您透过防盗门的猫眼一看是推销商品的, 便会在不需要的情况下开门并拒绝他们(REJECT). 但如果您看到的是债主带了十几个小弟来讨债, 此时不仅要拒绝开门, 还要默不作声, 伪装成自己不在家的样子(DROP). 

##### 基本的命令参数
> iptables命令可以根据流量的源地址、目的地址、传输协议、服务类型等信息进行匹配, 一旦匹配成功, iptables就会根据策略规则所预设的动作来处理这些流量. 另外, 再次提醒一下, 防火墙策略规则的匹配顺序是从上至下的, 因此要把较为严格、优先级较高的策略规则放到前面, 以免发生错误. 

<table><tbody class="row-hover"><tr class="row-1 odd"><td class="column-1">参数</td><td class="column-2">作用</td></tr><tr class="row-2 even"><td class="column-1">-P</td><td class="column-2">设置默认策略</td></tr><tr class="row-3 odd"><td class="column-1">-F</td><td class="column-2">清空规则链</td></tr><tr class="row-4 even"><td class="column-1">-L</td><td class="column-2">查看规则链</td></tr><tr class="row-5 odd"><td class="column-1">-A</td><td class="column-2">在规则链的末尾加入新规则</td></tr><tr class="row-6 even"><td class="column-1">-I num</td><td class="column-2">在规则链的头部加入新规则</td></tr><tr class="row-7 odd"><td class="column-1">-D num</td><td class="column-2">删除某一条规则</td></tr><tr class="row-8 even"><td class="column-1">-s</td><td class="column-2">匹配来源地址IP/MASK, 加叹号“!”表示除这个IP外</td></tr><tr class="row-9 odd"><td class="column-1">-d</td><td class="column-2">匹配目标地址</td></tr><tr class="row-10 even"><td class="column-1">-i 网卡名称</td><td class="column-2">匹配从这块网卡流入的数据</td></tr><tr class="row-11 odd"><td class="column-1">-o 网卡名称</td><td class="column-2">匹配从这块网卡流出的数据</td></tr><tr class="row-12 even"><td class="column-1">-p</td><td class="column-2">匹配协议, 如TCP、UDP、ICMP</td></tr><tr class="row-13 odd"><td class="column-1">--dport num</td><td class="column-2">匹配目标端口号</td></tr><tr class="row-14 even"><td class="column-1">--sport num</td><td class="column-2">匹配来源端口号</td></tr></tbody></table>

- 处理动作
    * ACCEPT: 允许数据包通过
    * DROP: 直接丢弃数据包, 不给任何回应消息, 客户端过了超时时间才会有反应
    * REJECT: 拒绝数据包通过, 必要的时候会给数据发送端一个拒绝响应的请求
    * SNAT: 源地址转换, 解决内网用户用同一个公网地址上网的问题
    * MASQUERADE: 是SNAT的一种特殊形式. 适用于动态的、临时会变的ip上
    * DNAT: 目标地址转换
    * REDIRECT: 在本季做端口映射
    * LOG: 在/var/log/messages文件中记录日志信息, 然后将数据包传递给下一条规则

- demo
    ```bash
        PORT_LIST=(9000 9870 9864 9866 9867 35035 8030 8031 8032 8033 8088 2049 111 50079 4242 4307 8700 13562 2375 33853 42791 5355 8040 8042 9868 4945)
        # 端口分别 namenode  |datanode            | resource               |nfs                |mysql    other

        # 清除所有规则
        iptables -F
        # 每个端口仅允许本机访问
        for each_port in ${PORT_LIST[@]};
        do
            # 向INPUT规则链中添加拒绝所有人访问本机 PORT_LIST 端口的策略规则, DROP直接丢弃
            iptables -I INPUT -p tcp --dport ${each_port} -j DROP
            # 将INPUT规则链设置为只允许本机访问本机的 PORT_LIST 端口, 拒绝来自其他所有主机的流量
            iptables -I INPUT -s 127.0.0.1 -p tcp --dport ${each_port} -j ACCEPT
            # 将INPUT规则链设置为只允许指定ip的主机访问本机的 PORT_LIST 端口, 拒绝来自其他所有主机的流量
            iptables -I INPUT -s xxx.xxx.xx.xx -p tcp --dport ${each_port} -j ACCEPT
        done

        # 将INPUT规则链设置为允许 ip=xxx.xxx.xx.xx 访问本机的8700端口, 下边类似
        iptables -I INPUT -s xxx.xxx.xx.xx -p tcp --dport 8700 -j ACCEPT

        # 流出的数据包规则中添加拒绝匹配到目标地址xxx.xxx.xx.xx的流量, REJECT拒绝流量通过后再回复一条“您的信息已经收到, 但是被扔掉了”信息
        iptables -A OUTPUT -d xxx.xxx.xx.xx -j REJECT
    ```
- demo1
    ```bash
        # 把所有访问xxx.xxx.xx.xx的web服务都转换到xx.xxx.xx.xx:8400
        iptables -t nat -A PREROUTING -d xxx.xxx.xx.xx -p tcp --dport 80 -j DNAT --to-destination xx.xxx.xx.xx:8400;
        # 凡是来自xx.xx.xx.0网段的主机的8400请求都将其转换为xx.xx.xx.9
        iptables -t nat -A POSTROUTING -d xx.xx.xx.0/24 -p tcp --dport 8400 -j SNAT --to-source xx.xx.xx.9;

        iptables -I INPUT -p tcp --dport 80 -j DROP
        iptables -I INPUT -p tcp --dport 8400 -j DROP
        iptables -I INPUT -p tcp --dport 3690 -j DROP
        iptables -I INPUT -p tcp --dport 8080 -j DROP
        iptables -I INPUT -p tcp --dport 8188 -j DROP
        iptables -I INPUT -p tcp --dport 18400 -j DROP
        iptables -I INPUT -p tcp --dport 8000 -j DROP
    ```
- demo2
    ```bash
        # 将INPUT规则链设置为只允许指定网段的主机访问本机的22端口, 拒绝来自其他所有主机的流量
        iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -j REJECT
        # 192.168.10.xx网段内的主机才能ssh到当前服务器上, 其它主机都会被拒绝
    ```
- demo3
    ```bash
        # 向INPUT规则链中添加拒绝所有人访问本机12345端口的策略规则
        iptables -I INPUT -p tcp --dport 12345 -j REJECT
        iptables -I INPUT -p udp --dport 12345 -j REJECT
    ```
- demo4
    ```bash
        # 向INPUT规则链中添加拒绝192.168.10.5主机访问本机80端口(Web服务)的策略规则
        iptables -I INPUT -p tcp -s 192.168.10.5 --dport 80 -j REJECT
    ```
- demo5
    ```bash
        # 向INPUT规则链中添加拒绝所有主机访问本机1000～1024端口的策略规则
        iptables -A INPUT -p tcp --dport 1000:1024 -j REJECT
        iptables -A INPUT -p udp --dport 1000:1024 -j REJECT
    ```
- 注意
    * 使用iptables命令配置的防火墙规则默认会在系统下一次重启时失效, 如果想让配置的防火墙策略永久生效, 还要执行保存命令
    ```bash
        [root@linuxprobe ~]# service iptables save
        iptables: Saving firewall rules to /etc/sysconfig/iptables: [ OK ]
    ```











