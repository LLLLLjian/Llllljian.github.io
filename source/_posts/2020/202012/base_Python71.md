---
title: Python_基础 (71)
date: 2020-12-25
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python的文件夹/文件操作

<!-- more -->

#### 先说说我想做的事
> 我要做文件上传、文件移动、临时文件删除、临时文件夹删除

#### 判断路径或文件
- 判断是否绝对路径
    ```python
        os.path.isabs(...)
    ```
- 判断是否真实存在
    ```python
        os.path.exists(...)
    ```
- 判断是否是个目录
    ```python
        os.path.isdir(...)
    ```
- 判断是否是个文件
    ```python
        os.path.isfile(...)
    ```
- eg
    ```bash
        $ cat 20201224_1.py
        import os

        # 注意 \\ ；windows 下是这么表示的；Linux 和 Mac 是 /
        file_dir = "/Users/daineko/Desktop/code/test"                          
        file_name = "20201224_1.py"
        # os.path.join(...) 表示路径链接
        file_abs = os.path.join(file_dir, file_name)            


        '''判断路径或文件'''
        print(1, os.path.isabs(file_dir))                       # 判断是否绝对路径
        print(2, os.path.isabs(file_name))
        print(3, os.path.isabs(file_abs))
        print(4, os.path.exists(file_abs))                      # 判断是否真实存在
        print(5, os.path.exists(os.path.join(file_dir, "xxx")))
        print(6, os.path.isdir(file_dir))                       # 判断是否是个目录
        print(7, os.path.isdir(file_abs))
        print(8, os.path.isfile(file_dir))                       # 判断是否是个文件
        print(9, os.path.isfile(file_abs))
        [daineko@B000000346231Q test 14:33:46 #6]$  -> 

        $ python3 20201224_1.py
        1 True
        2 False
        3 True
        4 True
        5 False
        6 True
        7 False
        8 False
        9 True
    ```

#### 工作目录及创建文件夹操作
- 获取当前工作目录
    ```python
        os.getcwd()
    ```
- 改变工作目录
    ```python
        os.chdir()
    ```
- 列出目录下的文件
    ```python
        os.listdir()
    ```
- 创建单个目录
    ```python
        os.mkdir()
    ```
- 创建多级目录
    ```python
        os.makedirs()
    ```
- eg
    ```bash
        $ cat 20201224_2.py
        import os

        file_dir = "/Users/daineko/Desktop/code/test"

        print(os.getcwd())                                 # 获取当前工作目录
        os.chdir(file_dir)                                  # 改变工作目录
        print(os.getcwd())
        print(os.listdir(file_dir))                         # 列出当前工作目录的所有文件 Python2 不支持 os.listdir()    Python3 会列出当前工作目录下的所有文件
        os.mkdir("test_mkdir")                             # 在当前工作目录下创建文件夹 test_mkdir；注意不可存在相同文件夹,不然会报错
        os.makedirs("test_mkdir/test1")
        os.chdir("./test_mkdir")                          # . 表示本级目录； .. 表示上级目录
        print(os.getcwd())
        for i in range(2, 6):                              # 使用for循环等,可方便的创建多个文件夹
            dir_name = "test" + str(i)
            os.mkdir(dir_name)

        $ python3 20201224_2.py
        /Users/daineko/Desktop/code/test
        /Users/daineko/Desktop/code/test
        ['20201213_1.lua', '20201224_2.py', '20201023_2.py', '20201221_1.py', 't2.sh', '20201023_6.py', 'helloWorld.lua', 't3.sh', '20201023_7.py', '20201109_1.py', 't7.sh', '20201023_3.py', '20201023_4.py', '20201109_2.py', 'log.txt', 't4.sh', 't5.sh', '20201023_1.py', 't1.sh', 'arithmetic', '20201023_5.py', '20201109_3.py', 'helloWorld.py', 'main.py', '20201224_1.py']
        /Users/daineko/Desktop/code/test/test_mkdir
    ```

#### 删除文件夹/文件
- 删除空文件夹
    ```python
        os.rmdir(...)
    ```
- 删除单一文件
    ```python
        os.remove(...)
    ```
- 删除文件夹及其下所有文件
    ```python
        shutil.rmtree(...)
    ```
- eg
    ```bash
        $ cat 20201224_3.py
        import os
        import shutil

        file_dir = "/Users/daineko/Desktop/code/test"

        ''' 删除文件/文件夹 '''
        os.chdir(file_dir+"/test_mkdir")
        print(os.getcwd())                                    # 确保当前工作目录
        print(os.listdir(os.getcwd()))                        # 查看当前文件夹下所有文件
        os.rmdir("test1")                                     # 删除 test1 文件夹(空文件夹)
        print(os.listdir(os.getcwd()))
        os.chdir("../")
        print(os.getcwd())                                    # 切换到上级目录
        print(os.listdir(os.getcwd()))
        shutil.rmtree("test_mkdir")                           # 删除 test_mkdir 及其下所有文件

        $ python3 20201224_3.py 
        /Users/daineko/Desktop/code/test/test_mkdir
        ['test1', 'test4', 'test3', 'test2', 'test5']
        ['test4', 'test3', 'test2', 'test5']
        /Users/daineko/Desktop/code/test
        ['20201213_1.lua', '20201224_2.py', '20201224_3.py', '20201023_2.py', '20201221_1.py', 't2.sh', '20201023_6.py', 'helloWorld.lua', 't3.sh', '20201023_7.py', '20201109_1.py', 't7.sh', '20201023_3.py', '20201023_4.py', '20201109_2.py', 'log.txt', 't4.sh', 'test_mkdir', 't5.sh', '20201023_1.py', 't1.sh', 'arithmetic', '20201023_5.py', '20201109_3.py', 'helloWorld.py', 'main.py', '20201224_1.py']
    ```

#### 重命名文件夹/文件
- 重命名文件夹/文件
- eg
    ```python
        '''
        重命名文件夹/文件
        '''
        os.chdir(file_dir)
        print(os.listdir(os.getcwd()))
        os.rename("test","test1")
        os.rename("test.txt","test1.txt")                # 重命名,注意需要带扩展名
        print(os.listdir(os.getcwd()))
    ```

#### 复制、移动文件夹/文件
- 复制文件,都只能是文件
    ```python
        shutil.copyfile("old","new") 
    ```
- 复制文件夹,都只能是目录,且new必须不存在
    ```python
        shutil.copytree("old","new") 
    ```
- 复制文件/文件夹,复制 old 为 new(new是文件,若不存在,即新建),复制 old 为至 new 文件夹(文件夹已存在)
    ```python
        shutil.copy("old","new") 
    ```
- 移动文件/文件夹至 new 文件夹中
    ```python
        shutil.move("old","new") 
    ```
- eg
    ```python
        import os
        import shutil

        file_dir = "/Users/daineko/Desktop/code/test"

        os.chdir(file_dir)
        shutil.copyfile("test_org.txt","test_copy.txt")        # copy test_org.txt 为 test_copy.txt 若存在,则覆盖
        shutil.copyfile("test_org.txt","test1.txt")            # 存在,覆盖
        shutil.copytree("test_org","test_copytree")            # copy test_org 为 test_copytree(不存在的新目录)
        shutil.copy("test_org.txt","test_copy1.txt")           # 同 copyfile
        shutil.copy("test_org.txt","test_copy")                # 将文件 copy 至 目标文件夹中(须存在)
        shutil.copy("test_org.txt","test_xxx")                 # 将文件 copy 至 目标文件(该文件可不存在,注意类型！)
        print os.listdir(os.getcwd())
        shutil.move("test_org.txt","test_move")                # 将文件 move 至 目标文件夹中
        shutil.move("test_org","test_move")                    # 将文件夹 move 至 目标文件夹中
        print os.listdir(os.getcwd())
    ```






