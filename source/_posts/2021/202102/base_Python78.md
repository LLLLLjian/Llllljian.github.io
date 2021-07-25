---
title: Python_基础 (78)
date: 2021-02-23
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
> 前边介绍了一下使用, 这里简单的写几个例子

#### 例子1
- 操作redis-list, 实现简单的队列
- eg
    ```python
        con = get_redis_connection("default")

        for i in range(5):
            con.rpush("test_list", i)

        while True:
            # 从队列中获取一个任务
            task = self._con.lpop("test_list")
            if (task is None):
                time.sleep(20)
            else:
                # 如果没有设置decode_responses
                # task = task.decode('utf-8') if isinstance(task, bytes) else task
                print(task)
    ```


#### 例子2
- 字符串实现简单的私有IP列表
- eg
    ```python
        def get_private_ips(self, subnet_id, is_ignore_cache=False):
            """
            查询私有IP列表
            使用Redis缓存,保存1小时
            :param subnet_id:
            :param is_ignore_cache: 是否忽略缓存 默认是否
            :return:
            """
            key = 'HW_private_ips_area_%s_subnetId_%s' % (self.area, subnet_id)
            cache = get_redis_connection()

            # 保存1小时
            expired_time = 60 * 60 * 1
            res = cache.get(key, None)

            if not res or is_ignore_cache:
                sig = self.sig
                uri = "/v1/{0}/subnets/{1}/privateips".format(sig.ProjectId, subnet_id)
                res = self._hw_request(uri)

                if res and not res.get('code') and res.get('privateips'):
                    cache.set(key, res, expired_time)

            return res
    ```

#### 例子3
- 简单的redis锁
- eg
    ```python
        class LockService:
            def __init__(self, conn=None):
                """
                如果不传连接池的话,默认读取配置的Redis作为连接池
                :param conn:
                """
                self.conn = conn if conn else get_redis_connection()

            def acquire_lock(self, lock_name, value, expire_time=60):
                """
                加锁
                如果不存在lock_name,则创建,并且设置过期时间,避免死锁
                如果存在lock_name,则刷新过期时间

                插入成功：返回True
                已存在：返回False并且刷新过期时间
                :param lock_name:
                :param value:
                :param expire_time:
                :return:
                """
                if self.conn.setnx(lock_name, value):
                    # 注意：Todo 这里可能会有问题,如果程序在写入redis之后但未设置有效期之前突然崩溃,则无法设置过期时间,将发生死锁
                    self.conn.expire(lock_name, expire_time)
                    return True
                elif self.conn.ttl(lock_name):
                    self.conn.expire(lock_name, expire_time)
                return False

            def release_lock(self, lock_name, value):
                """
                释放锁
                注意：只有value值一致才会删除,避免在并发下删除了其他进程/线程设置的锁
                :param lock_name:
                :param value:
                :return:
                """
                redis_value = self.conn.get(lock_name)

                # 注意：如果是get_redis_connection的话,从redis里面读取的是bytes字符的
                redis_value = redis_value.decode('utf-8') if isinstance(redis_value, bytes) else redis_value
                if str(redis_value) == str(value):
                    self.conn.delete(lock_name)
    ```


