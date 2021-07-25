---
title: 读T代码 (07)
date: 2021-06-08
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
        AUTH_FILE = os.path.join(DATA_DIR, "auth_key")  # 授信机器信息
        auth = Auth(AUTH_FILE)

        class Auth:
            """
            鉴权模块
            """
            def __init__(self, auth_file_path):
                self.auth_file_path = auth_file_path
                self.auth_dict = {}
                self.auth_pickle = PickleHandler(auth_file_path, {})
                self.admin_check_key = self._gen_admin_auth()
                # 加载授权信息
                self.load_auth_dict()

            def _gen_admin_auth(self):
                """
                获取加密后的管理员口令
                """
                admin_auth_key = "auth-auth"
                admin_auth = hashlib.md5()
                admin_auth.update(admin_auth_key.encode("utf8"))
                # 十六进制数据字符串值
                return admin_auth.hexdigest()

            def check_admin_auth(self, req_key):
                """
                检查管理员口令
                """
                if req_key == self.admin_check_key:
                    return True
                else:
                    logger.info("check admin auth key faield,expect=%s actual=%s" % (self.admin_check_key, req_key))
                    return False

            def check_req_auth(self, req_addr):
                """
                检查请求地址是否合法
                """
                # 本地默认允许
                if req_addr in ["127.0.0.1", "localhost"]:
                    return True
                if req_addr in self.auth_dict and self.auth_dict[req_addr]:
                    return True
                else:
                    return False

            def save_auth_dict(self):
                """
                存储当前授权信息
                """
                self.auth_pickle.set_data(self.auth_dict)
                self.auth_pickle.save()

            def load_auth_dict(self):
                """
                加载授权信息
                """
                self.auth_pickle.load()
                self.auth_dict = self.auth_pickle.get_data()

            def add_auth(self, auth_ip_list):
                """"
                增加授权机器
                """
                auth_dict = {}
                for ip in auth_ip_list:
                    auth_dict[ip] = True
                logger.info("now auth ip list:%s" % json.dumps(auth_dict))
                self.auth_dict = auth_dict
                self.save_auth_dict()

            def clear_auth(self):
                """
                清除所有授权信息
                """
                self.auth_dict = {}
                self.save_auth_dict()

            def disable_auth(self, key):
                """
                disable auth
                """
                self.auth_dict[key] = False
                self.save_auth_dict()

            def disable_all_auth(self):
                """
                禁用所有授权
                """
                for k in self.auth_dict:
                    self.auth_dict[k] = False
                self.save_auth_dict()

            def get_auth_content(self):
                """
                get auth content
                """
                return self.auth_dict
    ```




