---
title: Interview_总结 (170)
date: 2022-05-14
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 简述 with 方法打开处理文件帮我我们做了什么

with 语句适用于对资源进行访问的场合,确保不管使用过程中是否发生异常都会执行必要的“清理”操作,释放资源,比如文件使用后自动关闭、线程中锁的自动获取和释放等.

with语句即“上下文管理器”,在程序中用来表示代码执行过程中所处的前后环境 上下文管理器：含有enter和exit方法的对象就是上下文管理器.

enter()：在执行语句之前,首先执行该方法,通常返回一个实例对象,如果with语句有as目标,则将对象赋值给as目标.

exit()：执行语句结束后,自动调用exit()方法,用户释放资源,若此方法返回布尔值True,程序会忽略异常. 使用环境：文件读写、线程锁的自动释放等.

#### 深浅拷贝

copy 仅拷贝对象本身,而不拷贝对象中引用的其它对象.

deepcopy 除拷贝对象本身,而且拷贝对象中引用的其它对象.(子对象)

#### w、a+、wb 文件写入模式的区别

r : 读取文件,若文件不存在则会报错
w: 写入文件,若文件不存在则会先创建再写入,会覆盖原文件
a : 写入文件,若文件不存在则会先创建再写入,但不会覆盖原文件,而是追加在文件末尾
rb,wb：分别于r,w类似,用于读写二进制文件
r+ : 可读、可写,文件不存在也会报错,写操作时会覆盖
w+ : 可读,可写,文件不存在先创建,会覆盖
a+ ：可读、可写,文件不存在先创建,不会覆盖,追加在末尾

#### 可变类型和不可变类型
1. 可变类型有list,dict.不可变类型有string,number,tuple.

2. 当进行修改操作时,可变类型传递的是内存中的地址,也就是说,直接修改内存中的值,并没有开辟新的内存.

3. 不可变类型被改变时,并没有改变原内存地址中的值,而是开辟一块新的内存,将原地址中的值复制过去,对这块新开辟的内存中的值进行操作.

#### 求列表偶数
- code
    ```python
        a = [1,2,3,4,5,6,7,8,9,10]
        res = [ i for i in a if i%2==0]
        res1 = a[1::2]
        x = lambda m: m % 2 == 0
        res2 = list(filter(x, a))
        print(res)
        print(res1)
        print(res2)
    ```

#### list[dict1, dict2]去重
- code
    ```python
        from functools import reduce
        a = [{"a":123,"b":342},{"a":213,"b":231},{"a":123,"b":221},{"a":123,"b":342}]

        def delete_duplicate(data):
            func = lambda x, y: x + [y] if y not in x else x
            data = reduce(func, [[], ] + data)
            return data
        print(delete_duplicate(a))
    ```

#### 现有字典 d= {'a':24,'g':52,'i':12,'k':33}请按value值进行排序
- code
    ```python
        sorted(d.items(),key=lambda x:x[1])
    ```


