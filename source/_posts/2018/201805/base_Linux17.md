---
title: Linux_基础 (17)
date: 2018-05-03
tags: Linux
toc: true
---

### 文件与目录管理
    有关文件与目录的一些基础管理部分

<!-- more -->

#### mv
- 命令格式
    * mv [选项] 源文件或者目录,目标文件或者目录
- 命令功能
    * 用来将源文件移至一个目标文件中,或将一组文件移至一个目标目录中.源文件被移至目标文件有两种不同的结果：
        * 如果目标文件是到某一目录文件的路径,源文件会被移到此目录下,且文件名不变.
        * 如果目标文件不是目录文件,则源文件名(只能有一个)会变为此目标文件名,并覆盖己存在的同名文件.如果源文件和目标文件在同一个目录下,mv的作用就是改文件名.当目标文件是目录文件时,源文件或目录参数可以有多个,则所有的源文件都会被移至目标文件中.所有移到该目录下的文件都将保留以前的文件名.
    * 注意事项：mv与cp的结果不同,mv好像文件“搬家”,文件个数并未增加.而cp对文件进行复制,文件个数增加了.
- 命令参数
    * --backup=<备份模式>：若需覆盖文件,则覆盖前先行备份；
	* -b：当文件存在时,覆盖前,为其创建一个备份；
	* -f：若目标文件或目录与现有的文件或目录重复,则直接覆盖现有的文件或目录；
	* -i：交互式操作,覆盖前先行询问用户,如果源文件与目标文件或目标目录中的文件同名,则询问用户是否覆盖目标文件.用户输入”y”,表示将覆盖目标文件；输入”n”,表示取消对源文件的移动.这样可以避免误将文件覆盖.
	* --strip-trailing-slashes：删除源文件中的斜杠“/”；
	* -S<后缀>：为备份文件指定后缀,而不使用默认的后缀；
	* --target-directory=<目录>：指定源文件要移动到目标目录；
	* -u：当源文件比目标文件新或者目标文件不存在时,才执行移动操作.
    * 源文件：源文件列表.
    * 目标文件：如果“目标文件”是文件名则在移动文件的同时,将其改名为“目标文件”；如果“目标文件”是目录名则将源文件移动到“目标文件”下.
- 命令实例
    * 文件改名
        ```bash
            ls -al 1* 
            drwxrwxrwx 2 root      root      4096 5月  03 22:28 .
            drwxr-xr-x 8 root      root      4096 5月  03 22:27 ..
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_1.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_2.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_3.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_4.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1.txt
            
            mv 1_4.txt 1_5.txt
            
            ls -al 1* 
            drwxrwxrwx 2 root      root      4096 5月  03 22:50 .
            drwxr-xr-x 8 root      root      4096 5月  03 22:27 ..
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_1.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_2.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_3.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1_5.txt
            -rwxrwxrwx 1 root      root         0 5月  03 21:49 1.txt
        ```

    * 若目标文件存在
        ```bash
            ls -al 1*
            -rwxrwxrwx 1 root root 0 5月  03 21:49 1_1.txt
            -rwxrwxrwx 1 root root 0 5月  03 21:49 1_2.txt
            -rwxrwxrwx 1 root root 0 5月  03 21:49 1_3.txt
            -rwxrwxrwx 1 root root 0 5月  03 21:49 1_5.txt
            -rwxrwxrwx 1 root root 0 5月  03 21:49 1.txt
            
            cp -i 1.txt 1_5.txt
            cp：是否覆盖'1_5.txt'？ y
            
            cp -f 1.txt 1_5.txt
        ```   