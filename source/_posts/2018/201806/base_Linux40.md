---
title: Linux_基础 (40)
date: 2018-06-01
tags: Linux
toc: truek
---

### grep进阶
    grep:能使用正则表达式搜索文本,并把匹配的行打印出来,是一种强大的文本搜索工具.

<!-- more -->

#### grep
- 命令格式
    * grep [options]... '搜索字符串' file....
- 命令功能
    * 进行字符串数据的比较,然后符合用户需求的字符串打印出来,但是主意,grep在数据中查找一个字符串时,是以“整行”为单位进行数据筛选的
- 命令参数
    * options
        * -? : 同时显示匹配行上下的？行,如：grep -2 pattern filename同时显示匹配行的上下2行.
        * -b,--byte-offset : 打印匹配行前面打印该行所在的块号码.
        * -c,--count : 只打印匹配的行数,不显示匹配的内容.
        * -f File,--file=File : 从文件中提取模板.空文件中包含0个模板,所以什么都不匹配.
        * -h,--no-filename : 当搜索多个文件时,不显示匹配文件名前缀.
        * -i,--ignore-case : 忽略大小写差别.
        * -q,--quiet : 取消显示,只返回退出状态.0则表示找到了匹配的行.
        * -l,--files-with-matches : 打印匹配模板的文件清单.
        * -L,--files-without-match : 打印不匹配模板的文件清单.
        * -n,--line-number : 在匹配的行前面打印行号.
        * -s,--silent : 不显示关于不存在或者无法读取文件的错误信息.
        * -v,--revert-match : 反检索,只显示不匹配的行.
        * -w,--word-regexp : 如果被\\<和\\>引用,就把表达式做为一个单词搜索.
        * -V,--version : 显示软件版本信息.
    * 基本集正则表达式
        * ^ : 锚定行的开始 如：'^grep'匹配所有以grep开头的行.
        * $ : 锚定行的结束 如：'grep$'匹配所有以grep结尾的行.
        * . : 匹配一个非换行符的字符如：'gr.p'匹配gr后接一个任意字符,然后是p.
        * \* : 匹配零个或多个先前字符如：'*grep'匹配所有一个或多个空格后紧跟grep的行. .*一起用代表任意字符.
        * [] : 匹配一个指定范围内的字符,如'[Gg]rep'匹配Grep和grep.
        * [^] : 匹配一个不在指定范围内的字符,如：'[^A-FH-Z]rep'匹配不包含A-R和T-Z的一个字母开头,紧跟rep的行.
        * .. : 标记匹配字符,如'love',love被标记为1.
        * \< : 锚定单词的开始,如:'\<grep'匹配包含以grep开头的单词的行.
        * \\> : 锚定单词的结束,如'grep\\>'匹配包含以grep结尾的单词的行.
        * x\\{m\\} : 重复字符x,m次,如：'0\\{5\\}'匹配包含5个o的行.
        * x\\{m,\\} : 重复字符x,至少m次,如：'o\\{5,\\}'匹配至少有5个o的行.
        * x\\{m,n\\} : 重复字符x,至少m次,不多于n次,如：'o\\{5,10\\}'匹配5--10个o的行.
        * \w : 匹配文字和数字字符,也就是[A-Za-z0-9],如：'G\w*p'匹配以G后跟零个或多个文字或数字字符,然后是p.
        * \W : \w的反置形式,匹配一个或多个非单词字符,如点号句号等.
        * \b : 单词锁定符,如: '\bgrep\b'只匹配grep.
- 命令实例
    ```bash
        学的是私房菜,用的是示例文件http://linux.vbird.org/linux_basic/0330regularex/regular_express.txt

        包含the字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:24:57 #14]$ grep -n 'the' 1.txt
        8:I can't finish the test.
        12:the symbol '*' is represented as start.
        15:You are the best is mean you are the no. 1.
        16:The world <Happy> is the same with "glad".
        18:google is the best tools for search keyword.

        除了包含the字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:25:11 #15]$ grep -vn 'the' 1.txt
        1:"Open Source" is a good mechanism to develop programs.
        2:apple is my favorite food.
        3:Football game is not use feet only.
        4:this dress doesn't fit me.
        5:However, this dress is about $ 3183 dollars.
        6:GNU is free air not free beer.
        7:Her hair is very beauty.
        9:Oh! The soup taste good.
        10:motorcycle is cheap than car.
        11:This window is clear.
        13:Oh!	My god!
        14:The gd software is a library for drafting programs.
        17:I like dog.
        19:goooooogle yes!
        20:go! go! Let's go.
        21:# I am VBird
        22:
        23:

        包含the字符串的行并展示行号并不区分大小写
        [llllljian@llllljian-virtual-machine 20180601 14:25:25 #16]$ grep -in 'the' 1.txt
        8:I can't finish the test.
        9:Oh! The soup taste good.
        12:the symbol '*' is represented as start.
        14:The gd software is a library for drafting programs.
        15:You are the best is mean you are the no. 1.
        16:The world <Happy> is the same with "glad".
        18:google is the best tools for search keyword.

        包含tast或者test字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:29:08 #18]$ grep -n 't[ae]st' 1.txt
        8:I can't finish the test.
        9:Oh! The soup taste good.

        包含oo字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:29:21 #19]$ grep -n 'oo' 1.txt
        1:"Open Source" is a good mechanism to develop programs.
        2:apple is my favorite food.
        3:Football game is not use feet only.
        9:Oh! The soup taste good.
        18:google is the best tools for search keyword.
        19:goooooogle yes!

        包含oo字符串的行并展示行号并除了goo字符串的行
        [llllljian@llllljian-virtual-machine 20180601 14:29:49 #20]$ grep -n '[^g]oo' 1.txt
        2:apple is my favorite food.
        3:Football game is not use feet only.
        18:google is the best tools for search keyword.
        19:goooooogle yes!

        除了包含小写字母a-z开头oo字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:30:05 #21]$ grep -n '[^a-z]oo' 1.txt
        3:Football game is not use feet only.

        展示有数字的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:30:19 #22]$ grep -n '[0-9]' 1.txt
        5:However, this dress is about $ 3183 dollars.
        15:You are the best is mean you are the no. 1.

        展示除了小写字母开头oo字符串的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:30:29 #23]$ grep -n '[^[:lower:]]oo' 1.txt
        3:Football game is not use feet only.

        展示有数字的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:32:33 #24]$ grep -n '[[:digit:]]' 1.txt
        5:However, this dress is about $ 3183 dollars.
        15:You are the best is mean you are the no. 1.

        展示以the字符串开头的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:37:09 #26]$ grep -n '^the' 1.txt
        12:the symbol '*' is represented as start.

        展示小写字母开头的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:37:37 #27]$ grep -n '^[a-z]' 1.txt
        2:apple is my favorite food.
        4:this dress doesn't fit me.
        10:motorcycle is cheap than car.
        12:the symbol '*' is represented as start.
        18:google is the best tools for search keyword.
        19:goooooogle yes!
        20:go! go! Let's go.

        展示.结尾的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:37:53 #28]$ grep -n '\.$' 1.txt
        1:"Open Source" is a good mechanism to develop programs.
        2:apple is my favorite food.
        3:Football game is not use feet only.
        4:this dress doesn't fit me.
        5:However, this dress is about $ 3183 dollars.
        6:GNU is free air not free beer.
        7:Her hair is very beauty.
        8:I can't finish the test.
        9:Oh! The soup taste good.
        10:motorcycle is cheap than car.
        11:This window is clear.
        12:the symbol '*' is represented as start.
        14:The gd software is a library for drafting programs.
        15:You are the best is mean you are the no. 1.
        16:The world <Happy> is the same with "glad".
        17:I like dog.
        18:google is the best tools for search keyword.
        20:go! go! Let's go.

        展示空白的行并展示行号
        [llllljian@llllljian-virtual-machine 20180601 14:39:09 #29]$ grep -n '^$' 1.txt
        22:
        23:
    ```

#### egrep
- 命令格式
    * egrep [options]... '搜索字符串' file....
- 命令功能
    * egrep 相当于 grep -E,除了基本集正则表达之外还可以使用扩展表达式
- 命令参数
    * options : 同grep
    * 基本正则表达式 : 同grep
    * 元字符扩展集表达式
        * \+ : 匹配一个或者多个先前的字符, 至少一个先前字符.
        * \? : 匹配0个或者多个先前字符
        * a|b|c : 匹配a或b或c
        * () : 字符组, 如: love(able|ers) 匹配loveable或lovers.
        * (..)(..)\1\2 : 模板匹配. \1代表前面第一个模板, \2代第二个括弧里面的模板.
        * x{m,n} =x\\{m,n\\} : x的字符数量在m到n个之间.
- 命令实例
    ```bash
        包含is或者are的行
        [llllljian@llllljian-virtual-machine 20180601 14:58:00 #40]$ egrep '(are|is)' 1.txt
        "Open Source" is a good mechanism to develop programs.
        apple is my favorite food.
        Football game is not use feet only.
        this dress doesn't fit me.
        However, this dress is about $ 3183 dollars.
        GNU is free air not free beer.
        Her hair is very beauty.
        I can't finish the test.
        motorcycle is cheap than car.
        This window is clear.
        the symbol '*' is represented as start.
        The gd software is a library for drafting programs.
        You are the best is mean you are the no. 1.
        The world <Happy> is the same with "glad".
        google is the best tools for search keyword.

        至少包含一个大写字母的行
        [llllljian@llllljian-virtual-machine 20180601 14:58:04 #41]$ egrep '[A-Z]+' 1.txt
        "Open Source" is a good mechanism to develop programs.
        Football game is not use feet only.
        However, this dress is about $ 3183 dollars.
        GNU is free air not free beer.
        Her hair is very beauty.
        I can't finish the test.
        Oh! The soup taste good.
        This window is clear.
        Oh!	My god!
        The gd software is a library for drafting programs.
        You are the best is mean you are the no. 1.
        The world <Happy> is the same with "glad".
        I like dog.
        go! go! Let's go.
        # I am VBird
    ```

#### fgrep
- 命令格式
    * fgrep [options]... '搜索字符串' file....
- 命令功能
    * fgrep 相当于 grep -F,不能用特殊匹配模式[POSIX字符类],它不解析正则表达式、想找什么就跟什么就可以了
- 命令参数
    * options : 同grep
- 命令实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180601 15:21:42 #44]$ fgrep -n 'the' 1.txt
        8:I can't finish the test.
        12:the symbol '*' is represented as start.
        15:You are the best is mean you are the no. 1.
        16:The world <Happy> is the same with "glad".
        18:google is the best tools for search keyword.
    ```
