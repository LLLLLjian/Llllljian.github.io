---
title: Python_基础 (18)
date: 2018-12-29
tags: Python
toc: true
---

### Python3文件对象
    Python3学习笔记

<!-- more -->

#### 前提
    假设已经创建了一个称为f的文件对象

#### f.read()
- 功能
    * 读取一个文件的内容
- 格式
    * f.read(size)
- 参数说明
    * size 是一个可选的数字类型的参数
    * 当 size 被忽略了或者为负, 那么该文件的所有内容都将被读取并且返回
- eg
    ```python
        #!/usr/bin/python3

        # 打开一个文件
        f = open("/tmp/foo.txt", "r")

        str = f.read()
        print(str)

        # 关闭打开的文件
        f.close()
    ```

#### f.readline()
- 功能
    * 从文件中读取单独的一行
    * 换行符为 '\n'
- 格式
    * f.readline()
- eg
    ```python
        #!/usr/bin/python3

        # 打开一个文件
        f = open("/tmp/foo.txt", "r")

        str = f.readline()
        print(str)

        # 关闭打开的文件
        f.close()
    ```

#### f.readlines()
- 功能
    * 返回该文件中包含的所有行
- 格式
    * f.readlines()
- eg
    ```python
        #!/usr/bin/python3

        # 打开一个文件
        f = open("/tmp/foo.txt", "r")

        str = f.readlines()
        print(str)

        # 关闭打开的文件
        f.close()
    ```

#### f.write()
- 功能
    * 将字符串写入到文件中, 然后返回写入的字符数
- 格式
    * f.write(string)
- eg
    ```python
        #!/usr/bin/python3

        # 打开一个文件
        f = open("/tmp/foo.txt", "w")

        num = f.write( "Python 是一个非常好的语言.\n是的,的确非常好!!\n" )
        print(num)
        # 关闭打开的文件
        f.close()
    ```

#### f.close()
- 功能
    * 关闭文件并释放系统的资源,如果尝试再调用该文件,则会抛出异常
- 格式
    * f.close()

