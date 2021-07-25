---
title: Python_基础 (81)
date: 2021-02-25
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Python之configparse

<!-- more -->

#### 先说说我想做的事
> 嘻嘻嘻 我学了ConfigParser之后发现还有RawConfigParser、SafeConfigParser 也学一学吧

#### RawConfigParser的使用
- con.ini
    ```bash
        [root@gzbh-online-canary2 test_code_dir]# cat con.ini
        [mysql]
        port = 3306
        username = "llllljian"
    ```
- getconfig.py
    ```python
        >>> cf = configparser.RawConfigParser() 
        >>> cf.read("con.ini")
        ['con.ini']
        >>> cf.get("mysql", "port") 
        '3306'
        >>> cf.set("mysql", "port", "3307")
        >>> cf.get("mysql", "port") 
        '3307'
        >>> cf.write(open("con.ini", "w"))
    ```
    ```bash
        [root@gzbh-online-canary2 test_code_dir]# cat con.ini
        [mysql]
        port = 3307
        username = "llllljian"
    ```

#### SafeConfigParser的使用
- getconfig.py
    ```python
        >>> cf = configparser.SafeConfigParser() 
        >>> cf.read("con.ini")
        ['con.ini']
        >>> cf.get("mysql", "port") 
        '3307'
        >>> cf.set("mysql", "port", "3307")
        >>> cf.get("mysql", "port") 
        '3308'
        >>> cf.write(open("con.ini", "w"))
    ```

#### 三者之间的差别
> RawCnfigParser是最基础的INI文件读取类,ConfigParser、SafeConfigParser支持对%(value)s变量的解析


