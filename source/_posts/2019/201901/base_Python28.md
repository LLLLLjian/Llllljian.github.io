---
title: Python_基础 (28)
date: 2019-01-15
tags: Python
toc: true
---

### 内建模块re
    Python3学习笔记

<!-- more -->

#### re简介
    re模块使Python语言拥有全部的正则表达式功能

#### re.match
- 功能
    * 尝试从字符串的起始位置匹配一个模式,如果不是起始位置匹配成功的话,match()就返回none
- 语法
    * re.match(pattern, string, flags=0)
- 参数
    * pattern : 匹配的正则表达式
    * string : 要匹配的字符串
    * flags : 标志位,用于控制正则表达式的匹配方式
- eg
    ```python
        #!/usr/bin/python
 
        import re
        matchObj = re.match('www', 'www.baidu.com')  # 在起始位置匹配
        matchObj1 = re.match('com', 'www.baidu.com')         # 不在起始位置匹配

        if matchObj:
            print ("matchObj.group() : ", matchObj.group())
            print ("matchObj.span() : ", matchObj.span())
        else:
            print ("No match!!")
        
        if matchObj1:
            print ("matchObj.group() : ", matchObj1.group())
        else:
            print ("No match!!")

        E:\llllljian\python>python demo2_0115.py
        matchObj.group() :  www
        matchObj.span() :  (0, 3)
        No match!!
    ```
- eg1
    ```python
        #!/usr/bin/python3
        import re
        
        line = "Cats are smarter than dogs"
        # .* 表示任意匹配除换行符(\n、\r)之外的任何单个或多个字符
        matchObj = re.match( r'(.*) are (.*?) .*', line, re.M|re.I)
        
        if matchObj:
            print ("matchObj.groups() : ", matchObj.groups())
            print ("matchObj.group() : ", matchObj.group())
            print ("matchObj.group(1) : ", matchObj.group(1))
            print ("matchObj.group(2) : ", matchObj.group(2))
        else:
            print ("No match!!")

        E:\llllljian\python>python demo3_0115.py
        matchObj.groups() :  ('Cats', 'smarter')
        matchObj.group() :  Cats are smarter than dogs
        matchObj.group(1) :  Cats
        matchObj.group(2) :  smarter
    ```

#### re.search
- 功能
    * 扫描整个字符串并返回第一个成功的匹配
- 语法
    * re.search(pattern, string, flags=0)
- 参数
    * pattern : 匹配的正则表达式
    * string : 要匹配的字符串
    * flags : 标志位,用于控制正则表达式的匹配方式
- eg
    ```python
        #!/usr/bin/python3
 
        import re
        
        print(re.search('www', 'www.www.baidu.com.com').span())
        print(re.search('com', 'www.www.baidu.com.com').span())

        E:\llllljian\python>python demo4_0115.py
        (0, 3)
        (14, 17)
    ```
- eg1
    ```python
        #!/usr/bin/python3
        import re
        
        line = "Cats are smarter than dogs";
        
        searchObj = re.search( r'(.*) are (.*?) .*', line, re.M|re.I)
        
        if searchObj:
            print ("searchObj.group() : ", searchObj.group())
            print ("searchObj.group(1) : ", searchObj.group(1))
            print ("searchObj.group(2) : ", searchObj.group(2))
        else:
            print ("Nothing found!!")

        E:\llllljian\python>python demo5_0115.py
        searchObj.group() :  Cats are smarter than dogs
        searchObj.group(1) :  Cats
        searchObj.group(2) :  smarter
    ```

#### re.match与re.search的区别
    re.match只匹配字符串的开始,如果字符串开始不符合正则表达式,则匹配失败,函数返回None；而re.search匹配整个字符串,直到找到一个匹配
- eg
    ```python
        #!/usr/bin/python3

        import re
        
        line = "Cats are smarter than dogs";
        
        matchObj = re.match( r'dogs', line, re.M|re.I)
        if matchObj:
            print ("match --> matchObj.group() : ", matchObj.group())
        else:
            print ("No match!!")
        
        matchObj = re.search( r'dogs', line, re.M|re.I)
        if matchObj:
            print ("search --> matchObj.group() : ", matchObj.group())
        else:
            print ("No match!!")

        E:\llllljian\python>python demo6_0115.py
        No match!!
        search --> matchObj.group() :  dogs
    ```

#### re.sub
- 功能
    * 替换字符串中的匹配项
- 语法
    * re.sub(pattern, repl, string, count=0)
- 参数
    * pattern : 正则中的模式字符串.
    * repl : 替换的字符串,也可为一个函数.
    * string : 要被查找替换的原始字符串.
    * count : 模式匹配后替换的最大次数,默认 0 表示替换所有的匹配.
- eg
    ```python
        #!/usr/bin/python3
        import re
        
        phone = "2004-959-559 # 这是一个电话号码"
        
        # 删除注释
        num = re.sub(r'#.*$', "", phone)
        print ("电话号码 : ", num)
        
        # 移除非数字的内容
        num = re.sub(r'\D', "", phone)
        print ("电话号码 : ", num)

        E:\llllljian\python>python demo7_0115.py
        电话号码 :  2004-959-559 
        电话号码 :  2004959559
    ```
- eg1
    ```python
        #!/usr/bin/python
 
        import re
        
        # 将匹配的数字乘于 2
        def double(matched):
            value = int(matched.group('value'))
            return str(value * 2)
        
        s = 'A23G4HFD567'
        # (?P<name>exp) 匹配 exp,并捕获文本到名称为 name 的组
        # 匹配数字并放在value中
        print(re.sub('(?P<value>\d+)', double, s))
    ```

#### re.compile
- 功能
    * 用于编译正则表达式,生成一个正则表达式(Pattern)对象,供 match() 和 search() 这两个函数使用
- 语法
    * re.compile(pattern[, flags])
- 参数
    * pattern : 匹配的正则表达式
    * flags : 标志位,用于控制正则表达式的匹配方式
- eg
    ```python
        >>>import re
        >>> pattern = re.compile(r'\d+')                    # 用于匹配至少一个数字
        >>> m = pattern.match('one12twothree34four')        # 查找头部,没有匹配
        >>> print m
        None
        >>> m = pattern.match('one12twothree34four', 2, 10) # 从'e'的位置开始匹配,没有匹配
        >>> print m
        None
        >>> m = pattern.match('one12twothree34four', 3, 10) # 从'1'的位置开始匹配,正好匹配
        >>> print m                                         # 返回一个 Match 对象
        <_sre.SRE_Match object at 0x10a42aac0>
        >>> m.group(0)   # 可省略 0
        '12'
        >>> m.start(0)   # 可省略 0
        3
        >>> m.end(0)     # 可省略 0
        5
        >>> m.span(0)    # 可省略 0
        (3, 5)
    ```

