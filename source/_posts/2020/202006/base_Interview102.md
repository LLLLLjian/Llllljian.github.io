---
title: Interview_总结 (102)
date: 2020-06-04
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### php5与php7之间的区别 
1. 性能提升:PHP7比PHP5.0性能提升了两倍.
2. 以前的许多致命错误, 现在改成抛出异常.
3. PHP 7.0比PHP5.0移除了一些老的不在支持的SAPI(服务器端应用编程端口)和扩展.
4. PHP 7.0比PHP5.0新增了空接合操作符.
5. PHP 7.0比PHP5.0新增加了结合比较运算符.
6. PHP 7.0比PHP5.0新增加了函数的返回类型声明.
7. PHP 7.0比PHP5.0新增加了标量类型声明.
8. PHP 7.0比PHP5.0新增加匿名类.
9. 错误处理和64位支持
10. 声明返回类型

#### 为什么PHP7比PHP5性能提升了
1. 变量存储字节减小, 减少内存占用, 提升变量操作速度
2. 改善数组结构, 数组元素和hash映射表被分配在同一块内存里, 降低了内存占用、提升了 cpu 缓存命中率
3. 改进了函数的调用机制, 通过优化参数传递的环节, 减少了一些指令, 提高执行效率

#### Cookie和Session的区别 
1. 存储位置不同
    * cookie的数据信息存放在客户端浏览器上.
    * session的数据信息存放在服务器上.
2. 存储容量不同
    * 单个cookie保存的数据<=4KB, 一个站点最多保存20个Cookie. 
    * 对于session来说并没有上限, 但出于对服务器端的性能考虑, session内不要存放过多的东⻄, 并且设置session删除机制. 
3. 存储方式不同
    * cookie中只能保管ASCII字符串, 并需要通过编码方式存储为Unicode字符或者二进制数据
    * session中能够存储任何类型的数据, 包括且不限于string, integer, list, map等.
4. 隐私策略不同
    * cookie对客户端是可⻅的, 别有用心的人可以分析存放在本地的cookie并进行cookie欺骗, 所以它是不安全的
    * session存储在服务器上, 对客户端是透明对, 不存在敏感信息泄漏的⻛险.
5. 有效期上不同
    * 开发可以通过设置cookie的属性, 达到使cookie⻓期有效的效果.
    * session依赖于名为JSESSIONID的cookie, 而cookie JSESSIONID的过期时间默认为-1, 只需关闭窗口该session就会失效, 因而 session不能达到⻓期有效的效果.
6. 服务器压力不同
    * cookie保管在客户端, 不占用服务器资源.对于并发用户十分多的网站, cookie是很好的选择
    * session是保管在服务器端的, 每个用户都会产生一个session.假如并发访问的用户十分多, 会产生十分多的session, 耗费大量的内存.
7. 浏览器支持不同
    * 假如客户端浏览器不支持cookie: cookie是需要客户端浏览器支持的, 假如客户端禁用了cookie, 或者不支持cookie, 则会话跟踪会失效.关于WAP上的应用, 常规的 cookie就派不上用场了. 运用session需要使用URL地址重写的方式.一切用到session程序的URL都要进行URL地址重写, 否则session会话跟踪还会失效. 
    * 假如客户端支持cookie:cookie既能够设为本浏览器窗口以及子窗口内有效, 也能够设为一切窗口内有效.session只能在本窗口以及子窗口内有效.
8. 跨域支持上不同 cookie支持跨域名访问. session不支持跨域名访问.

#### 单例模式
> 在Web应用的开发中, 常常用于允许在运行时为某个特定的类创建仅有一个可访问的实例.应用场景比如连接数据库, 优点节省资源
    ```php
        class Singleton
        {
            // 私有属性, 用于保存实例
            private static $instance;
            // 构造方法私有化, 防止外部创建实例
            private function __construct(){}
            // 公共方法 用于获取实例
            public function getInstance()
            {
                if (empty(self::$instance)) {
                    self::$instance = new self();
                }
                return self::$instance;
            }

            // 克隆方法私有化, 防止复制实例
            private function __clone(){}
        }
    ```

#### 工厂模式
> 工厂模式就是一个类通过本身的静态方法来, 实例化一个类并返回一个实例对象;
  优点:如果已经使用的类内部发生改变, 那不需要在所有的地方都改变, 只需要在类工厂类里改变既可. 
  应用场景:连接数据库, 可以使用mysql 、mysqli、pdo, 根据不同参数配置使用不同的数据库操作类;做支付接口的时候, 未来可 能对应不同的支付网关:支付宝、财付通、网银在线等
    ```php
        interface mysql
        {
            public function connect();
        }

        interface mysqli2 implement mysql
        {
            puclic function connect()
            {
                echo "MYSQLI";
            }
        }

        interface pdo2 implement mysql
        {
            public function connect()
            {
                echo "PDO";
            }
        }

        class mysqlFactory
        {
            public static function factory($className)
            {
                return new $className();
            }
        }
    ```



