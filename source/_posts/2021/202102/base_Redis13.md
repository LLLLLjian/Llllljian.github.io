---
title: Redis_基础 (13)
date: 2021-02-20
tags: Redis
toc: true
---

### Linux安装部署Redis
    项目中要用redis了, 得自己装呀

<!-- more -->

#### 安装
1. 下载redis
    * 下载地址https://redis.io/download
    * 可以直接下载安装包上传到服务器, 不方便的话就用wget吧
    ```bash
        wget http://download.redis.io/releases/redis-5.0.7.tar.gz
    ```
2. 解压并安装
    ```bash
        tar -zvxf redis-5.0.7.tar.gz
        mv redis-5.0.7 /usr/local/redis
        cd /usr/local/redis
        make
        make PREFIX=/usr/local/redis install
    ```
3. 启动
    ```bash
        ./bin/redis-server & ./redis.conf
    ```
4. 设置conf(列几个比较重要的)
    * 重点可以看一下daemonize和requirepass
    * daemonize 设置之后redis启动的之后就可以直接在后台运行了 不用加&了
    * requirepass 是设置一个密码, 连接到 redis之后需要AUTH &gt;password>, 否则会拒绝任何命令 
    <table border="0"><tbody><tr><td>配置项名称</td><td>配置项值范围</td><td>说明</td></tr><tr><td>daemonize</td><td>yes、no</td><td>yes表示启用守护进程,默认是no即不以守护进程方式运行.其中Windows系统下不支持启用守护进程方式运行</td></tr><tr><td>port</td><td>&nbsp;</td><td>指定 Redis 监听端口,默认端口为 6379</td></tr><tr><td>bind</td><td>&nbsp;</td><td>绑定的主机地址,如果需要设置远程访问则直接将这个属性备注下或者改为bind * 即可,这个属性和下面的protected-mode控制了是否可以远程访问 .</td></tr><tr><td>protected-mode</td><td>yes 、no</td><td>保护模式,该模式控制外部网是否可以连接redis服务,默认是yes,所以默认我们外网是无法访问的,如需外网连接rendis服务则需要将此属性改为no.</td></tr><tr><td>timeout</td><td>300</td><td>当客户端闲置多长时间后关闭连接,如果指定为 0,表示关闭该功能</td></tr><tr><td>loglevel</td><td>debug、verbose、notice、warning</td><td>日志级别,默认为 notice</td></tr><tr><td>databases</td><td>16</td><td>设置数据库的数量,默认的数据库是0.整个通过客户端工具可以看得到</td></tr><tr><td>rdbcompression</td><td>yes、no</td><td>指定存储至本地数据库时是否压缩数据,默认为 yes,Redis 采用 LZF 压缩,如果为了节省 CPU 时间,可以关闭该选项,但会导致数据库文件变的巨大.</td></tr><tr><td>dbfilename</td><td>dump.rdb</td><td>指定本地数据库文件名,默认值为 dump.rdb</td></tr><tr><td>dir</td><td>&nbsp;</td><td>指定本地数据库存放目录</td></tr><tr><td>requirepass</td><td>&nbsp;</td><td>设置 Redis 连接密码,如果配置了连接密码,客户端在连接 Redis 时需要通过 AUTH &lt;password&gt; 命令提供密码,默认关闭</td></tr><tr><td>maxclients</td><td>0</td><td>设置同一时间最大客户端连接数,默认无限制,Redis 可以同时打开的客户端连接数为 Redis 进程可以打开的最大文件描述符数,如果设置 maxclients 0,表示不作限制.当客户端连接数到达限制时,Redis 会关闭新的连接并向客户端返回 max number of clients reached 错误信息.</td></tr><tr><td>maxmemory</td><td>XXX &lt;bytes&gt;</td><td>指定 Redis 最大内存限制,Redis 在启动时会把数据加载到内存中,达到最大内存后,Redis 会先尝试清除已到期或即将到期的 Key,当此方法处理 后,仍然到达最大内存设置,将无法再进行写入操作,但仍然可以进行读取操作.Redis 新的 vm 机制,会把 Key 存放内存,Value 会存放在 swap 区.配置项值范围列里XXX为数值.</td></tr></tbody></table>
5. 使用其他的配置文件
    ```bash
        cp ./redis.conf ./redis6380.conf
        vim ./redis6380.conf # 启动端口改为6380
        ./bin/redis-server  ./redis6380.conf
    ```
6. 查看redis运行情况
    ```bash
        ps aux | grep redis
        lsof -i:6379
        ll /prod/{$pid}
    ```


