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
    * 用于递归删除目录
- 格式
    * os.removedirs(path)
- 参数
    * path
        * 要移除的目录路径

#### os.rename(src, dst)
- 功能
    * 用于命名文件或目录，从 src 到 dst,如果dst是一个存在的目录, 将抛出OSError
- 格式
    * os.rename(src, dst)
- 参数
    * src : 要修改的目录名
    * dst : 修改后的目录名


#### os.path模块
- list
    <table class="reference"><tbody><tr><th>方法</th><th>说明</th></tr><tr><td>os.path.abspath(path)</td><td>返回绝对路径</td></tr><tr><td>os.path.basename(path)</td><td>返回文件名</td></tr><tr><td>os.path.commonprefix(list)</td><td>返回list(多个路径)中，所有path共有的最长的路径</td></tr><tr><td>os.path.dirname(path)</td><td>返回文件路径</td></tr><tr><td>os.path.exists(path)</td><td>路径存在则返回True,路径损坏返回False</td></tr><tr><td>os.path.lexists</td><td>路径存在则返回True,路径损坏也返回True</td></tr><tr><td>os.path.expanduser(path)</td><td>把path中包含的"~"和"~user"转换成用户目录</td></tr><tr><td>os.path.expandvars(path)</td><td>根据环境变量的值替换path中包含的"$name"和"${name}"</td></tr><tr><td>os.path.getatime(path)</td><td>返回最近访问时间（浮点型秒数）</td></tr><tr><td>os.path.getmtime(path)</td><td>返回最近文件修改时间</td></tr><tr><td>os.path.getctime(path)</td><td>返回文件path创建时间</td></tr><tr><td>os.path.getsize(path)</td><td>返回文件大小，如果文件不存在就返回错误</td></tr><tr><td>os.path.isabs(path)</td><td>判断是否为绝对路径</td></tr><tr><td>os.path.isfile(path)</td><td>判断路径是否为文件</td></tr><tr><td>os.path.isdir(path)</td><td>判断路径是否为目录</td></tr><tr><td>os.path.islink(path)</td><td>判断路径是否为链接</td></tr><tr><td>os.path.ismount(path)</td><td>判断路径是否为挂载点</td></tr><tr><td>os.path.join(path1[,path2[,...]])</td><td>把目录和文件名合成一个路径</td></tr><tr><td>os.path.normcase(path)</td><td>转换path的大小写和斜杠</td></tr><tr><td>os.path.normpath(path)</td><td>规范path字符串形式</td></tr><tr><td>os.path.realpath(path)</td><td>返回path的真实路径</td></tr><tr><td>os.path.relpath(path[,start])</td><td>从start开始计算相对路径</td></tr><tr><td>os.path.samefile(path1,path2)</td><td>判断目录或文件是否相同</td></tr><tr><td>os.path.sameopenfile(fp1,fp2)</td><td>判断fp1和fp2是否指向同一文件</td></tr><tr><td>os.path.samestat(stat1,stat2)</td><td>判断stat tuple stat1和stat2是否指向同一个文件</td></tr><tr><td>os.path.split(path)</td><td>把路径分割成dirname和basename，返回一个元组</td></tr><tr><td>os.path.splitdrive(path)</td><td>一般用在windows下，返回驱动器名和路径组成的元组</td></tr><tr><td>os.path.splitext(path)</td><td>分割路径，返回路径名和文件扩展名的元组</td></tr><tr><td>os.path.splitunc(path)</td><td>把路径分割为加载点与文件</td></tr><tr><td>os.path.walk(path,visit,arg)</td><td>遍历path，进入每个目录都调用visit函数，visit函数必须有3个参数(arg,dirname,names)，dirname表示当前目录的目录名，names代表当前目录下的所有文件名，args则为walk的第三个参数</td></tr><tr><td>os.path.supports_unicode_filenames</td><td>设置是否支持unicode路径名</td></tr></tbody></table>
