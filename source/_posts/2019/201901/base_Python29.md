---
title: Python_基础 (29)
date: 2019-01-16
tags: Python
toc: true
---

### 三方模块requests
    Python3学习笔记

<!-- more -->

#### 安装
- 通过pip安装
    ```bash
        sudo pip install requests
    ```

#### 发送请求
- eg
    ```python
        import requests

        rForGet = requests.get('https://api.github.com/events')
        rForPost = requests.post('http://httpbin.org/post', data = {'key':'value'})
        rForPut = requests.put('http://httpbin.org/put', data = {'key':'value'})
        rForDelete = requests.delete('http://httpbin.org/delete')
        rForHead = requests.head('http://httpbin.org/get')
        rForOptions = requests.options('http://httpbin.org/get')
    ```

#### 传递URL参数
- eg
    ```python
        import requests

        payload = {'key1': 'value1', 'key2': 'value2'}
        r = requests.get("http://httpbin.org/get", params=payload)

        # http://httpbin.org/get?key2=value2&key1=value1
        print(r.url)

        payload = {'key1': 'value1', 'key2': ['value2', 'value3']}
        r = requests.get('http://httpbin.org/get', params=payload)
        
        # http://httpbin.org/get?key1=value1&key2=value2&key2=value3
        print(r.url)
    ```

#### 设置请求头
- eg
    ```python
        url = 'https://api.github.com/some/endpoint'
        headers = {'user-agent': 'my-app/0.0.1'}
        r = requests.get(url, headers=headers)
    ```

#### 上传文件
- eg
    ```python
        url = 'http://httpbin.org/post'
        files = {'file': open('report.xls', 'rb')}
        r = requests.post(url, files=files)
    ```

#### 响应内容
- 状态响应码
    ```python
        import requests
        r = requests.get('http://httpbin.org/get')
        print(r.status_code)
    ```
- 响应头
    ```python
        import requests
        r = requests.get('https://api.github.com/events')
        print(r.headers)
    ```
- 普通文本
    ```python
        import requests
        r = requests.get('https://api.github.com/events')
        print(r.text)
    ```
- 二进制
    ```python
        import requests
        r = requests.get('https://api.github.com/events')
        print(r.content)
    ```
- JSON
    ```python
        import requests
        r = requests.get('https://api.github.com/events')
        print(r.json())
    ```
