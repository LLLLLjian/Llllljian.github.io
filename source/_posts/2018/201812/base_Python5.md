---
title: Python_基础 (5)
date: 2018-12-12
tags: Python
toc: true
---

### Python3运算符
    Python学习笔记

<!-- more -->

#### 逻辑运算符
- list
    <table class="reference"><tbody><tr><th>运算符</th><th>逻辑表达式</th><th>描述</th><th>实例</th></tr><tr><th align="center" valign="middle" colspan="4">假设a为10,变量b为20</th></tr><tr><td>and</td><td>x and y</td><td> 布尔"与" - 如果 x 为 False,x and y 返回 False,否则它返回 y 的计算值.</td><td> (a and b) 返回 20.</td></tr><tr><td>or</td><td>x or y</td><td>布尔"或" - 如果 x 是 True,它返回 x 的值,否则它返回 y 的计算值.</td><td> (a or b) 返回 10.</td></tr><tr><td>not</td><td>not x</td><td>布尔"非" - 如果 x 为 True,返回 False .如果 x 为 False,它返回 True.</td><td> not(a and b) 返回 False</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 10
        b = 20
        
        if ( a and b ):
        print ("1 - 变量 a 和 b 都为 true")
        else:
        print ("1 - 变量 a 和 b 有一个不为 true")
        
        if ( a or b ):
        print ("2 - 变量 a 和 b 都为 true,或其中一个变量为 true")
        else:
        print ("2 - 变量 a 和 b 都不为 true")
        
        # 修改变量 a 的值
        a = 0
        if ( a and b ):
        print ("3 - 变量 a 和 b 都为 true")
        else:
        print ("3 - 变量 a 和 b 有一个不为 true")
        
        if ( a or b ):
        print ("4 - 变量 a 和 b 都为 true,或其中一个变量为 true")
        else:
        print ("4 - 变量 a 和 b 都不为 true")
        
        if not( a and b ):
        print ("5 - 变量 a 和 b 都为 false,或其中一个变量为 false")
        else:
        print ("5 - 变量 a 和 b 都为 true")

        # 输出结果：

        1 - 变量 a 和 b 都为 true
        2 - 变量 a 和 b 都为 true,或其中一个变量为 true
        3 - 变量 a 和 b 有一个不为 true
        4 - 变量 a 和 b 都为 true,或其中一个变量为 true
        5 - 变量 a 和 b 都为 false,或其中一个变量为 false
    ```

#### 位运算符
- list
    <table class="reference"><tbody><tr><th>运算符</th><th>描述</th><th>实例</th></tr><tr><th align="center" valign="middle" colspan="3">假设a为60,变量b为13</th></tr><tr><td>&amp;</td><td>按位与运算符：参与运算的两个值,如果两个相应位都为1,则该位的结果为1,否则为0</td><td> (a &amp; b) 输出结果 12 ,二进制解释： 0000 1100</td></tr><tr><td>|</td><td> 按位或运算符：只要对应的二个二进位有一个为1时,结果位就为1.</td><td> (a | b) 输出结果 61 ,二进制解释： 0011 1101</td></tr><tr><td>^</td><td>按位异或运算符：当两对应的二进位相异时,结果为1</td><td> (a ^ b) 输出结果 49 ,二进制解释： 0011 0001</td></tr><tr><td>~</td><td> 按位取反运算符：对数据的每个二进制位取反,即把1变为0,把0变为1.<span class="marked">~x</span> 类似于<span class="marked">-x-1</span></td><td> (~a ) 输出结果 -61 ,二进制解释： 1100 0011, 在一个有符号二进制数的补码形式.</td></tr><tr><td>&lt;&lt;</td><td>左移动运算符：运算数的各二进位全部左移若干位,由"&lt;&lt;"右边的数指定移动的位数,高位丢弃,低位补0.</td><td> a &lt;&lt; 2 输出结果 240 ,二进制解释： 1111 0000</td></tr><tr><td>&gt;&gt;</td><td>右移动运算符：把"&gt;&gt;"左边的运算数的各二进位全部右移若干位,"&gt;&gt;"右边的数指定移动的位数</td><td> a &gt;&gt; 2 输出结果 15 ,二进制解释： 0000 1111</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 60            # 60 = 0011 1100 
        b = 13            # 13 = 0000 1101 
        c = 0
        
        c = a & b;        # 12 = 0000 1100
        print ("1 - c 的值为：", c)
        
        c = a | b;        # 61 = 0011 1101 
        print ("2 - c 的值为：", c)
        
        c = a ^ b;        # 49 = 0011 0001
        print ("3 - c 的值为：", c)
        
        c = ~a;           # -61 = 1100 0011
        print ("4 - c 的值为：", c)
        
        c = a << 2;       # 240 = 1111 0000
        print ("5 - c 的值为：", c)
        
        c = a >> 2;       # 15 = 0000 1111
        print ("6 - c 的值为：", c)

        # 输出结果：

        1 - c 的值为： 12
        2 - c 的值为： 61
        3 - c 的值为： 49
        4 - c 的值为： -61
        5 - c 的值为： 240
        6 - c 的值为： 15
    ```

#### 成员运算符
- list
    <table class="reference"><tbody><tr><th>运算符</th><th>描述</th><th>实例</th></tr><tr><td>in</td><td>如果在指定的序列中找到值返回 True,否则返回 False.</td><td> x 在 y 序列中 , 如果 x 在 y 序列中返回 True.</td></tr><tr><td>not in</td><td>如果在指定的序列中没有找到值返回 True,否则返回 False.</td><td>x 不在 y 序列中 , 如果 x 不在 y 序列中返回 True.</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 10
        b = 20
        list = [1, 2, 3, 4, 5 ];
        
        if ( a in list ):
            print ("1 - 变量 a 在给定的列表中 list 中")
        else:
            print ("1 - 变量 a 不在给定的列表中 list 中")
        
        if ( b not in list ):
            print ("2 - 变量 b 不在给定的列表中 list 中")
        else:
            print ("2 - 变量 b 在给定的列表中 list 中")
        
        # 修改变量 a 的值
        a = 2
        if ( a in list ):
            print ("3 - 变量 a 在给定的列表中 list 中")
        else:
            print ("3 - 变量 a 不在给定的列表中 list 中")
        
        # 输出结果：

        1 - 变量 a 不在给定的列表中 list 中
        2 - 变量 b 不在给定的列表中 list 中
        3 - 变量 a 在给定的列表中 list 中
    ```

#### 身份运算符
- list
    <table class="reference"><tbody><tr><th width="10%">运算符</th><th>描述</th><th>实例</th></tr><tr><td>is</td><td>is 是判断两个标识符是不是引用自一个对象</td><td><strong>x is y</strong>, 类似<strong>id(x) == id(y)</strong> , 如果引用的是同一个对象则返回 True,否则返回 False</td></tr><tr><td>is not</td><td>is not 是判断两个标识符是不是引用自不同对象</td><td><strong> x is not y</strong> , 类似<strong>id(a) != id(b)</strong>.如果引用的不是同一个对象则返回结果 True,否则返回 False.</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 20
        b = 20
        
        if ( a is b ):
            print ("1 - a 和 b 有相同的标识")
        else:
            print ("1 - a 和 b 没有相同的标识")
        
        if ( id(a) == id(b) ):
            print ("2 - a 和 b 有相同的标识")
        else:
            print ("2 - a 和 b 没有相同的标识")
        
        # 修改变量 b 的值
        b = 30
        if ( a is b ):
            print ("3 - a 和 b 有相同的标识")
        else:
            print ("3 - a 和 b 没有相同的标识")
        
        if ( a is not b ):
            print ("4 - a 和 b 没有相同的标识")
        else:
            print ("4 - a 和 b 有相同的标识")
        
        # 输出结果：

        1 - a 和 b 有相同的标识
        2 - a 和 b 有相同的标识
        3 - a 和 b 没有相同的标识
        4 - a 和 b 没有相同的标识
    ```


