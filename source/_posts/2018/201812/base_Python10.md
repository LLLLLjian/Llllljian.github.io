---
title: Python_基础 (10)
date: 2018-12-19
tags: Python
toc: true
---

### Python3元组
    Python3学习笔记

<!-- more -->

#### 元组与列表区别
    元组的元素不能修改

#### 元组创建
    在括号中添加元素，并使用逗号隔开
- eg
    ```python
        三种元组方式
        tuple1:
        tup1 = ('Google', 'Runoob', 1997, 2000);

        tuple2:
        tup2 = (1, 2, 3, 4, 5 );

        tuple3:
        tup3 = "a", "b", "c", "d";

        空元组
        tup4 = ();
    ```
- 注意的点
    * 元组中只包含一个元素时，需要在元素后面添加逗号，否则括号会被当作运算符使用
    * eg
        ```python
            >>>tup1 = (50)
            >>> type(tup1)     # 不加逗号，类型为整型
            <class 'int'>
            
            >>> tup1 = (50,)
            >>> type(tup1)     # 加上逗号，类型为元组
            <class 'tuple'>
        ```
        
#### 访问元组
    使用下标索引来访问元组中的值
- eg
    ```python
        #!/usr/bin/python3
 
        tup1 = ('Google', 'llllljian', 1997, 2000)
        tup2 = (1, 2, 3, 4, 5, 6, 7 )
        
        print ("tup1[0]: ", tup1[0])
        print ("tup2[1:5]: ", tup2[1:5])

        输出结果：
        tup1[0]:  Google
        tup2[1:5]:  (2, 3, 4, 5)
    ```

#### 元组连接
    直接使用+进行连接
- eg
    ```python
        #!/usr/bin/python3
 
        tup1 = (12, 34.56);
        tup2 = ('abc', 'xyz')
        
        # 创建一个新的元组
        tup3 = tup1 + tup2;
        print (tup3)

        输出结果：
        (12, 34.56, 'abc', 'xyz')
    ```

#### 删除元组
    不能删除单个，但使用del语句来删除整个元组
- eg
    ```python
        #!/usr/bin/python3
 
        tup = ('Google', 'Runoob', 1997, 2000)
        
        print (tup)
        del tup;
    ```

#### 元组运算符
- list
    <table class="reference"><tbody><tr><th style="width:33%">Python 表达式</th><th style="width:33%">结果</th><th style="width:33%"> 描述</th></tr><tr><td>len((1, 2, 3))</td><td>3</td><td>计算元素个数</td></tr><tr><td>(1, 2, 3) + (4, 5, 6)</td><td>(1, 2, 3, 4, 5, 6)</td><td>连接</td></tr><tr><td>('Hi!',) * 4</td><td>('Hi!', 'Hi!', 'Hi!', 'Hi!')</td><td>复制</td></tr><tr><td>3 in (1, 2, 3)</td><td>True</td><td>元素是否存在</td></tr><tr><td>for x in (1, 2, 3): print (x,)</td><td>1 2 3</td><td>迭代</td></tr></tbody></table>


#### 元组索引\截取
- list
    <table class="reference"><tbody><tr><th style="width:33%">Python 表达式</th><th style="width:33%">结果</th><th style="width:33%"> 描述</th></tr><tr><th colspan="2">L = ('llllljian0', 'llllljian1', 'llllljian2')</th></tr><tr><td>L[2]</td><td>'llllljian2'</td><td>读取第三个元素</td></tr><tr><td>L[-2]</td><td>'llllljian1'</td><td>反向读取；读取倒数第二个元素</td></tr><tr><td>L[1:]</td><td>('llllljian1', 'llllljian2')</td><td>截取元素，从第二个开始后的所有元素。</td></tr></tbody></table>

##### 元组内置函数
- list
    <table class="reference"><tbody><tr><th style="width:25%">方法及描述</th><th style="width:45%">实例</th></tr><tr><td>len(tuple)<br>计算元组元素个数。</td><td><pre class="prettyprint">&gt;&gt;&gt; tuple1 = ('Google', 'Runoob', 'Taobao')&gt;&gt;&gt; len(tuple1)3&gt;&gt;&gt;</pre></td></tr><tr><td>max(tuple)<br>返回元组中元素最大值。</td><td><pre class="prettyprint">&gt;&gt;&gt; tuple2 = ('5', '4', '8')&gt;&gt;&gt; max(tuple2)'8'&gt;&gt;&gt;</pre></td></tr><tr><td>min(tuple)<br>返回元组中元素最小值。</td><td><pre class="prettyprint">&gt;&gt;&gt; tuple2 = ('5', '4', '8')&gt;&gt;&gt; min(tuple2)'4'&gt;&gt;&gt;</pre></td></tr><tr><td>tuple(seq)<br>将列表转换为元组。</td><td><pre class="prettyprint">&gt;&gt;&gt; list1= ['Google', 'Taobao', 'Runoob', 'Baidu']&gt;&gt;&gt; tuple1=tuple(list1)&gt;&gt;&gt; tuple1('Google', 'Taobao', 'Runoob', 'Baidu')</pre></td></tr></tbody></table>


