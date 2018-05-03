---
title: JavaScript_基础 (8)
date: 2018-01-15
tags: JS
toc: true
---

## BOM基本操作

### BOM含义
    浏览器对象模型（BOM）：与浏览器交互的方法和接口
    Browser Object Model
    BOM 是为了操作浏览器出现的 API，window 是其的一个对象。

<!-- more -->

### Window对象
    Window 对象是 JavaScript层级中的顶层对象。
    Window 对象代表一个浏览器窗口或一个框架。
    Window 对象会在 <body>或<frameset>每次出现时被自动创建。
- 对象属性
    * window //窗户自身, window=window.self可使用全局属性window访问　Window对象
    * document 对 Document 对象的只读引用。请参阅Document对象。
    * history 对 History 对象的只读引用。请参数History对象。
    * location 用于窗口或框架的 Location 对象。请参阅Location对象。
    * screen 对 Screen 对象的只读引用。请参数Screen对象。
    * navigator 对 Navigator 对象的只读引用。请参数Navigator对象。
    * defaultStatus 设置或返回窗口状态栏中的默认文本。
    * innerheight 返回窗口的文档显示区的高度。
    * innerwidth 返回窗口的文档显示区的宽度。
    * outerheight 返回窗口的外部高度。
    * outerwidth 返回窗口的外部宽度。
    * pageXOffset 设置或返回当前页面相对于窗口显示区左上角的 X 位置。
    * pageYOffset 设置或返回当前页面相对于窗口显示区左上角的 Y 位置。
    * name 设置或返回窗口的名称。
    * parent 返回父窗口。
    * top 返回最顶层的先辈窗口。
    * status 设置窗口状态栏的文本。
    * window.location //URL地址，配备布置这个属性可以打开新的页面
- 对象方法
    * window.close(); //关闭窗口
    * window.alert("message"); //弹出一个具有OK按钮的系统消息框，显示指定的文本
    * window.confirm("Are you sure?"); //弹出一个具有OK和Cancel按钮的询问对话框，返回一个布尔值
    * window.prompt("What's your name?", "Default"); //提示用户输入信息，接受两个参数，即要显示给用户的文本和文本框中的默认值，将文本框中的值作为函数值返回
    * window.status //可以使状态栏的文本暂时改变
    * window.defaultStatus //默认的状态栏信息，可在用户离开当前页面前一直改变文本
    * window.setTimeout("alert('xxx')", 1000); //设置在指定的毫秒数后执行指定的代码，接受2个参数，要执行的代码和等待的毫秒数
    * window.clearTimeout("ID"); //取消还未执行的暂停，将暂停ID传递给它
    * window.setInterval(function, 1000); //无限次地每隔指定的时间段重复一次指定的代码，参数同setTimeout()一样
    * window.clearInterval("ID"); //取消时间间隔，将间隔ID传递给它
    * window.history.go(-1); //访问浏览器窗口的历史，负数为后退，正数为前进
    * window.history.back(); //同上
    * window.history.forward(); //同上
    * window.history.length //可以查看历史中的页面数  
    * clearInterval() 取消由 setInterval() 设置的timeout。
    * clearTimeout() 取消由 setTimeout() 方法设置的timeout。
    * createPopup() 创建一个 pop-up 窗口。
    * moveBy() 可相对窗口的当前坐标把它移动指定的像素。
    * moveTo() 把窗口的左上角移动到一个指定的坐标。
    * open() 打开一个新的浏览器窗口或查找一个已命名的窗口。
    * print() 打印当前窗口的内容。
    * resizeBy() 按照指定的像素调整窗口的大小。
    * resizeTo() 把窗口的大小调整到指定的宽度和高度。
    * scrollBy() 按照指定的像素值来滚动内容。
    * scrollTo() 把内容滚动到指定的坐标。
    * setInterval() 按照指定的周期（以毫秒计）来调用函数或计算表达式。
    * setTimeout(方法,秒数) 在指定的毫秒数后调用函数或计算表达式。　
    * timeOutEvent = setTimeout("longPress('" + obj + "')",1500);定时器传参数
- 成员对象
    * window.event
    * window.document //见document对象详解
    * window.history
    * window.screen
    * window.navigator
    * Window.external

### history历史对象
- length ：返回浏览过的页面数
- back() : 返回前一个URL
- forward() : 返回下一个URL
- go(i) : 返回某个具体的页面

### screen显示器对象
- width : 返回屏幕的像素宽度
- height : 返回屏幕的像素高度
- colorDepth : 返回屏幕颜色的位数
- availWidth : 返回显示屏幕可用宽度(除去任务栏的高度)
- availHeight : 返回显示屏幕可用高度(除去任务栏的高度)

### external对象
- window.external.AddFavorite("地址","标题" ) //把网站新增到保藏夹

### navigator导航器对象
- appCodeName : 返回浏览器代码名
- appName : 返回浏览器的名称
- platform : 返回运行浏览器的操作系统平台
- appVersion : 返回浏览器的平台和版本信息
- userAgent : 返回由客户机发送服务器的user-agent头部的值
- cookieEnabled : 返回指明浏览器中是否启用cookie的布尔值

### location位置对象
- 属性 
    * hash : 设置或返回从#开始的URl
    * host : 设置或返回主机名和当前URL的端口号
    * hostname : 设置或返回当前URL的主机名
    * href : 设置或返回完整的URL
    * pathname : 设置或返回当前URL的路径部分
    * port : 设置或返回当前url的端口号
    * protocol : 设置或返回当前URL的协议
    * search : 设置或返回从?开始的url
- 方法
    * assign(URL) : 加载新的文档
    * reload() : 重新加载当前页面
    * replace(newURL) 用新的文档替换之前文档

### document文档对象
- 集合
    * anchors[] : 描点对象数组
    * images[] : 图片对象数组
    * links[] : 连接对象数组
    * forms[] : 表单对象数组
- 属性
    * cookie : 设置和返回与当前文档有关的所有cookie
    * domain : 返回当前文档的域名
    * referrer : 返回载入当前文档的URL
    * title : 返回当前文档的标题
    * URL : 返回当前文档的URL
- 方法
    * open() : 打开一个新的文档,并擦除旧文档内容
    * close() : 关闭文档输出流
    * write() : 向当前文档追加写入文档
    * writein() : 与write()相同,在&lt;pre>中会追加换行

### 窗口控制
- moveBy
    * 语法 : moveBy(水平位移量, 垂直位移量)
    * 功能 : 按照给定像素参数移动指定窗口
- moveTo
    * 语法 : moveTo(x, y)
    * 功能 : 将窗口移动到指定的坐标(x, y)处
- resizeBy
    * 语法 : resizeBy(水平, 垂直)
    * 功能 : 将当前窗口改变指定的大小(x, y),当xy的值大于0时为扩大,小于0时为缩小
- resizeTo
    * 语法 : resizeTo(水平宽度, 垂直宽度)
    * 功能 : 将当前窗口改变成(x, y)大小,x、y分别为宽度和高度
- scrollBy
    * 语法 : scrollBy(水平位移量, 垂直位移量)
    * 功能 : 将窗口中的内容按给定的位移量滚动,参数为正数时,正向滚动,否则反向滚动
- scrollTo
    * 语法 : scrollTo(x, y)
    * 功能 : 将窗口中的内容滚动到指定位置

### 焦点控制
- focus() : 得到焦点
- blur() : 失去焦点

### 打开关闭窗口
- open
    * 语法 : open("URL", 窗口名称, 窗口风格)
    * 功能 : 打开一个新的窗口,并在窗口中装载指定URL地址的网页
    * 窗口风格
        * height : 数值,窗口高度,不能小于100
        * width : 数值,窗口宽度,不能小于100
        * left : 数值,窗口左坐标,不能为负值
        * top : 数值,窗口上坐标,不能为负值
        * location : yes/no,是否展示地址栏
        * menubar : yes/no,是否展示菜单栏
        * resizable : yes/no,是否可以改变窗口大小
        * scrollbars : yes/no,是否允许出现滚动条
        * status : yes/no,是否显示状态栏
        * toolbar : yes/no,是否显示工具栏
- close
    * 语法 : close()
    * 功能 : 自动关闭浏览器窗口

### 定时器
- setTimeout
    * 语法 : setTimeout(执行代码, 毫秒数)
    * 功能 : 当到了指定的毫秒数后,自动执行代码功能
- clearTimeout
    * 语法 : clearTimeout()
    * 功能 : 取消由serTimeout()设置的定时器
- setInterval
    * 语法 : setInterval()
    * 功能 : 按指定周期重复执行代码功能
- clearInter
    * 语法 : clearInter(时间间隔器)
    * 功能 : 取消由setInterval()设置的时间间隔器

### 对话框
- alert 
    * 语法 : alert("提示字符串")
    * 功能 : 弹出一个警告框,在警告框内显示提示字符串文本
- confirm 
    * 语法 : confirm("提示字符串") 
    * 功能 : 显示一个确认框,在确认框内显示提示字符串,当用户单击确定时该方法返回true,单击取消返回false
- prompt
    * 语法 : prompt("提示字符串", 缺省文本)
    * 功能 : 显示一个输入框,在输入框内显示提示字符串,在输入文本框显示缺省文本,并等待用户输入,当用户单击确定时,返回用户输入的字符串,当单击取消时,返回null 

### 属性
- 状态栏
    * defaultStatus : 改变浏览器状态栏的默认显示
    * status : 临时改变浏览器状态栏的显示
- 窗口位置
    * IE
        * screenLeft : 声明窗口的左上角的X坐标
        * screenTop : 声明窗口的左上角的Y坐标
        * document.body.scrollLeft/document.documentElement.scrollLeft : 声明当前文档向右滚动过的像素数
        * document.body.scrollTop/document.documentElement.scrollTop : 声明当前文档向下滚动过的像素数
    * !IE
        * screenX : 声明窗口的左上角的X坐标
        * screenY : 声明窗口的左上角的Y坐标
        * pageXOffset : 声明当前文档向右滚动过的像素数
        * pageYOffset : 声明当前文档向下滚动过的像素数
    * FF
        * innerHeight : 返回窗口的文档显示区的高度
        * innerWidth : 返回窗口的文档显示区的宽度
        * outerHeight : 返回窗口的外部高度
        * outerWidth : 返回窗口的外部宽度

### 其他属性
- opener : 可以实现同域名下跨窗体之间的通讯,一个窗体要包含另一个窗体的opener
- closed : 当前窗口关闭时返回true
- name : 设置或返回窗口的名称
- self : 返回对当前窗口的引用