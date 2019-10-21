---
title: Python_基础 (8)
date: 2018-12-17
tags: Python
toc: true
---

### Python3字符串
    Python3学习笔记

<!-- more -->

#### 字符串
    可以使用引号( ' 或 " )来创建字符串

#### 访问字符串中的值
    使用方括号来截取字符串
- eg
    ```python
        #!/usr/bin/python3
 
        var1 = 'Hello World!'
        var2 = "llllljian"

        print ("var1: ", var1)
        print ("var1[0]: ", var1[0])
        print ("var2: ", var2)
        print ("var2[1:5]: ", var2[1:5])

        E:\python>python stringTest.py
        var1:  Hello World!
        var1[0]:  H
        var2:  llllljian
        var2[1:5]:  llll
    ```

#### 字符串更新
    截取字符串的一部分并与其他字段拼接
- eg
    ```python
        #!/usr/bin/python3
 
        var1 = 'Hello World!'
        
        print ("已更新字符串 : ", var1[:6] + 'llllljian!')

        E:\python>python stringTest.py
        已更新字符串 :  Hello llllljian!
    ```

#### 转义字符
- list
    <table class="reference"><thead><tr><th>转义字符</th><th>描述</th></tr></thead><tbody><tr><td>\\(在行尾时)</td><td>续行符</td></tr><tr><td>\\\</td><td>反斜杠符号</td></tr><tr><td>\'</td><td>单引号</td></tr><tr><td>\"</td><td>双引号</td></tr><tr><td>\a</td><td>响铃</td></tr><tr><td>\b</td><td>退格(Backspace)</td></tr><tr><td>\e</td><td>转义</td></tr><tr><td>\000</td><td>空</td></tr><tr><td>\n</td><td>换行</td></tr><tr><td>\v</td><td>纵向制表符</td></tr><tr><td>\t</td><td>横向制表符</td></tr><tr><td>\r</td><td>回车</td></tr><tr><td>\f</td><td>换页</td></tr><tr><td>\oyy</td><td>八进制数,yy代表的字符,例如：\o12代表换行</td></tr><tr><td>\xyy</td><td>十六进制数,yy代表的字符,例如：\x0a代表换行</td></tr><tr><td>\other</td><td>其它的字符以普通格式输出</td></tr></tbody></table>

#### 字符串运算符
- list
    <table class="reference"><tbody><tr><th width="10%">操作符</th><th>描述</th><th width="20%">实例</th></tr><tr><th colspan="3" align="center" valign="middle">a值为字符串 "Hello",b变量值为 "Python"</th></tr><tr><td>+</td><td>字符串连接</td><td> a + b 输出结果： HelloPython</td></tr><tr><td>*</td><td>重复输出字符串</td><td> a*2 输出结果：HelloHello</td></tr><tr><td>[]</td><td>通过索引获取字符串中字符</td><td> a[1] 输出结果<b>e</b></td></tr><tr><td>[ : ]</td><td>截取字符串中的一部分,遵循<strong>左闭右开</strong>原则,str[0,2] 是不包含第 3 个字符的.</td><td> a[1:4] 输出结果<b>ell</b></td></tr><tr><td>in</td><td>成员运算符 - 如果字符串中包含给定的字符返回 True</td><td><b>'H' in a</b> 输出结果 True</td></tr><tr><td>not in</td><td>成员运算符 - 如果字符串中不包含给定的字符返回 True</td><td><b>'M' not in a</b> 输出结果 True</td></tr><tr><td>r/R</td><td>原始字符串 - 原始字符串：所有的字符串都是直接按照字面的意思来使用,没有转义特殊或不能打印的字符.原始字符串除在字符串的第一个引号前加上字母<span class="marked">r</span>(可以大小写)以外,与普通字符串有着几乎完全相同的语法.</td><td><pre class="prettyprint prettyprinted" style=""><span class="kwd">print</span><span class="pun">(</span><span class="pln"> r</span><span class="str">'\n'</span><span class="pln"></span><span class="pun">)</span><span class="pln"></span><span class="kwd">print</span><span class="pun">(</span><span class="pln"> R</span><span class="str">'\n'</span><span class="pln"></span><span class="pun">)</span></pre></td></tr><tr><td>%</td><td>格式字符串</td><td>请看下一节内容.</td></tr></tbody></table>
- eg
    ```python
        #!/usr/bin/python3
 
        a = "Hello"
        b = "Python"
        
        print("a + b 输出结果：", a + b)
        print("a * 2 输出结果：", a * 2)
        print("a[1] 输出结果：", a[1])
        print("a[1:4] 输出结果：", a[1:4])
        
        if( "H" in a) :
            print("H 在变量 a 中")
        else :
            print("H 不在变量 a 中")
        
        if( "M" not in a) :
            print("M 不在变量 a 中")
        else :
            print("M 在变量 a 中")
        
        print (r'\n')
        print (R'\n')

        输出结果为：

        a + b 输出结果： HelloPython
        a * 2 输出结果： HelloHello
        a[1] 输出结果： e
        a[1:4] 输出结果： ell
        H 在变量 a 中
        M 不在变量 a 中
        \n
        \n
    ```

#### 字符串格式化
- list
    <table class="reference"><tbody><tr><th width="10%">操作符</th><th>描述</th><th width="20%">实例</th></tr><tr><td>+</td><td>字符串连接</td><td> a + b 输出结果： HelloPython</td></tr><tr><td>*</td><td>重复输出字符串</td><td> a*2 输出结果：HelloHello</td></tr><tr><td>[]</td><td>通过索引获取字符串中字符</td><td> a[1] 输出结果<b>e</b></td></tr><tr><td>[ : ]</td><td>截取字符串中的一部分,遵循<strong>左闭右开</strong>原则,str[0,2] 是不包含第 3 个字符的.</td><td> a[1:4] 输出结果<b>ell</b></td></tr><tr><td>in</td><td>成员运算符 - 如果字符串中包含给定的字符返回 True</td><td><b>'H' in a</b> 输出结果 True</td></tr><tr><td>not in</td><td>成员运算符 - 如果字符串中不包含给定的字符返回 True</td><td><b>'M' not in a</b> 输出结果 True</td></tr><tr><td>r/R</td><td>原始字符串 - 原始字符串：所有的字符串都是直接按照字面的意思来使用,没有转义特殊或不能打印的字符.原始字符串除在字符串的第一个引号前加上字母<span class="marked">r</span>(可以大小写)以外,与普通字符串有着几乎完全相同的语法.</td><td><pre class="prettyprint prettyprinted" style=""><span class="kwd">print</span><span class="pun">(</span><span class="pln"> r</span><span class="str">'\n'</span><span class="pln"></span><span class="pun">)</span><span class="pln"></span><span class="kwd">print</span><span class="pun">(</span><span class="pln"> R</span><span class="str">'\n'</span><span class="pln"></span><span class="pun">)</span></pre></td></tr><tr><td>%</td><td>格式字符串</td><td>请看下一节内容.</td></tr></tbody></table>
- 格式化操作符辅助指令
    <table class="reference"><tbody><tr><th>符号</th><th>功能</th></tr><tr><td>*</td><td>定义宽度或者小数点精度</td></tr><tr><td>-</td><td>用做左对齐</td></tr><tr><td>+</td><td>在正数前面显示加号( + )</td></tr><tr><td>&lt;sp&gt;</td><td>在正数前面显示空格</td></tr><tr><td>#</td><td> 在八进制数前面显示零('0'),在十六进制前面显示'0x'或者'0X'(取决于用的是'x'还是'X')</td></tr><tr><td>0</td><td> 显示的数字前面填充'0'而不是默认的空格</td></tr><tr><td>%</td><td> '%%'输出一个单一的'%'</td></tr><tr><td>(var)</td><td>映射变量(字典参数)</td></tr><tr><td>m.n.</td><td>  m 是显示的最小总宽度,n 是小数点后的位数(如果可用的话)</td></tr></tbody></table>

#### 字符串内建函数
- list
    <table class="reference"><tbody><tr><th style="width:5%">序号</th><th>方法及描述</th></tr><tr><td>capitalize()</td><td><p>将字符串的第一个字符转换为大写</p></td></tr><tr><td>center(width, fillchar)</td><td>返回一个指定的宽度 width 居中的字符串,fillchar 为填充的字符,默认为空格.</td></tr><tr><td>count(str,beg=0,end=len(string))</td><td>返回 str 在 string 里面出现的次数,如果 beg 或者 end 指定则返回指定范围内 str 出现的次数</td></tr><tr><td>bytes.decode(encoding="utf-8", errors="strict")</td><td>Python3 中没有 decode 方法,但我们可以使用 bytes 对象的 decode() 方法来解码给定的 bytes 对象,这个 bytes 对象可以由 str.encode() 来编码返回.</td></tr><tr><td>encode(encoding='UTF-8',errors='strict')</td><td>以 encoding 指定的编码格式编码字符串,如果出错默认报一个ValueError 的异常,除非 errors 指定的是'ignore'或者'replace'</td></tr><tr><td>endswith(suffix, beg=0, end=len(string))</td><td>检查字符串是否以 obj 结束,如果beg 或者 end 指定则检查指定的范围内是否以 obj 结束,如果是,返回 True,否则返回 False.</p></td></tr><tr><td>expandtabs(tabsize=8)</td><td>把字符串 string 中的 tab 符号转为空格,tab 符号默认的空格数是 8 .</td></tr><tr><td>find(str,beg=0,end=len(string))</td><td>检测 str 是否包含在字符串中,如果指定范围 beg 和 end ,则检查是否包含在指定范围内,如果包含返回开始的索引值,否则返回-1</td></tr><tr><td>index(str, beg=0, end=len(string))</td><td>跟find()方法一样,只不过如果str不在字符串中会报一个异常.</td></tr><tr><td>isalnum()</td><td>如果字符串至少有一个字符并且所有字符都是字母或数字则返回 True,否则返回 False</td></tr><tr><td>isalpha()</td><td>如果字符串至少有一个字符并且所有字符都是字母则返回 True,否则返回 False</td></tr><tr><td>isdigit()</td><td>如果字符串只包含数字则返回 True 否则返回 False..</td></tr><tr><td>islower()</td><td>如果字符串中包含至少一个区分大小写的字符,并且所有这些(区分大小写的)字符都是小写,则返回 True,否则返回 False</td></tr><tr><td>isnumeric()</td><td>如果字符串中只包含数字字符,则返回 True,否则返回 False</td></tr><tr><td>isspace()</td><td>如果字符串中只包含空白,则返回 True,否则返回 False.</td></tr><tr><td>istitle()</td><td>如果字符串是标题化的(见 title())则返回 True,否则返回 False</td></tr><tr><td>isupper()</td><td>如果字符串中包含至少一个区分大小写的字符,并且所有这些(区分大小写的)字符都是大写,则返回 True,否则返回 False</td></tr><tr><td>join(seq)</td><td>以指定字符串作为分隔符,将 seq 中所有的元素(的字符串表示)合并为一个新的字符串</td></tr><tr><td>len(string)</td><td>返回字符串长度</td></tr><tr><td>ljust(width[, fillchar])</td><td>返回一个原字符串左对齐,并使用 fillchar 填充至长度 width 的新字符串,fillchar 默认为空格.</td></tr><tr><td>lower()</td><td>转换字符串中所有大写字符为小写.</td></tr><tr><td>lstrip()</td><td>截掉字符串左边的空格或指定字符.</td></tr><tr><td>maketrans()</td><td>创建字符映射的转换表,对于接受两个参数的最简单的调用方式,第一个参数是字符串,表示需要转换的字符,第二个参数也是字符串表示转换的目标.</td></tr><tr><td>max(str)</td><td>返回字符串 str 中最大的字母.</td></tr><tr><td>min(str)</td><td>返回字符串 str 中最小的字母.</td></tr><tr><td>replace(old, new [, max])</td><td>把 将字符串中的 str1 替换成 str2,如果 max 指定,则替换不超过 max 次.</td></tr><tr><td>rfind(str, beg=0,end=len(string))</td><td>类似于 find()函数,不过是从右边开始查找.</td></tr><tr><td>rindex( str, beg=0, end=len(string))</td><td>类似于 index(),不过是从右边开始.</td></tr><tr><td>rjust(width,[, fillchar])</td><td></a></p>返回一个原字符串右对齐,并使用fillchar(默认空格)填充至长度 width 的新字符串</td></tr><tr><td>rstrip()</td><td>删除字符串字符串末尾的空格.</td></tr><tr><td>split(str=””, num=string.count(str))</td><td>num=string.count(str))以 str 为分隔符截取字符串,如果 num 有指定值,则仅截取 num+1 个子字符串</td></tr><tr><td>splitlines([keepends])</td><td>按照行('\r', '\r\n', \n')分隔,返回一个包含各行作为元素的列表,如果参数 keepends 为 False,不包含换行符,如果为 True,则保留换行符.</td></tr><tr><td>startswith(substr, beg=0,end=len(string))</td><td>检查字符串是否是以指定子字符串 substr 开头,是则返回 True,否则返回 False.如果beg 和 end 指定值,则在指定范围内检查.</td></tr><tr><td>strip([chars])</td><td>在字符串上执行 lstrip()和 rstrip()</td></tr><tr><td>swapcase()</td><td>将字符串中大写转换为小写,小写转换为大写</td></tr><tr><td>title()</td><td>返回"标题化"的字符串,就是说所有单词都是以大写开始,其余字母均为小写(见 istitle())</td></tr><tr><td>translate(table, deletechars=””)</td><td>根据 str 给出的表(包含 256 个字符)转换 string 的字符,要过滤掉的字符放到 deletechars 参数中</td></tr><tr><td>upper()</td><td>转换字符串中的小写字母为大写</td></tr><tr><td>zfill (width)</td><td>返回长度为 width 的字符串,原字符串右对齐,前面填充0</td></tr><tr><td>isdecimal()</td><td>检查字符串是否只包含十进制字符,如果是返回 true,否则返回 false.</td></tr></tbody></table>


