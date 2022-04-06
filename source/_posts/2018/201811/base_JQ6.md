---
title: jQuery_基础 (5)
date: 2018-11-22
tags: JQ
toc: true
---

## jQuery Cookie
    jQuery之cookie操作,通过jQuery让客户端可以存取客户数据的一种技术

<!-- more -->

#### 下载与引入
    jquery.cookie.js基于jquery;先引入jquery,再引入jquery.cookie.js
- 下载地址
    * http://plugins.jquery.com/cookie/
- eg
    ```javascript
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.cookie.js"></script>
    ```

#### 添加cookie
- 添加一个"会话cookie"
    ```javascript
        // 这里没有指明 cookie有效时间,所创建的cookie有效期默认到用户关闭浏览器为止,所以被称为 “会话cookie(session cookie)”.
        $.cookie('the_cookie', 'the_value');
    ```
- 创建一个cookie并设置有效时间为7天
    ```javascript
        // 注意单位是: 天
        $.cookie('the_cookie', 'the_value', { expires: 7 });
    ```
- 创建一个cookie并设置cookie的有效路径
    ```javascript
        // 在默认情况下,只有设置 cookie的网页才能读取该 cookie.如果想让一个页面读取另一个页面设置的cookie,必须设置cookie的路径.cookie的路径用于设置能够读取 cookie的顶级目录.将这个路径设置为网站的根目录,可以让所有网页都能互相读取 cookie (一般不要这样设置,防止出现冲突).
        $.cookie('the_cookie', 'the_value', { expires: 7, path: '/' });
    ```

#### 读取cookie
    ```javascript
        $.cookie('the_cookie');
    ```

#### 删除cookie
    ```javascript
        // 通过传递null作为cookie的值即可
        $.cookie('the_cookie', null);
    ```

#### 可选参数
- expires
    * Number|Date
    * 有效期
    * 设置一个整数时,单位是天
    * 也可以设置一个日期对象作为Cookie的过期日期；
- path
    * String
    * 创建该Cookie的页面路径；
- domain
    * String
    * 创建该Cookie的页面域名；
- secure
    * Booblean
    * 如果设为true,那么此Cookie的传输会要求一个安全协议,例如: HTTPS；
- eg
    ```javascript
        $.cookie('the_cookie','the_value',{
            expires:7,  
            path:'/',
            domain:'jquery.com',
            secure:true
        })
    ```
