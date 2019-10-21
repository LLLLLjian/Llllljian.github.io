---
title: Python_基础 (4)
date: 2018-12-11
tags: Python
toc: true
---

### Python3运算符
    Python学习笔记

<!-- more -->


#### 算术运算符
- list
    <table><tbody><tr><th>运算符</th><th>描述</th><th>实例</th></tr><tr><th align="center" valign="middle" colspan="3">假设a为10,变量b为21</th></tr><tr><td>+</td><td>加 - 两个对象相加</td><td> a + b 输出结果 31</td></tr><tr><td>-</td><td>减 - 得到负数或是一个数减去另一个数</td><td> a - b 输出结果 -11</td></tr><tr><td>\*</td><td>乘 - 两个数相乘或是返回一个被重复若干次的字符串</td><td> a * b 输出结果 210</td></tr><tr><td>/</td><td>除 - x 除以 y</td><td> b / a 输出结果 2.1</td></tr><tr><td>%</td><td>取模 - 返回除法的余数</td><td> b % a 输出结果 1</td></tr><tr><td>\**</td><td>幂 - 返回x的y次幂</td><td> a\**b 为10的21次方</td></tr><tr><td>//</td><td>取整除 - 向下取接近除数的整数</td><td> <pre class="prettyprint prettyprinted" style=""><span class="pun">&gt;&gt;&gt;</span><span class="pln"> </span><span class="lit">9</span><span class="com">//2</span><span class="pln"></span><br /><span class="lit">4</span><span class="pln"></span><br /><span class="pun">&gt;&gt;&gt;</span><span class="pln"> </span><span class="pun">-</span><span class="lit">9</span><span class="com">//2</span><span class="pln"></span><br /><span class="pun">-</span><span class="lit">5</span></pre></td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 21
        b = 10
        c = 0
        
        c = a + b
        print ("1 - c 的值为：", c)
        
        c = a - b
        print ("2 - c 的值为：", c)
        
        c = a * b
        print ("3 - c 的值为：", c)
        
        c = a / b
        print ("4 - c 的值为：", c)
        
        c = a % b
        print ("5 - c 的值为：", c)
        
        # 修改变量 a 、b 、c
        a = 2
        b = 3
        c = a**b 
        print ("6 - c 的值为：", c)
        
        a = 10
        b = 5
        c = a//b 
        print ("7 - c 的值为：", c)

        # 输出结果：
        1 - c 的值为： 31
        2 - c 的值为： 11
        3 - c 的值为： 210
        4 - c 的值为： 2.1
        5 - c 的值为： 1
        6 - c 的值为： 8
        7 - c 的值为： 2
    ```

#### 比较(关系)运算符
- list
    <table class="reference"><tbody><tr><th width="10%">运算符</th><th>描述</th><th>实例</th></tr><tr><th align="center" valign="middle" colspan="3">假设a为10,变量b为21</th><tr><td>==</td><td> 等于 - 比较对象是否相等</td><td> (a == b) 返回 False.</td></tr><tr><td>!=</td><td> 不等于 - 比较两个对象是否不相等</td><td> (a != b) 返回 True.</td></tr><tr><td>&gt;</td><td> 大于 - 返回x是否大于y</td><td> (a &gt; b) 返回 False.</td></tr><tr><td>&lt;</td><td> 小于 - 返回x是否小于y.所有比较运算符返回1表示真,返回0表示假.这分别与特殊的变量True和False等价.注意,这些变量名的大写.</td><td> (a &lt; b) 返回 True.</td></tr><tr><td>&gt;=</td><td> 大于等于 - 返回x是否大于等于y.</td><td> (a &gt;= b) 返回 False.</td></tr><tr><td>&lt;=</td><td> 小于等于 - 返回x是否小于等于y.</td><td> (a &lt;= b) 返回 True.</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 21
        b = 10
        c = 0
        
        if ( a == b ):
        print ("1 - a 等于 b")
        else:
        print ("1 - a 不等于 b")
        
        if ( a != b ):
        print ("2 - a 不等于 b")
        else:
        print ("2 - a 等于 b")
        
        if ( a < b ):
        print ("3 - a 小于 b")
        else:
        print ("3 - a 大于等于 b")
        
        if ( a > b ):
        print ("4 - a 大于 b")
        else:
        print ("4 - a 小于等于 b")
        
        # 修改变量 a 和 b 的值
        a = 5;
        b = 20;
        if ( a <= b ):
        print ("5 - a 小于等于 b")
        else:
        print ("5 - a 大于  b")
        
        if ( b >= a ):
        print ("6 - b 大于等于 a")
        else:
        print ("6 - b 小于 a")

        # 输出结果：

        1 - a 不等于 b
        2 - a 不等于 b
        3 - a 大于等于 b
        4 - a 大于 b
        5 - a 小于等于 b
        6 - b 大于等于 a
    ```

#### 赋值运算符
- list
    <table class="reference"><tbody><tr><th>运算符</th><th>描述</th><th>实例</th></tr><tr><th align="center" valign="middle" colspan="3">假设a为10,变量b为21</th></tr><tr><td>=</td><td>简单的赋值运算符</td><td> c = a + b 将 a + b 的运算结果赋值为 c</td></tr><tr><td>+=</td><td>加法赋值运算符</td><td> c += a 等效于 c = c + a</td></tr><tr><td>-=</td><td>减法赋值运算符</td><td> c -= a 等效于 c = c - a</td></tr><tr><td>*=</td><td>乘法赋值运算符</td><td> c *= a 等效于 c = c * a</td></tr><tr><td>/=</td><td>除法赋值运算符</td><td> c /= a 等效于 c = c / a</td></tr><tr><td>%=</td><td>取模赋值运算符</td><td> c %= a 等效于 c = c % a</td></tr><tr><td>**=</td><td>幂赋值运算符</td><td> c **= a 等效于 c = c ** a</td></tr><tr><td>//=</td><td> 取整除赋值运算符</td><td> c //= a 等效于 c = c // a</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = 21
        b = 10
        c = 0
        
        c = a + b
        print ("1 - c 的值为：", c)
        
        c += a
        print ("2 - c 的值为：", c)
        
        c *= a
        print ("3 - c 的值为：", c)
        
        c /= a 
        print ("4 - c 的值为：", c)
        
        c = 2
        c %= a
        print ("5 - c 的值为：", c)
        
        c **= a
        print ("6 - c 的值为：", c)
        
        c //= a
        print ("7 - c 的值为：", c)

        # 输出结果：

        1 - c 的值为： 31
        2 - c 的值为： 52
        3 - c 的值为： 1092
        4 - c 的值为： 52.0
        5 - c 的值为： 2
        6 - c 的值为： 2097152
        7 - c 的值为： 99864
    ```

