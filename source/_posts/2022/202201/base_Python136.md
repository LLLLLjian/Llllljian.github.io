---
title: Python_基础 (136)
date: 2022-01-21
tags: Python
toc: true
---

### 详解Python中requirements.txt和setup.py
    详解Python中requirements.txt和setup.py

<!-- more -->

#### requirements.txt
> Python项目中必须包含一个 requirements.txt 文件, 用于记录所有依赖包及其精确的版本号.以便新环境部署.
1. 写法
    ```bash
        pip freeze > requirements.txt # 生成requirements.txt
        pip install -r requirements.txt # 从requirements.txt安装依赖
    ```
2. 支持的写法
    ```bash
        -r base.txt # base.txt下面的所有包
        pypinyin==0.12.0 # 指定版本(最日常的写法)
        django-querycount>=0.5.0 # 大于某个版本
        django-debug-toolbar>=1.3.1,<=1.3.3 # 版本范围
        ipython # 默认(存在不替换, 不存在安装最新版)
    ```
3. 推荐用法
    ```bash
        # 一般项目会分为开发环境, 测试环境, 生产环境等……依赖的包会不同.推荐在文件夹下为每个环境建立一个requirements.txt文件.公有的包存在base.txt供引用
        ➜ meeting git:(sync) ✗ tree requirements -h
        requirements
        ├── [ 286] base.txt
        ├── [ 80] local.txt
        └── [ 28] production.txt
    ```

#### setup.py
> 编写python的第三方库, 最终要的一个工作就是编写setup.py了, 其实如果我们下载过一些第三库的源代码文件, 打开之后一般就会有一个setup.py,执行python setup.py install 就可以安装这个库了
- code
    ```python
        import os

        from setuptools import setup, find_packages

        here = os.path.abspath(os.path.dirname(__file__))

        # Avoids IDE errors, but actual version is read from version.py
        __version__ = None
        with open("rasa/version.py") as f:
            exec (f.read())

        # Get the long description from the README file
        with open(os.path.join(here, "README.md"), encoding="utf-8") as f:
            long_description = f.read()

        tests_requires = [
            "pytest~=4.5",
            "pytest-cov~=2.7",
            "pytest-localserver~=0.5.0",
            "pytest-sanic~=1.0.0",
            "responses~=0.9.0",
            "freezegun~=0.3.0",
            "nbsphinx>=0.3",
            "aioresponses~=0.6.0",
            "moto~=1.3.8",
        ]

        install_requires = [
            "requests~=2.22",
            "boto3~=1.9",
            "matplotlib~=3.0",
            "simplejson~=3.16",
            "attrs>=18",
            "jsonpickle~=1.1",
            "redis~=3.2",
            "fakeredis~=1.0",
            "pymongo~=3.8",
            "numpy~=1.16",
            "scipy~=1.2",
            "tensorflow~=1.13.0",
            "apscheduler~=3.0",
            "tqdm~=4.0",
            "networkx~=2.3",
            "fbmessenger~=6.0",
            "pykwalify~=1.7.0",
            "coloredlogs~=10.0",
            "scikit-learn~=0.20.2",
            "ruamel.yaml~=0.15.0",
            "scikit-learn~=0.20.0",
            "slackclient~=1.3",
            "python-telegram-bot~=11.0",
            "twilio~=6.0",
            "webexteamssdk~=1.1",
            "mattermostwrapper~=2.0",
            "rocketchat_API~=0.6.0",
            "colorhash~=1.0",
            "pika~=1.0.0",
            "jsonschema~=2.6",
            "packaging~=19.0",
            "gevent~=1.4",
            "pytz~=2019.1",
            "python-dateutil~=2.8",
            "rasa-sdk~=1.0.0rc4",
            "colorclass~=2.2",
            "terminaltables~=3.1",
            "sanic~=19.3.1",
            "sanic-cors~=0.9.0",
            "sanic-jwt~=1.3",
            "aiohttp~=3.5",
            "questionary>=1.1.0",
            "python-socketio~=4.0",
            "pydot~=1.4",
            "async_generator~=1.10",
            "SQLAlchemy~=1.3.0",
            "kafka-python~=1.4",
            "sklearn-crfsuite~=0.3.6",
            # temporary dependency, until https://github.com/boto/botocore/issues/1733 is fixed
            "urllib3<1.25",
        ]

        extras_requires = {
            "test": tests_requires,
            "spacy": ["spacy>=2.1,<2.2"],
            "mitie": ["mitie"],
            "sql": ["psycopg2~=2.8.2", "SQLAlchemy~=1.3"],
        }
        # 启动入口
        setup(
            name="rasa", # 包名称
            classifiers=[ # 程序所属分类列表
                "Development Status :: 4 - Beta",
                "Intended Audience :: Developers",
                "License :: OSI Approved :: Apache Software License",
                # supported python versions
                "Programming Language :: Python",
                "Programming Language :: Python :: 3.5",
                "Programming Language :: Python :: 3.6",
                "Programming Language :: Python :: 3.7",
                "Topic :: Software Development :: Libraries",
            ],
            packages=find_packages(exclude=["tests", "tools", "docs", "contrib"]), # 需要处理的包目录
            entry_points={"console_scripts": ["rasa=rasa.__main__:main"]}, # 动态发现服务和插件
            version=__version__, # 包版本
            install_requires=install_requires, # 需要安装的依赖包
            tests_require=tests_requires,
            extras_require=extras_requires,
            include_package_data=True,
            description="Open source machine learning framework to automate text- and " # 包详细描述
            "voice-based conversations: NLU, dialogue management, connect to "
            "Slack, Facebook, and more - Create chatbots and voice assistants",
            long_description=long_description, # 长描述, 通常是readme, 打包到PiPy需要
            long_description_content_type="text/markdown", # 长描述文档类型
            author="Rasa Technologies GmbH", # 作者名称
            author_email="hi@rasa.com", # 作者邮箱
            maintainer="Tom Bocklisch", # 维护人员名称
            maintainer_email="tom@rasa.com", # 维护人员邮箱
            license="Apache 2.0", # 版权信息
            keywords="nlp machine-learning machine-learning-library bot bots "
            "botkit rasa conversational-agents conversational-ai chatbot"
            "chatbot-framework bot-framework", # 关键词
            url="https://rasa.com", # 项目官网
            download_url="https://github.com/RasaHQ/rasa/archive/{}.tar.gz"
            "".format(__version__), # 下载地址
            project_urls={
                "Bug Reports": "https://github.com/rasahq/rasa/issues",
                "Source": "https://github.com/rasahq/rasa",
            }, # 项目工程地址
        )

        print ("\nWelcome to Rasa!")
        print (
            "If you have any questions, please visit our documentation page: https://rasa.com/docs/"
        )
        print ("or join the community discussions on https://forum.rasa.com/")
    ```
- setup函数常用的参数
    <table><thead><tr><th>参数</th><th style="text-align:center">说明</th></tr></thead><tbody><tr><td>name</td><td style="text-align:center">包名称</td></tr><tr><td>version</td><td style="text-align:center">包版本</td></tr><tr><td>author</td><td style="text-align:center">程序的作者</td></tr><tr><td>author_email</td><td style="text-align:center">程序的作者的邮箱地址</td></tr><tr><td>maintainer</td><td style="text-align:center">维护者</td></tr><tr><td>maintainer_email</td><td style="text-align:center">维护者的邮箱地址</td></tr><tr><td>url</td><td style="text-align:center">程序的官网地址</td></tr><tr><td>license</td><td style="text-align:center">程序的授权信息</td></tr><tr><td>description</td><td style="text-align:center">程序的简单描述</td></tr><tr><td>long_description</td><td style="text-align:center">程序的详细描述</td></tr><tr><td>platforms</td><td style="text-align:center">程序适用的软件平台列表</td></tr><tr><td>classifiers</td><td style="text-align:center">程序的所属分类列表</td></tr><tr><td>keywords</td><td style="text-align:center">程序的关键字列表</td></tr><tr><td>packages]</td><td style="text-align:center">需要处理的包目录(通常为包含<strong>init</strong>.py 的文件夹)</td></tr><tr><td>py_modules</td><td style="text-align:center">需要打包的 Python 单文件列表</td></tr><tr><td>download_url</td><td style="text-align:center">程序的下载地址</td></tr><tr><td>cmdclass</td><td style="text-align:center">添加自定义命令</td></tr><tr><td>package_data</td><td style="text-align:center">指定包内需要包含的数据文件</td></tr><tr><td>include_package_data</td><td style="text-align:center">自动包含包内所有受版本控制(cvs/svn/git)的数据文件</td></tr><tr><td>exclude_package_data</td><td style="text-align:center">当 include_package_data 为 True 时该选项用于排除部分文件</td></tr><tr><td>data_files</td><td style="text-align:center">打包时需要打包的数据文件, 如图片, 配置文件等</td></tr><tr><td>ext_modules</td><td style="text-align:center">指定扩展模块</td></tr><tr><td>scripts</td><td style="text-align:center">指定可执行脚本,安装时脚本会被安装到系统 PATH 路径下</td></tr><tr><td>package_dir</td><td style="text-align:center">指定哪些目录下的文件被映射到哪个源码包</td></tr><tr><td>requires</td><td style="text-align:center">指定依赖的其他包</td></tr><tr><td>provides</td><td style="text-align:center">指定可以为哪些模块提供依赖</td></tr><tr><td>install_requires</td><td style="text-align:center">安装时需要安装的依赖包</td></tr><tr><td>entry_points</td><td style="text-align:center">动态发现服务和插件, 下面详细讲</td></tr><tr><td>setup_requires</td><td style="text-align:center">指定运行 setup.py 文件本身所依赖的包</td></tr><tr><td>dependency_links</td><td style="text-align:center">指定依赖包的下载地址</td></tr><tr><td>extras_require</td><td style="text-align:center">当前包的高级/额外特性需要依赖的分发包</td></tr><tr><td>zip_safe</td><td style="text-align:center">不压缩包, 而是以目录的形式安装</td></tr></tbody></table>

