---
title: Python_基础 (14)
date: 2018-12-25
tags: Python
toc: true
---

### Python3循环语句
    Python3学习笔记

<!-- more -->

#### while循环
- 格式
    ```python
        while 判断条件: 
            语句
    ```
- 注意
    * 注意冒号和缩进
    * 在Python中没有do..while循环

#### 无限循环
    设置条件表达式永远不为 false 来实现无限循环
    可以使用 CTRL+C 来退出当前的无限循环
- eg
    ```python
        #!/usr/bin/python
 
        flag = 1

        try:
            while (flag): print ('欢迎访问菜鸟教程!')
        except KeyboardInterrupt:
            print("是你自己点的退出哦")
            print ("Good bye!")
    ```

#### while循环使用else语句
    在 while … else 在条件语句为 false 时执行 else 的语句块

#### for语句
- 格式
    ```python
        for <variable> in <sequence>:
            <statements>
        else:
            <statements>
    ```

#### range()函数
    遍历数字序列生成数列

#### demo1
- 说明
    * 1-100的和
- 代码
    ```python
        #!/usr/bin/env python3

        n = 0
        sum = 0
        for n in range(0,101):# n 范围 0-100
            sum += n
        print(sum)
    ```
    ```python
        #!/usr/bin/env python3
        print(sum(range(101)))
    ```

#### demo2
- 说明
    * 99乘法表
- 代码
    ```python
        #!/usr/bin/python3

        #外边一层循环控制行数
        #i是行数
        i=1
        while i<=9:
            #里面一层循环控制每一行中的列数
            j=1
            while j<=i:
                mut =j*i
                print("%d*%d=%d"%(j,i,mut), end="  ")
                j+=1
            print("")
            i+=1
    ```

#### demo3
- 说明
    * 反向99乘法表
- 代码
    ```python
        #!/usr/bin/python3
        
        for i in range(9,0,-1):
            for j in range (1,i):
                print("\t",end="")
                for k in range (i,10):
                    print("%dx%d=%d" % (i,k,k*i), end="\t")
        print()
    ```


