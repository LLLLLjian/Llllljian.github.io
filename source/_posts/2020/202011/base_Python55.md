---
title: Python_基础 (55)
date: 2020-11-19
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之socket使用

<!-- more -->

#### Socket的地址表示
- 单独的字符串,用于AF_UNIX地址族
- (host,port)对,用于AF_INET地址族.其中host是一字符串,可以是‘www.google.com’ 域名形式或是‘203.208.46.180’这种ipv4地址的形式；port是一整数.
- (host,port,flowinfo,scopeid)四元组(4-tuple),用于AF_INET6地址族
 
#### 错误与异常
> 所有的错误都将引发异常.一般的异常有如 invalidargument type 或是 out-of-memoryconditions.与socket或地址语义相关的错误将引发socket.error异常.与Socket相关的异常有：
- socket.error：由Socket相关错误引发
- socket.herror：由地址相关错误引发
- socket.gaierror：由地址相关错误,如getaddrinfo()或getnameinfo()引发
- socket.timeout：当socket出现超时时引发.超时时间由settimeout()提前设定

#### 常用函数
- socket.has_ipv6：判断平台是否支持IPV6
- socket.create_connection(address[,timeout[, source_address]])：创建一个正在监听的地址,并返回Socket对象
- socket.getaddrinfo(host,port, family=0, socktype=0, proto=0, flags=0)：返回一个包含5元组的list,用来获得host的地址信息
- socket.gethostbyname(hostname)：将host主机名转换为ipv4地址
- socket.gethostbyname_ex(hostname)：根据hostname获取一个主机关于IP和名称的全面的信息.功能扩展的gethostbyname函数,返回主机名、主机别名列表、主机IP地址列表
- socket.gethostname()：返回python解释器运行的机器hostname,返回当前主机名
- socket.gethostbyaddr(ip_address)：通过ip地址,返回包括主机名的三元组：(hostname, aliaslist, ipaddrlist)
- socket.getnameinfo(sockaddr,flags)：
- socket.getprotobyname(protocolname)：
- socket.getservbyname(servicename[,protocolname])：通过给定的服务名,协议名,返回该服务所在的端口号
- socket.getservbyport(port[,protocolname])：返回该端口号的服务名,如‘80’：‘http’
- socket.socket([family[,type[, proto]]])：通过给定的地址族,socket类型和端口号,创建新的Socket.默认地址族为AF_INET,socket类型为SOCK_STREAM,端口号为0或省略
- socket.socketpair([family[,type[, proto]]])：可用平台,unix
- socket.fromfd(fd, family,type[, proto])：可用平台,unix
- socket.ntohl(x)：将32位正整数从网络字节序转换为机器字节序
- socket.ntohs(x)：将16为正整数从网络字节序转换为机器字节序
- socket.htonl(x)：将32为正整数从机器字节序转换为网络字节序
- socket.htons(x)：将16位正整数从机器字节序转换为网络字节序
- socket.inet_aton(ip_string)：将点分十进制字符串ipv4地址形式转化为32位二进制形式,即一个4个字符的字符串,一般用于标准C库函数中的struct_in_addr
- socket.inet_ntoa(packed_ip)：上个函数的反操作
- socket.inet_pton(address_family,ip_string)：类似上述操作,可用平台,部分unix
- socket.inet_ntop(address_family,packed_ip)：类似上述操纵,可用平台,部分unix
- socket.getdefaulttimeout()：返回socket默认超时时间,以秒计(float)
- socket.setdefaulttimeout(timeout)：设置Socket默认超时时间,以秒计(float)
- socket.SocketType：这是python的类型对象,表示socket的类型

#### Socket对象方法
- socket.accept()：返回(conn,address)对,其中conn是新的socket对象,在其上可以发送和接收数据；address是另一端的socket地址
- socket.bind(address)：将socket绑定到地址上,该socket必须之前没有做过绑定操作
- socket.close()：关闭socket,该socket之后对该socket所做的的所有操作将失败,远端连接将不会收到数据.当虚拟机进行垃圾回收时,该socket将被自动关闭
- socket.connect(address)：连接该地址上的远端Socket
- socket.connect_ex(address)：类似上面操作,但出错时返回错误代码而非触发异常,可以很好的支持异步连接
- socket.fileno()：
- socket.getpeername()：
- socket.getsockname()：返回Socket自己的地址,对查找端口号有用
- socket.getsockopt(level,optname[, buflen])：
- socket.ioctl(control,option)：可用平台 windows
- socket.listen(backlog)：监听socket连接,参数表示最大连接队列数.该参数与系统有关.通常是5,最小为0
- socket.makefile([mode[,bufsize]])：返回与socket相关的file对象
- socket.recv(bufsize[,flags])：接收数据,返回表示接收到数据的String.buffersize表示一次接收到的数据的最大量
- socket.recvfrom(bufsize[,flags])：接收数据,返回(String ,address)对.
- socket.recvfrom_into(buffer[,nbytes[,flags]])：接收数据,将其写入参数buffer而非生成字符串.返回(nbyte,address),其中nbyte是接收到的数据量,address是发送端的地址.
- socket.recv_into(buffer[,nbytes[, flags]])：接收数据,区别于上的是,仅返回nbyte——接收数量,没有地址
- socket.send(string[,flags])：发送数据,该socket必须与远端socket连接.返回发送的数据量.程序自己负责检查是否所有的数据均已发送,并自己处理未发送数据.
- socket.sendall(string[,flags])：发送数据.与上函数不同的是,该函数会持续发送数据直到数据发送完毕或出现错误为止.若成功发送,返回none,但当错误发生时,将无法判断发送了多少数据.
- socket.sendto(string[,flags],address)：向socket发送数据,该socket不应该连接远端socket,因为目的socket使用地址表示的.该函数返回发送的数据量
- socket.setblocking(flag)：设置阻塞或非阻塞模式.flag=0时被设置为非阻塞模式,其他为阻塞模式.新建的socket均为阻塞模式.当在非阻塞模式下,如果recv()函数执行中,没有收到任何数据,或是send()函数没有立即处理掉数据,error异常将会被触发；在阻塞模式下,执行函数将被阻塞直到其可以执行.s.setblocking(0)等同于 s.settimeout(0.0),s.setblocking(1)等同于s.settimeout(None)
- socket.settimeout(value)：设置阻塞模式下socket的超时时间,其值可以是非负数的float类型,以秒计,或是None.若给定float,socket的后续操作若在给定超时时间内没有完成,将触发timeout异常；若给定None,则使超时设置失效
- socket.gettimeout()：返回超时时间(float,以秒计)或None
- socket.setsockopt(level,optname, value)：
- socket.shutdown(how)：
- socket.family：python类型,socket族
- socket.type：python类型,socket类型
- socket.proto：python类型,socket协议






