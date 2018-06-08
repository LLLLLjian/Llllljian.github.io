---
title: jQuery_基础 (5)
date: 2018-01-22
tags: JQ
toc: true
---

## jQuery AJAX

### load
    经常用于加载一段代码
- $obj.load(url)
    * url : 指的是服务器的一个html文件的路径
    * 功能 : 向服务器请求一段html代码加载到(appendTO) $obj
- $obj.load(url, 回调函数)
    * url : 指的是服务器的一个html文件的路径
    * 回调函数 : 可以在数据加载完毕之后进行的一些处理

<!-- more -->

```javascript
    $("button").click(function() {
        $("#cont").load("xi.html", function() {
            $("li").css("background-color", "red");
        })
    })
```

### $.get
    全局函数
- $.get(URL, [data], [fn], [dataType])
    * 以get的方式向服务器请求数据
- 参数
    * 参数1 : url : 请求文件的地址
    * 参数2 : data : 请求参数
    * 参数3 : fn : 回调函数
    * 参数4 : dataType : 文件类型(html|xml|json|script|text)
- 公式
    * 注意 textStatus的三种状态
        * success 成功
        * error 失败
        * not found 没有找到
        * notModified 没有修改
    ```javascript
        $.get("fan.txt", function(data, textStatus, fn) {
            if(textStatus == 'success') {
                console.log(data);
            }
        }, "text")
    ```
- 例子
```javascript
    $("button").click(function() {
        $.get("get_html.php", {
            'username' : $("#name").val,
            'content' : $("#cont").val
        }, function(data, textStatus, fn) {
            if(textStatus == 'success') {
                $(data).appendTo("#msg");
            }
        }, "html")
    })
```

### $.post
- $.post(url, data, fn, dataType)
    * 以post的方式请求数据
- 参数
    * 参数1 : url : 请求文件的地址
    * 参数2 : data : 请求参数
    * 参数3 : fn : 回调函数
    * 参数4 : dataType : 文件类型(html|xml|json|script|text)
- 例子
```javascript
    $("button").click(function() {
        $.post("get_html.php", {
            'username' : $("#name").val,
            'content' : $("#cont").val
        }, function(data, textStatus, fn) {
            if(textStatus == 'success') {
                $("<p>" + data.username + "</p>").appendTo("#msg");
                $("<p>" + data.content + "</p>").appendTo("#msg");
            }
        }, "json")
    })
```

### get与post区别
- 安全性
    * post安全性高于get
    * get方式请求,请求参数会拼接到url后边,安全性低
    * post方式请求,请求参数包裹在请求体中安全性更高
- 数量区别
    * get方式传输的数据量小,规定不能超过2kb,post方式请求数据量大,没有限制

### $.getScript()
- $.getScript(url ,fn)
    * 向服务器请求脚本文件
- 参数
    * 参数1 : url : 地址 
    * 参数2 : fn : 回调函数(脚本文件加载完毕之后会调用)
- 例子
```javascript
    $("button").click(function() {
        $.getScript("basejs.js", function() {
            $(this).css("background-color", randomColor());
        })
    })
```

### $.getJson()
- $.getJson("url", data, fn)
    * 请求json数据
- 原生js的json跨域请求
    * 创建script标签,并将其添加到body中
    * 请求数据
    ```javascript
        var sc = document.getElement("script");
        sc.setAttribute("type", "text/javascripts");
        sc.src = "http://localhost/jsonp.php?jsoncallback=callBack";
        document.body.appendChild(sc);

        function callBack(data) {
            console.log(data);
        }
    ```
- jQuery的json请求
```javascript
    $.getJson("http://localhost/jsonp.php?jsoncallback=?", function(data) {
        console.log(data);ss
    })
```

### $.ajax({字面量对象})
    jQuery底层AJAX实现
- 对象内容
    * url : 请求地址
    * type : get|post|put|delete 默认是get
    * data : 请求参数{"id" : "123", "pwq" : "123456"}
    * dataType : 请求数据类型 html|text|json|xml|script|jsonp
    * success : function(data, dataTextStatus, jqxhr) {}
    * error : function(jqxhr, textStatus, error) {}
- 例子
```javascript
    $.ajax({
        url : "demo.php",
        type : "post",
        data : {"username" : "1", "password" : "2"},
        dataType : "json",
        success : function(data, textStatus, jqxhr) {
            console.log("__成功__");
            console.log(data);
            console.log(textStatus);
            console.log(jqxhr);
            console.log("____");
        },
        error : function(data, textStatus, jqxhr) {
            console.log("__失败__");
            console.log(data);
            console.log(textStatus);
            console.log(jqxhr);
            console.log("******");
        }
    })
```