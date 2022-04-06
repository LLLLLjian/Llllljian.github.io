---
title: Python_基础 (115)
date: 2021-08-20
tags: Python
toc: true
---

### python之pylint
    写了一段时间python代码了, 但还是半路出家, 代码规范上还是需要注意, 最近组内提出了pylint, 用来提高代码质量, 学习一下

<!-- more -->

#### 需求背景

Pylint 是一个 Python 代码分析工具, 它分析 Python 代码中的错误, 查找不符合代码风格标准和有潜在问题的代码. 

Pylint 是一个 Python 工具, 除了平常代码分析工具的作用之外, 它提供了更多的功能: 如检查一行代码的长度, 变量名是否符合命名标准, 一个声明过的接口是否被真正实现等等. 

Pylint 的一个很大的好处是它的高可配置性, 高可定制性, 并且可以很容易写小插件来添加功能. 

项目中需要做代码规范检查, 所以研究一下pylint的使用. 

#### pylint使用
- 安装pylint
    ```bash
        pip install pylint
    ```
- 确认pylint安装成功
    ```bash
        pylint 2.9.6
        astroid 2.6.5
        Python 3.8.2 (default, Sep 24 2020, 19:37:08) 
        [Clang 12.0.0 (clang-1200.0.32.21)]
    ```
- 生成默认配置文件
    ```bash
        # 查看当前目录下, 已经生成了名为pylint.conf的文件, 该文件中的配置项都是pylint的默认配置, 比较大400多行
        pylint --persistent=n --generate-rcfile > pylint.conf
        No config file found, using default configuration
    ```
- check单个文件
    ```bash
        pylint flvtomp3.py
        ************* Module flvtomp3
        flvtomp3.py:1:0: C0114: Missing module docstring (missing-module-docstring)
        flvtomp3.py:15:16: R1724: Unnecessary "else" after "continue" (no-else-continue)
        flvtomp3.py:3:0: C0411: standard import "import os" should be placed before "import imageio" (wrong-import-order)

        ------------------------------------------------------------------
        Your code has been rated at 8.33/10 (previous run: 8.33/10, +0.00)
    ```
- check整个文件夹
    ```bash
        pylint test
    ```
- 输出结果分析
    * eg: flvtomp3.py:1:0: C0114: Missing module docstring (missing-module-docstring)
    * flvtomp3.py 文件名
    * 1 行号
    * 0 列号
    * C: 表示convention, 规范
        * pylint结果总共有四个级别
        * error
        * warning 告警
        * refactor
        * convention 规范
    * Missing module docstring 提示信息
    * missing-module-docstring 消息类型
- .pylintrc
    * 重命名pylint.conf为.pylintrc, 即不需要每次执行都带上--rcfile参数了
    * 优先级: .pylintrc > pylintrc > .config/pylintrc > /etc/pylintrc
- config
    ```bash
        # .pylintrc 文件用于为pylint进行自定义配置

        [MASTER]
        # XXX 应被替换为你指定的文件夹如(./custom_master)
        init-hook='base_dir="./master"; import sys,os,re; _re=re.search(r".+\/" + base_dir, os.getcwd()); project_dir = _re.group() if _re else os.path.join(os.getcwd(), base_dir); sys.path.append(project_dir)'

        [MESSAGES CONTROL]
        # Find available symbolic names in:
        # https://docs.pylint.org/features.html
        disable=import-error, line-too-long, superfluous-parens, protected-access, unused-argument, invalid-name, no-self-use, no-member, arguments-differ
    ```
