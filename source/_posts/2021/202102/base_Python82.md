---
title: Python_基础 (82)
date: 2021-02-26
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Python之configparse

<!-- more -->

#### 先说说我想做的事
> 嘻嘻嘻 有几个例子记录一下

#### 例子1
> 读取 ini 配置文件, encoding="utf-8"为了放置读取的适合中文乱码
- config.ini
    ```bash
        #config.ini
        [DEFAULT]
        excel_path = ../test_cases/case_data.xlsx
        log_path = ../logs/test.log
        log_level = 1
        
        [email]
        user_name = 32@qq.com
        password = 123456
    ```
- getconfig.py
    ```python
        import configparser
 
        #创建配置文件对象
        conf = configparser.ConfigParser()
        #读取配置文件
        conf.read('config.ini', encoding="utf-8")
        #列表方式返回配置文件所有的section
        print( config.sections() )    #结果：['default', 'email']
        #列表方式返回配置文件email 这个section下的所有键名称
        print( conf.options('email') )    #结果：['user_name', 'password']
        #以[(),()]格式返回 email 这个section下的所有键值对
        print( conf.items('email') )    #结果：[('user_name', '32@qq.com'), ('password', '123456')]
        #使用get方法获取配置文件具体的值,get方法：参数1-->section(节) 参数2-->key(键名)
        value = conf.get('default', 'excel_path')
        print(value)
    ```

#### 例子2
> 写入 ini 配置文件(字典形式)
- getconfig.py
    ```python
        import configparser
 
        #创建配置文件对象
        conf = configparser.ConfigParser()
        #'DEFAULT'为section的名称,值中的字典为section下的键值对
        conf["DEFAULT"] = {'excel_path' : '../test_cases/case_data.xlsx' , 'log_path' : '../logs/test.log'}
        conf["email"] = {'user_name':'32@qq.com','password':'123456'}
        #把设置的conf对象内容写入config.ini文件
        with open('config.ini', 'w') as configfile:
            conf.write(configfile)
    ```

#### 例子3
> 写入 ini 配置文件(方法形式), 使用add_section方法时,如果配置文件存在section,则会报错；而set方法在使用时,有则修改,无则新建.
- getconfig.py
    ```python
        import configparser
 
        #创建配置文件对象
        conf = configparser.ConfigParser()
        #读取配置文件
        conf.read('config.ini', encoding="utf-8")
        #在conf对象中新增section
        conf.add_section('webserver')
        #在section对象中新增键值对
        conf.set('webserver','ip','127.0.0.1')
        conf.set('webserver','port','80')
        #修改'DEFAULT'中键为'log_path'的值,如没有该键,则新建
        conf.set('DEFAULT','log_path','test.log')
        #删除指定section
        conf.remove_section('email')
        #删除指定键值对
        conf.remove_option('DEFAULT','excel_path')
        #写入config.ini文件
        with open('config.ini', 'w') as f:
            conf.write(f)
    ```



