---
title: Interview_总结 (14)
date: 2018-09-07
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : 写个函数来解决多线程同时读写一个文件的问题

        a : 
        <?php
            $fp = fopen("/tmp/lock.txt", "w+");
            
            // 进行排它型锁定
            if (flock($fp, LOCK_EX)) {
                fwrite($fp, "Write something here\n");
                // 释放锁定
                flock($fp, LOCK_UN);
            } else {
                echo "Couldn't lock the file !";
            }

            fclose($fp);
        ?>
    ```

#### 魔术方法与魔术常量
- 魔术方法
    * 类方法
        * __construct() : 具有构造函数的类会在每次创建新对象时先调用此方法,适合在使用对象之前做一些初始化工作.如果子类中定义了构造函数则不会隐式调用其父类的构造函数.要执行父类的构造函数,需要在子类的构造函数中调用 parent::__construct().如果子类没有定义构造函数则会如同一个普通的类方法一样从父类继承.
        * __destruct() : 析构函数会在到某个对象的所有引用都被删除或者当对象被显式销毁时执行.
    * 方法重载
        * __call() : 在对象中调用一个不可访问方法时,__call(); 方法会被调用.
        * __callStatic() : 用静态方式中调用一个不可访问方法时,__callStatic(); 方法会被调用.
    * 属性重载(只对类中私有受保护的成员属性有效)
        * __get() : 读取不可访问属性的值时,__get() 会被调用.
        * __set() : 在给不可访问属性赋值时,__set() 会被调用.
        * __isset() : 当对不可访问属性调用 isset() 或 empty() 时,__isset() 会被调用.
        * __unset() : 当对不可访问属性调用 unset() 时,__unset() 会被调用.
    * 序列化相关
        * __sleep() : 序列化时调用,serialize() 函数会检查类中是否存在该魔术方法.如果存在,该方法会先被调用,然后才执行序列化操作.
        * __wakeup() : unserialize() 会检查是否存在一个 __wakeup() 方法.如果存在,则会先调用该方法,用在反序列化操作中,例如重新建立数据库连接,或执行其它初始化操作
    * 操作类和对象方法：
        * __toString() : 方法用于一个类被当成字符串时调用,例如把一个类当做字符串进行输出
        * __invoke() : 当尝试以调用函数的方式调用一个对象时,__invoke() 方法会被自动调用.
        * __set_state() : 当调用 var_export() 导出类时,此静态 方法会被调用. 本方法的唯一参数是一个数组
        * __clone() : 当复制完成时,如果定义了 __clone() 方法,则新创建的对象（复制生成的对象）中的 __clone() 方法会被调用,可用于修改属性的值.
        * __autoload() : 该方法可以自动实例化需要的类.当程序要用一个类但没有被实例化时,改方法在指定路径下查找和该类名称相同的文件.否则报错.
- 魔术常量
    * \__LINK__
        * 文件中的当前行号.
    * \__FILE__
        * 文件的完整路径和文件名.如果用在被包含文件中,则返回被包含的文件名.
    * \__DIR__
        * 文件所在的目录.如果用在被包括文件中,则返回被包括的文件所在的目录,它等价于 dirname(\__FILE__).
    * \__FUNCTION__
        * 函数名称.自 PHP 5 起本常量返回该函数被定义时的名字（区分大小写）.在 PHP 4 中该值总是小写字母的.
    * \__CLASS__
        * 类的名称.自 PHP 5 起本常量返回该类被定义时的名字（区分大小写）.在 PHP 4 中该值总是小写字母的.
    * \__METHOD__
        * 类的方法名（PHP 5.0.0 新加）.返回该方法被定义时的名字（区分大小写）.
    * \__NAMESPACE__
        * 当前命名空间的名称（大小写敏感）.这个常量是在编译时定义的

#### 问题3
    ```php
        q : 遍历文件夹下的所有文件和文件夹

        a : 
        function get_dir_info($path)
        {
            //打开目录返回句柄
            $handle = opendir($path);
            while (($content = readdir($handle)) !== false) {
                $new_dir = $path . DIRECTORY_SEPARATOR . $content;
                if ($content == '..' || $content == '.') {
                    continue;
                }

                if (is_dir($new_dir)) {
                    echo "<br>目录：".$new_dir . '<br>';
                    get_dir_info($new_dir);
                } else {
                    echo "文件：".$path.':'.$content .'<br>';
                }
            }
        }
        
        get_dir_info($dir);
    ```

#### 问题4
    ```php
        q : strlen()与mb_strlen的作用与区别

        a : 
        在PHP中,strlen与mb_strlen是求字符串长度的函数
        PHP内置的字符串长度函数strlen无法正确处理中文字符串,它得到的只是字符串所占的字节数.对于GB2312的中文编码,strlen得到的值是汉字个数的2倍,而对于UTF-8编码的中文,就是3倍（在 UTF-8编码下,一个汉字占3个字节）.
 
        采用mb_strlen函数可以较好地解决这个问题.mb_strlen的用法和strlen类似,只不过它有第二个可选参数用于指定字符编码.例如得到UTF-8的字符串str长度,可以用mbstrlen(str,'UTF-8').如果省略第二个参数,则会使用PHP的内部编码.内部编码可以通过 mb_internal_encoding()函数得到.

        需要注意的是,mb_strlen并不是PHP核心函数,使用前需要确保在php.ini中加载了php_mbstring.dll,即确保“extension=php_mbstring.dll”这一行存在并且没有被注释掉,否则会出现未定义函 数的问题.
    ```

#### 问题5
    ```php
        q : 从一个标准url中取出扩展名
        
        a : 
        $arr = parse_url('http://www.sina.com.cn/abc/de/fg.php?id=1');

        echo "<pre>";
        var_dump($arr);

        array(4) {
            ["scheme"]=>
            string(4) "http"
            ["host"]=>
            string(15) "www.sina.com.cn"
            ["path"]=>
            string(14) "/abc/de/fg.php"
            ["query"]=>
            string(4) "id=1"
        }
    ```
