---
title: jQuery_基础 (8)
date: 2018-11-26
tags: JQ
toc: true
---

## jQuery Button
    问题
    <button>提交</button>
    提交表单数据时,在谷歌浏览器中点击事件ajax提交会走到success中,火狐中则会走到error中
    
    改正
    添加属性type=button,火狐恢复正常

<!-- more -->

### 为什么用button标签
    <input>和<button>都能够提交表单,但是<button>能够在标签中嵌入其他的标签

### button标签的3种tpye
    请始终为按钮规定type属性
    Internet Explorer的默认类型是 “button”,而其他浏览器中(包括 W3C 规范)的默认值是 “submit”.
- 功能描述
    <table><thead><tr><th align="right">值</th><th align="right">描述</th></tr></thead><tbody><tr><td align="right">submit</td><td align="right">该按钮是提交按钮(除了 Internet Explorer,该值是其他浏览器的默认值).</td></tr><tr><td align="right">button</td><td align="right">该按钮是可点击的按钮(Internet Explorer 的默认值).</td></tr><tr><td align="right">reset</td><td align="right">该按钮是重置按钮(清除表单数据).</td></tr></tbody></table>

### 注意事项
- $('#customBtn').val()和$('#customBtn').attr('value')在不同浏览器下的值
    ```javascript
        // IE下会得到按钮,其它浏览器会得到test
        <script type="text/javascript">  
            $(function() {  
                $('#test1').click(function() {  
                    alert($('#customBtn').attr('value'));      
                });  
                $('#test2').click(function() {  
                    alert($('#customBtn').val());      
                });  
            });  
        </script>  
 
        <button id="customBtn" value="test">按钮</button>   
        <input type="button" id="test1" value="get attr"/>  
        <input type="button" id="test2" value="get val"/>
    ```
- &lt;form>标签中的&lt;button>标签
    ```javascript
        // <button>相当于<input type="submit"/>
        <form action="">  
            <button> button </button>  
            <input type="submit" value="input submit"/>  
            <input type="button" value="input button"/>  
        </form>
    ```
