---
title: Interview_总结 (1)
date: 2018-08-13
tags: Interview
toc: true
---

### 笔试总结
    列一下今天笔试题

<!-- more -->

#### 编码题1
    ```php
        q :  给定数组arr1('1', '2', '3', '4', '5', '6')转换为arr2('1' => '2', '3' => '4', '5' => '6')

        a : 
        function changeArr($arr) 
        {
            $returnArr = array();
            if (empty($arr) || !is_array($arr)) {
                return $returnArr;
            } else {
                foreach (array_chunk($arr, 2) as $set) {
                    if (count($set) == 2) {
                        $returnArr[$set[0]] = $set[1];
                    }
                }
                
                return $returnArr;
            }
        }
    ```

#### 编码题2
    ```php
        q : 给定字符串hello_world和welcome_to_new_world转换为HelloWorld和WelcomeToNewWorld

        a :

        function changeString($string) 
        {
            $resultString = "";
            if (empty($string)) {
                return $resultString;
            } else {
                $resultArr = explode('_', (string)$string);

                foreach ($resultArr as $key=>$value) {
                    $resultString .= ucfirst($value);
                }

                return $resultString;
            }
        }
    ```

#### 队列和栈区别
    吃多了拉就是队列(先进先出)；吃多了吐就是栈(先进后出)

#### http头相关信息
- General
    * Request URL
        * 请求地址
    * Request Method
        * 请求方法
    * Status Code
        * 状态码
    * Remote Address
        * 请求的远程地址
    * Referrer Policy:no-referrer-when-downgrade
        * referrer策略
- Response Headers
    * 相应头
    * accept-ranges:bytes
        * 表明服务器是否支持指定范围请求及哪种类型的分段请求
    * age:0
        * 从原始服务器到代理缓存形成的估算时间
    * cache-control:max-age=600
        * 告诉所有的缓存机制是否可以缓存及哪种类型
    * content-encoding:gzip
        * web服务器支持的返回内容压缩编码类型
    * content-length:41354
        * 响应体的长度
    * content-type:text/html; charset=utf-8
        * 返回内容的MIME类型
    * date:Sat, 18 Aug 2018 14:08:49 GMT
        * 原始服务器消息发出的时间
    * expires:Sat, 18 Aug 2018 14:18:49 GMT
        * 响应过期的日期和时间
    * last-modified:Thu, 09 Aug 2018 12:03:19 GMT
        * 请求资源的最后修改时间
    * server:GitHub.com
        * web服务器软件名称
- Request Headers
    * 请求头
    * accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
        * 请求报头域,用于指定客户端可接受哪些类型的信息
    * accept-encoding:gzip, deflate, sdch, br
        * 指定客户端可接受的内容编码
    * accept-language:zh-CN,zh;q=0.8
        * 指定客户端可接受的语言类型
    * referer
        * 标识这个请求是从哪个页面发过来的
    * Host
        * 用于指定请求资源的主机IP和端口号,其内容为请求URL的原始服务器或网关的位置.从HTTP 1.1版本开始,请求必须包含此内容.
    * Cookie
    * User-Agent
        * 简称UA,它是一个特殊的字符串头,可以使服务器识别客户使用的操作系统及版本、浏览器及版本等信息.在做爬虫时加上此信息,可以伪装为浏览器；如果不加,很可能会被识别出为爬虫.
    * Content-Type
        * 也叫互联网媒体类型（Internet Media Type)或者MIME类型,在HTTP协议消息头中,它用来表示具体请求中的媒体类型信息

#### redis中list和set的区别
- list
    * 列表
    * 简单字符串,按照插入顺序排序,你可以添加一个元素到列表的头部(左边)或者尾部(右边)
- set
    * 集合
    * String 类型的无序集合
    * 数据唯一,不能出现重复
