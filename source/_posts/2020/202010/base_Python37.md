---
title: Python_基础 (37)
date: 2020-10-21
tags: Python
toc: true
---

### 重新开始学Python
    之前学都是业务的, 现在要用到工作中了！！！

<!-- more -->

#### 第一个Python3.x程序
- Hello World
    ```bash
        $ cat helloWorld.py
        #!/usr/bin/python3 是告诉操作系统执行这个脚本的时候, 调用 /usr/bin 下的 python3 解释器；
        #!/usr/bin/env python3 这种用法是为了防止操作系统用户没有将 python3 装在默认的 /usr/bin 路径里.当系统看到这一行的时候, 首先会到 env 设置里查找 python3 的安装路径, 再调用对应路径下的解释器程序完成操作.
        #!/usr/bin/python3 相当于写死了 python3 路径;
        #!/usr/bin/env python3 会去环境设置寻找 python3 目录, 推荐这种写法

        print("Hello, World!")

        $ python3 helloWorld.py
        Hello, World!
    ```

#### Python3 基础语法
- 编码
    * 默认选择UTF-8, 
- 标识符
    * 第一个字符必须是字母表中字母或下划线 _ 
    * 标识符的其他的部分由字母、数字和下划线组成.
    * 标识符对大小写敏感
- python保留字
    ```python
        >>> import keyword
        >>> keyword.kwlist
        ['False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']
    ```
- 注释
    * 单行用#
    * 多行用多个# 或者 ''' 和 """
- 行与缩进
    * python最具特色的就是使用缩进来表示代码块, 不需要使用大括号 {} 
    * 缩进的空格数是可变的, 但是同一个代码块的语句必须包含相同的缩进空格数
- 多行语句
    * Python 通常是一行写完一条语句, 但如果语句很长, 我们可以使用反斜杠(\)来实现多行语句
- 数字(Number)类型
    * int (整数), 如 1, 只有一种整数类型 int, 表示为长整型, 没有 python2 中的 Long.
    * bool (布尔), 如 True.
    * float (浮点数), 如 1.23、3E-2
    * complex (复数), 如 1 + 2j、 1.1 + 2.2j
- 字符串(String)
    * python中单引号和双引号使用完全相同.
    * 使用三引号('''或""")可以指定一个多行字符串.
    * 转义符 '\'
    * 反斜杠可以用来转义, 使用r可以让反斜杠不发生转义.. 如 r"this is a line with \n" 则\n会显示, 并不是换行.
    * 按字面意义级联字符串, 如"this " "is " "string"会被自动转换为this is string.
    * 字符串可以用 + 运算符连接在一起, 用 * 运算符重复.
    * Python 中的字符串有两种索引方式, 从左往右以 0 开始, 从右往左以 -1 开始.
    * Python中的字符串不能改变.
    * Python 没有单独的字符类型, 一个字符就是长度为 1 的字符串.
    * 字符串的截取的语法格式如下: 变量[头下标:尾下标:步长]
- Print 输出
    * print 默认输出是换行的, 如果要实现不换行需要在变量末尾加上 end="": 



