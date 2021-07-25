---
title: 读T代码 (08)
date: 2021-06-09
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
        pwd = os.path.dirname(os.path.realpath(__file__))  # src
        WORK_DIR = os.path.dirname(pwd)  # test_agent
        BASE_CONFIG_FILE = os.path.join(WORK_DIR, "baseconfig")  # 基础配置
        default_cfg = {
            "name": "llllljian",
            "age": 18
        }
        base_config = PickleHandler(BASE_CONFIG_FILE, default_cfg)

        class PickleHandler:
            """
            通过pickle,代替数据库处理数据存储
            pickle_file: 存储pickle文件路径
            defualt_data: 如果没有历史存储记录,初始化的值
            """
            def __init__(self, pickle_file, default_data):
                self.lock = threading.Lock()
                self.data = default_data
                self.pickle_file = pickle_file
                # 文件不存在,创建并写入默认值
                if not os.path.exists(pickle_file):
                    self.save()
                self.load()

            def save(self):
                """
                save config to pickle file
                """
                self.lock.acquire()
                try:
                    with open(self.pickle_file, "wb") as f:
                        logger.debug("save pickle to file:%s" % self.pickle_file)
                        # 序列化对象, 并将结果数据流写入到文件对象中
                        pickle.dump(self.data, f)
                        return True
                except Exception as e:
                    logger.error("save pickle failed:%s" % self.pickle_file)
                    logger.exception(e)
                    return False
                finally:
                    self.lock.release()

            def load(self):
                """
                load config from file
                """
                try:
                    with open(self.pickle_file, "rb") as f:
                        logger.debug("load config to file:%s" % self.pickle_file)
                        # 处理文件为空
                        self.data = pickle.load(f)
                except EOFError:
                    logger.info("pickle file is empty,set data to None")
                    self.data = {}
                except Exception as e:
                    logger.error("load pickle failed:%s, set data to None" % self.pickle_file)
                    logger.exception(e)
                    self.data = {}
                return self.data

            def get_data(self):
                """
                get data
                """
                return self.data

            def set_data(self, data):
                """
                set data
                """
                self.data = data

            def get_key(self, key):
                """
                获取key
                """
                return self.data.get(key)

            def set_key(self, key, v):
                """
                更新key
                """
                self.lock.acquire()
                try:
                    self.data[key] = v
                except Exception as e:
                    logger.error("save key vailed:%s" % key)
                    logger.exception(e)
                    return False
                finally:
                    self.lock.release()

            def del_key(self, key):
                """
                删除key
                """
                self.lock.acquire()
                try:
                    if self.data.get(key):
                        del self.data[key]
                except Exception as e:
                    logger.error("save key vailed:%s" % key)
                    logger.exception(e)
                    return False
                finally:
                    self.lock.release()
    ```




