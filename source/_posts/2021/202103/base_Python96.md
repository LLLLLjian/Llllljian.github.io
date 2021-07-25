---
title: Python_基础 (96)
date: 2021-03-31
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之日常积累

<!-- more -->

#### 文件操作
- eg
    ```python
        >>> import os
        >>> os.path.exists('test')
        True
        >>> os.path.exists('test/getTeacherList.py')
        True
        >>> os.path.isfile('test')
        False
        >>> os.path.isfile('test/getTeacherList.py')
        True
        >>> os.makedirs('test/new')
        >>> os.path.exists('test/new')
        True
    ```

#### startswith()
1. 描述
    * Python startswith() 方法用于检查字符串是否是以指定子字符串开头, 如果是则返回 True, 否则返回 False.如果参数 beg 和 end 指定值, 则在指定范围内检查.
2. 语法
    ```python
        str.startswith(str, beg=0,end=len(string))
    ```
3. 参数
    * str -- 检测的字符串.
    * strbeg -- 可选参数用于设置字符串检测的起始位置.
    * strend -- 可选参数用于设置字符串检测的结束位置.
4. 返回值
    * 如果检测到字符串则返回True, 否则返回False.
5. 实例
    ```python
        str = "this is string example....wow!!!"
        print(str.startswith( 'this' ))
        # out: True
        print(str.startswith( 'is', 2, 4 ))
        # out: True
        print(str.startswith( 'this', 2, 4 ))
        # out: False
    ```

#### endswith()
1. 描述
    * Python endswith() 方法用于判断字符串是否以指定后缀结尾, 如果以指定后缀结尾返回True, 否则返回False.可选参数"start"与"end"为检索字符串的开始与结束位置.
2. 语法
    ```python
        str.endswith(suffix[, start[, end]])
    ```
3. 参数
    * suffix -- 该参数可以是一个字符串或者是一个元素.
    * start -- 字符串中的开始位置.
    * end -- 字符中结束位置.
4. 返回值
    * 如果字符串含有指定的后缀返回True, 否则返回False.
5. 实例
    ```python
        str = "this is string example....wow!!!"
 
        suffix = "wow!!!"
        print(str.endswith(suffix))
        # out: True
        print(str.endswith(suffix,20))
        # out: True
        suffix = "is";
        print(str.endswith(suffix, 2, 4))
        # out: True
        print(str.endswith(suffix, 2, 6))
        # out: False

        if 'test.png'.endswith(('jpg','png','jpeg','bmp')):
	        print(True)
    ```
