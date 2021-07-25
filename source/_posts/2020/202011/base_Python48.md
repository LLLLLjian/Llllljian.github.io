---
title: Python_基础 (48)
date: 2020-11-10
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Django 单元测试TestCase

<!-- more -->

#### 前情提要
> 啊 写完接口要自己跑单元测试, 懵了懵了 好不容易复制粘贴了14个 感觉太蠢了 经同事大哥指点 准备重新看一下这块

#### TestCase类的结构
> 常见的TestCase由setUp函数、tearDown函数和test_func组成.
这里test_func是指你编写了测试逻辑的函数,而setUp函数则是在test_func函数之前执行的函数,tearDown函数则是在test_func执行之后执行的函数
- demo
    ```python
        from django.test import TestCase

        class Demo(TestCase):
            def setUp(self):
                print('setUp')

            def tearDown(self):
                print('tearDown')

            def test_demo(self):
                print('test_demo')

            def test_demo_2(self):
                print('test_demo2')

        # 执行结果
        setUp
        test_demo
        test_demo2
        tearDown
    ```

#### 利用TestCase测试接口
- 请求的路由地址
    1. 直接设置请求地址
        ```bash
            url = '/test_case/hello_test_case'
        ```
    2. 透过django.urls.reverse函数和在路由设置的name来得到请求的地址
        ```bash
            url = reverse('hello_test_case')
        ```
- 请求的客户端
    * Django在它的TestCase类 中已经集成了一个客户端工具,我们只需要调用TestCase的client属性就可以得到一个客户端
    * client = self.client
- 发起请求
    * response = self.client.get(url)
    * response = self.client.get(url, {'name': self.name})
- 验证响应体
    * 检查状态码
        * self.assertEqual(response.status_code, 200)  # 期望的Http相应码为200
    * 检查返回值
        * self.assertEqual(data['msg'], 'Hello , I am a test Case')  # 期望的msg返回结果为'Hello , I am a test Case'

#### TestCase在使用中需要注意的一些问题
- demo
    ```python
        def send_data_test(operation, data, method="POST", token=None):
            """
            发送数据测试
            operation url
            data 要发送的数据
            method 请求的方法
            token header头中的认证信息
            """
            try:
                if sys.version_info < (3,):
                    conn = httplib.HTTPConnection('%s:%s' % (conf["master_ip"], conf["master_port"]))
                else:
                    conn = http.client.HTTPConnection('%s:%s' % (conf["master_ip"], conf["master_port"]))

                headers = {"Content-type": "application/json", "Connection": "close"}
                if token is not None:
                    headers["token"] = token
                conn.request(method, operation, json.dumps(data), headers)
                response = conn.getresponse()
            except Exception as ex:
                # conn.close()
                return None, None, None

            status, header, body = response.status, response.getheaders(), response.read()
            conn.close()
            try:
                body = json.loads(body)
            except Exception as ex:
                pass
            return status, header, body
    ```

