---
title: Interview_总结 (15)
date: 2019-02-25
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : echo (int)((0.1+0.7)*10);

        a : 
        <?php
            // 浮点数精度
            // 7
            echo (int)((0.1+0.7)*10);
            // 0.8000000000000000 0.1000000000000000 0.7000000000000000 0.7999999999999999
            printf("%0.16f %0.16f %0.16f %0.16f", 0.8, 0.1, 0.7, 0.1+0.7);
        ?>
    ```

#### 问题2
    ```php
        q : $a = '1';$b = &$a; $b = "2$b";echo $a;echo $b;

        a : 21 21
    ```

#### 问题3
    ```php
        q : 写一个函数，尽可能高效的，从一个标准 url 里取出文件的扩展名

        a1 :
        $url_path = "http://www.sina.com.cn/abc/de/fg.php?id=1";
        $temp = pathinfo($url_path,PATHINFO_EXTENSION);
        $temp = explode("?",$temp)
        echo $temp[0];

        a2 :
        $url_path = "http://www.sina.com.cn/abc/de/fg.php?id=1";
        $temp = parse_url($url_path);
        $path = $temp['path'];
        echo pathinfo($path,PATAINFO_EXTENSION);

        a3 :
        $url_path = "http://www.sina.com.cn/abc/de/fg.php?id=1";
        $temp = pathinfo($url_path,PATHINFO_BASENAME);
        $temp = explode(".",$temp)
        echo $temp[0];
    ```

#### 问题4
    ```php
        q : 将1234567890转换成1,234,567,890 每3位用逗号隔开的形式

        a1 : 
        $s = 1234567890;
        echo number_format($s);

        a2 : 
        $s = '1234567890';  
        $count = 4;  
        echo $s;  
        echo '<br>';  
        echo test($s,$count);  
        function test($s='',$count=3){  
            if(empty($s) || $count <= 0){  
                return false;  
            }  
            //反转  
            $str = strrev($s);  
            //分割  
            $arr = str_split($str,$count);  
            //连接  
            $new_s = implode(',',$arr);  
            //再次反转  
            return strrev($new_s);  
            
        } 
    ```

#### 邮箱正则
    ```php
        ^[a-z0-9A-Z]+  =>   字符或者数字开头,出现一次或多次
        [- | a-z0-9A-Z . _]+  =>   横线或者字符数字小数点下划线,出现一次或多次
        @  => @出现一次
        ([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)
        [a-z0-9A-Z]+  =>   字符或者数字,出现一次或多次
        [a-z0-9A-Z]+  =>   字符或者数字,出现一次或多次
        (-[a-z0-9A-Z]+)?  =>   字符或者数字,出现零次或一次
        \\.  =>  转义.
        [a-z]{2,}$  => 字母最少出现两次,并且字母结尾
        ^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$
    ```
