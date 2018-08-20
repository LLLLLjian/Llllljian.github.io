---
title: Interview_总结 (4)
date: 2018-08-16
tags: Interview
toc: true
---

### 高并发与大数据
    学习笔记总结

<!-- more -->

#### web资源防盗链
- 盗链是什么？ 为什么要防？
    * 在自己页面上显示一些不是自己服务器的资源(图片、音频、视频、css、js等)
    * 由于别人盗链你的资源会加重你的服务器负担，所以我们需要防止
    * 可能会影响统计
- 防盗链是什么
    * 防止别人通过一些技术手段绕过本站的资源展示页，盗用本站资源，让绕开本站资源展示页面的资源链接失效
    * 大大减轻服务器压力
- 有哪几种方式
    * Referer (易伪造referer,安全性低)
    * 加密签名 （安全性高)
- 防盗链的工作原理
    * 通过Referer，服务器可以检测到访问目标资源的来源网站，如果是资源文件，则可以跟踪到显示它的网页地址.一旦检测到来源网站不是本站进行阻止
    * 通过签名，根据计算签名的方式，判断请求是否合法，如果合法则显示，否则返回错误信息
- Referer实现
    ```bash
        location ~* \.(gif|jpg|png|webp)$ {
            valid_referers none blocked domain.com *.domain.com ;
            if ($invalid_referer) {
                    return 403;
                    #rewrite ^/ http://www.domain.com/403.jpg;
            }
        }
    ```
- 加密签名
    ```bash
        location ~* \.(gif|jpg|png|webp)$ {
            accesskey on;
            accesskey_hashmethod md5;
            accesskey_arg key;
            accesskey_signature "mysrc$remote_addr";
        }
    ```

#### 动态语言静态化
- 适用场景
    * 对实时性要求不高的页面
- 为什么要使用静态化
    * 解决高并发，减轻Web服务器和数据库服务器压力
- 静态化实现方式有几种
    * 使用Smarty模板引擎
    * 使用ob系列函数


