---
title: Python_基础 (134)
date: 2021-10-14
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### thread.lock
> 学了多线程之后, 就得考虑一下线程安全的问题, 多线程运行会不会有问题

##### 线程安全问题
- 经典银行取钱问题
    * 用户输入账户、密码, 系统判断用户的账户、密码是否匹配. 
    * 用户输入取款金额. 
    * 系统判断账户余额是否大于取款金额. 
    * 如果余额大于取款金额, 则取款成功；如果余额小于取款金额, 则取款失败
- code
    ```python
        import threading


        class Account:
            # 定义构造器
            def __init__(self, account_no, balance):
                # 封装账户编号、账户余额的两个成员变量
                self.account_no = account_no
                self.balance = balance


        # 定义一个函数来模拟取钱操作
        def draw(account, draw_amount):
            # 账户余额大于取钱数目
            if account.balance >= draw_amount:
                # 吐出钞票
                print(threading.current_thread().name + "取钱成功！吐出钞票:" + str(draw_amount))
                # time.sleep(0.001)
                # 修改余额
                account.balance -= draw_amount
                print("\t余额为: " + str(account.balance))
            else:
                print(threading.current_thread().name + "取钱失败！余额不足！")


        # 创建一个账户
        acct = Account("1234567", 1000)
        # 模拟两个线程对同一个账户取钱
        threading.Thread(name='甲', target=draw, args=(acct, 800)).start()
        threading.Thread(name='乙', target=draw, args=(acct, 800)).start()

        # 预期结果
        甲取钱成功！吐出钞票:800
        余额为: 200
        乙取钱失败！余额不足！

        # 可能出现的结果(这就是线程不安全产生的问题)
        甲取钱成功！吐出钞票:800
                余额为: 200
        乙取钱成功！吐出钞票:800
                余额为: -600
    ```

##### 解决方案(同步锁Lock)
- func
    * acquire(blocking=True, timeout=-1): 请求对 Lock 或 RLock 加锁, 其中 timeout 参数指定加锁多少秒
    * release(): 释放锁
- class
    * threading.Lock: 它是一个基本的锁对象, 每次只能锁定一次, 其余的锁请求, 需等待锁释放后才能获取
    * threading.RLock: 它代表可重入锁(Reentrant Lock). 对于可重入锁, 在同一个线程中可以对它进行多次锁定, 也可以多次释放. 如果使用 RLock, 那么 acquire() 和 release() 方法必须成对出现. 如果调用了 n 次 acquire() 加锁, 则必须调用 n 次 release() 才能释放锁
- eg
    ```python
        class X:
            #定义需要保证线程安全的方法
            def m () :
                #加锁
                self.lock.acquire()
                try :
                    #需要保证线程安全的代码
                    ＃...方法体
                #使用finally 块来保证释放锁
                finally :
                    #修改完成, 释放锁
                    self.lock.release()
    ```
- code
    ```python
        import threading
        import time


        class Account:
            # 定义构造器
            def __init__(self, account_no, balance):
                # 封装账户编号、账户余额的两个成员变量
                self.account_no = account_no
                self._balance = balance
                self.lock = threading.Lock()

            # 因为账户余额不允许随便修改, 所以只为self._balance提供getter方法
            def getBalance(self):
                return self._balance

            # 提供一个线程安全的draw()方法来完成取钱操作
            def draw(self, draw_amount):
                # 加锁
                self.lock.acquire()
                try:
                    # 账户余额大于取钱数目
                    if self._balance >= draw_amount:
                        # 吐出钞票
                        print(threading.current_thread().name + "取钱成功！吐出钞票:" + str(draw_amount))
                        time.sleep(0.001)
                        # 修改余额
                        self._balance -= draw_amount
                        print("\t余额为: " + str(self._balance))
                    else:
                        print(threading.current_thread().name + "取钱失败！余额不足！")
                finally:
                    # 修改完成, 释放锁
                    self.lock.release()

            # 另一种方式的加锁
            def draw1(self, draw_amount):
                # 加锁
                with self.lock:
                    # 账户余额大于取钱数目
                    if self._balance >= draw_amount:
                        # 吐出钞票
                        print(threading.current_thread().name + "取钱成功！吐出钞票:" + str(draw_amount))
                        time.sleep(0.001)
                        # 修改余额
                        self._balance -= draw_amount
                        print("\t余额为: " + str(self._balance))
                    else:
                        print(threading.current_thread().name + "取钱失败！余额不足！")


        # 定义一个函数来模拟取钱操作
        def draw(account, draw_amount):
            # 直接调用account对象的draw()方法来执行取钱操作
            account.draw(draw_amount)


        # 定义一个函数来模拟取钱操作
        def draw1(account, draw_amount):
            # 直接调用account对象的draw()方法来执行取钱操作
            account.draw1(draw_amount)


        # 创建一个账户
        acct = Account("1234567", 1000)
        """
        # 模拟两个线程对同一个账户取钱
        threading.Thread(name='甲', target=draw, args=(acct, 800)).start()
        threading.Thread(name='乙', target=draw, args=(acct, 800)).start()
        """
        # 模拟两个线程对同一个账户取钱
        threading.Thread(name='甲', target=draw1, args=(acct, 800)).start()
        threading.Thread(name='乙', target=draw1, args=(acct, 800)).start()

        # 运行结果(draw和draw1都是可以实现锁的)
        甲取钱成功！吐出钞票:800
                余额为: 200
        乙取钱失败！余额不足！
    ```


