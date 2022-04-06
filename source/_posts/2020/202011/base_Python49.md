---
title: Python_基础 (49)
date: 2020-11-11
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django的htpp请求之WSGIRequest

<!-- more -->

#### 前情提要
> 啊 为什么每一个视图里都有一个request 他是什么 我打印了一下发现他是WSGIRequest

#### WSGIRequest对象
> Django在接收到http请求之后,会根据http请求携带的参数以及报文信息创建一个WSGIRequest对象,并且作为视图函数第一个参数传给视图函数.这个参数就是django视图函数的第一个参数,通常写成request.在这个对象上我们可以找到客户端上传上来的所有信息.这个对象的完整路径是django.core.handlers.wsgi.WSGIRequest

#### http请求的url详解
- 在了解WSGIRequest对象的属性和方法之前,我们先了解一下url的组成,通常来说url的完整组成如下,[]为可选 : 
    * protocol ://hostname[:port]/path/[;parameters][?query]#fragment
        * protocol :  网络协议,常用的协议有http/https/ftp等
        * hostname :  主机地址,可以是域名,也可以是IP地址
        * port :  端口 http协议默认端口是 : 80端口,在浏览器中默认会隐藏不显示
        * path : 路径 网络资源在服务器中的指定路径
        * parameter :  参数 如果要向服务器传入参数,在这部分输入
        * query :  查询字符串 如果需要从服务器那里查询内容,在这里编辑
        * fragment : 片段 网页中可能会分为不同的片段,如果想访问网页后直接到达指定位置,可以在这部分设置

#### WSGIRequest对象常用属性
1. path : 资源在服务器的完整“路径”,但不包含域名和参数,在url中也是path的内容.比如http://www.baidu.com/xxx/yyy/,那么path就是/xxx/yyy/.
2. method : 代表当前请求的http方法.比如是GET、POST、delete或者是put等方法
3. GET : 一个django.http.request.QueryDict对象.操作起来类似于字典.这个属性中包含了所有以?xxx=xxx的方式上传上来的参数.
4. POST : 也是一个django.http.request.QueryDict对象.这个属性中包含了所有以POST方式上传上来的参数.
5. FILES : 也是一个django.http.request.QueryDict对象.这个属性中包含了所有上传的文件.
6. COOKIES : 一个标准的Python字典,包含所有的cookie,键值对都是字符串类型.
7. session : 一个类似于字典的对象.用来操作服务器的session.
8. user : user 只有当Django 启用 AuthenticationMiddleware 中间件时才可用.它的值是一个 setting.py 里面AUTH_USER_MODEL 字段所定义的类的对象,表示当前登录的用户.如果用户当前没有登录,user 将设为 django.contrib.auth.models.AnonymousUser 的一个实例.你可以通过 is_authenticated() 区分它们.
9. META : 存储的客户端发送上来的所有header信息,下面是这些常用的header信息
    * CONTENT_LENGTH : 请求的正文的长度(是一个字符串).
    * CONTENT_TYPE : 请求的正文的MIME类型.
    * HTTP_ACCEPT : 响应可接收的Content-Type.
    * HTTP_ACCEPT_ENCODING : 响应可接收的编码,用于告知服务器客户端所能够处理的编码方式和相对优先级.
    * HTTP_ACCEPT_LANGUAGE :  响应可接收的语言.
    * HTTP_HOST : 客户端发送的HOST值.
    * HTTP_REFERER : 在访问这个页面上一个页面的url.
    * QUERY_STRING : 单个字符串形式的查询字符串(未解析过的形式).
    * TE : 设置传输实体的编码格式,表示请求发起者愿意接收的Transfer-Encoding类型(传输过程中的编码格式,代理服务器之间)
    * REMOTE_ADDR : 客户端的IP地址.如果服务器使用了nginx做反向代理或者负载均衡,那么这个值返回的是127.0.0.1,这时候可以使用* HTTP_X_FORWARDED_FOR来获取,所以获取ip地址的代码片段如下
        ```bash
            if request.META.has_key('HTTP_X_FORWARDED_FOR'):  
                ip =  request.META['HTTP_X_FORWARDED_FOR']  
            else:  
                ip = request.META['REMOTE_ADDR']
        ```
    * REMOTE_HOST : 客户端的主机名.
    * REQUEST_METHOD : 请求方法.一个字符串类似于GET或者POST.
    * SERVER_NAME : 服务器域名.
    * SERVER_PORT : 服务器端口号,是一个字符串类型.

#### WSGIRequest对象常用方法
- is_secure() : 是否是采用https协议.
- is_ajax() : 是否采用ajax发送的请求.原理就是判断请求头中是否存在X-Requested-With:XMLHttpRequest.
- get_host() : 服务器的域名.如果在访问的时候还有端口号,那么会加上端口号,在url中就是hostname+port.比如www.baidu.com:9000.
- get_full_path() : 返回完整的path.如果有查询字符串,还会加上查询字符串,在url中就是path以及其后面的所有.比如/music/bands/?- print=True.
- get_raw_uri() : 获取请求的完整url.

#### QueryDict对象
> 我们平时用的request.GET、request.POST和request.FILES都是QueryDict对象,这个对象继承自dict,因此用法跟dict相差无几.其中用得比较多的是get方法和getlist方法.
- get方法 : 用来获取指定key的值,如果没有这个key,那么会返回None.
- getlist方法 : 如果浏览器上传上来的key对应的值有多个,如果使用get取值,那么你只能取出最后面一个值,如果你想取到所有的值,那么就需要通过getlist这个方法获取.

#### 插播一条重要新闻
> 你想看看自己通过ORM执行的sql语句吗, 把下边的代码加到setting.py里就可以了
    ```python
        # 日志配置
        LOGGING = {
            'version': 1,  # 使用的python内置的logging模块,那么python可能会对它进行升级,所以需要写一个版本号,目前就是1版本
            'disable_existing_loggers': False,  # 是否去掉目前项目中其他地方中以及使用的日志功能,但是将来我们可能会引入第三方的模块,里面可能内置了日志功能,所以尽量不要关闭.
            'formatters': {  # 日志记录格式  
                'verbose': {  #详细格式输出
                    # levelname等级,asctime记录时间,module表示日志发生的文件名称,lineno行号,message错误信息
                    'format': '%(levelname)s %(asctime)s %(module)s %(lineno)d %(message)s'
                },
                'simple': {  # 简单格式输出
                    'format': '%(levelname)s %(module)s %(lineno)d %(message)s'
                },
            },
            'filters': {  # 过滤器: 可以对日志进行输出时的过滤用的
                'require_debug_true': {  # 在debug=True下产生的一些日志信息,要不要记录日志,需要的话就在handlers中加上这个过滤器,不需要就不加
                    '()': 'django.utils.log.RequireDebugTrue',
                },
                'require_debug_false': {  # 和上面相反
                    '()': 'django.utils.log.RequireDebugFalse',
                },
            },
            'handlers': {  # 日志处理方式,日志实例
                'console': {  # 在控制台输出时的实例
                    'level': 'DEBUG',  # 日志等级；debug是最低等级,那么只要比它高等级的信息都会被记录
                    'filters': ['require_debug_true'],  # 在debug=True下才会打印在控制台
                    'class': 'logging.StreamHandler',  # 使用的python的logging模块中的StreamHandler来进行输出
                    'formatter': 'simple'
                },
                'file': {
                    'level': 'INFO',
                    'class': 'logging.handlers.RotatingFileHandler',
                    # 日志位置,日志文件名,日志保存目录必须手动创建
                    'filename': os.path.join(os.path.dirname(BASE_DIR), "logs/luffy.log"),  # 注意,你的文件应该有读写权限.
                    # 日志文件的最大值,这里我们设置300M
                    'maxBytes': 300 * 1024 * 1024,
                    # 日志文件的数量,设置最大日志数量为10
                    'backupCount': 10,
                    # 日志格式:详细格式
                    'formatter': 'verbose',
                    # 设置默认编码,否则打印出来汉字乱码
                    'encoding': 'utf-8',
                },
            },
            # 日志对象
            'loggers': {
                'django': {  # 和django结合起来使用,将django中之前的日志输出内容的时候,按照我们的日志配置进行输出,
                    'handlers': ['console', 'file'],  # 项目上线,需要把console去掉
                    'propagate': True,
                    # 冒泡: 是否将日志信息记录冒泡给其他的日志处理系统,工作中都是True,不然django这个日志系统捕获到日志信息之后,其他模块中可能也有日志记录功能的模块,就获取不到这个日志信息了
                },
                'django.db.backends': {
                    'handlers': ['console'],
                    'propagate': True,
                    'level':'DEBUG',
                },
            }
        }
    ```

