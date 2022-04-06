---
title: Linux_基础 (3)
date: 2018-04-12
tags: Linux
toc: true
---

### 文件权限与目录配置
    Linux一般将文件可存取的身份分为三个等级,分别是owner/group/others,且三种身份各有read/write/execute等权限

<!-- more -->

#### 使用者和群组
- 文件所有者
    * 文件属于谁,即用户
- 群组概念
    * 用户的集合,体现共享的特性
- 其他人概念
    * 不属于用户组的集合.注意root也属于其他人,但是root用户可以访问用户组的内容


#### 文件权限概念
- 文件属性
    ```bash
        ls -al

        ...
        drwx------  11      llllljian llllljian 4096        4月  12 13:18 .cache
        -rw-r--r--  1       llllljian llllljian   25        4月  12 09:57 .dmrc
        [权限]      [连接]   [拥有者]  [群组]     [文件容量]  [修改日期]     [文件名]
        ...
    ```
    * 权限
        * 10个字符
        * 第一个表示文件的类型
            * d 目录
            * \- 文件
            * l 连接档
            * b 装置文件里面的可供存储的接口设备
            * c 装置文件里面的串行端口设备
        * 接下来的字符中三个一组,均为[rwx]的参数组合,其中r代表可读,[w]代表可写,[x]代表可操作,没有权限就是[-]
            * 第一组为文件拥有者可具备的权限
            * 第二组为加入此群组的账号的权限
            * 非本人且没有加入本群组的其他账号的权限
    * 连接
        * 有多少档名连接到此节点
    * 拥有者
        * 代表这个文件或目录的拥有者账号
    * 群组
        * 第二组权限中操作相关的组
    * 文件容量
        * 代表这个文件的大小,默认单位是bytes
    * 修改日期
        * 代表这个文件的建档日期或者最近的修改日期,如果被修改日期在很久之前只显示年份
    * 文件名
        * 代表文件名.以.开头的话表示为隐藏文件 
    * 作用
        * 数据安全性
- 修改文件属性和权限
    * -R 进行递归的持续变更.即将该目录下的所有文件目录都发生相应改变
    * chgrp
        * 改变文件的所属群组
        * 修改的组名必须在/etc/group文件中
        * chgrp [-R] dirname/filename
        ```bash
            ls -al
            总用量 16
            drwxrwxrwx 2 root      root      4096 4月  12 13:24 .
            drwxr-xr-x 4 root      root      4096 4月  12 12:06 ..
            -rwxrwxrwx 1 root      root         8 4月  12 13:20 1.txt
            -rw-rw-r-- 1 llllljian llllljian    9 4月  12 13:24 2.txt

            sudo chgrp llllljian 1.txt
            
            ls -al
            总用量 16
            drwxrwxrwx 2 root      root      4096 4月  12 13:24 .
            drwxr-xr-x 4 root      root      4096 4月  12 12:06 ..
            -rwxrwxrwx 1 root      llllljian    8 4月  12 13:20 1.txt
            -rw-rw-r-- 1 llllljian llllljian    9 4月  12 13:24 2.txt
            
            sudo chgrp test 1.txt
            chgrp: 无效的组: "test"
        ```
    * chown
        * 改变文件的拥有者
        * 修改的用户名必须有在/etc/passwd文件中
        * chown [-R] 账号名称 文件或目录
        * chown [-R] 账号名称:组名 文件或目录
        ```bash
            ls -al
            总用量 16
            drwxrwxrwx 2 root      root      4096 4月  12 13:24 .
            drwxr-xr-x 4 root      root      4096 4月  12 12:06 ..
            -rwxrwxrwx 1 root      llllljian    8 4月  12 13:20 1.txt
            -rw-rw-r-- 1 llllljian llllljian    9 4月  12 13:24 2.txt

            chown llllljian 1.txt
            chown: 正在更改'1.txt' 的所有者: 不允许的操作

            sudo chown llllljian 1.txt
            
            ls -al
            总用量 16
            drwxrwxrwx 2 root      root      4096 4月  12 13:24 .
            drwxr-xr-x 4 root      root      4096 4月  12 12:06 ..
            -rwxrwxrwx 1 llllljian llllljian    8 4月  12 13:20 1.txt
            -rw-rw-r-- 1 llllljian llllljian    9 4月  12 13:24 2.txt

            sudo touch 3.txt

            sudo cp 3.txt 3_1.txt

            ls -al 3*
            -rw-r--r-- 1 root root 0 4月  12 14:38 3_1.txt
            -rw-r--r-- 1 root root 0 4月  12 14:37 3.txt

            sudo chown llllljian:llllljian 3_1.txt
            
            ls -al 3*
            -rw-r--r-- 1 llllljian llllljian 0 4月  12 14:38 3_1.txt
            -rw-r--r-- 1 root      root      0 4月  12 14:37 3.txt
        ```
    * chmod
        * 改变文件的权限
        * 数字类型改变
            * r:4 w:2 x:1
            * chmod [-R] xyz 文件或目录
            ```bash
                ls -al 1*
                -rwxrwxrwx 1 llllljian llllljian 8 4月  12 13:20 1.txt
                
                chmod -R 755 1.txt
                
                ls -al 1*
                -rwxr-xr-x 1 llllljian llllljian 8 4月  12 13:20 1.txt
            ```
        * 符号类型改变
            * u:文件所有者 g:群组用户 o:其他用户 a:所有 +:加入 -:除去 =:设定 r:读 w:写 x:操作
            * chmod [u|g|o|a][+|-|=][r|w|x] 文件或目录
            ```bash
                ls -al 3*
                -rw-r--r-- 1 llllljian llllljian 0 4月  12 14:38 3_1.txt
                -rw-r--r-- 1 root      root      0 4月  12 14:37 3.txt
                
                chmod u=rwx,go=rw 3_1.txt
                
                ls -al 3*
                -rwxrw-rw- 1 llllljian llllljian 0 4月  12 14:38 3_1.txt
                -rw-r--r-- 1 root      root      0 4月  12 14:37 3.txt
            
                sudo chmod a=rwx 3.txt

                ls -al 3*
                -rwxrw-rw- 1 llllljian llllljian 0 4月  12 14:38 3_1.txt
                -rwxrwxrwx 1 root      root      0 4月  12 14:37 3.txt
                
                sudo chmod o-rwx 3.txt
                
                ls -al 3*
                -rwxrw-rw- 1 llllljian llllljian 0 4月  12 14:38 3_1.txt
                -rwxrwx--- 1 root      root      0 4月  12 14:37 3.txt
            ```
- 权限对文件与目录的意义
    * 对文件的重要性
        * r 可读写该文件的实际内容,如读取文本文件的文字内容等
        * w 可以编辑 新增 修改文件内容[不包含删除]
        * x 该文件具有可以被系统执行的权限
    * 对目录的重要性
        * r 表示具有读取目录结构列表的权限
        * w 建立新的文件与目录;删除已经存在的文件或目录[不论文件的权限是什么];将已存在的文件或目录进行更名;搬移该目录内的文件目录位置
        * x 代表用户能否进入该目录称为工作目录
- 文件种类和扩展名
    * 文件种类
        * 正规文件 进行存取类型的文件
        * 目录 第一个属性为d的
        * 连结档 类似Windows的快捷方式,第一个属性为l的
        * 设备与装置文件
        * 资料接口文件
        * 数据输送文件
    * 文件扩展名
        * .sh 脚本或批处理文件
        * *.tar,*.zip 经过打包的压缩文件
        * .html,.php 网页相关文件