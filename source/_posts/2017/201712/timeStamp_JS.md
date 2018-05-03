---
title: JS_时间相关
date: 2017-12-12
tags: JS
toc: true
---
# 页面上需要JS操作时间相关

## 计算两个日期之间的天数

``` bash
function daysBetween(DateOne,DateTwo)  
{   
    var OneMonth = DateOne.substring(5,DateOne.lastIndexOf ('-'));  
    var OneDay = DateOne.substring(DateOne.length,DateOne.lastIndexOf ('-')+1);  
    var OneYear = DateOne.substring(0,DateOne.indexOf ('-'));  
  
    var TwoMonth = DateTwo.substring(5,DateTwo.lastIndexOf ('-'));  
    var TwoDay = DateTwo.substring(DateTwo.length,DateTwo.lastIndexOf ('-')+1);  
    var TwoYear = DateTwo.substring(0,DateTwo.indexOf ('-'));  
  
    var cha=((Date.parse(OneMonth+'/'+OneDay+'/'+OneYear)- Date.parse(TwoMonth+'/'+TwoDay+'/'+TwoYear))/86400000);   
    return Math.abs(cha);  
} 
```
<!-- more-->

## 多少天之后

``` bash
Date.prototype.addDays = function(days)
{
    var date = new Date(this);
     date.setDate(date.getDate() + days);
     return date;
}
```

## 指定时间日期格式

``` bash
var newDate = new Date();

Date.prototype.format = function(format) {
    var date = {              
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S+": this.getMilliseconds()
    };
    if (/(y+)/i.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
    }
    for (var k in date) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1
            ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
        }
    }
    return format;
}
$("#dangqianshijian").text(newDate.format('yyyy-MM-dd h:m:s'));

var timeStamp = new Date(new Date().setHours(0, 0, 0, 0));
timeStamp2 = timeStamp / 1000;		
var nowtime = Date.parse(new Date());
//var updatetime = info.updatetime;
var updatetime = 1512533532000;
var newDate = new Date();
newDate.setTime(updatetime);
if ((updatetime / 1000) < timeStamp2) {
    $("#zhanshishijian").text(newDate.format('yyyy-MM-dd h:m:s'));
} else {
    if ((updatetime / 1000) < (nowtime - 5 * 60)) {
        $("#zhanshishijian").text(newDate.format('h:m:s'));
    } else {
        $("#zhanshishijian").text("刚刚");
    }			
}
$("#lingchenshijian_miao").text(timeStamp2);
```