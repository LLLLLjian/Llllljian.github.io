---
title: Interview_总结 (16)
date: 2019-02-26
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### web页面加载速度优化
- Q
    * 打开页面白屏10s才能显示,请进行优化排查
- A
    * 页面分析
        * 锁定耗费时间较长的请求
    * 优化图片
        * 合并小图片
        * 优化图片格式
    * 使用免费cdn加载第三方资源
    * 使用cdn储存静态资源
    * 合并压缩js css
    * 代码优化
        * HTML头部的JavaScript和写在HTML标签中的Style会阻塞页面的渲染
        * 按需加载,把统计. 分享等 js 在页面 onload 后再进行加载,可以提高访问速度
        * 优化cookie,减少cookie体积
        * 避免&lt;img>的src为空
        * 尽量避免设置图片大小,多次重设图片大小会引发图片的多次重绘,影响性能
        * 合理使用display属性
            a.display:inline后不应该再使用width. height. margin. padding以及float
            b.display:inline-block后不应该再使用float
            c.display:block后不应该再使用vertical-align
            d.display:table-*后不应该再使用margin或者float
        * 不滥用Float和web字体
        * 尽量使用CSS3动画
        * 使用ajax异步加载部分请求

#### PHP如何处理大流量高并发或者提高页面访问速度
1. 流量优化
    * 防盗链处理(去除恶意请求)
2. 前端优化
    1. 减少HTTP请求[将css,js等合并]
    2. 添加异步请求(先不将所有数据都展示给用户,用户触发某个事件,才会异步请求数据)
    3. 启用浏览器缓存和文件压缩
    4. CDN加速
    5. 建立独立的图片服务器(减少I/O)
3. 服务端优化
    1. 页面静态化
    2. 并发处理
    3. 队列处理
4. 数据库优化
    1. 数据库缓存
    2. 分库分表,分区
    3. 读写分离
    4. 负载均衡
5. web服务器优化
    1. nginx反向代理实现负载均衡
    2. lvs实现负载均衡

