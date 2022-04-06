---
title: Python_基础 (104)
date: 2021-08-03
tags: Python
toc: true
---

### 快来跟我一起学requests
    主要看一下requests超时

<!-- more -->

#### 超时分析
> 网络请求不可避免会遇上请求超时的情况, 在 requests 中, 如果不设置你的程序可能会永远失去响应. 
超时又可分为连接超时和读取超时
- 连接超时
    * 连接超时指的是在你的客户端实现到远端机器端口的连接时(对应的是connect()), Request 等待的秒数
    * 简单来说, 连接超时就是发起请求连接到连接建立之间的最大时长
    ```python
        import time
        import requests

        url = 'http://www.google.com.hk'

        print(time.strftime('%Y-%m-%d %H:%M:%S'))
        try:
            html = requests.get(url, timeout=5).text
            print('success')
        except requests.exceptions.RequestException as e:
            print(e)

        print(time.strftime('%Y-%m-%d %H:%M:%S'))

        # 输出结果
        # 2021-08-03 16:27:52
        # HTTPConnectionPool(host='www.google.com.hk', port=80): Max retries exceeded with url: / (Caused by ConnectTimeoutError(<urllib3.connection.HTTPConnection object at 0x1100d0760>, 'Connection to www.google.com.hk timed out. (connect timeout=5)'))
        # 2021-08-03 16:27:57
    ```
- 读取超时
    * 读取超时指的就是客户端等待服务器发送请求的时间. (特定地, 它指的是客户端要等待服务器发送字节之间的时间. 在 99.9% 的情况下这指的是服务器发送第一个字节之前的时间)
    * 简单来说, 读取超时就是连接成功开始到服务器返回响应之间等待的最大时长
    ```python
        import time
        import requests
        # 我在本地起了一个flask的服务, 这个路由对应的方法里有一个time.sleep(5)
        url = 'http://127.0.0.1:5000/'
        print("req 1 S, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))
        resp1 = requests.get(url)
        print("req 1 E, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))

        time.sleep(2)
        print("req 2 S, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))
        try:
            resp2 = requests.get(url, timeout=3)
        except requests.exceptions.RequestException as e:
            print(e)
        print("req 2 E, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))

        time.sleep(2)
        print("req 3 S, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))
        try:
            resp3 = requests.get(url, timeout=(10, 4))
        except requests.exceptions.RequestException as e:
            print(e)
        print("req 3 E, date is %s" % (time.strftime('%Y-%m-%d %H:%M:%S')))

        # resp1 5s之后会返回接口内容
        # resp2 3s之后会抛出异常 requests.exceptions.ReadTimeout: HTTPConnectionPool(host='127.0.0.1', port=5000): Read timed out. (read timeout=3)
        # resp3 4s之后会抛出和resp2同样的异常

        # 结果分析
        # resp1 模拟的是接口响应成功, 但是读取夯住了, sleep5之后才返回内容
        # resp2 模拟的是设置了超时时间, 3s之后如果还没有响应就直接抛出读取异常
        # resp3 模拟的是设置了10s的连接超时和4s的请求超时, 4s之后抛出了读取异常
    ```
- 超时重试
    * 一般超时我们不会立即返回, 而会设置一个三次重连的机制
    ```python
        # fun1
        def gethtml(url):
            i = 0
            while i < 3:
                try:
                    html = requests.get(url, timeout=5).text
                    return html
                except requests.exceptions.RequestException:
                    i += 1
            return "try 3 also fail"
        url = 'http://127.0.0.1:5000/'
        gethtml(url)

        # func2
        import time
        import requests
        from requests.adapters import HTTPAdapter

        s = requests.Session()
        # max_retries 为最大重试次数, 重试3次, 加上最初的一次请求, 一共是4次
        s.mount('http://', HTTPAdapter(max_retries=3))
        s.mount('https://', HTTPAdapter(max_retries=3))

        print(time.strftime('%Y-%m-%d %H:%M:%S'))
        try:
            r = s.get('http://127.0.0.1:5000/', timeout=5)
            print(r.text)
        except requests.exceptions.RequestException as e:
            print(e)
            # HTTPConnectionPool(host='127.0.0.1', port=5000): Max retries exceeded with url: / (Caused by ReadTimeoutError("HTTPConnectionPool(host='127.0.0.1', port=5000): Read timed out. (read timeout=5)"))
        print(time.strftime('%Y-%m-%d %H:%M:%S'))

        # 输出结果
        # 2021-08-03 17:34:03
        # HTTPConnectionPool(host='127.0.0.1', port=5000): Max retries exceeded with url: / (Caused by ConnectTimeoutError(<urllib3.connection.HTTPConnection object at 0x0000000013269630>, 'Connection to 127.0.0.1 timed out. (connect timeout=5)'))
        # 2021-08-03 17:34:23

        # hello.py 部分代码
        # 生成一个随机数去sleep, 如果三次之内可以请求成功直接返回接口内容, 否则就返回try 3 also fail
        @app.route("/")
        def hello_world():
            index = random.sample(range(0, 20), 1)
            print(index[0])
            time.sleep(index[0])
            return "<p>Hello, World!</p>"
    ```

