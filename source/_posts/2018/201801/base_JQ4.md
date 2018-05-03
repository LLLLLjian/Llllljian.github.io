---
title: jQuery_基础 (4)
date: 2018-01-19
tags: JQ
toc: true
---

## 自定义事件和内置动画

### 触发事件
- .trigger("事件名")
    * 在每一个匹配的元素上触发某类事件
    ```bash
        $("button").trigger("click");
        $("input").trigger("focus");
    ```

<!-- more -->

### 自定义事件
- 必须通过on bind绑定
- 通过trigger()触发函数
```bash
    $("div").on("slideup", function() {
        $(this).html("上滑");
    })
            .on("slidedown", function() {
        $(this).html("下滑");
    })
            .on("slideleftt", function() {
        $(this).html("左滑");
    })
            .on("slideright", function() {
        $(this).html("右滑");
    })

    var startX;
    var startY;
    var endX;
    var endY;

    $("div").on("mousedown", function() {
        startX = event.pageX;
        startY = event.pageY;
    })

    $("div").on("mouseup", function(event) {
        endX = event.pageX;
        endY = event.pageY;

        if(endY < startY - 50 && Math.abs(endX - startX) < 50) {
            $(this).trigger("slideup");
        }

        if(endY > startY + 50 && Math.abs(endX - startX) < 50) {
            $(this).trigger("slidedown");
        }

        if(endX < startX - 50 && Math.abs(endY - startY) < 50) {
            $(this).trigger("slideleftt");
        }

        if(endX > startX - 50 && Math.abs(endY - startY) < 50) {
            $(this).trigger("slideright");
        }
    })
```
### 事件委托
    是叫事件代理,利用事件冒泡给父元素添加事件处理程序从而使所有子元素都可以处理该事件
- 优点1
    * 减少DOM操作,提高交互效率
- 优点2
    * 新添加的子元素同样可以相应事件
- 优点3
    * 如果所有的子元素要求实现同样的效果,这个时候可以考虑添加到父元素,让父元素代替子元素去响应事件
```bash
    $("table").click(function(e) {
        $(e.target).not("tbody,tr,table").css("background-color", "red");
    })
```

### jQuery自带事件
- show()
    * 让元素显示,相当于.css("display", "block")
- hide(slow|normal|num)
    * 让元素隐藏,相当于.css("display", "none")
```bash
    $("button:eq(0)").click(function() {
        if($("div").css("display") == 'none') {
            $("div").show(1000);
        } else {
            $("div").hide(1000);
        }
    })
```
- fadeIn(slow|normal|num)
- fadeOut()
- fadeTOggle()
    * 通过不透明度的变化来开关所有匹配元素的淡入淡出效果,并在动画完成之后可选的触发一个回调函数
```bash
    $("button:eq(0)").click(function() {
        if($("div").css("display") == 'none') {
            $("div").fadeIn(1000);
        } else {
            $("div").fadeOut(1000);
        }
    })
```
- slideDown(slow|normal|num)
- slideUp()
- slideToggle()
    * 通过高度变化来切换所有匹配元素的可见性,并在切换完成后可选地触发一个回调函数

### 自定义动画
    $("div").animate(最终状态, 执行时间, 回调函数)
- 顺序执行
    ```bash
        $("div").animate({"left" : "500px"}, 2000, function() {console.log("over");});
        $("div").animate({"top" : "500px"}, 2000, function() {console.log("down");});
    ```

- 同时执行 
    ```bash
        $("div").animate({"top" : "500px", "left" : "500px"}, 2000});
    ```

- 累加动画
    * delay(时间)延迟
    ```bash 
        $("div").delay(2000).animate({"left" : "+=500"}, 2000);
    ```

- 延迟动画
    * delay(时间)延迟
    ```bash
        $("div").delay(2000).animate({"left" : "+=500"}, 2000);
    ```

- 停止动画
    * stop(是否清空动画队列, 是否显示最终效果)
    ```bash
        $("div").hover(function() {
            $(this).stop(true);
            $(this).animate({"width" : "400px"}, 1000);
                   .animate({"height" : "400px"}, 1000);
        }, function() {
            $(this).stop(true);//停止动画
            $(this).animate({"width" : "200px"}, 1000);
                   .animate({"height" : "200px"}, 1000);
        })
    ```