---
title: Python_基础 (80)
date: 2021-02-24
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之configparse

<!-- more -->

#### 先说说我想做的事
> 嘻嘻嘻 我一直写配置文件都是py结尾的, 那.ini得怎么读呀 人傻了

#### configparser简介
> configparser 是用来读取配置文件的包,他还可以读.ini文件

#### configparser初始工作
> 使用configparser 首选需要初始化实例,并读取配置文件
- eg
    ```python
        cf = configparser.configparser()
        cf.read("配置文件名")
    ```

#### configparser常用方法
1. 获取所有sections.也就是将配置文件中所有“[ ]”读取到列表中
    ```python
        s = cf.sections()
        print(s)
    ```
2. 获取指定section 的options.即将配置文件某个section 内key 读取到列表中
    ```python
        o = cf.options("db")
        print(o)
    ```
3. 获取指定section 的配置信息
    ```python
        v = cf.items("db")
    ```
4. 按照类型读取指定section 的option 信息
    ```python
        #可以按照类型读取出来
        db_host = cf.get("db", "db_host")
        db_port = cf.getint("db", "db_port")
        db_user = cf.get("db", "db_user")
        db_pass = cf.get("db", "db_pass")

        # 返回的是整型的
        threads = cf.getint("concurrent", "thread")
        processors = cf.getint("concurrent", "processor")

        print("db_host:%s" % db_host)
        print("db_port:%s" % db_port)
        print("db_user:%s" % db_user)
        print("db_pass:%s" % db_pass)
        print("thread:%s" % thread)
        print("processor:%s" % processor)
    ```
5. 设置某个option的值
    ```python
        cf.set("db", "db_pass", "zhaowei")
        cf.write(open("test.conf", "w"))
    ```
6. 添加一个section
    ```python
        cf.add_section('liuqing')
        cf.set('liuqing', 'int', '15')
        cf.set('liuqing', 'bool', 'true')
        cf.set('liuqing', 'float', '3.1415')
        cf.set('liuqing', 'baz', 'fun')
        cf.set('liuqing', 'bar', 'Python')
        cf.set('liuqing', 'foo', '%(bar)s is %(baz)s!')
        cf.write(open("test.conf", "w"))
    ```
7. 移除section或者option
    ```python
        cf.remove_option('liuqing','int')
        cf.remove_section('liuqing')
        cf.write(open("test.conf", "w"))
    ```


