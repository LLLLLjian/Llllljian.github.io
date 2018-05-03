---
title: jQuery_基础 (1)
date: 2018-01-16
tags: JQ
toc: true
---

## 选择器

### 注意
- DOM对象 : 通过原生js获取的是DOM对象(DOM树上的节点就是DOM对象)
- jQuery对象 : 通过jQuery选择器获得的是jQuery对象
- jQuery对象只能使用jQuery中封装的方法,不能使用DOM对象的方法
- DOM对象只能使用DOM的方法不能使用jQuery中封装的方法

<!-- more -->

### 选择器相互转化
- DOM对象转换成JQ对象
    * $(DOM对象)
- JQ对象转换成DOM对象
    * jQuery对象[index]
    * jQuery对象.get(index)

### 基本选择器
- #id : $("#id名")
- .class : $(".class名")
- element : $("标签名")
- 群组选择器 : $("选择器1, 选择器2")
- \* : $("*")

### 后代选择器
- $("#list li")

### 子元素选择器
- $("#list>li")

### 紧邻的同辈选择器
- 忽略空白文本节点
    * $("#first+")
    * $("#first++")
    * $("#first+++")

### 相邻的后面的同辈选择器
- $("#first~")
- ~后面加标签名.可以获取到相邻的后面的所有此标签名的同辈选择器

### 表单元素选择器
- :input 获取表单中所有的input select textarea元素 //注意:前面一定要加空格 
    * $("#f1 :input")
- :text获取单行输入框
    * $("#f1 :text")
- :password
    * $("#f1 :password")
- :radio
    * $("#f1 :radio")
- :checkbox
    * $("#f1 :checkbox")
- :file
    * $("#f1 :file")
- :image
    * $("#f1 :image")
- :hidden
    * $("#f1 :hidden")
- :submit
    * $("#f1 :submit")
- :reset
    * $("#f1 :reset")
- :button
    * $("#f1 :button")

### 过滤选择器
    注意 : 过滤选择器要和其它选择器搭配使用
    接班过滤选择器 : 根据下标来过滤
- :first
    * 在匹配的所有li的集合中选取第一个元素
    * $("li:first")
- :last
    * 在匹配的所有li的集合中选取最后一个元素
    * $("li:last")
- :eq
    * 下标从0开始
    * $("li:eq(1)")
- :gt
    * 下标大于index
    * $("li:gt(1)")
- :lt
    * 下标小于index
    * $("li:lt(1)")
- :odd
    * 奇数
    * $("li:odd")
- :even
    * 偶数
    * $("li:even")
- :not
    * (指定选择器) 去除与指定选择器匹配的元素
    * $("li:not(#li2)")
- :header
    * 获取到标题元素的结合
    * $(":header").css("backgroundColor", "red")
- :animated
    * 匹配正在执行动画的元素

### 内容过滤选择器
- :contains(指定文本值)
    * 查找所有的包含指定文本值的元素
    * 查找出页面中所有包含"招聘"二字的div,把招聘高亮显示
    ```bash
        var num = $("div:contains(招聘)");
        for (var i = 0; i < num.length; i++>) {
            var div = num[i];
            div.innerHTML = div.innerHTML.replace(/招聘/g, "<span style='background:red'>招聘</span>");
        }
    ```
- :has(selector)
    * 查找所有包含指定选择器的子元素的元素
    * 所有子元素中含有p标签的div  $("div:has(p)")
    * 筛选出含有class为text的子元素的div  $("div:has(.text)")
- :empty
    * 删选出空元素
    * 删选出所有内容为空的div $("div:empty")
- :parent
    * 删选出非空元素
    * 删选出所有内容为非空的div $("div:parent")    

### 属性过滤选择器
- [attr]
    * 筛选出含有指定属性的元素
    * $("input[placeholder]")
- [attr = value]
    * 筛选出含有指定属性值的元素
    * $("input[type = checkbox]")
- [attr != value]
    * 筛选出属性值不等于指定值的元素 
    * $("input[type != checkbox]")
- [attr ^= value]
    * 筛选出属性值以指定值开头的
    * $("[class ^= banner]").css('background-color', 'red')
- [attr $= value]
    * 筛选出属性值以指定值结尾的
    * $("[class $= banner]").css('background-color', 'red')
- [attr *= value]
    * 筛选出属性值包含指定值得元素
    * $("[placeholder] *= 密码").css('background-color', 'red')
- [attr1] [attr2] ... [attrN]
    * 筛选多个指定属性的元素
    * $("input[type][placeholder]").css('background-color', 'red')

### 子元素过滤选择器
    注意 : 子元素过滤选择器
    需要在前一个selector与子元素过滤选择器之间加上空格
- :first-child
- :last-child
- :nth-child(num|表达式|even|odd) 下标是从1开始的
- :nth-last-child(num|表达式|even|odd)  倒数 下标是从1开始的

### 可见性过滤选择器
- :hidden
    * 匹配所有不可见元素,或者type为hidden的元素
    * $("div:hidden")
- :visible
    * 匹配所有课件元素
    * $("div:visible")

### 表单属性过滤选择器
- :enabled
    * 匹配所有可用元素
    * $(":text:ennabled")
- :disabled
    * 匹配所有不可用的元素
    * $(":text:disabled")
- :checked
    * 匹配所有选中的被选元素(复选框、单选框等,不包括select中的option)
    * $(":input:checked")
- :selected
    * 匹配所有选中的option元素
    * $("option:selected")