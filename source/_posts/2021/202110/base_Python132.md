---
title: Python_基础 (132)
date: 2021-10-12
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### threading
> 多线程工作
- 基础
    ```python
        import threading
    ```
- 启动多线程
    * 将函数传到Thread对象
        ```python
            import threading
            import time


            def test():
                print("children thread start")
                time.sleep(2)
                print("children thread end")


            testThread = threading.Thread(target=test, args=())
            testThread.start()
        ```
    * 自定义Thread(继承Thread类)
        ```python
            import threading
            import time


            # 继承至threading.Thread
            class MyThread(threading.Thread):
                def __init__(self):
                    threading.Thread.__init__(self)

                # 重写run方法
                def run(self):
                    print("children thread start")
                    time.sleep(2)
                    print("children thread end")


            testThread = MyThread()
            testThread.start()
        ```
- 控制线程
    * 直接start之后
        ```python
            print("main thread start")
            testThread = MyThread()
            testThread.start()
            time.sleep(1)
            print("main thread end")

            # 执行结果
            # children thread被启动之后, main thread和children thread分别各自执行. 在main thread执行完&children thread没执行完时, main thread会等待children thread执行完成后才会退出
            main thread start
            children thread start
            main thread end
            children thread end
        ```
    * 守护进程
        ```python
            print("main thread start")
            testThread = MyThread()
            testThread.setDaemon(True)
            testThread.start()
            time.sleep(1)
            print("main thread end")

            # 执行结果
            # children thread被设置为守护进程, 带来的变化是main thread执行完成后, children thread会一并退出, 即使没有执行完
            main thread start
            children thread start
            main thread end
        ```
    * 阻塞join
        ```python
            print("main thread start")
            testThread = MyThread()
            testThread.start()
            testThread.join()
            time.sleep(1)
            print("main thread end")

            # 执行结果
            # 使用join的变化: children thread开始执行后, main thread被阻塞. 等到children thread执行完成后, main thread才会继续执行后续code
        ```
- 控制线程1.0
    * 多线程默认情况
        ```python
            import threading
            import time

            def run():
                time.sleep(2)
                print('当前线程的名字是:  ', threading.current_thread().name)
                time.sleep(2)


            if __name__ == '__main__':
                start_time = time.time()
                print('这是主线程: ', threading.current_thread().name)
                thread_list = []
                for i in range(5):
                    t = threading.Thread(target=run)
                    thread_list.append(t)

                for t in thread_list:
                    t.start()

                print('主线程结束！' , threading.current_thread().name)
                print('一共用时: ', time.time()-start_time)

            # 结果分析
            # 1. 我们的计时是对主线程计时, 主线程结束, 计时随之结束, 打印出主线程的用时
            # 2. 主线程的任务完成之后, 主线程随之结束, 子线程继续执行自己的任务, 直到全部的子线程的任务全部结束, 程序结束
            这是主线程:  MainThread
            主线程结束！ MainThread
            一共用时:  0.0006511211395263672
            当前线程的名字是:   Thread-2
            当前线程的名字是:   Thread-4
            当前线程的名字是:   Thread-1
            当前线程的名字是:   Thread-5
            当前线程的名字是:   Thread-3
        ```
    * 设置守护线程
        ```python
            import threading
            import time

            def run():

                time.sleep(2)
                print('当前线程的名字是:  ', threading.current_thread().name)
                time.sleep(2)


            if __name__ == '__main__':

                start_time = time.time()

                print('这是主线程: ', threading.current_thread().name)
                thread_list = []
                for i in range(5):
                    t = threading.Thread(target=run)
                    thread_list.append(t)

                for t in thread_list:
                    t.setDaemon(True)
                    t.start()

                print('主线程结束了！' , threading.current_thread().name)
                print('一共用时: ', time.time()-start_time)

            # 结果分析
            # 非常明显的看到, 主线程结束以后, 子线程还没有来得及执行, 整个程序就退出了
            这是主线程:  MainThread
            主线程结束了！ MainThread
            一共用时:  0.0004990100860595703
        ```
    * join的作用
        ```python
            import threading
            import time

            def run():
                time.sleep(2)
                print('当前线程的名字是:  ', threading.current_thread().name)
                time.sleep(2)

            if __name__ == '__main__':

                start_time = time.time()

                print('这是主线程: ', threading.current_thread().name)
                thread_list = []
                for i in range(5):
                    t = threading.Thread(target=run)
                    thread_list.append(t)

                for t in thread_list:
                    t.setDaemon(True)
                    t.start()

                for t in thread_list:
                    t.join()

                print('主线程结束了！' , threading.current_thread().name)
                print('一共用时: ', time.time()-start_time)
            
            # 结果分析
            # 主线程一直等待全部的子线程结束之后, 主线程自身才结束, 程序退出
            这是主线程:  MainThread
            当前线程的名字是:   Thread-2
            当前线程的名字是:   Thread-4
            当前线程的名字是:   Thread-1
            当前线程的名字是:   Thread-5
            当前线程的名字是:   Thread-3
            主线程结束了！ MainThread
            一共用时:  4.010980129241943
        ```



