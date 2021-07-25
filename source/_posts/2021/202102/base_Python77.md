---
title: Python_基础 (77)
date: 2021-02-22
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django之django-redis

<!-- more -->

#### 先说说我想做的事
> 我们要做一个异步的任务队列, 我就想到了用redis的队列去实现这个功能,至于为什么用redis, 哈哈哈哈哈哈 好处太多了(os:我记不住了)

#### DJANGO-REDIS简介
> 是一个使 Django 支持 Redis cache/session 后端的全功能组件

#### 环境一览
1. Django 3.1.2
2. django-redis 4.7.0
3. Python 3.8.2
4. redis 

#### 安装及配置
1. 安装
    ```bash
        pip install django-redis
    ```
2. 配置
    * URL scheme
        * redis://: 普通的 TCP 套接字连接 redis://\[:password]@localhost:6379/0
        * rediss://: SSL 包裹的 TCP 套接字连接 rediss://\[:password]@localhost:6379/0
        * unix://: Unix 域套接字连接 unix://\[:password]@/path/to/socket.sock?db=0
    * 指定数据库
        * db 查询参数, 例如: redis://localhost?db=0
        * 如果使用 redis:// scheme, 可以直接将数字写在路径中, 例如: redis://localhost/0
    * eg
        ````bash
            # vim setting.py
            # Django的缓存配置
            CACHES = {
                "default": {
                    "BACKEND": "django_redis.cache.RedisCache",
                    # URL scheme
                    "LOCATION": "redis://127.0.0.1:6379/0",
                    "OPTIONS": {
                        # 使用的redis客户端
                        "CLIENT_CLASS": "django_redis.client.DefaultClient",
                        # 连接redis的密码
                        "PASSWORD": "yourpassword",
                        # 连接池设置
                        "CONNECTION_POOL_KWARGS": {
                            # 设置连接池的最大连接数量
                            "max_connections": 100,
                            # 以字符串的形式写入Redis,为False的话写入字节类型
                            'decode_responses': True
                        }
                    }
                }
            }
            
            # 配置session存储(不用的话 可以不配置)
            SESSION_ENGINE = "django.contrib.sessions.backends.cache"
            SESSION_CACHE_ALIAS = "default"
        ````

#### 使用
1. 方式1
    * from django_redis import get_redis_connection
    * eg
        ```python
            # 原生连接方式
            from django_redis import get_redis_connection
            con = get_redis_connection('default')

            # 字符串操作
            >>> con.set('redis_test3', 22)
            True
            # 取出来的是数据类型是bytes, 需要decode为utf-8,decode_responses=True的话, 读取出去就不需要自己decode了
            >>> con.get('redis_test3')
            b'22'

            # 操作列表, 操作基本同redis原生命令
            # 增 conn.lpush(list, 1)
            # 删 conn.lrem(list, 0, 1)
            # 查 con.lrange(list, 0, 4)

            # 获取当前连接数
            con.connection_pool._created_connections

            # 清除所有数据
            con.flushall()
        ```
2. 方式2
    * from django.core.cache import cache
    * eg
        ```python
            from django.core.cache import cache

            # 获取不到, 因为通过cache进行增删的时候都会添加上默认的前缀
            >>> cache.get("redis_test3")
            >>> 
            >>> cache.set("redis_test3", "1234")
            True
            >>> cache.get("redis_test3")
            '1234'
            >>> con.keys()
            [b':1:redis_test3',b'redis_test3']

            # decode_responses设置为True的话,通过cache读取是会报错的
            >>> cache.get('redis_test3')
            Traceback (most recent call last):
            UnicodeDecodeError: 'utf-8' codec can't decode byte 0x80 in position 0: invalid start byte
        ```
3. 对比
    * 原生的可以操作的类型有很多(字符串、列表、集合、有序集合、哈希), cache的话只能操作字符串
    * redis客户端写进去的key/其它应用写到redis里的key可以通过原生的方式获取到, 但cache获取不到
    * cache默认进到redis里的是字符串, 但是原生的默认写进去的是字节型, 需要取出来之后再转移或者在配置中设置参数

#### 需要注意的点
1. django-redis使用redis-py的连接池接口,redis-py默认不会关闭连接,尽可能重用连接
2. 如有多个Redis的话,可以在CACHE里面添加一个新的,区别于default即可
3. 使用原生方式操作redis的话,caches里面的前缀是不生效的,即设置到redis里面去,keys是什么就是什么,不会自动加上前缀
4. 还有其他方式操作redis时,请使用原生的方式存取redis,要不然key找不到


