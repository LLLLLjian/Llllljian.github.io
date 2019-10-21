---
title: jQuery_基础 (2)
date: 2018-01-17
tags: JQ
toc: true
---

## DOM操作

### 获取设置节点的属性 
- $("").attr("属性值")
    * 设置或返回被选元素的属性值
    * 返回 : $(".box").attr("title")
    * 设置
        * 设置元素指定属性的属性值
            * attr("属性名", "属性值")
            * $(".box").attr("title", 'title_value')
        * 设置多个属性的属性值
            * attr("属性名1":"属性值1", "属性名2":"属性值值2")
            * $(".box").attr("title":"1111", 'my':'2222')

<!-- more -->

- $("").removeAttr("属性")
    * 从每一个匹配的元素中删除一个属性
    * $("").removeAttr("my")
- $("").prop("属性")
    * 获取在陪陪的元素集中的一个元素的属性值
    * $(":checkbox").attr("checked")
    * 设置属性
        * 获取checked,select,readOnly属性的时候,可以用prop():只有true和false
        * $(":checkbox").attr("checked", "checked")
        * $(":checkbox").prop("checked", true)
- $("").removeProp("属性")
    * 用来删除由.prop()方法设置的属性集

### HTML代码/文本/值
- $("").html()
    * 相当于js中的innerHTML
    * 取得第一个匹配元素的html内容
    * $("div").html("&lt;button>点击&lt;/button>");
- $("").text()
    * 相当于js中的innerText
    * 取得所有匹配元素的内容
    * $("div").text("123")
- $("").val()
    * 相当于js中的value
    * 获得匹配元素的当前值
    * $("textarea").val()

### css相关属性
- $("").offset()
    * 返回或设置匹配元素相对于文档的偏移(位置)
    * offset 可以获取,可以改变
    * $("#parent").offset({left : 300, top : 300})
- $("").position()
    * 匹配元素相对父元素(非静态)的偏移
    * position 只可以获取,不能设置
    * $("#son").position()
- $("").height()
    * 取得匹配元素当前设计的高度值(px)
    * $("#parent").height(300)
- $("").width()
    * 取得匹配元素当前设计的宽度值(px)
    * $("#parent").width(300)

### 节点操作
- 创建元素节点
    * var $Div = $("&lt;div class='box'>&lt;/div>")
- 插入元素节点
    * 在所有孩子列表的末尾插入
        * 父节点.append(子节点)
        * eg : $('body').append($Div)
        * 子节点.appendTo(父节点)
        * eg : $Div.appendTo($("body"))
    * 在所有孩子列表的首部插入
        * 父节点.prepend(子节点)
        * eg : $("body").prepend($div)
        * 子节点.prepend(父节点)
        * eg : $div.prependTo("body")
    * 在每个匹配的元素之后插入内容
        * 旧节点.after(新节点)
        * $("#p1").after($p)
    * 把所有匹配的元素插入到另一个,指定的元素集合的后边
        * 新节点.insertAfter(旧节点)
        * $p.insertAfter($("#p1"))
    * 在每个匹配的元素之前插入内容
        * 旧节点.before(新节点)
        * $("#p1").before('&lt;p>p&lt;/p>')
    * 把所有匹配的元素插入到另一个指定的元素集合前边
        * 新节点.insertBefor(旧节点)
        * $('&lt;p>p&lt;/p>').insertBefor("#p1")
- 移除节点
    * $().remove()
        * 从DOM中删除所有匹配的元素
        * 移除节点之后,会保存jQuery对象,不会保存该对象上添加的事件
    * $().detach()
        * 从DOM中删除所有匹配的元素
        * 移除节点之后,会保存jQuery对象,会保存该对象上添加的事件
    * $().empty()
        * 删除匹配的元素集合中所有的子节点

### 克隆节点
- clone(true|false)
    * 传入参数true,同时克隆该节点关联的事件

### 替换节点
- 旧节点.replaceWith(新节点)
- 新节点.replaceAll(旧节点)

### 包裹节点
- wrap()
    * 把所有匹配的元素用其他元素的结构化标记包裹起来
    * 参数写在括号里
- unwrap()
    * 把所有匹配的元素非让父节点去掉
    * 不用传参数
- wrapAll()
    * 将所有匹配的元素用单个元素包裹起来
    * 参数写在括号里
- wrapInner()
    * 将每一个匹配的元素的子内容(包括文本节点)用一个HTML结构包裹起来
    * 参数写在括号里

### 遍历DOM数
- 父子关系
    * children()
        * 取得一个包含匹配的元素集合中每一个元素的所有子元素的元素集合
    * parent()
        * 获取匹配到的每一个节点的父节点
- 祖先节点
    * parents() 
        * 取得一个包含着所有匹配元素的祖先元素的元素集合(不包含根元素)
        * 可以通过一个可选的表达式进行筛选
    * closest("筛选条件")
        * 从元素本身开始,逐级向上级元素匹配,并返回最先匹配的元素
- 兄弟节点
    * 前一个兄弟 prev()
    * 前边所有的兄弟节点 prevAll()
    * 后一个兄弟节点 next()
    * 后边所有的兄弟节点 nextAll()
    * 除本身外所有的兄弟节点 siblings()
- find("筛选条件")
    * 把匹配到的每一个元素的后代再进行一次筛选