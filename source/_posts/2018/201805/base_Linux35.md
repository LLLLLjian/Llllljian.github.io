---
title: Linux_基础 (35)
date: 2018-05-25
tags: Linux
toc: true
---

### 管线命令pipe
    管道就是用 | 连接两个命令,以前面一个命令的标准输出作为后面命令的标准输入,与连续执行命令是有区别的,值得注意的管道对于前一条命令的标准错误输出没事有处理能力的

<!-- more -->

#### 注意点
    管线命令仅会处理 standard output,对于standard error ouput会予以忽略
    管线命令必须能够接受来自前一个指令的数据成为standard input 继续处理才行

#### 撷取命令
    针对一行一行来分析的
- cut
    * 命令格式
        * cut(选项)(参数)
    * 命令功能
        * 以某种方式按照文件的行进行分割
    * 命令参数
    	* -b: 仅显示行中指定直接范围的内容；
        * -c: 仅显示行中指定范围的字符；
        * -d: 指定字段的分隔符,默认的字段分隔符为“TAB”；
        * -f: 显示指定字段的内容；
        * -n: 与“-b”选项连用,不分割多字节字符；
        * --complement: 补足被选择的字节、字符或字段；
        * --out-delimiter=<字段分隔符>: 指定输出内容是的字段分割符；
        * --help: 显示指令的帮助信息；
        * --version: 显示指令的版本信息.
    * 范围控制
        * n:只有第n项
        * n-:从第n项一直到行尾
        * n-m:从第n项到第m项(包括m)
        * -m:从一行的开始到第m项(包括m)
        * -:从一行的开始到结束的所有项
    * 命令实例
        ```bash
            cat 1.txt 
            姓名	年龄	班级
            name1	age1	class1
            name2	age2	class2
            name3	age3	class3
            name4	age4	class4
            name5	age5	class5
            name6	age6	class6
            name7	age7	class7

            选取某一列
            cut -f 1 1.txt
            姓名
            name1
            name2
            name3
            name4
            name5
            name6
            name7

            选取指定的列
            cut -f 2,3 1.txt
            年龄	班级
            age1	class1
            age2	class2
            age3	class3
            age4	class4
            age5	class5
            age6	class6
            age7	class7

            选取指定字段之外的列
            cut -f2 --complement 1.txt
            姓名	班级
            name1	class1
            name2	class2
            name3	class3
            name4	class4
            name5	class5
            name6	class6
            name7	class7

            cat 2.txt
            姓名-年龄-班级
            name1-age1-class1
            name2-age2-class2
            name3-age3-class3
            name4-age4-class4
            name5-age5-class5
            name6-age6-class6
            name7-age7-class7

            cut -f2 -d"-" 2.txt
            年龄
            age1
            age2
            age3
            age4
            age5
            age6
            age7

            cat 3.txt
            abcdefghijklmnopqrstuvwxyz
            abcdefghijklmnopqrstuvwxyz
            abcdefghijklmnopqrstuvwxyz
            abcdefghijklmnopqrstuvwxyz
            abcdefghijklmnopqrstuvwxyz

            cut -c1-3 3.txt
            abc
            abc
            abc
            abc
            abc
            
            cut -c-5 3.txt
            abcde
            abcde
            abcde
            abcde
            abcde
            
            cut -c8- 3.txt
            hijklmnopqrstuvwxyz
            hijklmnopqrstuvwxyz
            hijklmnopqrstuvwxyz
            hijklmnopqrstuvwxyz
            hijklmnopqrstuvwxyz
        ```
- grep
    * 命令格式
        * grep [options] ‘pattern’ filename
    * 命令功能
        * 文本搜索工具,通过参数获取符合你要求的数据
    * 命令参数
        * -a 不要忽略二进制数据.
        * -A<显示列数> 除了显示符合范本样式的那一行之外,并显示该行之后的内容.
        * -b 在显示符合范本样式的那一行之外,并显示该行之前的内容.
        * -c 计算符合范本样式的列数.
        * -C<显示列数>或-<显示列数>  除了显示符合范本样式的那一列之外,并显示该列之前后的内容.
        * -d<进行动作> 当指定要查找的是目录而非文件时,必须使用这项参数,否则grep命令将回报信息并停止动作.
        * -e<范本样式> 指定字符串作为查找文件内容的范本样式.
        * -E 将范本样式为延伸的普通表示法来使用,意味着使用能使用扩展正则表达式.
        * -f<范本文件> 指定范本文件,其内容有一个或多个范本样式,让grep查找符合范本条件的文件内容,格式为每一列的范本样式.
        * -F 将范本样式视为固定字符串的列表.
        * -G 将范本样式视为普通的表示法来使用.
        * -h 在显示符合范本样式的那一列之前,不标示该列所属的文件名称.
        * -H 在显示符合范本样式的那一列之前,标示该列的文件名称.
        * -i 忽略字符大小写的差别.
        * -l 列出文件内容符合指定的范本样式的文件名称.
        * -L 列出文件内容不符合指定的范本样式的文件名称.
        * -n 在显示符合范本样式的那一列之前,标示出该列的编号.
        * -q 不显示任何信息.
        * -R/-r 此参数的效果和指定“-d recurse”参数相同.
        * -s 不显示错误信息.
        * -v 反转查找.
        * -w 只显示全字符合的列.
        * -x 只显示全列符合的列.
        * -y 此参数效果跟“-i”相同.
        * -o 只输出文件中匹配到的部分.
    * 命令实例
        ```bash
            查找文件中带name1字符串的行
            grep "name1" 1.txt 2.txt
            1.txt:name1	age1	class1
            2.txt:name1-age1-class1
            
            查找文件中带name字符串的行
            grep "name" 1.txt 2.txt
            1.txt:name1	age1	class1
            1.txt:name2	age2	class2
            1.txt:name3	age3	class3
            1.txt:name4	age4	class4
            1.txt:name5	age5	class5
            1.txt:name6	age6	class6
            1.txt:name7	age7	class7
            2.txt:name1-age1-class1
            2.txt:name2-age2-class2
            2.txt:name3-age3-class3
            2.txt:name4-age4-class4
            2.txt:name5-age5-class5
            2.txt:name6-age6-class6
            2.txt:name7-age7-class7
            
            标记颜色
            grep "name" 1.txt 2.txt --color=auto
            1.txt:name1	age1	class1
            1.txt:name2	age2	class2
            1.txt:name3	age3	class3
            1.txt:name4	age4	class4
            1.txt:name5	age5	class5
            1.txt:name6	age6	class6
            1.txt:name7	age7	class7
            2.txt:name1-age1-class1
            2.txt:name2-age2-class2
            2.txt:name3-age3-class3
            2.txt:name4-age4-class4
            2.txt:name5-age5-class5
            2.txt:name6-age6-class6
            2.txt:name7-age7-class7

            正则匹配name[数字]
            grep -E "name[1-9]+" 1.txt 2.txt
            1.txt:name1	age1	class1
            1.txt:name2	age2	class2
            1.txt:name3	age3	class3
            1.txt:name4	age4	class4
            1.txt:name5	age5	class5
            1.txt:name6	age6	class6
            1.txt:name7	age7	class7
            2.txt:name1-age1-class1
            2.txt:name2-age2-class2
            2.txt:name3-age3-class3
            2.txt:name4-age4-class4
            2.txt:name5-age5-class5
            2.txt:name6-age6-class6
            2.txt:name7-age7-class7

            统计出现次数
            grep -c -E "name[1-9]+" 1.txt 2.txt
            1.txt:7
            2.txt:7

            忽略大小写
            echo "hello world" | grep -i "HELLO"

            只在目录中所有的.php和.html文件中递归搜索字符"main"
            grep "main" . -r --include *.{php,html}

            在搜索结果中排除所有README文件
            grep "main" . -r --exclude "README"

            在搜索结果中排除20180525文件列表里的文件
            grep "main" . -r --exclude-from 20180525
        ```