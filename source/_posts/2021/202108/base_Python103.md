---
title: Python_基础 (103)
date: 2021-08-02
tags: Python
toc: true
---

### 快来跟我一起学requests
    主要看一下requests.cookies、requests.session

<!-- more -->

#### cookies
- demo
    ```python
        # 让cookie只作用于单个请求
        import requests

        s = requests.session()
        # 第一步: 发送一个请求, 用于设置请求中的cookies
        cookies = dict(cookies_are='cookie1')
        # tips: http://httpbin.org能够用于测试http请求和响应
        r1 = s.get(url='http://httpbin.org/cookies', cookies=cookies, headers=headers)
        print(r1.text)
        # 第二步: 发送一个请求, 用于再次设置请求中的cookies
        cookies = dict(cookies_are='cookie2')
        r2 = s.get(url='http://httpbin.org/cookies', cookies=cookies)
        print(r2.text)

        # 输出结果
        # r1.text
        # {
        #   "cookies": {
        #     "cookies_are": "cookie1"
        #   }
        # }
        # t2.text
        # {
        #   "cookies": {
        #     "cookies_are": "cookie2"
        #   }
        # }
    ```
- demo1
    ```python
        # 跨域时保持cookie
        import requests

        s = requests.session()
        s.cookies.update({'cookies_are': 'cookie'})
        r = s.get(url='http://httpbin.org/cookies')
        print(r.text)
    ```
- demo2
    ```python
        # 除了直接用字典去赋值cookie之外, requests还提供了RequestsCookieJar对象供我们使用, 它的行为类似字典, 但接口更为完整, 适合跨域名跨路径使用
        import requests
        jar = requests.cookies.RequestsCookieJar()
        jar.set('tasty_cookie', 'yum', domain='httpbin.org', path='/cookies')
        jar.set('gross_cookie', 'blech', domain='httpbin.org', path='/elsewhere')
        url = 'http://httpbin.org/cookies'
        r = requests.get(url, cookies=jar)
        print(r.text)

        # 输出结果
        # {
        #     "cookies": {
        #         "tasty_cookie": "yum"
        #     }
        # }
    ```

#### session
- demo
    ```python
        import requests

        s = requests.Session()
        s.headers.update({'x-test': 'true'})
        # both 'x-test' and 'x-test2' are sent
        r1 = s.get('http://httpbin.org/headers', headers={'x-test2': 'true'})
        print(r1.text)
        # 'x-test' is sent
        r2 = s.get('http://httpbin.org/headers')
        print(r2.text)

        # 输出结果
        # # r1.text
        # {
        #     "headers": {
        #         "Accept": "*/*", 
        #         "Accept-Encoding": "gzip, deflate", 
        #         "Host": "httpbin.org", 
        #         "User-Agent": "python-requests/2.22.0", 
        #         "X-Amzn-Trace-Id": "Root=1-5e91656f-b99f14a4d6f47f9e55a90bb4", 
        #         "X-Test": "true", 
        #         "X-Test2": "true"
        #     }
        # }
        # # r2.text
        # {
        #     "headers": {
        #         "Accept": "*/*", 
        #         "Accept-Encoding": "gzip, deflate", 
        #         "Host": "httpbin.org", 
        #         "User-Agent": "python-requests/2.22.0", 
        #         "X-Amzn-Trace-Id": "Root=1-5e91656f-e9741db4c2ca2fd6e0628396", 
        #         "X-Test": "true"
        #     }
        # }
    ```


