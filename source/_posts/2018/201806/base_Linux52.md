---
title: Linux_基础 (52)
date: 2018-06-14
tags: Linux
toc: true
---

### Linux三剑客
    grep 适合单纯的匹配或查找文件
    sed 适合编辑匹配到的文本
    awk 适合格式化文本,对文本进行复杂格式化处理

<!-- more -->

#### grep 
- [grep直达连接](/2018/201806/base_Linux40/)

#### sed
- 命令功能
    * 自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等
- 命令格式
    * sed [options] 'command' file(s)
    * sed [options] -f scriptfile file(s)
- 命令选项
    * -e&lt;script>或--expression=&lt;script>：以选项中的指定的script来处理输入的文本文件；
	* -f<script文件>或--file=<script文件>：以选项中指定的script文件来处理输入的文本文件；
	* -h或--help：显示帮助；
	* -n或--quiet或——silent：仅显示script处理后的结果；
	* -V或--version：显示版本信息.
- 命令
    * a\ 在当前行下面插入文本.
	* i\ 在当前行上面插入文本.
	* c\ 把选定的行改为新的文本.
	* d 删除,删除选择的行.
	* D 删除模板块的第一行.
	* s 替换指定字符
	* h 拷贝模板块的内容到内存中的缓冲区.
	* H 追加模板块的内容到内存中的缓冲区.
	* g 获得内存缓冲区的内容,并替代当前模板块中的文本.
	* G 获得内存缓冲区的内容,并追加到当前模板块文本的后面.
	* l 列表不能打印字符的清单.
	* n 读取下一个输入行,用下一个命令处理新的行而不是用第一个命令.
	* N 追加下一个输入行到模板块后面并在二者间嵌入一个新行,改变当前行号码.
	* p 打印模板块的行.
	* P(大写) 打印模板块的第一行.
	* q 退出Sed.
	* b lable 分支到脚本中带有标记的地方,如果分支不存在则分支到脚本的末尾.
	* r file 从file中读行.
	* t label if分支,从最后一行开始,条件一旦满足或者T,t命令,将导致分支到带有标号的命令处,或者到脚本的末尾.
	* T label 错误分支,从最后一行开始,一旦发生错误或者T,t命令,将导致分支到带有标号的命令处,或者到脚本的末尾.
	* w file 写并追加模板块到file末尾.  
	* W file 写并追加模板块的第一行到file末尾.  
	* ! 表示后面的命令对所有没有被选定的行发生作用.  
	* = 打印当前行号码.  
	* \# 把注释扩展到下一个换行符以前.
- sed替换标记
	* g 表示行内全面替换.  
	* p 表示打印行.  
	* w 表示把行写入一个文件.  
	* x 表示互换模板块中的文本和缓冲区中的文本.  
	* y 表示把一个字符翻译为另外的字符(但是不用于正则表达式)
	* \1 子串匹配标记
	* & 已匹配字符串标记
- sed元字符集
    * ^ 匹配行开始,如：/^sed/匹配所有以sed开头的行.
	* $ 匹配行结束,如：/sed$/匹配所有以sed结尾的行.
	* . 匹配一个非换行符的任意字符,如：/s.d/匹配s后接一个任意字符,最后是d.
	* \* 匹配0个或多个字符,如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行.
	* [] 匹配一个指定范围内的字符,如/[ss]ed/匹配sed和Sed.  
	* [^] 匹配一个不在指定范围内的字符,如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头,紧跟ed的行.
	* \\(..\\) 匹配子串,保存匹配的字符,如s/\\(love\\)able/\1rs,loveable被替换成lovers.
	* \\> 匹配单词的结束,如/love\\>/匹配包含以love结尾的单词的行.
	* x\\{m\\} 重复字符x,m次,如：/0\\{5\\}/匹配包含5个0的行.
	* x\\{m,\\} 重复字符x,至少m次,如：/0\\{5,\\}/匹配至少有5个0的行.
	* x\\{m,n\\} 重复字符x,至少m次,不多于n次,如：/0\\{5,10\\}/匹配5~10个0的行.
- 命令实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180614 15:41:31 #81]$ cat 1.txt
        1
        2
        3
        4
        5
        6
        7
        8
        9
        10
        11
        12
        13
        14
        15

        [llllljian@llllljian-virtual-machine 20180614 15:41:42 #82]$ sed 's/1/a/' 1.txt
        a
        2
        3
        4
        5
        6
        7
        8
        9
        a0
        a1
        a2
        a3
        a4
        a5

        [llllljian@llllljian-virtual-machine 20180614 15:41:50 #83]$ sed 's/1/a/g' 1.txt
        a
        2
        3
        4
        5
        6
        7
        8
        9
        a0
        aa
        a2
        a3
        a4
        a5

        [llllljian@llllljian-virtual-machine 20180614 15:42:07 #84]$ sed -n 's/1/a/p' 1.txt
        a
        a0
        a1
        a2
        a3
        a4
        a5

        [llllljian@llllljian-virtual-machine 20180614 15:42:26 #85]$ sed -i 's/1/a/g' 1.txt
        [llllljian@llllljian-virtual-machine 20180614 15:42:38 #86]$ cat 1.txt
        a
        2
        3
        4
        5
        6
        7
        8
        9
        a0
        aa
        a2
        a3
        a4
        a5

        [llllljian@llllljian-virtual-machine 20180614 15:47:24 #103]$ cat 1.txt
        11
        22
        33
        44
        55
        66
        77
        88
        99
        1010
        1111
        1212
        1313
        1414
        1515

        [llllljian@llllljian-virtual-machine 20180614 15:47:27 #104]$ sed 's/1/a/2g' 1.txt
        1a
        22
        33
        44
        55
        66
        77
        88
        99
        10a0
        1aaa
        12a2
        13a3
        14a4
        15a5

        [llllljian@llllljian-virtual-machine 20180614 15:47:36 #105]$ sed 's/1/a/3g' 1.txt
        11
        22
        33
        44
        55
        66
        77
        88
        99
        1010
        11aa
        1212
        1313
        1414
        1515

        [llllljian@llllljian-virtual-machine 20180614 16:19:43 #172]$ cat 2.txt
        a
        b
        c
        d
        e
        f
        g
        h
        i
        j

        k
        l

        m
        n
        o
        p
        q
        r
        s
        t
        u
        v
        w
        x
        y
        z

        [llllljian@llllljian-virtual-machine 20180614 16:19:46 #173]$ sed '/^$/d' 2.txt
        a
        b
        c
        d
        e
        f
        g
        h
        i
        j
        k
        l
        m
        n
        o
        p
        q
        r
        s
        t
        u
        v
        w
        x
        y
        z

        [llllljian@llllljian-virtual-machine 20180614 16:20:56 #174]$ sed '2d' 2.txt
        a
        c
        d
        e
        f
        g
        h
        i
        j

        k
        l

        m
        n
        o
        p
        q
        r
        s
        t
        u
        v
        w
        x
        y
        z

        [llllljian@llllljian-virtual-machine 20180614 16:21:13 #175]$ sed '2,$d' 2.txt
        a

        [llllljian@llllljian-virtual-machine 20180614 16:21:27 #176]$ echo this is a test line | sed 's/\w\+/[&]/g'
        [this] [is] [a] [test] [line]

        [llllljian@llllljian-virtual-machine 20180614 16:23:24 #177]$ echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
        this is 7 in a number

        [llllljian@llllljian-virtual-machine 20180614 16:23:32 #178]$ echo aaa BBB | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
        BBB aaa
    ```

#### awk
- [awk直达连接](/2018/201806/base_Linux53/)
