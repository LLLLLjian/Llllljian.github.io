---
title: Linux_基础 (23)
date: 2018-05-10
tags: Linux
toc: true
---

### which whereis locate find特点和区别
    简单说一下四者之间的特点和区别

<!-- more -->

#### which
- 主要是用来查找系统PATH目录下的可执行文件.说白了就是查找那些我们已经安装好的可以直接执行的命令
```bash
    which ls
    alias ls='ls --color=auto'
	/usr/bin/ls
```

#### whereis
- 查找二进制(命令)、源文件、man文件.与which不同的是这条命令可以是通过文件索引数据库而非PATH来查找的,所以查找的面比which要广
```bash
    whereis ls
    ls: /usr/bin/ls /usr/share/man/man1p/ls.1p.gz /usr/share/man/man1/ls.1.gz
```

#### locate
- 通过数据库查找文件,但是这个命令的适用范围就比whereis大多了.这个命令可以找到任意你指定要找的文件,并且可以只输入部分文件名(前面两个命令是要输入完整文件名的).同时locte还可以通过-r选项使用正则表达式,功能十分强大
```bash
    locate ls | head -n 5
    /data/0.22/apache2.2.17/include/apr_pools.h
    /data/0.22/apache2.2.17/manual/vhosts/details.html
    /data/0.22/apache2.2.17/manual/vhosts/details.html.en
    /data/0.22/apache2.2.17/manual/vhosts/details.html.fr
    /data/0.22/apache2.2.17/manual/vhosts/details.html.ko.euc-kr
```
- 新创建的文件立即用locate查找是查找不到的,要updatedb命令更新索引数据库

#### find
- 通过直接搜索硬盘的方式查找的,所以可以保证查找的信息绝对可靠.并且支持各种查找条件.但是功能强大肯定是有代价的,那就是搜索速度慢.所以一般前边几种找不出来的情况下才会使用find.另外如果要实现某些特殊条件的查找,比如找出某个用户的size最大的文件,那就只能用find了

#### 总结
- which主要用来查找可直接执行的命令,可以查找别名.适用于查找安装好的命令
- whereis比which的搜索范围大了一些,同时可以查找源文件和man文件.适用于查找安装好的命令.
- locate的查找范围更大,可以查找任意类型文件.适合快速查找指定文件.
- find最强大也最慢.适合查找前几个命令找不到的文件