---
title: Python_基础 (135)
date: 2021-10-15
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### queue
> 以前光知道这个是python的queue模块, 可以实现队列, 这里刚好有机会看看源码
- 起步
    * queue 模块提供适用于多线程编程的先进先出(FIFO)数据结构. 因为它是线程安全的, 所以多个线程很轻松地使用同一个实例
- base_code
    ```python
        '''A multi-producer, multi-consumer queue.'''

        import threading
        from collections import deque
        from heapq import heappush, heappop
        from time import monotonic as time
        try:
            from _queue import SimpleQueue
        except ImportError:
            SimpleQueue = None

        __all__ = ['Empty', 'Full', 'Queue', 'PriorityQueue', 'LifoQueue', 'SimpleQueue']


        try:
            from _queue import Empty
        except ImportError:
            class Empty(Exception):
                'Exception raised by Queue.get(block=0)/get_nowait().'
                pass

        class Full(Exception):
            'Exception raised by Queue.put(block=0)/put_nowait().'
            pass


        class Queue:
            '''Create a queue object with a given maximum size.

            If maxsize is <= 0, the queue size is infinite.
            '''

            def __init__(self, maxsize=0):
                # 设置队列的最大容量
                self.maxsize = maxsize
                self._init(maxsize)

                # 线程锁, 互斥变量
                self.mutex = threading.Lock()
                # 由锁衍生出三个条件变量
                self.not_empty = threading.Condition(self.mutex)
                self.not_full = threading.Condition(self.mutex)
                self.all_tasks_done = threading.Condition(self.mutex)
                self.unfinished_tasks = 0

            def task_done(self):
                '''
                在完成一项工作后, 向任务已经完成的队列发送一个信号
                唤醒正在阻塞的 join() 操作
                '''
                with self.all_tasks_done:
                    unfinished = self.unfinished_tasks - 1
                    if unfinished <= 0:
                        if unfinished < 0:
                            raise ValueError('task_done() called too many times')
                        self.all_tasks_done.notify_all()
                    self.unfinished_tasks = unfinished

            def join(self):
                '''
                等到队列为空再执行别的操作
                '''
                with self.all_tasks_done:
                    while self.unfinished_tasks:
                        # 如果有未完成的任务, 将调用wait()方法等待
                        self.all_tasks_done.wait()

            def qsize(self):
                '''
                返回队列中的元素数(互斥的哦)
                '''
                with self.mutex:
                    return self._qsize()

            def empty(self):
                '''
                队列是否为空(互斥的哦)
                '''
                with self.mutex:
                    return not self._qsize()

            def full(self):
                '''
                队列是否已满(互斥的哦)
                '''
                with self.mutex:
                    return 0 < self.maxsize <= self._qsize()

            def put(self, item, block=True, timeout=None):
                '''
                入队列操作
                '''
                # 获取条件变量not_full
                with self.not_full:
                    if self.maxsize > 0:
                        if not block:
                            if self._qsize() >= self.maxsize:
                                # 如果 block 是 False, 并且队列已满, 那么抛出 Full 异常
                                raise Full
                        elif timeout is None:
                            while self._qsize() >= self.maxsize:
                                # 阻塞直到由剩余空间
                                self.not_full.wait()
                        elif timeout < 0:
                            # 不合格的参数值, 抛出ValueError
                            raise ValueError("'timeout' must be a non-negative number")
                        else:
                            # 计算等待的结束时间
                            endtime = time() + timeout
                            while self._qsize() >= self.maxsize:
                                remaining = endtime - time()
                                if remaining <= 0.0:
                                    # 等待期间一直没空间, 抛出 Full 异常
                                    raise Full
                                self.not_full.wait(remaining)
                    # 往底层数据结构中加入一个元素
                    self._put(item)
                    self.unfinished_tasks += 1
                    self.not_empty.notify()

            def get(self, block=True, timeout=None):
                '''Remove and return an item from the queue.

                If optional args 'block' is true and 'timeout' is None (the default),
                block if necessary until an item is available. If 'timeout' is
                a non-negative number, it blocks at most 'timeout' seconds and raises
                the Empty exception if no item was available within that time.
                Otherwise ('block' is false), return an item if one is immediately
                available, else raise the Empty exception ('timeout' is ignored
                in that case).
                '''
                with self.not_empty:
                    if not block:
                        if not self._qsize():
                            raise Empty
                    elif timeout is None:
                        while not self._qsize():
                            self.not_empty.wait()
                    elif timeout < 0:
                        raise ValueError("'timeout' must be a non-negative number")
                    else:
                        endtime = time() + timeout
                        while not self._qsize():
                            remaining = endtime - time()
                            if remaining <= 0.0:
                                raise Empty
                            self.not_empty.wait(remaining)
                    item = self._get()
                    self.not_full.notify()
                    return item

            def put_nowait(self, item):
                '''Put an item into the queue without blocking.

                Only enqueue the item if a free slot is immediately available.
                Otherwise raise the Full exception.
                '''
                return self.put(item, block=False)

            def get_nowait(self):
                '''Remove and return an item from the queue without blocking.

                Only get an item if one is immediately available. Otherwise
                raise the Empty exception.
                '''
                return self.get(block=False)

            # Initialize the queue representation
            def _init(self, maxsize):
                # 初始化底层数据结构
                # deque是个双端列表
                self.queue = deque()

            def _qsize(self):
                return len(self.queue)

            # Put a new item in the queue
            def _put(self, item):
                self.queue.append(item)

            # Get an item from the queue
            def _get(self):
                return self.queue.popleft()


        class PriorityQueue(Queue):
            '''
            优先级队列, 如果数据元素不具有可比性, 则可将数据包装在忽略数据项的类中, 仅比较优先级编号
            '''

            def _init(self, maxsize):
                self.queue = []

            def _qsize(self):
                return len(self.queue)

            def _put(self, item):
                # 最小堆结构
                heappush(self.queue, item)

            def _get(self):
                return heappop(self.queue)


        class LifoQueue(Queue):
            '''
            last in first out
            '''

            def _init(self, maxsize):
                self.queue = []

            def _qsize(self):
                return len(self.queue)

            def _put(self, item):
                self.queue.append(item)

            def _get(self):
                return self.queue.pop()


        class _PySimpleQueue:
            '''
            简单队列, 无跟踪任务的功能
            '''
            def __init__(self):
                self._queue = deque()
                self._count = threading.Semaphore(0)

            def put(self, item, block=True, timeout=None):
                '''Put the item on the queue.

                The optional 'block' and 'timeout' arguments are ignored, as this method
                never blocks.  They are provided for compatibility with the Queue class.
                '''
                self._queue.append(item)
                self._count.release()

            def get(self, block=True, timeout=None):
                '''Remove and return an item from the queue.

                If optional args 'block' is true and 'timeout' is None (the default),
                block if necessary until an item is available. If 'timeout' is
                a non-negative number, it blocks at most 'timeout' seconds and raises
                the Empty exception if no item was available within that time.
                Otherwise ('block' is false), return an item if one is immediately
                available, else raise the Empty exception ('timeout' is ignored
                in that case).
                '''
                if timeout is not None and timeout < 0:
                    raise ValueError("'timeout' must be a non-negative number")
                if not self._count.acquire(block, timeout):
                    raise Empty
                return self._queue.popleft()

            def put_nowait(self, item):
                '''Put an item into the queue without blocking.

                This is exactly equivalent to `put(item)` and is only provided
                for compatibility with the Queue class.
                '''
                return self.put(item, block=False)

            def get_nowait(self):
                '''Remove and return an item from the queue without blocking.

                Only get an item if one is immediately available. Otherwise
                raise the Empty exception.
                '''
                return self.get(block=False)

            def empty(self):
                '''Return True if the queue is empty, False otherwise (not reliable!).'''
                return len(self._queue) == 0

            def qsize(self):
                '''Return the approximate size of the queue (not reliable!).'''
                return len(self._queue)


        if SimpleQueue is None:
            SimpleQueue = _PySimpleQueue
    ```
- 扩展(优先队列demo)
    ```python
        import queue

        class A:
            def __init__(self, priority, value):
                self.priority = priority
                self.value = value

            def __lt__(self, other):
                return self.priority < other.priority

        q = queue.PriorityQueue()

        q.put(A(1, 'a'))
        q.put(A(0, 'b'))
        q.put(A(1, 'c'))

        print(q.get().value)  # 'b'
        print(q.get().value)  # 'a'
        print(q.get().value)  # 'c'

        # 结果分析
        # 使用优先队列的时候, 需要定义 __lt__ 魔术方法, 来定义它们之间如何比较大小. 若元素的 priority 相同, 依然使用先进先出的顺序
        b
        a
        c
    ```





