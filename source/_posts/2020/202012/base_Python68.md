---
title: Python_基础 (68)
date: 2020-12-22
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    为啥要有个__init__.py

<!-- more -->

#### 引入问题
> 看到很多模块目录中会看到 "\__init__.py"  这个文件,那么它到底有什么作用呢

#### 作用
> 标识该目录是一个python的模块包(module package), 如果使用python的相关IDE来进行开发,那么如果目录中存在该文件,该目录就会被识别为module package

#### 一个普通的四则运算模块
- menu
    ```bash
        |____arithmetic
        | |____add.py
        | |____mul.py
        | |____sub.py
        | |____dev.py
        |____main.py
    ```
- result
    ```bash
        $ python3 main.py
        3 + 8 = 11
        3 - 8 = -5
        3 * 8 = 24
        3 / 8 = 0.375
    ```
- main.py
    ```bash
        $ cat main.py
        import arithmetic.add
        import arithmetic.sub as sub

        from arithmetic.mul import mul
        from arithmetic import dev


        def letscook(x, y, oper):
            r = 0
            if oper == "+":
                r = arithmetic.add.add(x, y)
            elif oper == "-":
                r = sub.sub(x, y)
            elif oper == "*":
                r = mul(x, y)
            else:
                r = dev.dev(x, y)

            print("{} {} {} = {}".format(x, oper, y, r))


        x, y = 3, 8

        letscook(x, y, "+")
        letscook(x, y, "-")
        letscook(x, y, "*")
        letscook(x, y, "/")
    ```
- add.py
    ```bash
        $ cat arithmetic/add.py
        #
        # @file add.py
        #

        def add(a, b):
            return a + b
    ```
- dev.py
    ```bash
        $ cat arithmetic/dev.py
        #
        # @file dev.py
        #

        def dev(a, b):
            return a / b
    ```
- mul.py
    ```bash
        $ cat arithmetic/mul.py
        #
        # @file mul.py
        #

        def mul(a, b):
            return a * b
    ```
- sub.py
    ```bash
        $ cat arithmetic/sub.py
        #
        # @file sub.py
        #

        def sub(a, b):
            return a - b
    ```

#### 利用__init__.py
- \__init__.py
    ```bash
        $ cat arithmetic/__init__.py
        #
        # @file __init__.py
        #

        import arithmetic.add
        import arithmetic.sub
        import arithmetic.mul
        import arithmetic.dev

        add = arithmetic.add.add
        sub = arithmetic.sub.sub
        mul = arithmetic.mul.mul
        dev = arithmetic.dev.dev
    ```
- main.py
    ```bash
        $ cat main.py
        #
        # @file main.py
        #

        import arithmetic as a4


        def letscook(x, y, oper):
            r = 0
            if oper == "+":
                r = a4.add(x, y)
            elif oper == "-":
                r = a4.sub(x, y)
            elif oper == "*":
                r = a4.mul(x, y)
            else:
                r = a4.dev(x, y)

            print("{} {} {} = {}".format(x, oper, y, r))


        x, y = 3, 8

        letscook(x, y, "+")
        letscook(x, y, "-")
        letscook(x, y, "*")
        letscook(x, y, "/")
    ```

#### __init__.py的设计原则
> \__init__.py的原始使命是声明一个模块,所以它可以是一个空文件.在__init__.py中声明的所有类型和变量,就是其代表的模块的类型和变量,第2小节就是利用这个原理,为四则运算的4个子模块声明了新的变量.我们在利用__init__.py时,应该遵循如下几个原则: 
1. 不要污染现有的命名空间.模块一个目的,是为了避免命名冲突,如果你在种用__init__.py时违背这个原则,是反其道而为之,就没有必要使用模块了.
2. 利用__init__.py对外提供类型、变量和接口,对用户隐藏各个子模块的实现.一个模块的实现可能非常复杂,你需要用很多个文件,甚至很多子模块来实现,但用户可能只需要知道一个类型和接口.就像我们的arithmetic例子中,用户只需要知道四则运算有add、sub、mul、dev四个接口,却并不需要知道它们是怎么实现的,也不想去了解arithmetic中是如何组织各个子模块的.由于各个子模块的实现有可能非常复杂,而对外提供的类型和接口有可能非常的简单,我们就可以通过这个方式来对用户隐藏实现,同时提供非常方便的使用.
3. 只在__init__.py中导入有必要的内容,不要做没必要的运算.像我们的例子,import arithmetic语句会执行__ini__.py中的所有代码.如果我们在__init__.py中做太多事情,每次import都会有额外的运算,会造成没有必要的开销.一句话,\__init__.py只是为了达到B中所表述的目的,其它事情就不要做啦


