---
title: Python_基础 (138)
date: 2021-10-20
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 我的内存为啥已经用完了 怀疑是自己代码问题, 准备优化自己代码

#### 背景知识 & IO操作的类型
> python文件读写文件是最常见的IO操作. Python内置了读写文件的函数, 用法和C是兼容的. 
读写文件前, 我们先必须了解一下, 在磁盘上读写文件的功能都是由操作系统提供的, 现代操作系统不允许普通的程序直接操作磁盘. 
读写文件就是请求操作系统打开一个文件对象(通常称为文件描述符), 然后, 通过操作系统提供的接口从这个文件对象中读取数据(读文件), 或者把数据写入这个文件对象(写文件)
- 常见的IO操作的类型
    <table><thead><tr><th>type</th><th align="left">info</th></tr></thead><tbody><tr><td>r</td><td align="left">以只读方式打开文件. 文件的指针将会放在文件的开头. 这是默认模式. </td></tr><tr><td>w</td><td align="left">打开一个文件只用于写入. 如果该文件已存在则将其覆盖. 如果该文件不存在, 创建新文件. </td></tr><tr><td>a</td><td align="left">打开一个文件用于追加. 如果该文件已存在, 文件指针将会放在文件的结尾. 也就是说, 新的内容将会被写入到已有内容之后. 如果该文件不存在, 创建新文件进行写入. </td></tr><tr><td>rb</td><td align="left">以二进制格式打开一个文件用于只读. 文件指针将会放在文件的开头. 这是默认模式. </td></tr><tr><td>wb</td><td align="left">以二进制格式打开一个文件只用于写入. 如果该文件已存在则将其覆盖. 如果该文件不存在, 创建新文件. </td></tr><tr><td>ab</td><td align="left">以二进制格式打开一个文件用于追加. 如果该文件已存在, 文件指针将会放在文件的结尾. 也就是说, 新的内容将会被写入到已有内容之后. 如果该文件不存在, 创建新文件进行写入. </td></tr><tr><td>r+</td><td align="left">打开一个文件用于读写. 文件指针将会放在文件的开头. </td></tr><tr><td>w+</td><td align="left">打开一个文件用于读写. 如果该文件已存在则将其覆盖. 如果该文件不存在, 创建新文件. </td></tr><tr><td>a+</td><td align="left">打开一个文件用于读写. 如果该文件已存在, 文件指针将会放在文件的结尾. 文件打开时会是追加模式. 如果该文件不存在, 创建新文件用于读写. </td></tr><tr><td>rb+</td><td align="left">以二进制格式打开一个文件用于读写. 文件指针将会放在文件的开头. </td></tr><tr><td>wb+</td><td align="left">以二进制格式打开一个文件用于读写. 如果该文件已存在则将其覆盖. 如果该文件不存在, 创建新文件. </td></tr><tr><td>ab+</td><td align="left">以二进制格式打开一个文件用于追加. 如果该文件已存在, 文件指针将会放在文件的结尾. 如果该文件不存在, 创建新文件用于读写. </td></tr></tbody></table>

#### 读取文件
- 传统方式
    ```python
        try:
            # r表示读取文件, 我们就成功地打开了一个文件
            # 如果文件不存在, open()函数就会抛出一个IOError的错误, 并且给出错误码和详细的信息告诉你文件不存在
            f = open('/path/to/file', 'r')
            # 调用read()方法可以一次读取文件的全部内容, Python把内容读到内存
            print(f.read())
        finally:
            # 为了保证无论是否出错都能正确地关闭文件
            if f:
                # 文件使用完毕后必须关闭, 因为文件对象会占用操作系统的资源, 并且操作系统同一时间能打开的文件数量也是有限的
                f.close()
    ```
- 推荐方式
    ```python
        # with 的作用就是自动调用close()方法 
        with open('/path/to/file', 'r') as f:
            print(f.read())
            # f.read():  读取全部文件内容
            # f.read(size): 每次读取size个字节内容
            # f.readline(): 每次读取一行的内容
            # f.readlines(): 读取全部内容, 但结果是个list, 每行内容是一个元素

        # 同时打开多个文件
        With open('1.txt') as f1, open('2.txt') as  f2:
            do something
    ```
    * 注意
        * 调用read()会一次性读取文件的全部内容, 如果文件有10G, 内存就爆了. 
        * 要保险起见, 可以反复调用read(size)方法, 每次最多读取size个字节的内容. 例如, read(1024) 每次读取1024个字节的数据内容
        * 调用readline()可以每次读取一行内容, 调用readlines()一次读取所有内容并按行返回list. 因此, 要根据需要决定怎么调用. 
        * 如果文件很小, read()一次性读取最方便；如果不能确定文件大小, 反复调用read(size)比较保险；如果是配置文件, 调用readlines()最方便
        * 跳过第一行可以直接用 next(f)
- 打开非utf8编码文件
    ```python
        with open('/Users/michael/gbk.txt', 'r', encoding='gbk') as f:
            f.read()

        # 遇到有些编码不规范的文件, 你可能会遇到UnicodeDecodeError, 因为在文本文件中可能夹杂了一些非法编码的字符. 
        # open()函数还接收一个errors参数, errors=‘ignore’ 表示遇到编码错误的时候直接忽略
        with open('/Users/michael/gbk.txt', 'r', encoding='gbk',errors='ignore') as f:
            f.read()
    ```

#### 写入文件
- 传统方式
    ```python
        f = open('/Users/michael/test.txt', 'w')
        f.write('Hello, world!')
        f.close()
    ```
    * Notice
        * 你可以反复调用write()来写入文件, 但是务必要调用f.close()来关闭文件
        * 当我们写文件时, 操作系统往往不会立刻把数据写入磁盘, 而是放到内存缓存起来, 空闲的时候再慢慢写入
        * 只有调用close()方法时, 操作系统才保证把没有写入的数据全部写入磁盘. 忘记调用close()的后果是数据可能只写了一部分到磁盘, 剩下的丢失了. 所以, 还是用with语句来得保险
- 推荐方式
    ```python
        with open('/Users/michael/test.txt', 'w') as f:
            f.write('Hello, world!')
    ```

#### with open底层
> with语句的底层, 其实是很通用的结构, 允许使用上下文管理器(context manager). 上下文管理器实际是指一种支持__enter__和__exit__这两个方法的对象: 
enter 方法是不带参数的, 它会在进入with语句块时被调用, 即将其返回值绑定到as关键字之后的变量上；
exit 方法则带有3个参数: 异常类型、异常对象和异常回溯. 在离开方法时这个函数会被调用(带有通过参数提供的, 可以引发的异常). 如果__exit__返回的是false, 那么所有的异常都将不被处理；
- eg
    ```python
        class OperateTest(object):
            def open(self):
                print("此处打开文件了！")
                
            def close(self):
                print("此处关闭文件了！")
                
            def operate(self, txt_file):
                print("文件处理中！%s" % txt_file)
                
            def __enter__(self):
                self.open()
                return self
                
            def __exit__(self, exc_type, exc_val, exc_tb):
                self.close()
                
        with OperateTest() as fp:
            fp.operate("text_file")

        # 运行结果
        此处打开文件了！
        文件处理中！text_file
        此处关闭文件了！
    ```

