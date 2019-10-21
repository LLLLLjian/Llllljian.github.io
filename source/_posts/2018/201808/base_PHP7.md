---
title: PHP_基础 (7)
date: 2018-08-04
tags: PHP 
toc: true
---

### PHP设计模式
    常见的设计模式: 策略模式 工厂模式 单例模式 注册模式

<!-- more -->

#### 单例模式
- 又称职责模式,通俗地说是实例化出来的对象是唯一的
- 单例类不能再其它类中直接实例化,只能被其自身实例化
- 它不会创建实例副本,而是会向单例类内部存储的实例返回一个引用
- 特点
    * 必须拥有一个构造函数,并且必须被标记为private
    * 拥有一个保存类的实例的静态成员变量
    * 它们拥有一个访问这个实例的公共的静态方法
    * 只能有一个实例.
    * 必须自行创建这个实例.
    * 必须给其他对象提供这一实例.
- eg
    ```php
        class Single 
        {
            // 声明一个私有的实例变量
            private $name;
            // 声明私有构造方法为了防止外部代码使用new来创建对象
            private function __construct()
            {
            
            }

            // 声明一个静态变量(保存在类中唯一的一个实例)
            static public $instance;
            // 声明一个getinstance()静态方法,用于检测是否有实例对象
            static public function getinstance()
            {
                if(!self::$instance) {
                    self::$instance = new self();
                }
                return self::$instance;
            }

            public function setname($n)
            { 
                $this->name = $n; 
            }

            public function getname()
            { 
                return $this->name; 
            }
        }

        $oa = Single::getinstance();
        $ob = Single::getinstance();
        $oa->setname('hello world');
        $ob->setname('good morning');
        echo $oa->getname();//good morning
        echo $ob->getname();//good morning
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

#### 策略模式
- 对一组算法的封装.动态的选择需要的算法并使用
- 三个角色
    * 抽象策略角色
    * 具体策略角色
    * 环境角色(对抽象策略角色的引用)
- eg
    ```php
        // 抽象策略类
        abstract class baseAgent 
        { 
            abstract function PrintPage();
        }

        // 用于客户端是IE时调用的类(环境角色)
        class ieAgent extends baseAgent 
        {
            function PrintPage() 
            {
                return 'IE';
            }
        }

        // 用于客户端不是IE时调用的类(环境角色)
        class otherAgent extends baseAgent 
        {
            function PrintPage() 
            {
                return 'not IE';
            }
        }

        // 具体策略角色
        class Browser 
        { 
            public function call($object)  
            {
                return $object->PrintPage();
            }
        }

        $bro = new Browser();
        echo $bro->call ( new ieAgent() );
    ```

#### 注册模式
- 解决全局共享和交换对象
- 已经创建好的对象,挂在到某个全局可以使用的数组上,在需要使用的时候,直接从该数组上获取即可
- eg
    ```php
        class Register
        {
            protected static $objects;

            // 将对象注册到全局的树上
            function set($alias, $object)
            {
                // 将对象放到树上
                self::$objects[$alias] = $object;
            }
            
            // 获取某个注册到树上的对象
            static function get($name)
            {
                return self::$objects[$name];
            }

            // 移除某个注册到树上的对象
            function _unset($alias)
        　　{
                unset(self::$objects[$alias]);
            }
        }
    ```

