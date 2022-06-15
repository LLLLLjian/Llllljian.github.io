---
title: Interview_总结 (181)
date: 2022-06-07 12:00:00
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 垃圾回收
- 引用计数
    * Python在内存中存储每个对象的引用计数,如果计数变成0,该对象就会消失,分配给该对象的内存就会释放出来
- 标记清除
    * 一些容器对象,比如list、dict、tuple,instance等可能会出现引用循环,对于这些循环,垃圾回收器会定时回收这些循环(对象之间通过引用(指针)连在一起,构成一个有向图,对象构成这个有向图的节点,而引用关系构成这个有向图的边)
- 分代清除
    * Python把内存根据对象存活时间划分为三代,对象创建之后,垃圾回收器会分配它们所属的代.每个对象都会被分配一个代,而被分配更年轻的代是被优先处理的,因此越晚创建的对象越容易被回收.

#### GIL(Global Interpreter Lock)
> 全局解释器锁

全局解释器锁(Global Interpreter Lock)是计算机程序设计语言解释器用于同步线程的一种机制,它使得任何时刻仅有一个线程在执行.即便在多核处理器上,使用 GIL 的解释器也只允许同一时间执行一个线程,常见的使用 GIL 的解释器有CPython与Ruby MRI.可以看到GIL并不是Python独有的特性,是解释型语言处理多线程问题的一种机制而非语言特性.

#### GIL的设计初衷

单核时代高效利用CPU, 针对解释器级别的数据安全(不是thread-safe 线程安全). 首先需要明确的是GIL并不是Python的特性,它是在实现Python解析器(CPython)时所引入的一个概念.当Python虚拟机的线程想要调用C的原生线程需要知道线程的上下文,因为没有办法控制C的原生线程的执行,所以只能把上下文关系传给原生线程,同理获取结果也是线 程在python虚拟机这边等待.那么要执行一次计算操作,就必须让执行程序的线程组串行执行.

#### 为什么要加在解释器,而不是在其他层

GIL锁加在解释器一层,也就是说Python调用的Cython解释器上加了GIL锁,因为你python调用的所有线程都是原生线程.原生线程是通过C语言提供原生接口,相当于C语言的一个函数.你一调它,你就控制不了了它了,就必须等它给你返回结果.只要已通过python虚拟机 ,再往下就不受python控制了,就是C语言自己控制了.加在Python虚拟机以下加不上去,只能加在Python解释器这一层.

#### 什么是深拷贝和浅拷贝

赋值(=),就是创建了对象的一个新的引用,修改其中任意一个变量都会影响到另一个.

浅拷贝 copy.copy：创建一个新的对象,但它包含的是对原始对象中包含项的引用(如果用引用的方式修改其中一个对象,另外一个也会修改改变)

深拷贝：创建一个新的对象,并且递归的复制它所包含的对象(修改其中一个,另外一个不会改变){copy模块的deep.deepcopy()函数}

#### 什么是 lambda 表达式

简单来说,lambda表达式通常是当你需要使用一个函数,但是又不想费脑袋去命名一个函数的时候使用,也就是通常所说的匿名函数.

lambda表达式一般的形式是：关键词lambda后面紧接一个或多个参数,紧接一个冒号“：”,紧接一个表达式

#### 双等于和 is 有什么区别

==比较的是两个变量的 value,只要值相等就会返回True

is比较的是两个变量的 id,即id(a) == id(b),只有两个变量指向同一个对象的时候,才会返回True

#### yield关键字
- 生成器, 节省大量的内存, 比较适合计算大量的数据

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