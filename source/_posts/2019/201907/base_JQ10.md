---
title: jQuery_基础 (10)
date: 2019-07-03
tags: JQ
toc: true
---

## 解决select下拉框禁用（设置disabled属性）,后台获取值为空
    最近在做的项目在某个条件之后需要禁用掉下拉框, 但是禁用之后后台接收不到下拉框中的值

<!-- more -->

### 解决方法
- 方法1
    ```javascript
        <!-- 为下拉框添加样式,可以禁用该下拉框 -->
        <select name="name" id="select" class="select" style="pointer-events: none;"></select>
    ```
- 方法2
    ```javascript
        <!-- 为下拉框添加onfocus和onchange方法,可以禁用该下拉框 -->
        <select name="name" id="select" class="select" onfocus="this.defaultIndex=this.selectedIndex;"  onchange="this.selectedIndex=this.defaultIndex;">
    ```
- 方法3
    ```javascript
        <!-- 在页面加载之前设置 -->
        $(function() {  $('#select').attr("disabled",true); }）;
        <!-- 提交表单前设置 -->
        $('#select').attr("disabled",false);
    ```