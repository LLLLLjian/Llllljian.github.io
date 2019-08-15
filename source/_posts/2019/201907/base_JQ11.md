---
title: jQuery_基础 (11)
date: 2019-07-04
tags: JQ
toc: true
---

### jquery操作select
    要根据合同类型对应修改页面的值, 需要操作一波select

<!-- more -->

#### SELECT下拉框 
- 获取SELECT选中的值
    * 获取text
        ```javascript
            var checkText=$("#select_id").find("option:selected").text();
        ```
    * 获取Value
        ```javascript
            var checkValue=$("#select_id").val();
        ```
    * 获取索引
        ```javascript
            var checkIndex=$("#select_id ").get(0).selectedIndex;
        ```
    * 获取最大的索引
        ```javascript
            var maxIndex=$("#select_id option:last").attr("index");
        ```
- 设置SELECT选中的值
    ```javascript
        //设置Select索引值为1的项选中
        $("#select_id ").get(0).selectedIndex=1;  
        // 设置Select的Value值为4的项选中
        $("#select_id ").val(4);
        //设置Select的Text值为jQuery的项选中
        $("#select_id option[text='jQuery']").attr("selected", true);   
    ```
- 改变SELECT的值时触发的事件
    ```html
        <select name="type" onchange="changeType()">

        </select>
    ```
    ```javascript
        //为Select添加事件,当选择其中一项时触发
        $("#select_id").change(function(){
            //code...
        }); 
    ```
- 增删SELECT的Option
    ```javascript
        //为Select追加一个Option(下拉项)
        $("#select_id").append("<option value='Value'>Text</option>");  
        //为Select插入一个Option(第一个位置)
        $("#select_id").prepend("<option value='0'>请选择</option>");  
        //删除Select中索引值最大Option(最后一个)
        $("#select_id option:last").remove();  
        //删除Select中索引值为0的Option(第一个)
        $("#select_id option[index='0']").remove();  
        //删除Select中Value='3'的Option
        $("#select_id option[value='3']").remove();  
        //删除Select中Text='4'的Option
        $("#select_id option[text='4']").remove();  
    ```
- 清空SELECT的选中
    ```javascript
        $("#select_id").empty();
    ```