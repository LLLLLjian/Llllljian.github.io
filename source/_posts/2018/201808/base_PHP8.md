---
title: PHP_基础 (8)
date: 2018-08-08
tags: PHP 
toc: true
---

### 匿名函数
    闭包是指在创建时封装周围状态的函数.即使闭包所在的环境不存在了,闭包中封装的状态依然存在.
    匿名函数就是没有名称的函数.匿名函数可以赋值给变量,还能像其他任何PHP对象那样传递.不过匿名函数仍是函数,因此可以调用,还可以传入参数.匿名函数特别适合作为函数或方法的回调

<!-- more -->

#### 创建闭包
- 闭包对象实现了__invoke()魔术方法
- 只要变量名后有(),PHP就会查找并调用__invoke()方法
- eg
    ```php
        $closure = function($name) {
            return sprintf("Hello %s", $name);
        };

        echo $closure("llllljian");
        echo "\n";

        // 检测$closure变量是否是一个闭包
        var_dump($closure instanceof Closure);

        // 输出
        Hello llllljian
        bool(true)
    ```

#### 使用闭包
- 与回调函数联合使用
- eg
    ```php
        echo preg_replace_callback('~-([a-z])~', function ($match) {
            return strtoupper($match[1]);
        }, 'hello-world');

        echo "\n";

        var_dump(array_map(function($number) {
            return $number+=2;
        }, [1,2]));

        // 输出
        helloWorld
        array(2) {
            [0]=>
            int(3)
            [1]=>
            int(4)
        }
    ```

#### 使用use
- 闭包可以从父作用域中继承变量.任何此类变量都应该用use语言结构传递进去
- eg
    ```php
        function Car ($name) {
            return function($statu) use ($name) {
                return sprintf("Car %s is %s", $name, $statu); 
            };
        }

        $car = Car("bmw");
        echo $car("running");

        echo "\n";

        $message = 'world';
        $example = function ($arg) use ($message) {
            var_dump($arg . ' ' . $message);
        };
        $example("hello");

        // 输出
        Car bmw is running
        string(11) "hello world"
    ```

### 使用bindTo
- 复制当前闭包对象,绑定指定的$this对象和类作用域
- eg
    ```php
        class A {
            private $a = 12;
            private function getA () {
                return $this->a;
            }
        }

        class B {
            private $b = 34;
            private function getB () {
                return $this->b;
            }
        }
        $a = new A();
        $b = new B();
        $c = function () {
            if (property_exists($this, "a") && method_exists($this, "getA")) {
                $this->a++;
                return $this->getA();
            }

            if (property_exists($this, "b") && method_exists($this, "getB")) {
                $this->b++;
                return $this->getB();
            }
        };
        $ca = $c->bindTo($a, $a);
        $cb = $c->bindTo($b, $b);
        echo $ca(), "\n";
        echo $cb(), "\n";

        // 输出结果
        13
        35
    ```

