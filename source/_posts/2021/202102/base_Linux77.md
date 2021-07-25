---
title: Linux_基础 (77)
date: 2021-02-02
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 以文件之名

##### 查找文件差异并进行修补
- eg
    * 两个文件version1.txt 和 version2.txt,比较差异并进行修补
    ```bash
        [root@xxxxx test_code_dir]# cat version1.txt
        this is the original text
        line2
        line3
        line4
        happy hacking !

        [root@xxxxx test_code_dir]# cat version2.txt
        this is the original text
        line2
        line4
        happy hacking !
        GNU is not UNIX

        [root@xxxxx test_code_dir]# diff version1.txt version2.txt
        3d2
        < line3
        5a5
        > GNU is not UNIX

        [root@xxxxx test_code_dir]# diff -u version1.txt version2.txt
        --- version1.txt	2021-02-02 11:05:27.370165659 +0000
        +++ version2.txt	2021-02-02 11:07:45.510975581 +0000
        @@ -1,5 +1,5 @@
        this is the original text
        line2
        -line3
        line4
        happy hacking !
        +GNU is not UNIX

        [root@xxxxx test_code_dir]# diff -u version1.txt version2.txt > version.patch

        [root@xxxxx test_code_dir]# patch -p1 version1.txt < version.patch
        patching file version1.txt

        [root@xxxxx test_code_dir]# cat version1.txt
        this is the original text
        line2
        line4
        happy hacking !
        GNU is not UNIX

        [root@xxxxx test_code_dir]# patch -p1 version1.txt < version.patch
        patching file version1.txt
        Reversed (or previously applied) patch detected!  Assume -R? [n] y

        [root@xxxxx test_code_dir]# cat version1.txt
        this is the original text
        line2
        line3
        line4
        happy hacking !
    ```
