---
title: Python_基础 (62)
date: 2020-12-14
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django的wsgi

<!-- more -->

#### 你听说过wsgi吗
> 今天听到这个词挺突然的, 因为带我的大哥让我把定时任务写到这个里边, 这样就用不额外再管别的线程/进程了, 完全通过django来启动后台任务, 所以来学一下wsgi

#### 什么是Web框架
> 框架,即framework,特指为解决一个开放性问题而设计的具有一定约束性的支撑结构,使用框架可以帮你快速开发特定的系统
- 浏览器与服务器之间发起HTTP请求
    1. 浏览器发送一个HTTP请求；
    2. 服务器收到请求,生成一个HTML文档；
    3. 服务器把HTML文档作为HTTP响应的Body发送给浏览器；
    4. 浏览器收到HTTP响应,从HTTP Body取出HTML文档并显示.
- 对于所有的Web应用,本质上其实就是一个socket服务端,用户的浏览器其实就是一个socket客户端.
- 接受HTTP请求、解析HTTP请求、发送HTTP响应都是底层的东西,如果要研究这些底层那得花上一定的时间.因此我们不希望接触到TCP连接、HTTP原始请求和响应格式,所以,需要一个统一的接口,让我们专心用Python编写Web业务.这个接口就是WSGI: Web Server Gateway Interface.

#### WSGI
> WSGI,全称 Web Server Gateway Interface,或者 Python Web Server Gateway Interface ,是为 Python 语言定义的 Web 服务器和 Web 应用程序或框架之间的一种简单而通用的接口.自从 WSGI 被开发出来以后,许多其它语言中也出现了类似接口
WSGI就像是一座桥梁,一边连着web服务器,另一边连着用户的应用.但是呢,这个桥的功能很弱,有时候还需要别的桥来帮忙才能进行处理

#### uWSGI
> uWSGI是一个Web服务器,它实现了WSGI协议、uwsgi、http等协议.Nginx中HttpUwsgiModule的作用是与uWSGI服务器进行交换.
- WSGI/uwsgi/uWSGI 这三个概念的区分
    1. WSGI是一种通信协议.
    2. uwsgi同WSGI一样是一种通信协议.
    3. uWSGI是实现了uwsgi和WSGI两种协议的Web服务器.

#### 分界线
> 看了一堆概念之后咱们再来看看Django+uwsgi是怎么工作的


#### Python+Django+Nginx+Uwsgi
- Python
    * 可以参考之前的安装步骤
- Django(3.1)
    * 可以参考之前的安装步骤
- Nginx
    * 可以参考之前的安装步骤
- Uwsgi
    1. 安装
        * pip3 install uwsgi
    2. 测试
        ```python
            # test.py
            def application(env, start_response):
                start_response('200 OK', [('Content-Type','text/html')])
                return [b"Hello World"]
        ```
    3. 执行shell命令
        ```bash
            uwsgi –http :8001 –wsgi-file test.py
        ```
    4. 访问网页
        * localhost:8001
- 连接django和uwsgi
    1. 在项目中urls.py同级目录下创建wsgi.py文件
    2. 文件内容如下
        ```python
            import os

            from django.core.wsgi import get_wsgi_application

            os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')

            application = get_wsgi_application()
        ```
    3. 设置uwsgi.ini
        ```bash
            # uwsgi使用配置文件启动,配置如下
            [uwsgi]
            #项目目录
            chdir=./

            #指定项目application
            module=mysite.wsgi

            #监控python模块mtime来触发重载
            py-autoreload=1

            #指定sock的文件路径(nginx使用)
            socket=./uwsgi/uwsgi.sock

            # 进程个数(processess一样效果)
            workers=2
            #指定启动时的pid文件路径
            pidfile=./uwsgi/uwsgi.pid

            #指定ip及端口(配置nginx就不需要,单独启动uwsgi需要填写)
            #http=172.16.0.4:8001
            #指定静态文件(配置nginx不需要,单独启动uwsgi加载静态文件)
            #static-map=/static=/var/www/orange_web/static
            #启动uwsgi的用户名和用户组
            uid=root
            gid=root

            #启用主进程
            master=true

            # 启用线程
            enable-threads=true

            #自动移除unix Socket和pid文件当服务停止的时候
            vacuum=true

            #设置日志目录
            daemonize=./logs/uwsgi.log

            #不记录信息日志,只记录错误以及uwsgi内部消息
            disable-logging=true

            # 序列化接受的内容,如果可能的话
            thunder-lock=true
        ```
    4. 启动
        ```bash
            uwsgi --chdir=/path/to/your/project \
                  --module=mysite.wsgi:application \
                  --env DJANGO_SETTINGS_MODULE=mysite.settings \
                  --master --pidfile=/tmp/project-master.pid \
                  --socket=127.0.0.1:49152 \      # can also be a file
                  --processes=5 \                 # number of worker processes
                  --uid=1000 --gid=2000 \         # if root, uwsgi can drop privileges
                  --harakiri=20 \                 # respawn processes taking more than 20 seconds
                  --max-requests=5000 \           # respawn processes after serving 5000 requests
                  --vacuum \                      # clear environment on exit
                  --home=/path/to/virtual/env \   # optional path to a virtual environment
                  --daemonize=/var/log/uwsgi/yourproject.log      # background the process
        ```
    5. 启动wsgi的shell脚本
        ```bash
            uwsgi --ini ./uwsgi/uwsgi.ini
        ```
    6. 关闭wsgi的shell脚本
        ```bash
            uwsgi --stop ./uwsgi/uwsgi.pid
        ```
- 配置nginx
    ```bash
        1
    ```




