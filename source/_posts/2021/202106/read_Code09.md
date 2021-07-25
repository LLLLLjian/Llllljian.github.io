---
title: 读T代码 (09)
date: 2021-06-10
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### Auth.py
- code
    ```python
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

            def check_exist(self, remote_path):
                """check path exist"""
                if self.client.status(remote_path, strict=False):
                    return True
                else:
                    return False

            def list_dir(self, remote_path):
                """
                列出文件夹列表
                """
                return self.client.list(remote_path)

            def makedirs(self, remote_path):
                """
                创建文件夹
                """
                self.client.makedirs(remote_path)

            def put_file(self, local_path, remote_path):
                """
                put one file
                """
                self.client.write(remote_path, local_path)

            def delete_file(self, remote_path):
                """删除文件"""
                self.client.delete(remote_path, recursive=True)

            def _get_log_path(self, date, product_name, module_name, env, local_path, hostname, start_offset):
                ori_path = local_path.replace("/", "%")
                now_ts = int(time.time())
                hdfs_filename = "#".join([hostname, ori_path, str(start_offset), str(now_ts)])
                # "/user/test/log/20200221/BCH/console-bch/env_preonline/xxx.log_${start_offset}"
                hdfs_path = os.path.join(self.root_path, "log", date, product_name, module_name, env, hdfs_filename)
                return hdfs_path

            def _get_result_path(self, date, product_name, module_name, env, local_path, hostname, start_offset):
                ori_path = local_path.replace("/", "%")
                now_ts = int(time.time())
                hdfs_filename = "#".join([hostname, ori_path, str(start_offset), str(now_ts)])
                # "/user/test/map_reduce/20200221/project_module_cluster#agent/"
                hdfs_dir = "_".join([product_name, module_name, env, "#agent"])
                hdfs_path = os.path.join(self.root_path, "map_reduce", date, hdfs_dir, hdfs_filename)
                return hdfs_path

            def init_hdfs_path(self, init_set, date):
                """
                make sure hdfs /user/test/log/20210225/BCC/nova/env_preonline/log exist.
                Args:
                    init_set: {product_name}.{module_name}, Neutron.neugtron, BCC-NOVA.nova
                """
                for name in init_set:
                    product_name, module_name, cluster = name.split(".")
                    hdfs_dir = os.path.join(self.root_path, "log", date, product_name, module_name, cluster)
                    if not self.check_exist(hdfs_dir):
                        logger.info("mkdir: %s" % hdfs_dir)
                        self.client.makedirs(hdfs_dir)

            def init_analyse_path(self, init_set, date):
                """
                make sure hdfs /user/test/map_reduce/20210225/AFS_afs_master_ec_agent exist.
                Args:
                    init_set: {product_name}.{module_name}.{ckuster}, Neutron.neugtron.sandbox, BCC-NOVA.nova.sandbox
                """
                for name in init_set:
                    product_name, module_name, cluster = name.split(".")
                    result_dir = "_".join([product_name, module_name, cluster])
                    hdfs_dir = os.path.join(self.root_path, "map_reduce", date, result_dir)
                    if not self.check_exist(hdfs_dir):
                        logger.info("mkdir: %s" % hdfs_dir)
                        self.client.makedirs(hdfs_dir)

            def put_file_part(self, local_path, remote_path, start_offset):
                """
                put file to hdfs by start offset, this will only put a part of file.
                """
                logger.info("start put offset %s file: %s to hdfs path:%s" % (start_offset, local_path, remote_path))
                with open(local_path, "rb") as reader:
                    if start_offset:
                        reader.seek(start_offset)
                    self.client.write(remote_path, data=reader)

            def put_log(self, date, product_name, module_name, env, local_path, hostname, start_offset):
                """
                put log to test hdfs
                """
                try:
                    remote_path = self._get_log_path(
                        date,
                        product_name,
                        module_name,
                        env,
                        local_path,
                        hostname,
                        start_offset
                    )
                    self.put_file_part(local_path, remote_path, start_offset)
                    return True
                except Exception as e:
                    logger.exception(e)
                    return False

            def put_analyse_result(self, date, product_name, module_name, env, local_path, hostname, start_offset):
                """
                put log to test hdfs
                """
                try:
                    remote_path = self._get_result_path(
                        date,
                        product_name,
                        module_name,
                        env,
                        local_path,
                        hostname,
                        start_offset
                    )
                    self.put_file_part(local_path, remote_path, start_offset)
                    return True
                except Exception as e:
                    logger.exception(e)
                    return False

            def put_file_force(self, date, product_name, module_name, env, local_path):
                """
                强制重新上传完整的一个文件
                1. 删除源文件
                2. 使用偏移量为0参数重传
                """
                hostname = G_HOST_NAME
                remote_path = self._get_log_path(date, product_name, module_name, env, local_path, hostname, start_offset=0)
                self.client.delete(remote_path)
                self.put_file_part(local_path, remote_path, start_offset=0)
    ```




