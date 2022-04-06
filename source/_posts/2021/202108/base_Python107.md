---
title: Python_基础 (107)
date: 2021-08-06
tags: Python
toc: true
---

### 快来跟我一起学requests
    主要看一下requests重试实践

<!-- more -->

#### 基础版
> 只有重试功能
- code
    ```python
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
    ```

#### 增强版
> 从urllib3的Retry进行修改

[Retry源码](https://urllib3.readthedocs.io/en/latest/reference/urllib3.util.html#urllib3.util.retry.Retry)

- code
    ```python
        def retry_session():
            session = requests.Session()
            retry = Retry(
                # 允许的重试总数
                total=24,
                # 要重试的连接相关错误数
                connect=24,
                # 读取错误时重试的次数
                read=5,
                # 如果出现重试, 请求之间的时间间隔[0.3*2^0, 0.3*2^1, 0.3*2^2, ....]
                # # 重试算法,  _observed_erros就是第几次重试, 每次失败这个值就+1.
                # backoff_factor = 0.1, 重试的间隔为[0.1, 0.2, 0.4, 0.8, ..., BACKOFF_MAX(120)]
                # backoff_value = self.backoff_factor * (2 ** (self._observed_errors - 1))
                # return min(self.BACKOFF_MAX, backoff_value)
                backoff_factor=0.3,
                # 应该强制重试的一组整数HTTP状态代码. 如果请求方法位于allowed_methods中且响应状态代码位于status_forcelist中, 则会启动重试
                status_forcelist=(500, 502, 504),
                # 一组大写的HTTP方法动词, 应该重试的请求类型
                method_whitelist=('GET', 'POST'),
            )
            adapter = HTTPAdapter(max_retries=retry)
            session.mount('http://', adapter)
            session.mount('https://', adapter)
            return session
    ```
- code1
    ```python
        import requests
        from requests.adapters import HTTPAdapter
        from requests.packages.urllib3.util.retry import Retry
        session = requests.Session()
        retries = Retry(
            total=3,
            # [2, 4, 8]
            backoff_factor=2,
            # [3, 6, 12]
            # backoff_factor=3,
            status_forcelist=[429],
            method_whitelist=["GET", "POST", "PUT", "DELETE"])
        session.mount('http://', HTTPAdapter(max_retries=retries))

        print(time.strftime('%Y-%m-%d %H:%M:%S'))
        try:
            r = session.get('http://127.0.0.1:5000/', timeout=5)
            print(r.text)
        except requests.exceptions.RequestException as e:
            print(e)
        print(time.strftime('%Y-%m-%d %H:%M:%S'))
        # 32 = 5 + 5 + 4 + 5 + 8 + 5
        # 开始时间 2021-08-06 22:28:54
        # 第一次请求时间 2021-08-06 22:28:54 第一次请求5s超时
        # 第二次请求时间 2021-08-06 22:28:59 第二次请求5s超时 2*2**(2-1)
        # 第三次请求时间 2021-08-06 22:29:08 第三次请求5s超时 2*2**(3-1)
        # 第三次请求时间 2021-08-06 22:29:21 第四次请求5s超时
        # 抛出异常 结束时间: 2021-08-06 22:29:26

        # 如果backoff_factor=3
        # 38  = 5 + 5 + 6 + 5 + 12 + 5
    ```





