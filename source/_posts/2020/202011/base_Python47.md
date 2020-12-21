---
title: Python_基础 (47)
date: 2020-11-09
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python logging模块

<!-- more -->

#### logging模块简介
> logging模块是Python内置的标准模块，主要用于输出运行日志，可以设置输出日志的等级、日志保存路径、日志文件回滚等；相比print，具备如下优点：
可以通过设置不同的日志等级，在release版本中只输出重要信息，而不必显示大量的调试信息；
print将所有信息都输出到标准输出中，严重影响开发者从标准输出中查看其它数据；logging则可以由开发者决定将信息输出到什么地方，以及怎么输出

#### logging模块使用
1. 基本使用
    ```bash
        import logging
        logging.basicConfig(level = logging.INFO,format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        logger = logging.getLogger(__name__)

        logger.info("Start print log")
        logger.debug("Do something")
        logger.warning("Something maybe fail.")
        logger.info("Finish")

        # 运行输出
        # 2020-11-09 23:24:53,699 - __main__ - INFO - Start print log
        # 2020-11-09 23:24:53,699 - __main__ - WARNING - Something maybe fail.
        # 2020-11-09 23:24:53,699 - __main__ - INFO - Finish

        # 将日志等级设置为DEBUG
        # logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        # 2020-11-09 23:28:02,273 - __main__ - INFO - Start print log
        # 2020-11-09 23:28:02,274 - __main__ - DEBUG - Do something
        # 2020-11-09 23:28:02,274 - __main__ - WARNING - Something maybe fail.
        # 2020-11-09 23:28:02,274 - __main__ - INFO - Finish

        # 将日志具体到行
        # logging.basicConfig(level=logging.INFO, format='%(asctime)s %(filename)s [line:%(lineno)d] %(levelname)s %(message)s')
        # 2020-11-09 23:35:27,658 20201109_1.py [line:7] INFO Start print log
        # 2020-11-09 23:35:27,658 20201109_1.py [line:9] WARNING Something maybe fail.
        # 2020-11-09 23:35:27,658 20201109_1.py [line:10] INFO Finish
    ```
    - logging.basicConfig函数各参数
        * filename：指定日志文件名
        * filemode：和file函数意义相同，指定日志文件的打开模式，'w'或者'a'；
        * format：指定输出的格式和内容，format可以输出很多有用的信息，
            * %(levelno)s：打印日志级别的数值
            * %(levelname)s：打印日志级别的名称
            * %(pathname)s：打印当前执行程序的路径，其实就是sys.argv[0]
            * %(filename)s：打印当前执行程序名
            * %(funcName)s：打印日志的当前函数
            * %(lineno)d：打印日志的当前行号
            * %(asctime)s：打印日志的时间
            * %(thread)d：打印线程ID
            * %(threadName)s：打印线程名称
            * %(process)d：打印进程ID
            * %(message)s：打印日志信息
        * datefmt：指定时间格式，同time.strftime()；
        * level：设置日志级别，默认为logging.WARNNING；
        * stream：指定将日志的输出流，可以指定输出到sys.stderr，sys.stdout或者文件，默认输出到sys.stderr，当stream和filename同时指定时，stream被忽略；
2. 将日志写入到文件
    * 将日志写入到文件
        ```bash
            import logging
            logger = logging.getLogger(__name__)
            logger.setLevel(level = logging.INFO)
            handler = logging.FileHandler("log.txt")
            handler.setLevel(logging.INFO)
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            handler.setFormatter(formatter)
            logger.addHandler(handler)

            logger.info("Start print log")
            logger.debug("Do something")
            logger.warning("Something maybe fail.")
            logger.info("Finish")

            # log.txt文件中的内容
            # 2020-11-09 23:37:54,777 - __main__ - INFO - Start print log
            # 2020-11-09 23:37:54,777 - __main__ - WARNING - Something maybe fail.
            # 2020-11-09 23:37:54,777 - __main__ - INFO - Finish
        ```
    * 将日志同时输出到屏幕和日志文件
        ```bash
            import logging
            logger = logging.getLogger(__name__)
            logger.setLevel(level = logging.INFO)
            handler = logging.FileHandler("log.txt")
            handler.setLevel(logging.INFO)
            formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            handler.setFormatter(formatter)

            console = logging.StreamHandler()
            console.setLevel(logging.INFO)

            logger.addHandler(handler)
            logger.addHandler(console)

            logger.info("Start print log")
            logger.debug("Do something")
            logger.warning("Something maybe fail.")
            logger.info("Finish")

            # 控制台中
            # Start print log
            # Something maybe fail.
            # Finish

            # 文件中
            # 2020-11-09 23:39:53,563 - __main__ - INFO - Start print log
            # 2020-11-09 23:39:53,563 - __main__ - WARNING - Something maybe fail.
            # 2020-11-09 23:39:53,563 - __main__ - INFO - Finish
        ```
    - logging中包含的handler
        * StreamHandler：logging.StreamHandler；日志输出到流，可以是sys.stderr，sys.stdout或者文件
        * FileHandler：logging.FileHandler；日志输出到文件
        * BaseRotatingHandler：logging.handlers.BaseRotatingHandler；基本的日志回滚方式
        * RotatingHandler：logging.handlers.RotatingHandler；日志回滚方式，支持日志文件最大数量和日志文件回滚
        * TimeRotatingHandler：logging.handlers.TimeRotatingHandler；日志回滚方式，在一定时间区域内回滚日志文件
        * SocketHandler：logging.handlers.SocketHandler；远程输出日志到TCP/IP sockets
        * DatagramHandler：logging.handlers.DatagramHandler；远程输出日志到UDP sockets
        * SMTPHandler：logging.handlers.SMTPHandler；远程输出日志到邮件地址
        * SysLogHandler：logging.handlers.SysLogHandler；日志输出到syslog
        * NTEventLogHandler：logging.handlers.NTEventLogHandler；远程输出日志到Windows NT/2000/XP的事件日志
        * MemoryHandler：logging.handlers.MemoryHandler；日志输出到内存中的指定buffer
        * HTTPHandler：logging.handlers.HTTPHandler；通过"GET"或者"POST"远程输出到HTTP服务器
3. 设置消息的等级
    * 可以设置不同的日志等级，用于控制日志的输出，
    * 日志等级：使用范围
        * FATAL：致命错误
        * CRITICAL：特别糟糕的事情，如内存耗尽、磁盘空间为空，一般很少使用
        * ERROR：发生错误时，如IO操作失败或者连接问题
        * WARNING：发生很重要的事件，但是并不是错误时，如用户登录密码错误
        * INFO：处理请求或者状态变化等日常事务
        * DEBUG：调试过程中使用DEBUG等级，如算法中每个循环的中间状态



