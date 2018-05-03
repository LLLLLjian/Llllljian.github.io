---
title: jQuery_基础 (3)
date: 2018-01-18
tags: JQ
toc: true
---

## 关于事件

### 添加事件
-  基本用法
    * on("事件名", 响应函数)
    ```bash
        $("div").on("click", function(){
            console.log("这是点击事件");
        })
    ```
- 多个事件添加同一个函数
    * on("事件名 事件名", 响应函数)
    ```bash
        $("div").on("click mouseover", function(){
            console.log("这是点击事件");
        })
    ```
- 一次性添加多个事件的响应
    * on({"事件名1" : "响应函数1", "事件名2" : "响应函数2", "事件名n" : "响应函数n",})
    ```bash
        $("div").on({
            "click" : function() {console.log("click");},
            "mouseover" : function() {console.log("mouseover");},
            "mouseout" : function() {console.log("mouseout");}
        })
    ```

<!-- more -->

- 响应事件传参
    * 参数写在函数名的后面,用逗号分隔
    * 参数为对象或者数字
    ```bash
        $("div").on("click", {"key" : "value"}, function(event) {
            console.log(event.data);
        })
    ```
- 链式操作
    ```bash
        $("div").on("click", function() {console.log("click")})
                .on("mouseover", function() {console.log("mouseover")})
                .on("click", hand);
        function hand() {
            console.log("click2");
        }
    ```

### 移除事件
- 移除所有事件
    * off()
    * $("div").off();
- 移除某一事件
    * off(事件名)
    * $("div").off("click");
- 移除某一响应函数
    * off("事件名", 函数名)
    * $("div").off("click", hand);

### 绑定事件
- 绑定事件
    * bind("事件名", 相应函数)
- 移除绑定的所有事件
    * unbind()
- 移除绑定事件
    * unbind("事件名")

### 页面载入
- 方法
    * $(document).ready(function() {})
    * 页面加载完毕会触发
- 简写
    * $(function() {正文代码在此处添加})
- load事件和ready事件的区别
    * load事件是指页面中所有元素加载完毕之后就会触发(所有文件图片都下载完成)
    * ready是指DOM元素加载完毕之后就会触发(此时图片不一定加载完)

### 合成事件
- hover()
    * $("").hover(mouseover的事件函数, mouseout的事件函数)
    ```bash
        //mouseover和mouseout的合成
        $(function() {
            $("div").hover(function() {
                $(this).css("background-color", "red");
            }, function() {
                $(this).css("background-color", "green");
            })
        })
    ```

### 常见事件
    focus和blur是由内像外进行事件冒泡。focusin和focusout是由外像内进行捕获，所以当父元素添加了focusin和focusout时子元素也会触发聚焦或者失焦事件
- foucus
- foousout
    ```bash
        .input {
            display : none;
        }

        var rel = /^[a-z]\w{5, 20}$/i;

        $(function() {
            $("input").focus(function() {
                $(".input").css("display", "block");
            })

            $("input').focusout(function90 {
                $(".input").css("display", "none");

                var value = $("input").val();
                if(rel.test(i)) {
                    $("div").html("<span style='color:green'>输入正确</span>");
                } else {
                    $("div").html("<span style='color:red'>输入错误</span>");
                }
            })
        })
    ```

### toggle()
- 如果被选元素可见,则隐藏这些元素,否则显示这些元素
    ```bash
        <ul>
            <p>快速导航栏</p>
            <li>热卖商品</li><div class="div1"></div>
            <li>热卖商品</li><div class="div2"></div>
            <li>热卖商品</li><div class="div3"></div>
            <li>热卖商品</li><div class="div4"></div>
        </ul>

        $("li").click(function() {
            $(this).next("div").toggle(500);
            $(this).next("div").siblings("div").hide(400);
        })
    ```

### 添加元素样式
- addClass
    * 添加样式
- removeClass
    * 移除样式
- toggleClass
    * 有样式移除 没有样式添加
- hasClass
    * 判断元素是否有指定class,没有就返回false,有就返回true
```bash
    $("#b1").click(function () {
        $("div").addClass("c1");
    })

    $("#b2").click(function () {
        $("div").addClass("c2");
    })

    $("#b3").click(function () {
        $("div").removeClass("c2");
    })

    $("#b4").click(function () {
        $("div").removeClass("c1");
    })

    $("#b5").click(function () {
        $("div").toggleClass("c1");
    })

    console.log($("#div1").hasClass("c"));
```

### 事件对象
    event就是事件对象
    事件对象只需要获取,不需要创建,每触发一次事件,就会触发这个事件的所有信息
- 事件对象常用的属性和方法
    * stopPropagation()
        * 阻止冒泡
    * preventDafault()
        * 阻止所有默认行为
    * target
        * 触发事件的元素
    * which
        * 在鼠标事件中获取的鼠标的滚轮键
        * 在键盘事件中获取的是按下的键
    * type
        * 获取事件名

```bash 
    $("body").click(function() {
        console.log("body!");
        console.log(event.target);
        console.log(event.pageX, event.pageY);
    })

    $("body").mousedown(function(event) {
        console.log(event.which);
    })

    $(document).keydown(function(event) {
        console.log(event.which);
    })
```