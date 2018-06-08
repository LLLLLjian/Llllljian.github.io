---
title: JavaScript_基础 (7)
date: 2018-01-12
tags: JS
toc: true
---

## DOM基本操作

### DOM含义
    文档对象模型 （DOM）：处理网页内容的方法和接口
    Document Object Model
    DOM 是为了操作文档出现的 API,document 是其的一个对象；

### 获取节点
- document
    * getElementById
        * 语法 : document.getElementBId(元素ID)
        * 功能 : 通过元素ID获取节点
    * getElementsByName
        * 语法 : document.getElementsByName(元素name)
        * 功能 : 通过元素的name属性获取节点
    * getElementsByTagName
        * 语法 : document.getElementsByTagName(元素标签)
        * 功能 : 通过元素标签获取节点

<!-- more -->

- 节点指针
    * firstChild
        * 语法 : 父节点.firstChild
        * 功能 : 获取元素的首个子节点
    * lastChild
        * 语法 : 父节点.lastChild
        * 功能 : 获取元素的最后一个子节点
    * childNodes
        * 语法 : 父节点.childNodes
        * 功能 : 获取元素的子节点列表
    * previousSibling
        * 语法 : 兄弟节点.previousSibling
        * 功能 : 获取已知节点的前一个节点
    * nextSibling
        * 语法 : 兄弟节点.nextSibling
        * 功能 : 获取已知节点的后一个节点
    * parentNode
        * 语法 : 子节点.parentNode
        * 功能 : 获取已知节点的父节点

### 节点操作
- 创建节点
    * createElement
        * 语法 : document.createElement(元素标签)
        * 功能 : 创建元素节点
    * createAttribute
        * 语法 : document.createAttribute(元素属性)
        * 功能 : 创建属性节点
    * createTextNode
        * 语法 : document.createTextNode(文本内容)
        * 功能 : 创建文本节点
- 插入节点
    * appendChild
        * 语法 : appendChild(所添加的新节点)
        * 功能 : 向节点的子节点列表的末尾添加新的子节点
    * insertBefore
        * 语法 : insertBefore(所要添加的新节点,已知子节点)
        * 功能 : 在已知的子节点前插入一个新的子节点
- 替换节点
    * replaceChild
        * 语法 : replaceChild(要插入的新元素,将被替换成的老元素)
        * 功能 : 将某个子节点替换成另一个
- 复制节点
    * cloneNode 
        * 语法 : 需要被复制的节点.cloneNode(true/false)
        * 功能 : 创建指定节点的副本
        * 参数 : true-复制当前节点及其所有子节点;false-仅复制当前节点
- 删除节点
    * removeChild
        * 语法 : removeChild(要删除的节点)
        * 功能 : 删除指定的节点

### 属性操作
- 获取属性
    * getAttribute
        * 语法 : 元素节点.getAttribute(元素属性名) 
        * 功能 : 获取元素节点中指定属性的属性值
- 设置属性
    * setAttribute
        * 语法 : 元素节点.setAttribute(属性名, 属性值)
        * 功能 : 创建或改变元素节点的属性
- 删除属性
    * removeAttribute
        * 语法 : 元素节点.removeAttribute(属性名)
        * 功能 : 删除属性中的指定元素

### 文本操作
- insertData(offset, String)  : 从offset指定的位置插入string
- appendData(string) : 将string插入到文本节点的末尾处
- deleteData(offset, count) : 从offset起删除count个字符
- replaceData(off, count, string) : 从offset起将count个字符用string代替
- splitData(offset) : 从offset起将文本节点分成两个节点
- substring(offset, count) : 返回由offset起的count个节点

### DOM事件
    DOM同时两种事件模型：冒泡型事件和捕获型事件
    冒泡型 : 
        事件按照从最特定的事件目标到最不特定的事件目标的顺序触发
        触发的顺序是：div、body、html(IE 6.0和Mozilla 1.0)、document、window(Mozilla 1.0)
    捕获型 : 
        事件从最不精确的对象开始触发,然后到最精确
        触发的顺序是：document、div
- 事件处理函数/监听函数
    * JavaScript中 : obj.onclick = function(){ //onclick只能用小写 }
    * HTML中 : &lt;div onclick="javascript: alert("Clicked!")">&lt;/div> //onclick大小写任意
- 跨浏览器的事件处理程序
    * addHandler()
    * removeHandler()
- 事件类型
    * 鼠标事件：click、dbclick、mousedown、mouseup、mouseover、mouseout、mousemove
    * 键盘事件：keydown、keypress、keyup
    * HTML事件：load、unload、abort、error、select、change、submit、reset、resize、scroll、focus、blur
- 事件处理器
    * 执行JavaScript 代码的程序在事件发生时会对事件做出响应.为了响应一个特定事件而被执行的代码称为事件处理器.
    * 在HTML标签中使用事件处理器的语法是：<HTML标签 事件处理器="JavaScript代码''>
- 事件处理程序
    * 事件就是用户或浏览器自身执行的某种动作.比如click,mouseup,keydown,mouseover等都是事件的名字.而响应某个事件的函数就叫事件处理程序（事件监听器）,
    * 事件处理程序以on开头,因此click的事件处理程序就是onclick