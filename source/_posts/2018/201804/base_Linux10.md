---
title: Linux_基础 (10)
date: 2018-04-23
tags: Linux
toc: true
---

### 目录配置
    主要说明一下目录结构

<!-- more -->

#### 目录配置的依据-FHS
- Filesystem Hierarchy Standard(文件系统层次化标准)
- 多数Linux版本采用这种文件组织形式,类似于Windows操作系统中c盘的文件目录
- FHS采用树形结构组织文件.
- FHS定义了系统中每个区域的用途、所需要的最小构成的文件和目录,同时还给出了例外处理与矛盾处理
- 主要目的 : 让使用者可以了解到已安装软件通常放置于哪个目录下
- 重点 : 规范每个特定的目录下应该要放置什么样子的数据
- FHS依据文件系统使用的频繁与否是否允许用户随意改动,而将目录定义成为四种交互作用的形态.
    * 可分享的： 可以分享给其他系统挂载使用的目录,所以包括执行文件与用户的邮件等数据,是能够分享给网络上其他主机挂载用的目录.
    * 不可分享的： 自己机器上面运行的设备文件或者是与程序有关的socket文件等,由于仅与自身机器有关,所以当然就不合适分享给其他主机了
    * 不变的：  有些数据是不会经常变动的,跟随着distribution而不变动.例如函数库、文件说明文件、系统管理员所管理的主机服务配置文件等.
    * 可变动的： 经常改变的数据,例如登录文件,新闻组等
<table><tr><td>&nbsp;</td><td>可分享的(shareable)</td><td>不可分享的(unshareable)</td></tr><tr><td rowspan="2">不变的(static)</td><td>/usr(软件放置处)</td><td>/etc(配置文件)</td></tr><tr><td>/opt(第三方软件)</td><td>/boot(开机与内核文件)</td></tr><tr><td rowspan="2">可变动的(variable)</td><td>/var/mail(用户邮件信箱)</td><td>/var/run (程序相关)</td></tr><tr><td>/var/spool/news(新闻组)</td><td>/var/lock(程序相关)</td></tr></table>

- 目录树架构三层目录：
    * /(root, 根目录)： 与开机系统有关；
        * /bin
            /bin放置的是在单用户维护模式下还能够被操作的命令
            在/bin下面的命令可以被root与一般账户所使用,主要有cat,chmod,chown,date,mv,mkdir, cp,bash等常用的命令.
        * /boot
            这个目录主要放置开机会使用到的文件,包括Linux内核文件以及开机菜单与开机所需要配置文件等
        * /dev
            在Linux系统上, 任何设备与接口设备都是以文件的形式存在于这个目录当中的
        * /etc
            系统主要的配置文件几乎都放置在这个目录内, 例如人员的账号密码文件、各种服务的起始文件等
        * /home
            系统默认的用户主文件夹(home directory).在你创建一个一般用户账号时,默认的用户主文件夹都会规范到这里来
            主文件夹有两种代号：
            ~： 代表目前这个用户的主文件夹
            ~dmtsai: 则代表dmtsai的主文件夹
        * /lib
            在开机时会用到的函数库,以及在/bin或/sbin下面的命令会调用的函数库
        * /media
            可删除的设备.包括软盘、光盘、DVD等设备都暂时挂载于此
        * /mnt
        * /opt
            第三方软件放置的目录
        * /root
            系统管理员(root)的主文件夹
        * /sbin
            开机过程中所需要的,里面包括了开机、修复、还原系统所需要的命令
        * /srv
            是一些网络服务启动之后,这些服务所需要取用的数据目录
        * /tmp
            让一般用户或者正在执行的程序暂时放置文件的地方
    * /usr(UNIX software resource): 与软件安装/执行有关
        * /usr/bin
            绝大部分的用户可使用命令都放在这里
        * /usr/lib
            包含各应用软件的函数库、目标文件(Object file), 以及不被一般用户惯用的执行文件或脚本(script)
        * /usr/local
            系统管理员在本机自行安装自己下载的软件(非distribution默认提供者)
        * /usr/sbin
            非系统正常运行所需要的系统命令
        * /usr/share
            放置共享文件的地方
        * /usr/src
            一般源码建议放置到这里
    * /var (variable): 与系统运作过程有关
        * /var/cache
            应用程序本身运行过程中会产生的一些暂存文件
        * /var/lib
            程序本身执行的过程中,需要使用到的数据文件放置的目录
        * /var/lock
            某些设备或者是文件资源一次只能被一个应用程序所用,如果同时有两个程序使用该设备时,就可能产生一些错误的状况,因此就得要将该设备上锁(lock),以确保该设备只会给单一软件所使用
        * /var/log
            这是登录文件放置的目录
        * /var/mail
            放置个人电子邮件信箱的目录,不过这个目录也被放置到/var/spool/mail/目录中.通常这两个目录是互为连接文件
        * /var/run
            某些程序或者服务启动后,会将他们的PID放置在这个目录下
        * /var/spool
            通常放置一些对列数据,所谓的“队列”就是排队等待其他程序使用的数据,这些数据被使用后通常都会被删除

#### 绝对路径与相对路径
- 绝对路径
    * 由根目录(/)开始写起的文件名或目录名称
    * 实例[进入/var/log目录]
        ```bash
            cd /var/log
        ```
- 相对路径
    * 相对于目前路径的文件名写法
    * 实例[进入/var/log目录]
        ```bash
            cd ../../var/log
        ```
    * . : 代表当前目录  ./
    * .. : 代表上一层目录 ../

#### 题外话
- /bin /sbin/ /usr/bin/ /usr/loca/bin/ 各目录的区别
    * /bin
        * 系统级的组件放在/bin
        * 是系统的一些指令.bin为binary的简写主要放置一些系统的必备执行档
        * 例如:cat、cp、chmod df、dmesg、gzip、kill、ls、mkdir、more、mount、rm、su、tar等.
    * /sbin
        * 根用户才能访问的放在/sbin
        * 一般是指超级用户指令.主要放置一些系统管理的必备程式
        * 例如:cfdisk、dhcpcd、dump、e2fsck、fdisk、halt、ifconfig、ifup、 ifdown、init、insmod、lilo、lsmod、mke2fs、modprobe、quotacheck、reboot、rmmod、 runlevel、shutdown等.
    * /usr/bin　
        * 系统repository提供的应用程序放在/usr/bin
        * 后期安装的一些软件的运行脚本.主要放置一些应用软体工具的必备执行档
        * 例如c++、g++、gcc、chdrv、diff、dig、du、eject、elm、free、gnome*、 gzip、htpasswd、kfm、ktop、last、less、locale、m4、make、man、mcopy、ncftp、 newaliases、nslookup passwd、quota、smb*、wget等.
    * /usr/sbin   
        * 放置一些用户安装的系统管理的必备程式
        * 例如:dhcpd、httpd、imap、in.*d、inetd、lpd、named、netconfig、nmbd、samba、sendmail、squid、swap、tcpd、tcpdump等
    * /usr/local/xxx
        * 用户自己编译的放在/usr/local/xxx