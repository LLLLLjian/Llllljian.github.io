---
title: Python_基础 (133)
date: 2021-10-13
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### threading.lock
> 在多线程中使用lock可以让多个线程在共享资源的时候不会“乱”
- eg
    ```python
        """
        例如, 创建多个线程, 每个线程都往空列表l中添加一个数字并打印当前的列表l, 如果不加锁, 就可能会这样
        """
        # encoding=utf8
        import threading
        import time
        lock = threading.Lock()
        l = []
        
        def test1(n):
            # 正在占用该资源
            lock.acquire()
            l.append(n)
            print l
            # 已经完成使用该资源了
            lock.release()
        
        def test(n):
            l.append(n)
            print l
        
        def main():
            for i in xrange(0, 10):
                th = threading.Thread(target=test, args=(i, ))
                th.start()

        def main1():
            for i in xrange(0, 10):
                th = threading.Thread(target=test1, args=(i, ))
                th.start()
        if __name__ == '__main__':
            print("main-test")
            main()
            print("main-test1")

        # 运行结果
        main-test
        [0]
        [0, 1]
        [0, 1, 2]
        [0, 1, 2, 3][
        0, 1, 2, 3, 4]
        [0, 1, 2, 3, 4, 5]
        [0, 1, 2, 3, 4[, 05, , 16, , 27, ]3
        , 4, 5, 6[, 07, , 18, ]2
        , 3, 4, [50, , 61, , 72, , 83, , 94], 
        5, 6, 7, 8, 9]
        main-test1
        [0]
        [0, 1]
        [0, 1, 2]
        [0, 1, 2, 3]
        [0, 1, 2, 3, 4]
        [0, 1, 2, 3, 4, 5]
        [0, 1, 2, 3, 4, 5, 6]
        [0, 1, 2, 3, 4, 5, 6, 7]
        [0, 1, 2, 3, 4, 5, 6, 7, 8]
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    ```
