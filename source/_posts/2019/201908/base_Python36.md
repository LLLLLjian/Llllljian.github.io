---
title: Python_基础 (36)
date: 2019-08-15
tags: Python
toc: true
---

### python文件内容搜索、替换、添加
    学习一下python操作文件的方式

<!-- more -->

#### 内容搜索
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent python 18:04:58 #19]$ cat hello.txt
        hello world
        hello python
        hello China
        [llllljian@llllljian-cloud-tencent python 18:05:03 #20]$ cat fileSearch.py
        #文件查找
        import re   #引用re模块

        f1  =  open("hello.txt","r")
        content = f1.read()
        print("输出文件内容：\n",content)      #输出文件内容
        count = len(re.findall("hello",content)) 
        #re.findall()返回的是一个列表

        print("re.findall()的返回值: ",re.findall("hello",content))
        print("共有{}个hello".format(count))
        [llllljian@llllljian-cloud-tencent python 18:05:07 #21]$ python3.5 fileSearch.py
        输出文件内容：
        hello world
        hello python
        hello China

        re.findall()的返回值:  ['hello', 'hello', 'hello']
        共有3个hello
    ```

#### 内容替换
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent python 18:07:02 #25]$ cat fileReplace.py
        f1 = open("hello.txt","r")
        content = f1.read()
        f1.close()

        t = content.replace("hello","hi")
        with open("hello.txt","w") as f2:
            f2.write(t)

        [llllljian@llllljian-cloud-tencent python 18:07:07 #26]$ python3.5 fileReplace.py
        [llllljian@llllljian-cloud-tencent python 18:07:17 #27]$ cat hello.txt
        hi world
        hi python
        hi China
    ```

#### 删除空行
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent python 18:09:35 #34]$ cat fileDelete.py
        # coding = utf-8
        def clearBlankLine():
            file1 = open('text1.txt', 'r', encoding='utf-8') # 要去掉空行的文件 
            file2 = open('text2.txt', 'w', encoding='utf-8') # 生成没有空行的文件
            try:
                for line in file1.readlines():
                    if line == '\n':
                        line = line.strip("\n")
                    file2.write(line)
            finally:
                file1.close()
                file2.close()


        if __name__ == '__main__':
            clearBlankLine()
        [llllljian@llllljian-cloud-tencent python 18:09:54 #35]$ python3.5 fileDelete.py
        [llllljian@llllljian-cloud-tencent python 18:10:03 #36]$ cat text1.txt
        hello world

        hello python

        hellp China
        [llllljian@llllljian-cloud-tencent python 18:10:09 #37]$ cat text2.txt
        hello world
        hello python
        hellp China
    ```
