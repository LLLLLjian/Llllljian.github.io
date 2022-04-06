---
title: Python_基础 (108)
date: 2021-08-10
tags: Python
toc: true
---

### 快来跟我一起学signal
    python信号处理

<!-- more -->

#### Python信号模块signal
> Python的signal模块负责程序内部的信号处理, 典型的操作包括信号处理函数、暂停并等待信号, 定时发出SIGALRM等
主要针对UNIX平台
- 加载模块
    ```python
        import signal
    ```
- 信号名称
    * signal.SIGUP: 连接挂断
    * signal.SIGILL: 非法指令
    * signal.SIGINT: 终止进程
    * signal.SIGTP: 暂停进程
    * signal.SIGKILL: 杀死进程, 此信号不能被捕获或忽略
        * 用于强制杀死进程, 此信号进程无法忽视, 直接在系统层面将进程杀死, 所以在Python中它是不能监听的
    * signal.SIGQUIT: 终端退出
    * signal.SIGTERM: 终止信号, 软件终止信号
        * 当终端用户输入kill sigerm pid时对应PID的进程会接收到此信号, 此信号进程是可以捕获并指定函数处理. 比如做一下程序清理等工作, 当然也是可以忽视此信号的
    * signal.SIGALRM: 闹钟信号, 由signal.alarm()发起
    * signal.SIGCONT: 继续执行暂停进程
- 信号处理函数
    * 设置发送SIGALRM信号的定时器
        * signal.alarm(time)
            * 功能: 在time秒后向进程自身发送SIGALRM信号
            * 参数: time为时间参数, 单位为秒
            * eg1
                ```bash
                    $ cat sigalrm.py
                    #!/usr/bin/env python
                    # -*- coding:utf-8 -*-

                    import signal
                    import time

                    # 3秒后终止程序
                    signal.alarm(3)

                    while True:
                        time.sleep(1)
                        print("working")

                    $ python3 sigalrm.py
                    working
                    working
                    Alarm clock: 14
                ```
            * eg2
                ```bash
                    # 一个进程中只能设置一个时钟, 如果设置第二个则会覆盖第一个的时间, 并返回第一个的剩余时间, 同时第一个闹钟返回为0
                    $ cat sigalrm1.py
                    #!/usr/bin/env python
                    # -*- coding:utf-8 -*-

                    import signal
                    import time

                    # 3秒后终止程序
                    print(signal.alarm(3))  # output:0
                    time.sleep(1)
                    print(signal.alarm(3))  # output:2

                    while True:
                        time.sleep(1)
                    
                    $ python3 sigalrm1.py
                    0
                    2
                    working
                    working
                    Alarm clock: 14
                ```
        * signal.pause()
            * 使程序进入休眠直到程序接收到某个信号量
            * eg
                ```bash
                    $ cat sigalrm2.py
                    #!/usr/bin/env python
                    # -*- coding:utf-8 -*-

                    import signal
                    import time

                    # 3秒后终止程序
                    print(signal.alarm(3)) # output:0
                    time.sleep(1)
                    print(signal.alarm(3)) # output:2

                    # 阻塞等待信号的发生, 无论什么信号都可以. 
                    signal.pause()

                    while True:
                        time.sleep(1)
                        print("working")

                    $ python3 sigalrm2.py
                    0
                    2
                    Alarm clock: 14
                ```
    * 获取当前程序注册signalnum信号量的处理函数
        * signal.getsignal(signalnum)
            * 作用: 获取当前程序注册signalnum信号量的处理函数
            * 返回值: 可能使Python可调用对象如signal.SIG_DFL、signal.SIG_IGN、None. 
    * 设置信号处理函数
        * signal.signal(sig, handler)
            * 功能: 按照handler处理器制定的信号处理方案处理函数
            * 参数: sig拟需处理的信号 , 处理信号只针对这一种信号其作用. 
            * 参数: handler信号处理方案, 进程可以无视信号采取默认操作也可自定义操作. 
            * handler=SIG_IGN信号被无视ignore或忽略
            * handler=SIG_DFL进程采用默认default行为处理
            * handler=function处理器handler作为函数名称时, 进程采用自定义函数处理. 
            * handler=SIGSTOP SIGKILL不能处理只能采用
            * eg
                ```bash
                    $ cat signal1.py
                    #!/usr/bin/env python
                    # -*- coding:utf-8 -*-

                    import signal

                    # 3秒后终止程序
                    signal.alarm(3)
                    # 当遇到SIGINT即CTRL+C时忽略SIG_IGN
                    signal.signal(signal.SIGINT, signal.SIG_IGN)
                    # 阻塞等待信号的发生, 无论什么信号都可以. 
                    signal.pause()

                    $ python3 signal1.py
                    Alarm clock: 14
                ```
    * 信号拦截
        * 为什么需要设置信号拦截呢？如果使用多线程或多协程, 为了防止主线程结束而子线程和子协程还在运行, 此时就需要使用signal模块, 使用signal模块可以绑定一个处理函数, 当接收步到信号的时候不会立即结束程序. 
        * fun1: signal.signal(signal.SIGTERM, self._term_handler) # SIGTERM 表示关闭程序信号
        * func2: signal.signal(signal.SIGINT, self._term_handler) # SIGINT表示CTRL+C信号
        * 在多线程多协程的程序设计时, 一般多线程或的多协程程序在设计时应该设计一个程序终止标记, 当收到终止信号的时候, 让终止标记状态由False修改为True, 此时运行的程序只有终止标记在False状态下时才能够以运行. 如果由需要休眠的协程, 还应给协程增加一个休眠标记, 当程序休眠的时候休眠标记设置为True, 当收到终止信号的时候, 不仅仅要把终止标记设置为True, 还要将休眠中的协程结束掉. 

#### 实例
- code
    ```bash
        $ cat signal_test.py
        #!/usr/bin/env python
        # -*- coding:utf-8 -*-
        import signal
        import os


        def sig_handler(sig, frame):
            """
            停止信号处理
            """
            f = open("./signal_test.txt", "w")
            try:
                f.write("get signal: %s, I will quit" % sig)
                exit(0)
            except Exception as e:
                f.write(e)
                exit(0)
            finally:
                f.close()


        def main():
            """
            主函数
            """
            signal.signal(signal.SIGTERM, sig_handler)
            signal.signal(signal.SIGINT, sig_handler)
            print("My pid is %s" % os.getpid())

            while True:
                time.sleep(3)


        if __name__ == "__main__":
            main()

        $ python3 signal_test.py
        My pid is 57455

        # 新开一个窗口
        $ kill -1 57455

        # 原窗口输出Hangup: 1并终止
        $ python3 signal_test.py
        My pid is 57455
        Hangup: 1

        $ cat ./signal_test.txt
        get signal: 2, I will quit
    ```
- code1
    ```bash
        $ cat signal_test1.py
        #coding:utf-8

        import signal
        import time
        import sys
        import os


        def handle_int(sig, frame):
            print("get signal: %s, I will quit"%sig)
            sys.exit(0)


        def handle_hup(sig, frame):
            print("get signal: %s"%sig)


        if __name__ == "__main__":
            signal.signal(2, handle_int)
            signal.signal(1, handle_hup)
            print("My pid is %s"%os.getpid())
            while True:
                time.sleep(3)

        # 首先启动程序(根据打印的 pid), 在另外的窗口输入 kill -1 21838 和 kill -HUP 21838, 最后使用 ctrl+c关闭程序.  程序的输出如下: 
        # python signal_test1.py
        My pid is 21838
        get signal: 1
        get signal: 1
        ^Cget signal: 2, I will quit
    ```



