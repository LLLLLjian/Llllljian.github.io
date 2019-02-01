---
title: Python_基础 (27)
date: 2019-01-14
tags: Python
toc: true
---

### 内建模块urllib
    Python3学习笔记
    urllib提供了一系列用于操作URL的功能

<!-- more -->

#### GET
- eg
    ```python
        from urllib import request

        with request.urlopen('https://api.douban.com/v2/book/2129650') as f:
            data = f.read()
            print('Status:', f.status, f.reason)
            for k, v in f.getheaders():
                print('%s: %s' % (k, v))
            print('Data:', data.decode('utf-8'))

        E:\llllljian\python>python demo1_0114.py
        Status: 200 OK
        Date: Tue, 14 Jan 2019 08:27:30 GMT
        Content-Type: application/json; charset=utf-8
        Content-Length: 2138
        Connection: close
        Vary: Accept-Encoding
        X-Ratelimit-Remaining2: 99
        X-Ratelimit-Limit2: 100
        Expires: Sun, 1 Jan 2006 01:00:00 GMT
        Pragma: no-cache
        Cache-Control: must-revalidate, no-cache, private
        Set-Cookie: bid=Nva97csX9YE; Expires=Wed, 14-Jan-20 08:27:30 GMT; Domain=.douban
        .com; Path=/
        X-DOUBAN-NEWBID: Nva97csX9YE
        X-DAE-Node: anson13
        X-DAE-App: book
        Server: dae
        X-Frame-Options: SAMEORIGIN
        Data: {"rating":{"max":10,"numRaters":16,"average":"7.4","min":0},"subtitle":"","author":["廖雪峰编著"],"pubdate":"2007-6",...}
    ```
- eg1
    ```python
        # 伪装成浏览器进行访问
        from urllib import request

        req = request.Request('https://www.douyu.com/78622')
        req.add_header('User-Agent', 'Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25')
        with request.urlopen(req) as f:
            print('Status:', f.status, f.reason)
            for k, v in f.getheaders():
                print('%s: %s' % (k, v))
            print('Data:', f.read().decode('utf-8'))
    ```

#### POST
- eg
    ```python
        from urllib import request, parse

        print('Login to weibo.cn...')
        email = input('Email: ')
        passwd = input('Password: ')
        login_data = parse.urlencode([
            ('username', email),
            ('password', passwd),
            ('entry', 'mweibo'),
            ('client_id', ''),
            ('savestate', '1'),
            ('ec', ''),
            ('pagerefer', 'https://passport.weibo.cn/signin/welcome?entry=mweibo&r=http%3A%2F%2Fm.weibo.cn%2F')
        ])

        req = request.Request('https://passport.weibo.cn/sso/login')
        req.add_header('Origin', 'https://passport.weibo.cn')
        req.add_header('User-Agent', 'Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25')
        req.add_header('Referer', 'https://passport.weibo.cn/signin/login?entry=mweibo&res=wel&wm=3349&r=http%3A%2F%2Fm.weibo.cn%2F')

        with request.urlopen(req, data=login_data.encode('utf-8')) as f:
            print('Status:', f.status, f.reason)
            for k, v in f.getheaders():
                print('%s: %s' % (k, v))
            print('Data:', f.read().decode('utf-8'))

        E:\llllljian\python>python demo3_0114.py
        Login to weibo.cn...
        Email: 2575710657@qq.com
        Password: 8023.ljy
        Status: 200 OK
        Server: nginx/1.6.1
        Date: Tue, 14 Jan 2019 08:35:08 GMT
        Content-Type: text/html
        Transfer-Encoding: chunked
        Connection: close
        Vary: Accept-Encoding
        Cache-Control: no-cache, must-revalidate
        Expires: Sat, 26 Jul 1997 05:00:00 GMT
        Pragma: no-cache
        Access-Control-Allow-Origin: https://passport.weibo.cn
        Access-Control-Allow-Credentials: true
        DPOOL_HEADER: lich107
        Set-Cookie: login=f656a41107fa6197509ed6d05b9390fd; Path=/
        Data: {"retcode":50011015,"msg":"\u7528\u6237\u540d\u6216\u5bc6\u7801\u9519\u8bef","data":{"username":"2575710657@qq.com","errline":656}
    ```
