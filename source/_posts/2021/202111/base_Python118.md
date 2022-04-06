---
title: Python_基础 (118)
date: 2021-11-22
tags: Python
toc: true
---

### Python+HDFS=hdfs
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### 前情提要
> 我本来是用的 mount nfs, 但是太卡了,还因为网络问题 经常断,然后我就想到了hdfs有没有python相关的类库,我就去研究了一下

#### hdfs
- 安装
    ```bash
        pip install hdfs
    ```
- 连接hadoop
    * 普通
        ```python
            from hdfs.client import Client
            client = Client("http://127.0.0.1:50070/")
        ```
    * 指定用户
        ```python
            from hdfs import InsecureClient
            client = InsecureClient("http://172.10.236.21:50070", user='ann')
        ```
    * token
        ```python
            from hdfs import TokenClient
            client = TokenClient("http://172.10.236.21:50070", token='xxxxxxx')
        ```
- 简单使用
    * list(): 列出hdfs指定路径的所有文件信息
        ```python
            # hdfs_path 要列出的hdfs路径
            # status 默认为False,是否显示详细信息
            print("hdfs中的目录为:", client.list(hdfs_path="/",status=True))
        ```
    * status(): 查看文件或者目录状态
        ```python
            # hdfs_path 要列出的hdfs路径
            # strict 是否开启严格模式,严格模式下目录或文件不存在不会返回None,而是raise
            print(client.status(hdfs_path="/b.txt",strict=True))
        ```
    * checksum(): 计算目录下的文件数量
        ```python
            print("根目录下的文件数量为:", client.checksum(hdfs_path="/input.txt"))
        ```
    * parts(): 列出路径下的part file
        ```python
            # hdfs_path 要列出的hdfs路径
            # parts 要显示的parts数量 默认全部显示
            # status 默认为False,是否显示详细信息
            print("", client.parts(hdfs_path="/log", parts=0, status=True))
        ```
    * content(): 列出目录或文件详情
        ```python
            # hdfs_path 要列出的hdfs路径
            # strict 是否开启严格模式,严格模式下目录或文件不存在不会返回None,而是raise
            print(client.content(hdfs_path="/",strict=True))
        ```
    * makedirs(): 创建目录
        ```python
            # hdfs_path hdfs路径
            # permission 文件权限
            print("创建目录", client.makedirs(hdfs_path="/t", permission="755"))
        ```
    * rename(): 文件或目录重命名
        ```python
            # hdfs_src_path 原始路径或名称
            # hdfs_dst_path 修改后的文件或路径
            client.rename(hdfs_src_path="/d.txt",hdfs_dst_path="/d.bak.txt")
        ```
    * resolve(): 返回绝对路径
        ```python
            print(client.resolve("d.txt"))
        ```
    * set_replication(): 设置文件在hdfs上的副本(datanode上)数量
        ```python
            # hdfs_path hdfs路径
            # replication 副本数量
            client.set_replication(hdfs_path="/b.txt",replication=2)
        ```
    * read(): 读取文件信息
        ```python
            # hdfs_path hdfs路径
            # offset 读取位置
            # length 读取长度
            # buffer_size 设置buffer_size 不设置使用hdfs默认100MB 对于大文件 buffer够大的化 sort与shuffle都更快
            # encoding 指定编码
            # chunk_size 字节的生成器,必须和encodeing一起使用 满足chunk_size设置即 yield
            # delimiter 设置分隔符 必须和encodeing一起设置
            # progress 读取进度回调函数 读取一个chunk_size回调一次

            # 读取200长度
            with client.read("/input.txt", length=200, encoding='utf-8') as obj:
                for i in obj:
                    print(i)

            # 从200位置读取200长度
            with client.read("/input.txt", offset=200, length=200, encoding='utf-8') as obj:
                for i in obj:
                    print(i)

            # 设置buffer为1024,读取
            with client.read("/input.txt", buffer_size=1024, encoding='utf-8') as obj:
                for i in obj:
                    print(i)

            # 设置分隔符为换行
            p = client.read("/input.txt", encoding='utf-8', delimiter='\n')
            with p as d:
                print(d, type(d), next(d))

            # 设置读取每个块的大小为8
            p = client.read("/input.txt", encoding='utf-8', chunk_size=8)
            with p as d:
                print(d, type(d), next(d))
        ```
    * download(): 从hdfs下载文件到本地
        ```python
            # hdfs_path hdfs路径
            # local_path 下载到的本地路径
            # overwrite 是否覆盖(如果有同名文件) 默认为Flase
            # n_threads 启动线程数量,默认为1,不启用多线程
            # temp_dir下载过程中文件的临时路径
            # **kwargs其他属性
            print("下载文件结果input.txt:", client.download(hdfs_path="/input.txt", local_path="~/",overwrite=True))
        ```
    * upload(): 上传文件到hdfs
        ```python
            # hdfs_path, hdfs上位置
            # local_path, 本地文件位置
            # n_threads=1 并行线程数量 temp_dir=None, overwrite=True或者文件已存在的情况下的临时路径
            # chunk_size=2 ** 16 块大小
            # progress=None, 报告进度的回调函数 完成一个chunk_size回调一次 chunk_size可以设置大点 如果大文件的话
            # cleanup=True, 上传错误时 是否删除已经上传的文件
            # **kwargs 上传的一些关键字 一般设置为 overwrite 来覆盖上传
            def callback(filename, size):
                print(filename, "完成了一个chunk上传", "当前大小:", size)
                if size == -1:
                    print("文件上传完成")
                    
            # 上传成功返回 hdfs_path
            client.upload(hdfs_path="/a_bak14.txt", local_path="a.txt", chunk_size=2 << 19, progress=callback,cleanup=True)
        ```
    * delete(): 删除文件
        ```python
            # hdfs_path
            # recursive=False 是否递归删除
            # skip_trash=True 是否移到垃圾箱而不是直接删除 hadoop 2.9+版本支持
            client.delete("/a.s")
        ```
    * set_owner(): 修改目录或文件的所属用户,用户组
        ```python
            # hdfs_path hdfs路径
            # owner 用户
            # group 用户组
            client.set_owner(hdfs_path="/a.txt", owner="root", group="root")
        ```
    * set_permission(): 修改权限
        ```python
            # hdfs_path hdfs路径
            # permission 权限
            client.set_permission(hdfs_path="/b.txt",permission='755')
        ```
    * set_acl(): 查看权限控制
    * acl_status(): 修改权限控制
    * set_times(): 设置文件时间
        ```python
            import time

            # hdfs_path: hdfs路径.
            # access_time: 最后访问时间 时间戳 毫秒
            # modification_time: 最后修改时间 时间戳 毫秒
            client.set_times(
                hdfs_path="/b.txt",
                access_time=int(time.time())*1000,
                modification_time=int(time.time())*1000
            )
        ```
- class
    ```python
        import hdfs
        import random
        import time
        import logging as logger

        def time_sleep(origin_func):
            """
            类方法装饰器
            """
            def wrapper(*args, **kwargs):
                """
                防止请求太过频繁导致api返回错误, 这里随机sleep 1-10s
                """
                sleeptime = random.randint(1, 10)
                logger.error("time sleep %s" % sleeptime)
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
            def makedirs(self, hdfs_path):
                """
                创建目录,同hdfs dfs -mkdir与hdfs dfs -chmod的结合体,接收两个参数
                hdfs_path hdfs路径
                permission 文件权限
                """
                try:
                    self.client.makedirs(hdfs_path)
                    logger.debug("makedirs succ, path is %s" % hdfs_path)
                    return True
                except Exception as e:
                    logger.error("makedirs error, e is %s" % str(e))
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

            @time_sleep
            def get_file_num(self, hdfs_path):
                """
                获取目录下的文件数量
                """
                if self.check_exist(hdfs_path):
                    return self.client.checksum(hdfs_path)
                else:
                    return 0

            @time_sleep
            def rename_file(self, hdfs_src_path, hdfs_dst_path):
                """
                文件或目录重命名,接收两个参数
                hdfs_src_path 原始路径或名称
                hdfs_dst_path 修改后的文件或路径
                """
                self.client.rename(hdfs_src_path, hdfs_dst_path)

            @time_sleep
            def resolve_file(self, hdfs_path):
                """
                返回绝对路径,接收一个参数hdfs_path
                """
                return self.client.resolve(hdfs_path)

            @time_sleep
            def read_file(self, hdfs_path, **kwargs):
                """
                读取文件信息 类似与 hdfs dfs -cat hfds_path
                hdfs_path hdfs路径
                offset 读取位置
                length 读取长度
                buffer_size 设置buffer_size 不设置使用hdfs默认100MB 对于大文件 buffer够大的化 sort与shuffle都更快
                encoding 指定编码
                chunk_size 字节的生成器,必须和encodeing一起使用 满足chunk_size设置即 yield
                delimiter 设置分隔符 必须和encodeing一起设置
                progress 读取进度回调函数 读取一个chunk_size回调一次
                """
                with self.client.read(hdfs_path, **kwargs) as obj:
                    for i in obj:
                        print(i)

            @time_sleep
            def download_file(self, **kwargs):
                """
                从hdfs下载文件到本地,参数列表如下
                hdfs_path hdfs路径
                local_path 下载到的本地路径
                overwrite 是否覆盖(如果有同名文件) 默认为Flase
                n_threads 启动线程数量,默认为1,不启用多线程
                temp_dir下载过程中文件的临时路径
                **kwargs其他属性
                """
                return self.client.download(**kwargs)

            @time_sleep
            def upload_file(self, **kwargs):
                """
                上传文件到hdfs 同hdfs dfs -copyFromLocal local_file hdfs_path,参数列表如下:
                hdfs_path, hdfs上位置
                local_path, 本地文件位置
                n_threads=1 并行线程数量 temp_dir=None, overwrite=True或者文件已存在的情况下的临时路径
                chunk_size=2 ** 16 块大小
                progress=None, 报告进度的回调函数 完成一个chunk_size回调一次 chunk_size可以设置大点 如果大文件的话
                cleanup=True, 上传错误时 是否删除已经上传的文件
                **kwargs 上传的一些关键字 一般设置为 overwrite 来覆盖上传

                def callback(filename, size):
                    print(filename, "完成了一个chunk上传", "当前大小:", size)
                    if size == -1:
                        print("文件上传完成")
                # 上传成功返回 hdfs_path
                client.upload(hdfs_path="/a_bak14.txt", local_path="a.txt", chunk_size=2 << 19, progress=callback,cleanup=True)
                """
                return self.client.upload(**kwargs)

            @time_sleep
            def append_to_hdfs(self, hdfs_path, data):
                """
                追加数据到hdfs文件
                """
                self.client.write(hdfs_path, data, overwrite=False, append=True, encoding='utf-8')

            @time_sleep
            def write_to_hdfs(self, hdfs_path, data):
                """
                覆盖数据写到hdfs文件
                """
                self.client.write(hdfs_path, data, overwrite=True, append=False, encoding='utf-8')

            @time_sleep
            def put_file(self, local_path, hdfs_path):
                """
                上传文件
                """
                self.client.write(hdfs_path, local_path)

            @time_sleep
            def delete_file(self, hdfs_path):
                """
                删除文件
                hdfs_path
                recursive=False 是否递归删除
                skip_trash=True 是否移到垃圾箱而不是直接删除
                """
                self.client.delete(hdfs_path, recursive=True)


        hdfs_client = HttpFs(
            "127.0.0.1",
            "57000",
            "hadoop",
            "/user/hadoop/",
            "http"
        )
    ```
