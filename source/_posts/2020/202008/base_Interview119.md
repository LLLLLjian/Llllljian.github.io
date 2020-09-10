---
title: Interview_总结 (119)
date: 2020-08-19
tags: Interview
toc: true
---

### 设计模式
    今日被问傻系列-设计模式

<!-- more -->

#### 单例模式
- 概念
    * 单例模式是指整个应用中某个类只有一个对象实例的设计模式.具体来说,作为对象的创建方式,单例模式确保某一个类只有一个实例,而且自行实例化并向整个系统全局的提供这个实例.它不会创建实例副本,而是会向单例类内部存储的实例返回一个引用
- 特点: 三私一公
    * 需要一个保存类的唯一实例的**私有静态成员变量**
    * **构造函数**必须声明为私有的,防止外部程序new一个对象从而失去单例的意义
    * **克隆函数**必须声明为私有的,防止对象被克隆
    * 必须提供一个访问这个实例的**公共静态方法**(通常命名为getInstance),从而返回唯一实例的一个引用
- 使用原因及场景
> 在PHP的大多数应用中都会存在大量的数据库操作,如果不用单例模式,那每次都要new操作,但是每次new都会消耗大量的系统资源和内存资源,而且每次打开和关闭数据库都是对数据库的一种极大考验和浪费.所以单例模式经常用在数据库操作类中
- demo
    ```php
        class Test
        {
            private static $instance;

            private function __construct() {}

            public static function getInter()
            {
                if (!(self::$instance instanceof self)) {
                    self::$instance = new self();
                }
                return self::$instance;
            }

            private function __clone() {}
        }
    ```

#### 工厂模式
- 工厂方法代替new操作的一种模式
- 好处
    * 如果想要更改所实例化的类名等,则只需更改该工厂方法内容即可,不需逐一寻找代码中具体实例化的地方(new处)修改了
    * 为系统结构提供灵活的动态扩展机制,减少了耦合
- eg
    ```php
        // 创建一个基本的工厂类
        class Factory 
        {
            // 创建一个返回对象实例的静态方法
            static public function fac($id)
            {
                if (1 == $id) {
                    return new A();
                } elseif (2 == $id) {
                    return new B();
                } elseif (3 == $id) {
                    return new C();
                } else {
                    return new D();
                }   
            }
        }

        // 创建一个接口
        interface FetchName 
        {
            public function getname();
        }

        class A implements FetchName
        {
            private $name = "AAAAA";
            public function getname()
            { 
                return $this->name; 
            }
        }

        class C implements FetchName
        {
            private $name = "CCCCC";
            public function getname()
            { 
                return $this->name; 
            }
        }

        class B implements FetchName
        {
            private $name = "BBBBB";
            public function getname()
            { 
                return $this->name; 
            }
        }

        class D implements FetchName
        {
            private $name = "DDDDD";
            public function getname()
            { 
                return $this->name; 
            }
        }

        // 调用工厂类中的方法
        $o = Factory::fac(6);
        if ($o instanceof FetchName) {
            echo $o->getname();//DDDDD
        }

        $p=Factory::fac(3);
        echo $p->getname();//CCCCC
    ```



