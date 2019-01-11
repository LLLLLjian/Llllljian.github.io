---
title: Python_基础 (19)
date: 2019-01-02
tags: Python
toc: true
---

### Python3 OS
    Python3学习笔记
    os模块处理文件和目录

<!-- more -->

#### os.access()
- 功能
    * 使用当前的uid/gid尝试访问路径
- 格式
    * os.access(path, mode);
- 参数
    * path
        * 要用来检测是否有访问权限的路径
    * mode
        * os.F_OK : 是否存在
        * os.R_OK : 是否可读.
        * os.W_OK : 是否可写.
        * os.X_OK : 是否可执行
- eg
    ```python
        #!/usr/bin/python3

        import os, sys

        # 假定 /tmp/foo.txt 文件存在,并有读写权限

        ret = os.access("/tmp/foo.txt", os.F_OK)
        print ("F_OK - 返回值 %s"% ret)

        ret = os.access("/tmp/foo.txt", os.R_OK)
        print ("R_OK - 返回值 %s"% ret)

        ret = os.access("/tmp/foo.txt", os.W_OK)
        print ("W_OK - 返回值 %s"% ret)

        ret = os.access("/tmp/foo.txt", os.X_OK)
        print ("X_OK - 返回值 %s"% ret)
    ```

#### os.chdir()
- 功能
    * 改变当前工作目录到指定的路径
- 格式
    * os.chdir(path)
- 参数
    * path
        * 要切换到的新路径
- eg
    ```python
        #!/usr/bin/python3

        import os, sys

        path = "/tmp"

        # 查看当前工作目录
        retval = os.getcwd()
        print ("当前工作目录为 %s" % retval)

        # 修改当前工作目录
        os.chdir( path )

        # 查看修改后的工作目录
        retval = os.getcwd()

        print ("目录修改成功 %s" % retval)

        # 输出结果
        当前工作目录为 /www
        目录修改成功 /tmp
    ```

#### os.removedirs()
- 功能
- 格式
- 参数






















