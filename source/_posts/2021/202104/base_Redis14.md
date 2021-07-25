---
title: Redis_基础 (14)
date: 2021-04-07
tags: 
    - Redis
    - Python
toc: true
---

### 关于队列
    项目中需要用到队列, 我看之前用的python的queue, 我也打算用这个, 然后被教育了, 让我用线程池, 但我也不会呀, 所以打算用redis的队列, 先记录一下差异

<!-- more -->

#### 生产者消费者模型
> 在餐馆吃饭时, 厨师做完一道菜后就会把菜从传菜窗口递出去, 然 后继续做下一道菜.厨师不需要关心顾客是不是已经把菜吃完了.如果 厨师做菜的速度大于顾客拿菜的速度, 那么就会有越来越多的菜堆在传菜窗口.如果顾客拿菜的速度大于厨师做菜的速度, 那么传菜窗口始终是空的, 来一道菜就会立刻被拿走.在程序开发中, 这就是一个典型的“生产者/消费者”模型:厨师是生产者, 负责生产;顾客是消费者, 负责消费.厨师和顾客各做各的事情.传菜窗口就是队列, 它把生产者与消费者联系在一起

#### python-queue
- eg
    ```python
        import time
        import random
        from queue import Queue
        from threading import Thred

        class Producer(Thread):
            """
            生产者
            """
            def __init__(self, queue):
                """
                初始化
                """
                # 显式调用父类的初始化方法
                super().__init__()
                self.queue = queue

            def run(self):
                """
                入队列操作
                """
                while True:
                    a = random.randint(0, 10)
                    b = random.randint(90, 100)
                    print(f"生产者生产了两个数字: {a}, {b}")
                    # 入队列
                    self.queue.put((a, b))
                    time.sleep(2)

        class Consumer(Thread):
            """
            消费者
            """
            def __init__(self, queue):
                super().__init__()
                self.queue = queue

            def run(self):
                while True:
                    # block=True表示如果队列为空就阻塞在这里, 直到队列有数据为止
                    num_tuple = self.queue.get(block=True)
                    sum_a_b = sum(num_tuple)
                    print(f"消费者消费了一组数 {num_tuple[0]} + {num_tuple[1]} = {sum_a_b}")
                    time.sleep(random.randint(0, 10))

        queue = Queue()
        producer = Producer(queue)
        consumer = Consumer(queue)

        producer.start()
        consumer.start()

        while True:
            time.sleep(1)
    ```
- 代码解读
    * 生产者固定每两秒生产一组数, 然后把这一组数放进队列里.
    * 消费者每次从队列里面取一组数, 将它们相加然后打印出来.消费 者取一次数的时间是1~10秒中的一个随机时间
    * 可能出现的情况
        * 如果消费者每次暂停的时间都小于2秒, 那么队列始终是空的,  来一组数立刻就被消费.
        * 如果消费者每次暂停的时间都大于2秒, 那么队列里的数就会越来越多
        * 如果不仅想看队列长度, 还想看里面每一组数都是什么, 又该如何操作?
        * 假设队列里已经堆积了一百组数, 现在想增加消费者, 该怎么增加?
        * 如再运行一个Python程序, 那能去读第一个正在运行中的Python程序中的队列吗?
        * Python 把队列中的数据存放在内存中.如果电脑突然断电, 那队列里的数是不是全都丢失了?
        * 为了防止丢数据, 是否需要把数据持久化到硬盘?那持久化的代码怎么写, 代码量有多少, 考不考虑并发和读写冲突?

#### redis-list
- 生产者代码
    ```python
        import time
        import json
        import redis
        import random

        from threading import Thread

        class Producer(Thread):
            """
            生产者
            """
            def __init__(self, queue):
                """
                初始化
                """
                # 显式调用父类的初始化方法
                super().__init__()
                self.queue = redis.Redis()

            def run(self):
                """
                入队列操作
                """
                while True:
                    a = random.randint(0, 10)
                    b = random.randint(90, 100)
                    print(f"生产者生产了两个数字: {a}, {b}")
                    # 入队列
                    self.queue.rpush('producer', json.dumps((a, b)))
                    time.sleep(2)

        producer = Producer()
        producer.start()

        while True:
            time.sleep(1)
    ```
- 消费者代码
    ```python
        import time
        import json
        import redis
        import random

        from threading import Thread

        class Consumer(Thread):
            """
            消费者
            """
            def __init__(self, queue):
                super().__init__()
                self.queue = redis.Redis()

            def run(self):
                while True:
                    num_tuple = self.queue.blpop("producer")
                    a, b = json.loads(num_tuple[1].decode())
                    print(f"消费者消费了一组数, {a} + {b} = {a + b}")
                    time.sleep(random.randint(0, 10))
        
        consumer = Consumer()
        consumer.start()

        while True:
            time.sleep(1)
    ```
- 代码解读
    * 现在, 生产者和消费者可以放在不同的机器上运行, 想运行多少个 消费者就运行多少个消费者, 想什么时候增加消费者都没有问题
    * llen 队列名称 可以查看队列长度
    * Redis自己可以持久化
