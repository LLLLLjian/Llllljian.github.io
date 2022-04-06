---
title: Python_基础 (105)
date: 2021-08-04
tags: Python
toc: true
---

### 快来跟我一起学requests
    主要看一下requests源码分析

<!-- more -->

#### 源码
[request源码](https://github.com/psf/requests)
[request文档](https://docs.python-requests.org/en/master/)

#### 核心流程
> get请求的核心时序流程

![request.get](/img/20210804_1.png)

##### api
> api模块中封装了 get, post, options, head, put, delete等方法, 我们可以直接调用这几个方法发起HTTP请求, 这些方法中都调用了request()方法, request方法的代码如下, 这里实例化了一个Session对象, 然后调用了Session对象的request方法发起请求
- code
    ```python
        def request(method, url, **kwargs):
            with sessions.Session() as session:
                return session.request(method=method, url=url, **kwargs)
    ```

##### session
> Session对象可用于保存请求的状态, 比如证书、cookies、proxy等信息, 可实现在多个请求之间保持长连接. 如果我们是直接使用的api层的方法发起的请求, 那么在请求结束之后, 所有的状态都会被清理掉. 如果我们需要频繁向服务端发起请求, 那么使用Session实现长连接可以大大提升处理性能. Session类中维护了多个HTTPAdpater对象, 分别用于处理不同scheme的请求, 代码如下, 我们也可以通过Session.mount()方法设置我们自定义的HTTPAdapter, 比如根据要求重新设置重试次数等等. 
- code
    ```python
        class Session(SessionRedirectMixin):
            def __init__(self):
                ......
                self.adapters = OrderedDict()
                self.mount('https://', HTTPAdapter())
                self.mount('http://', HTTPAdapter())
    ```

##### HTTPAdapter
> Adapter中主要维护了三个对象, max_retries用于请求重试, proxy_manager用于维护与proxy的连接, poolmanager属性维护了一个连接池PoolManager对象. 我们在创建HTTPAdapter的时候可以指定连接池的大小和请求最大重试次数. 这里之所以使用连接池, 是为了对连接到相同服务端的请求的连接进行复用, 我们知道在一次请求过程中, TCP连接的建立和断开是非常耗时的, 如果能够把建立连接这一步省掉那将会大大提升请求性能. 
- code
    ```python
        def send(self, request, ...):
            # 从proxy_manager或者poolmanager中获取到连接, 这里代码中用的虽然是connection变量名, 但是实际上这里获取的是一个连接池HTTPConnectionPool对象, 具体使用的是哪个连接发送请求其实是在连接池HTTPConnectionPool中去自动选择的. 这里如果有使用proxy, 那么这里就是获取的连接到proxy的一个连接池
            conn = self.get_connection(request.url, proxies)
            # 将TLS证书设置到连接中去, 如果使用HTTPS的话
            self.cert_verify(conn, request.url, verify, cert)
            # 调用连接池HTTPConnectionPool的urlopen()方法, 获取一个连接, 发送请求, 获取响应, 这里获取到的响应还是urllib3库中的原生response对象
            resp = conn.urlopen(...)
            # 将urllib3库中的原生response对象封装为requests库中的Response对象. 
            return self.build_response(request, resp)
    ```

##### PoolManager
> PoolManager中维护了若干个连接池HTTPConnectionPool或者HTTPSConnectionPool, 每个连接池又维护了若干条Connection, 这里默认的大小是10个连接池, 每个连接池10条连接, 但是我们可以在创建PoolManager的时候自行指定. PoolManager中针对具有scheme、host、port三个属性相同的请求使用同一个连接池, 每个连接池维护了一个连接队列, 当获取连接时会优先从队列中获取一条现成的连接, 如果没有现成的则新创建一条连接, 连接使用完成之后会再次添加回队列中, 以便后续可以继续使用. 



