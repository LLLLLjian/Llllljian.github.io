---
title: PHP_基础 (30)
date: 2018-11-22
tags: PHP 
toc: true
---

### 今日知识
    PHP中json格式遇到的问题

<!-- more -->

#### 问题描述
    线上反馈页面展示店铺出现问题,列表中不能展示,店铺是通过接口从其他API中请求的信息.
    排查问题

#### 问题解决
    测试环境经测试没有发现问题,对比线上和测试代码,先将接口传回的信息记入日志进行查看
    经检查,接口中可以正常返回json信息,json_decode后为空,怀疑是json数据有问题,导致未能正常解析.

#### PHP解析json格式数据
- json_decode
    * 说明
        * 接受一个 JSON 编码的字符串并且把它转换为PHP变量
    * 格式
        * json_decode(string $json[,bool $assoc=false[,int $depth=512[,int $options=0]]])
    * 参数
        * $json: UTF-8编码的json格式的字符串
        * $assoc: 当该参数为TRUE时,将返回array而非object
    * 返回值
        * TRUE: 返回相应的值
        * FALSE: 如果无法解码json,或者如果编码数据比递归限制更深,则返回NULL
    * 可能失败的原因
        * 返回的json有bom头
        * 返回的json最后有逗号或者json字符串中有特殊字符(斜杠换行等)
        * json格式不正确
- json_last_error
    * 返回最后发生的错误
    * 返回值  
        * JSON_ERROR_NONE 没有错误发生   
        * JSON_ERROR_DEPTH 到达了最大堆栈深度   
        * JSON_ERROR_STATE_MISMATCH 无效或异常的 JSON   
        * JSON_ERROR_CTRL_CHAR 控制字符错误,可能是编码不对   
        * JSON_ERROR_SYNTAX 语法错误   
        * JSON_ERROR_UTF8 异常的 UTF-8 字符,也许是因为不正确的编码
