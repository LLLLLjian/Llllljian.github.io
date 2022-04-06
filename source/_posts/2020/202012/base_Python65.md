---
title: Python_基础 (65)
date: 2020-12-17
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之threading模块

<!-- more -->

#### 学它
> 上一篇中, 实现定时任务是通过urls.py中直接调用某个函数, 然后通过多线程的方式去实现了不同定时任务的启动, 新接触了threading模块, 所以打算学一下

#### 之前项目中的例子
1. do_test.py
    ```python
        import threading
        import time

        def th():
            while True:
                print(1)
                time.sleep(2)


        def do_test():
            t = threading.Thread(target=th,args=())
            t.setDaemon(True)
            t.start()

        do_test()

        time.sleep(10)
    ```
2. 分析
    1. 先运行do_test(), 启动一个线程去调用th(), 启动之后while True进入死循环, 输出1, sleep2秒, 
    2. 执行到sleep10秒, 10秒之后文件执行完成, 终止线程, 共输出5个1

#### 我写的例子
1. do_test.py
    ```python
        def backend_task():
            while True:
                # 每天02点执行一次
                if (time.strftime("%H:%M") == "02:00"):
                    th = threading.Thread(target=func1)
                    th.setDaemon(True)
                    th.start()
                    time.sleep(30)

                # 每个小时执行一次
                if (time.strftime("%M") == "00"):
                    th = threading.Thread(target=func2)
                    th.setDaemon(True)
                    th.start()
                    time.sleep(30)


        if __name__ == "__main__":
            # 周期性任务
            backend_task()
    ```
2. 分析
    1. 执行python do_teset.py, 默认会执行backend_task(), 会直接进入死循环, 会根据当前的时间点去执行不同的方法
3. 弊端
    * 相当于会有一个死循环一直挂在后台, 如果所有的if条件都不满足就会一直空转, 直到打满

#### threading(多线程)

##### threading函数
> 通常情况下,Python程序启动时,Python解释器会启动一个继承自threading.Thread的threading._MainThread线程对象作为主线程,所以涉及到threading.Thread的方法和函数时通常都算上了这个主线程的,比如在启动程序时打印threading.active_count()的结果就已经是1了
1. threading.active_count()
    * 返回当前存活的threading.Thread线程对象数量,等同于len(threading.enumerate()).
2. threading.current_thread()
    * 返回此函数的调用者控制的threading.Thread线程对象.如果当前调用者控制的线程不是通过threading.Thread创建的,则返回一个功能受限的虚拟线程对象.
3. threading.get_ident()
    * 返回当前线程的线程标识符.注意当一个线程退出时,它的线程标识符可能会被之后新创建的线程复用.
4. threading.enumerate()
    * 返回当前存活的threading.Thread线程对象列表.
5. threading.main_thread()
    * 返回主线程对象,通常情况下,就是程序启动时Python解释器创建的threading._MainThread线程对象.
6. threading.stack_size([size])
    * 返回创建线程时使用的堆栈大小.也可以使用可选参数size指定之后创建线程时的堆栈大小,size可以是0或者一个不小于32KiB的正整数.如果参数没有指定,则默认为0.如果系统或者其他原因不支持改变堆栈大小,则会报RuntimeError错误；如果指定的堆栈大小不合法,则会报ValueError,但并不会修改这个堆栈的大小.32KiB是保证能解释器运行的最小堆栈大小,当然这个值会因为系统或者其他原因有限制,比如它要求的值是大于32KiB的某个值,只需根据要求修改即可

##### threading常量
> threading.TIMEOUT_MAX: 指定阻塞函数(如Lock.acquire()、RLock.acquire()、Condition.wait()等)中参数timeout的最大值,在给这些阻塞函数传参时如果超过了这个指定的最大值会抛出OverflowError错误

##### 线程对象: threading.Thread
> threading.Thread目前还没有优先级和线程组的功能,而且创建的线程也不能被销毁、停止、暂定、恢复或中断.
1. 守护线程
    * 只有所有守护线程都结束,整个Python程序才会退出,但并不是说Python程序会等待守护线程运行完毕,相反,当程序退出时,如果还有守护线程在运行,程序会去强制终结所有守护线程,当守所有护线程都终结后,程序才会真正退出.可以通过修改daemon属性或者初始化线程时指定daemon参数来指定某个线程为守护线程.
2. 非守护线程
    * 一般创建的线程默认就是非守护线程,包括主线程也是,即在Python程序退出时,如果还有非守护线程在运行,程序会等待直到所有非守护线程都结束后才会退出
3. threading.Thread(group=None, target=None, name=None, args=(), kwargs={}, *, daemon=None)
    * group
        * 应该设为None,即不用设置,使用默认值就好,因为这个参数是为了以后实现ThreadGroup类而保留的.
    * target
        * 在run方法中调用的可调用对象,即需要开启线程的可调用对象,比如函数或方法.
    * name
        * 线程名称,默认为“Thread-N”形式的名称,N为较小的十进制数.
    * args
        * 在参数target中传入的可调用对象的参数元组,默认为空元组().
    * kwargs
        * 在参数target中传入的可调用对象的关键字参数字典,默认为空字典{}.
    * daemon
        * 默认为None,即继承当前调用者线程(即开启线程的线程,一般就是主线程)的守护模式属性,如果不为None,则无论该线程是否为守护模式,都会被设置为“守护模式”.
4. start()
    * 开启线程活动.它将使得run()方法在一个独立的控制线程中被调用,需要注意的是同一个线程对象的start()方法只能被调用一次,如果调用多次,则会报RuntimeError错误.
5. run()
    * 此方法代表线程活动.
6. join(timeout=None)
    * 让当前调用者线程(即开启线程的线程,一般就是主线程)等待,直到线程结束(无论它是什么原因结束的),timeout参数是以秒为单位的浮点数,用于设置操作超时的时间,返回值为None.如果想要判断线程是否超时,只能通过线程的is_alive方法来进行判断.join方法可以被调用多次.如果对当前线程使用join方法(即线程在内部调用自己的join方法),或者在线程没有开始前使用join方法,都会报RuntimeError错误.
7. name
    * 线程的名称字符串,并没有什么实际含义,多个线程可以赋予相同的名称,初始值由初始化方法来设置.
8. ident
    * 线程的标识符,如果线程还没有启动,则为None.ident是一个非零整数,参见threading.get_ident()函数.当线程结束后,它的ident可能被其他新创建的线程复用,当然就算该线程结束了,它的ident依旧是可用的.
9. is_alive()
    * 线程是否存活,返回True或者False.在线程的run()运行之后直到run()结束,该方法返回True.
10. daemon
    * 表示该线程是否是守护线程,True或者False.设置一个线程的daemon必须在线程的start()方法之前,否则会报RuntimeError错误.这个值默认继承自创建它的线程,主线程默认是非守护线程的,所以在主线程中创建的线程默认都是非守护线程的,即daemon=False.

##### demo1
- 使用threading.Thread类创建线程简单示例
    ```python
        """
        通过实例化threading.Thread类创建线程
        """
        import time
        import threading


        def test_thread(para='hi', sleep=3):
            """线程运行函数"""
            time.sleep(sleep)
            print(para)


        def main():
            # 创建线程
            thread_hi = threading.Thread(target=test_thread)
            thread_hello = threading.Thread(target=test_thread, args=('hello', 1))
            # 启动线程
            thread_hi.start()
            thread_hello.start()
            print('Main thread has ended!')


        if __name__ == '__main__':
            main()
    ```
- 输出结果
    ```bash
        python demo1.py
        Main thread has ended!
        hello
        hi
    ```

##### demo2
- 使用threading.Thread类的子类创建线程简单示例
    ```python
        """
        通过继承threading.Thread的子类创建线程
        """
        import time
        import threading


        class TestThread(threading.Thread):
            def __init__(self, para='hi', sleep=3):
                # 重写threading.Thread的__init__方法时,确保在所有操作之前先调用threading.Thread.__init__方法
                super().__init__()
                self.para = para
                self.sleep = sleep

            def run(self):
                """线程内容"""
                time.sleep(self.sleep)
                print(self.para)


        def main():
            # 创建线程
            thread_hi = TestThread()
            thread_hello = TestThread('hello', 1)
            # 启动线程
            thread_hi.start()
            thread_hello.start()
            print('Main thread has ended!')


        if __name__ == '__main__':
            main()
    ```
- 输出结果
    ```bash
        python demo2.py
        Main thread has ended!
        hello
        hi
    ```

#### 多线程和多进程的理解
1. 进程ID
    * 多线程的主进程和它的子线程的进程ID,即os.getpid(),都是相同的,都是主进程的进程ID.多进程则是主进程和它的子进程都有各自的进程ID,都不相同.
2. 共享数据
    * 多线程可以共享主进程内的数据,但是多进程用的都是各自的数据,无法共享.
3. 主线程
    * 由Python解释器运行主py时,也就是开启了一个Python进程,而这个py是这个进程内的一个线程,不过不同于其他线程,它是主线程,同时这个进程内还有其他的比如垃圾回收等解释器级别的线程,所以进程就等于主线程这种理解是有误的.
4. CPU多核利用
    * Python解释器的线程只能在CPU单核上运行,开销小,但是这也是缺点,因为没有利用CPU多核的特点.Python的多进程是可以利用多个CPU核心的,但也有其他语言的多线程是可以利用多核的.
5. 单核与多核
    * 一个CPU的主要作用是用来做计算的,多个CPU核心如果都用来做计算,那么效率肯定会提高很多,但是对于IO来说,多个CPU核心也没有太大用处,因为没有输入,后面的动作也无法执行.所以如果一个程序是计算密集型的,那么就该利用多核的优势(比如使用Python的多进程),如果是IO密集型的,那么使用单核的多线程就完全够了.
6. 线程或进程间的切换
    * 线程间的切换是要快于进程间的切换的.
7. 死锁
    * 指的是两个或两个以上的线程或进程在请求锁的时候形成了互相等待阻塞的情况,导致这些线程或进程无法继续执行下去,这时候称系统处于死锁状态或者系统产生了死锁,这些线程或进程就称为死锁线程或死锁进程.解决死锁的办法可以使用递归锁,即threading.RLock,然后线程或进程就可以随意请求和释放锁了,而不用担心别的线程或进程也在请求锁而产生死锁的情况.
8. 信号量与进程池
    * 进程池Pool(n)只能是“池”中的n个进程运行,不能有新的进程,信号量只要保证最大线程数就行,而不是只有这几个线程,旧的线程运行结束,就可以继续来新的线程

