---
title: Interview_总结 (70)
date: 2020-03-10
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列

<!-- more -->

#### HTTP状态码
- 301
    * 代表永久性转移
    * 表示旧地址A的资源已经被永久地移除了(这个资源不可访问了), 搜索引擎在抓取新内容的同时也将旧的网址交换为重定向之后的网址
- 302
    * 暂时性转移
    * 旧地址A的资源还在(仍然可以访问), 这个重定向只是临时地从旧地址A跳转到地址B, 搜索引擎会抓取新的内容而保存旧的网址
- 499
    * nginx要给客户端吐数据时发现客户端已经断开连接.常见场景是客户端超时
- 502
    * 作为网关或者代理工作的服务器尝试执行请求时, 从上游服务器接收到<a href="#desc1">无效的响应</a>
    * 当nginx收到了无法理解的响应时, 就返回502
- 504
    * 作为网关或者代理工作的服务器尝试执行请求时, 未能及时从上游服务器(URI标识出的服务器, 例如HTTP、FTP、LDAP)或者辅助服务器(例如DNS)收到响应
    * nginx超过了自己设置的超时时间, 不等待php-fpm的返回结果, 直接给客户端返回504错误.但是此时php-fpm依然还在处理请求(在没有超出自己的超时时间的情况下)
    * 当nginx超过自己配置的超时时间还没有收到请求时, 就返回504错误

#### 单例模式
> 用于允许在运行时为某个特定的类创建仅有一个可访问的实例
```php
    <?php
    class Singleton
    {
        //私有属性, 用于保存实例
        private static $instance;
        //构造方法私有化, 防止外部创建实例
        private function __construct()
        {

        }
        //公有属性, 用于测试
        public $a;
        //公有方法, 用于获取实例
        public static function getInstance()
        {
            //判断实例有无创建, 没有的话创建实例并返回, 有的话直接返回
            if(!(self::$instance instanceof self)){
                self::$instance = new self();
            }
            return self::$instance;
        }
        //克隆方法私有化, 防止复制实例
        private function __clone()
        {

        }
    }

    // 测试
    $first = Singleton::getInstance();
    $second = Singleton::getInstance();

    $first->a = "12";
    echo "<pre>";
    print_r($first);
    print_r($second);

    $first->a = "12";
    $second->a = "34";
    echo "<pre>";
    print_r($first);
    print_r($second);
```

#### 工厂模式
> 如果已经使用的类内部发生改变, 不需要在所有的地方都改变, 只需要在类工厂类里改变既可
```php
    interface  mysql
    {
        public function connect();
    }
    
    class mysqli2  implements mysql
    {
        public  function connect(){
            echo 'mysqli';
        }
    }
    
    class pdo2 implements mysql
    {
    
        public function connect(){
            echo 'pdo';
        }
    }
    
    
    class mysqlFactory
    {
        static public function factory($class_name)
        {
            return new $class_name();
        }
    
    }
    
    $obj = mysqlFactory::factory('pdo2');
    $obj->connect();
```

#### <span id="desc1">无效的响应</span>
- nginx无法与php-fpm进行连接, php-fpm没有启动,nginx无法将请求交给php-fpm
- nginx在连接php-fpm一段时间后发现与php-fpm的连接被断开, php-fpm运行脚本超时, php-fpm终止了脚本的执行和执行脚本的Worker进程, nginx发现自己与php-fpm的连接断开


