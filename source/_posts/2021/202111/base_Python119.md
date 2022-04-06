---
title: Python_基础 (119)
date: 2021-11-29
tags: Python
toc: true
---

### 巧用装饰器
    装饰器这个东西真的是好用不好写

<!-- more -->

#### 前情提要
> 第三方类库操作hdfs的时候,为了防止请求太过频繁导致api返回错误,所以写了一个简单的装饰器来保证调用的时候会随机sleep几秒；如何优化的捕获一个类里的异常

#### 调用前先sleep
- code
    ```python
        import hdfs
        import random
        import time

        def time_sleep(origin_func):
            """
            类方法装饰器
            """
            def wrapper(*args, **kwargs):
                """
                防止请求太过频繁导致api返回错误, 这里随机sleep 1-10s
                """
                sleeptime = random.randint(1, 10)
                logger.debug("time sleep %s" % sleeptime)
                time.sleep(sleeptime)
                u = origin_func(*args, **kwargs)
                return u
            return wrapper


        class HttpFs:
            """
            hdfs http api
            """
            def __init__(self, host, port, user, root_path, schema="http"):
                self.host = host
                self.user = user
                self.schema = schema
                self.root_path = root_path
                self.base_url = "%s://%s:%s" % (schema, host, port)
                self.client = hdfs.client.InsecureClient(self.base_url, user=self.user)

            @time_sleep
            def check_exist(self, hdfs_path):
                """
                检查路径是否存在
                hdfs_path 要列出的hdfs路径
                strict 是否开启严格模式,严格模式下目录或文件不存在不会返回None,而是raise
                """
                try:
                    if self.client.status(hdfs_path, strict=False):
                        logger.error("check_exist succ, path is %s" % hdfs_path)
                        return True
                    else:
                        logger.warn("check_exist warn, path is %s" % hdfs_path)
                        return False
                except Exception as e:
                    logger.error("check_exist error, e is %s" % str(e))
                    return False

            @time_sleep
            def list_dir(self, hdfs_path):
                """
                列出文件夹列表
                """
                try:
                    if self.check_exist(hdfs_path):
                        logger.debug("list_dir succ, path is %s" % hdfs_path)
                        return self.client.list(hdfs_path)
                    else:
                        logger.warn("list_dir warn, path is %s" % hdfs_path)
                        return None
                except Exception as e:
                    logger.error("list_dir error, e is %s" % str(e))
                    return False


        hdfs_client = HttpFs(
            "127.0.0.1",
            "57000",
            "hadoop",
            "/user/hadoop/",
            "http"
        )
    ```

#### 优雅的捕获异常
- base_code
    ```python
        class Test(object):
            def __init__(self):
                pass

            def revive(self):
                print('revive from exception.')
                # do something to restore

            def read_value(self):
                """
                会在多个地方被调用,有可能随机抛出一场导致程序崩溃
                """
                print('here I will do something.')
                # do something.
    ```
- code1.0
    ```python
        class Test(object):
            def __init__(self):
                pass

            def revive(self):
                print('revive from exception.')
                # do something to restore

            def read_value(self):
                """
                最粗暴做法 直接try ... except包住
                """
                try:
                    print('here I will do something.')
                    # do something.
                except Exception as e:
                    print(f'exception {e} raised, parse exception.')
                    # do other thing.
                    self.revive()
    ```
- code2.0
    ```python
        def catch_exception(origin_func):
            def wrapper(*args, **kwargs):
                try:
                    u = origin_func(*args, **kwargs)
                    return u
                except Exception:
                    return 'an Exception raised.'
            return wrapper


        class Test(object):
            def __init__(self):
                pass

            def revive(self):
                print('revive from exception.')
                # do something to restore

            @catch_exception
            def read_value(self):
                print('here I will do something.')
                # do something.
    ```
- code3.0
    ```python
        # 捕获异常之后还想调用类中的某个方法 类似final
        def catch_exception(origin_func):
            def wrapper(self, *args, **kwargs):
                try:
                    u = origin_func(self, *args, **kwargs)
                    return u
                except Exception:
                    self.revive() #不用顾虑,直接调用原来的类的方法
                    return 'an Exception raised.'
            return wrapper


        class Test(object):
            def __init__(self):
                pass

            def revive(self):
                print('revive from exception.')
                # do something to restore

            @catch_exception
            def read_value(self):
                print('here I will do something.')
                # do something.
    ```






