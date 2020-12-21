---
title: Python_基础 (59)
date: 2020-12-09
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之requests.post

<!-- more -->

#### 方法定义
    ![request.post](/img/20201209_1.png)

#### 源码
    ![request.post](/img/20201209_2.png)

#### 常用返回信息
    ![request.post](/img/20201209_3.png)

#### post方法简单使用
1. 带数据的post
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        url = ''.join([host,endpoint])
        data = {'key1':'value1','key2':'value2'}
        
        r = requests.post(url,data=data)
        #response = r.json()
        print (r.text)
    ```
2. 带header的post
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        headers = {"User-Agent":"test request headers"}
        
        # r = requests.post(url)
        r = requests.post(url,headers=headers)
        #response = r.json()
    ```
3. 带json的post
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        data = {
            "sites": [
                        { "name":"test" , "url":"www.test.com" },
                        { "name":"google" , "url":"www.google.com" },
                        { "name":"weibo" , "url":"www.weibo.com" }
            ]
        }
        
        r = requests.post(url,json=data)
        # r = requests.post(url,data=json.dumps(data))
        response = r.json()
    ```
4. 带参数的post
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        params = {'key1':'params1','key2':'params2'}
        
        # r = requests.post(url)
        r = requests.post(url,params=params)
        #response = r.json()
        print (r.text)
    ```
5. 普通文件上传
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        #普通上传
        files = {
            'file':open('test.txt','rb')
        }
        
        r = requests.post(url,files=files)
        print (r.text)
    ```
6. 定制化文件上传
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        #自定义文件名，文件类型、请求头
        files = {
            'file':(
                'test.png',
                open('test.png','rb'),
                'image/png'
            )
        }
        
        r = requests.post(url,files=files)
        print (r.text)heman793
    ```
7. 多文件上传
    ```python
        # -*- coding:utf-8 -*-
        import requests
        import json
        
        host = "http://httpbin.org/"
        endpoint = "post"
        
        url = ''.join([host,endpoint])
        #多文件上传
        files = [
            ('file1',('test.txt',open('test.txt', 'rb'))),
            ('file2', ('test.png', open('test.png', 'rb')))
            ]
        
        r = requests.post(url,files=files)
        print (r.text)
    ```


