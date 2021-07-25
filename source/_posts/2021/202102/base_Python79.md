---
title: Python_基础 (79)
date: 2021-02-24
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django之cache

<!-- more -->

#### 先说说我想做的事
> 前边学了django-redis了, 趁热打铁 看看django cache

#### 缓存
> 缓存(Cache)对于创建一个高性能的网站和提升用户体验来说是非常重要的,缓存是一类可以更快的读取数据的介质统称,也指其它可以加快数据读取的存储方式.一般用来存储临时数据,常用介质的是读取速度很快的内存.一般来说从数据库多次把所需要的数据提取出来,要比从内存或者硬盘等一次读出来付出的成本大很多.对于中大型网站而言,使用缓存减少对数据库的访问次数是提升网站性能的关键之一. 某些数据访问很频繁的场景下,通过缓存的方式,可以减少对于数据库的连接、查询请求、带宽等多个方面；同时也要注意的是缓存的占用空间,缓存的失效时间

#### Django缓存应用场景
> 缓存主要适用于对页面实时性要求不高的页面.存放在缓存的数据,通常是频繁访问的,而不会经常修改的数据
1. 博客文章.假设用户一天更新一篇文章,那么可以为博客设置1天的缓存,一天后会刷新
2. 购物网站.商品的描述信息几乎不会变化,而商品的购买数量需要根据用户情况实时更新.我们可以只选择缓存商品描述信息
3. 缓存网页片段.比如缓存网页导航菜单和脚部(Footer)

#### Django缓存的五种配置
1. 开发调试
    ```python
        CACHES = {
            'default1': {
                'BACKEND': 'django.core.cache.backends.dummy.DummyCache',  
            },
        }
    ```
2. 将缓存信息保存至文件
    ```python
        CACHES = {
            'default2': {
                'BACKEND': 'django.core.cache.backends.filebased.FileBasedCache',
                'LOCATION': os.path.join(BASE_DIR, 'cache'),
            },
        }
    ```
3. 将缓存信息保存至内存
    ```python
        CACHES = {
            'default3': {
                'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
                'LOCATION': 'unique-snowflake',
            },
        }
    ```
4. 将缓存信息保存至数据库
    ```python
        # 需要执行python3 manage.py createcachetable
        CACHES = {
            'default4': {
                'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
                'LOCATION': 'my_cache_table',                               # 数据库表
            },
        }
    ```
5. 将缓存信息保存至memcache(python-memcached模块)
    ```python
        CACHES = {
            'default5': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': '127.0.0.1:11211',
            },
            
            'default6': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': 'unix:/tmp/memcached.sock',
            },
            
            'default7': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': [
                    '172.19.26.240:11211',
                    '172.19.26.242:11211',
                ]
            },
        
            # 我们也可以给缓存机器加权重,权重高的承担更多的请求,如下
            'default8': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': [
                    ('172.19.26.240:11211',5),
                    ('172.19.26.242:11211',10),
                ]
            },
        }
    ```
6. 将缓存信息保存至memcache(pylibmc模块)
    ```python
        CACHES = {
            'default9': {
                'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
                'LOCATION': '127.0.0.1:11211',
            },
            'default10': {
                'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
                'LOCATION': '/tmp/memcached.sock',
            },
            'default11': {
                'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
                'LOCATION': [
                    '172.19.26.240:11211',
                    '172.19.26.242:11211',
                ]
            },
            'default12': {
                'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
                'LOCATION': [
                    ('172.19.26.240:11211',10),
                    ('172.19.26.242:11211',10),
                ]
            },
        }
    ```
7. 将缓存信息保存至redis(django-redis模块)
    ```python
        CACHES = {
            "default": {
                "BACKEND": "django_redis.cache.RedisCache",
                "LOCATION": "redis://127.0.0.1:6379/0",
                'TIMEOUT': 1800,                                              # 缓存超时时间(默认300,None表示永不过期,0表示立即过期)
                "OPTIONS": {
                    "MAX_ENTRIES": 300,                                       # 最大缓存个数(默认300)
                    "CULL_FREQUENCY": 3,                                      # 缓存到达最大个数之后,剔除缓存个数的比例,即：1/CULL_FREQUENCY(默认3)
                    "CLIENT_CLASS": "django_redis.client.DefaultClient",      # redis客户端
                    "CONNECTION_POOL_KWARGS": {"max_connections": 1},         # redis最大连接池配置
                    "PASSWORD": "password",                                   # redis密码
                },
                'KEY_PREFIX': 'Cache',                                        # 缓存key的前缀(默认空)
                'VERSION': 2,                                                 # 缓存key的版本(默认1)
            },
        }
    ```

#### 源码解析
1. 关于缓存名称的生成规则
    * venv/lib/python3.7/site-packages/django/core/cache/backends/base.py default_key_func
    * code
        ```python
            def default_key_func(key, key_prefix, version):
            """
            Default function to generate keys.

            Construct the key used by all other methods. By default, prepend
            the `key_prefix'. KEY_FUNCTION can be used to specify an alternate
            function with custom key making behavior.
            """
            print('%s:%s:%s' % (key_prefix, version, key))
            #return '%s:%s' % (key_prefix, version)
            return '%s:%s:%s' % (key_prefix, version, key)
        ```
