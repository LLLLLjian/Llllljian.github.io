---
title: Linux_基础 (13)
date: 2018-04-26
tags: Linux
toc: true
---

### 目录与路径
    主要说明一下目录与路径

<!-- more -->

#### 相对路径和绝对路径  
- 相对路径
    * 不是由/写起的
    * 相对于当前工作目录的路径
    * 相对于同一个文件夹下的其它文件,查找起来比较方便
- 绝对路径
    * 一定由根目录/写起
    * 准确度高,一般不会有问题

#### 目录的相关操作
- 特殊目录
    * . 代表此层目录
    * .. 代表上一层目录
    * \- 代表前一个工作目录
    * ~ 代表 [目前用户身份] 所在的家目录
    * ~othername 代表 othername 这个用户的家目录[othername用户不在的话会提示找不到该文件夹]
    * 根目录的上一层和根目录是同一个目录.在根目录中cd ../还是本身
- 常见处理目录命令
    * cd 
        * change directory,变更目录
        * cd [相对路径或绝对路径]
        * 目录名称与cd指令之间有一个空格
        * 仅输入cd = cd ~.也就是回到自己账号的家目录
    * pwd
        * print working directory,显示目前所在的目录
        * pwd [-P]
        * 加上参数P,可以显示软链接正确的目录名称
    * mkdir
        * make directory,创建新的目录
        * 在没有额外参数的情况下,需要的目录必须一层一层建立
        * 加上参数-p,可以直接建立多层目录
        * 加上参数-m,可以给目录加上相关权限
    * rmdir
        * remove directory,移除目录
        * 在没有额外参数的情况下,只能删除空的目录

#### 关于执行文件路径的变量:$PATH
- 不同身份用户预设的PATH不同，预设能够随意执行的指令也不同；  
- PATH是可以修改的；  
- 使用绝对路径或相对路径直接指定某个命令的文件名进行执行，会比查找PATH正确性更高；  
- 命令应该要放到正确的目录下，执行才会比较方便；  
- 本地目录(.)最好不要放到PATH当中[为了安全起见,防止有人恶意操作命令]
```bash
    执行命令 ls  
    执行命令 /bin/ls 输出结果一致

    echo $PATH  
    /usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/llllljian/.local/bin:/home/llllljian/bin

    分析一下当前执行文件路径
    不同目录中间用冒号隔开,目录是有顺序之分的
    /usr/local/bin: 用户自己编译的
    /usr/bin: 系统repository提供的应用程序
    /usr/local/sbin: 用户自己编译的
    /usr/sbin: 放置一些用户安装的系统管理的必备程式
    /home/llllljian/.local/bin: 当前用户家目录下本地的bin
    /home/llllljian/bin  当前用户家目录下的bin
```

