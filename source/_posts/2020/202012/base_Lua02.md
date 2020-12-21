---
title: Lua_基础 (02)
date: 2020-12-02
tags: Lua
toc: true
---

### 快来跟我一起学Lua
    快来学Lua

<!-- more -->

#### Lua 变量
> 变量在使用前，需要在代码中进行声明，即创建该变量。
编译程序执行代码之前编译器需要知道如何给语句变量开辟存储区，用于存储变量的值。
Lua 变量有三种类型：全局变量、局部变量、表中的域。
Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 local 显式声明为局部变量。
局部变量的作用域为从声明位置开始到所在语句块结束。
变量的默认值均为 nil。
- 理解一下上边那段话
    ```lua
        -- 20201202_1.lua 文件脚本
        a = 5               -- 全局变量
        local b = 5         -- 局部变量

        function joke()
            c = 5           -- 全局变量
            local d = 6     -- 局部变量
        end

        joke()
        print(c,d)          --> 5 nil

        do
            local a = 6     -- 局部变量
            b = 6           -- 对局部变量重新赋值
            print(a,b);     --> 6 6
        end

        print(a,b)      --> 5 6

        --[[
        $ lua 20201202_1.lua
        5       nil
        6       6
        5       6
        ]]--
    ```

#### 赋值语句
> 赋值是改变一个变量的值和改变表域的最基本的方法。
Lua 可以对多个变量同时赋值，变量列表和值列表的各个元素用逗号分开，赋值语句右边的值会依次赋给左边的变量。
遇到赋值语句Lua会先计算右边所有的值然后再执行赋值操作，所以我们可以这样进行交换变量的值
当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：
a. 变量个数 > 值的个数             按变量个数补足nil
b. 变量个数 < 值的个数             多余的值会被忽略
- 理解一下上边那段话
    ```lua
        a, b, c = 0, 1
        print(a,b,c)             --> 0   1   nil
        
        a, b = a+1, b+1, b+2     -- value of b+2 is ignored
        print(a,b)               --> 1   2
        
        a, b, c = 0
        print(a,b,c)             --> 0   nil   nil

        a, b, c = 0, 0, 0
        print(a,b,c)             --> 0   0   0
    ```

#### Lua 函数
> 在Lua中，函数是对语句和表达式进行抽象的主要方法。既可以用来处理一些特殊的工作，也可以用来计算一些值。
Lua 提供了许多的内建函数，你可以很方便的在程序中调用它们，如print()函数可以将传入的参数打印在控制台上。
Lua 函数主要有两种用途：
1.完成指定的任务，这种情况下函数作为调用语句使用；
2.计算并返回值，这种情况下函数作为赋值语句的表达式使用。
- 函数定义
    * Lua 编程语言函数定义格式如下：
    ```lua
        optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
            function_body
            return result_params_comma_separated
        end
    ```
    * optional_function_scope: 该参数是可选的制定函数是全局函数还是局部函数，未设置该参数默认为全局函数，如果你需要设置函数为局部函数需要使用关键字 local。
    * function_name: 指定函数名称。
    * argument1, argument2, argument3..., argumentn: 函数参数，多个参数以逗号隔开，函数也可以不带参数。
    * function_body: 函数体，函数中需要执行的代码语句块。
    * result_params_comma_separated: 函数返回值，Lua语言函数可以返回多个值，每个值以逗号隔开。
- 理解一下上边那段话
    ```lua
        function maximum (a)
            local mi = 1             -- 最大值索引
            local m = a[mi]          -- 最大值
            for i,val in ipairs(a) do
            if val > m then
                mi = i
                m = val
            end
            end
            return m, mi
        end

        print(maximum({8,10,23,12,5}))
        -- 23    3
    ```


