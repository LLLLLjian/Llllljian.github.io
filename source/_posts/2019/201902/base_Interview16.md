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
        * 按需加载,把统计、分享等 js 在页面 onload 后再进行加载,可以提高访问速度
        * 优化cookie,减少cookie体积
        * 避免&lt;img>的src为空
        * 尽量避免设置图片大小,多次重设图片大小会引发图片的多次重绘,影响性能
        * 合理使用display属性
            a.display:inline后不应该再使用width、height、margin、padding以及float
            b.display:inline-block后不应该再使用float
            c.display:block后不应该再使用vertical-align
            d.display:table-*后不应该再使用margin或者float
        * 不滥用Float和web字体
        * 尽量使用CSS3动画
        * 使用ajax异步加载部分请求

