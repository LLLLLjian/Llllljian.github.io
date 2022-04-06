---
title: Python_基础 (137)
date: 2021-10-19
tags: 
    - Python
    - Django
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> logging开始记录日志了 但是记录的日志有问题呀 一是写入错乱 二是日志并没有按天分割, 而且还丢失 查找问题非常不方便

#### 解决多进程logging问题
- 排查问题
    * 通过python manage.py runserver启动的时候 日志是正常的, 也会正常按天分割, 线上用的是uwsgi启动的多进程, 但是logging模块是线程安全的, 不能保证多进程安全
- 问题描述
    * 假设每天生成一个error.log 每天凌晨进行日志分割
    * 单进程情况下是这样的
        * 生成error.log文件
        * 写入一天的日志
        * 凌晨时判断error.log.2021-10-18 是否存在, 如果存在就删除, 如果不存在的话就将error.log重命名为error.log.2021-10-18
        * 重新生成error.log 并将logger文件句柄指向新的error.log
    * 多进程情况下是这样的
        * 生成error.log文件
        * 写入一天的日志
        * 凌晨时 1号进程判断error.log.2021-10-18 是否存在, 如果存在就删除, 如果不存在的话就将error.log重命名为error.log.2021-10-18
        * 此时 2号进程可能还在向error.log文件中写入, 由于写入文件句柄已经打开, 所以会向error.log.2021-10-18进行写入
        * 2号进程进行文件分割操作,  由于 error.log-2021-10-18 已经存在, 所以 2 号进程会将它删除, 然后再重命名 error.log, 这样就导致了日志丢失
        * 由于2号进程将error.log 重命名为error.log.2021-10-18, 也会导致1号进程继续向error.log.2021-10-18写入, 这样就会造成写入错乱
- 解决办法
    * 使用 concurrent-log-handler包
        * 通过加锁的方式实现了多进程安全, 并且可以在日志文件达到特定大小时, 分割文件
    * 重写TimedRotatingFileHandler
        ```python
            # 解决多进程日志写入混乱问题
            import os
            import time
            from logging.handlers import TimedRotatingFileHandler


            class CommonTimedRotatingFileHandler(TimedRotatingFileHandler):

                @property
                def dfn(self):
                    currentTime = int(time.time())
                    # get the time that this sequence started at and make it a TimeTuple
                    dstNow = time.localtime(currentTime)[-1]
                    t = self.rolloverAt - self.interval
                    if self.utc:
                        timeTuple = time.gmtime(t)
                    else:
                        timeTuple = time.localtime(t)
                        dstThen = timeTuple[-1]
                        if dstNow != dstThen:
                            if dstNow:
                                addend = 3600
                            else:
                                addend = -3600
                            timeTuple = time.localtime(t + addend)
                    dfn = self.rotation_filename(self.baseFilename + "." + time.strftime(self.suffix, timeTuple))

                    return dfn

                def shouldRollover(self, record):
                    """
                    是否应该执行日志滚动操作: 
                    1、存档文件已存在时, 执行滚动操作
                    2、当前时间 >= 滚动时间点时, 执行滚动操作
                    """
                    dfn = self.dfn
                    t = int(time.time())
                    if t >= self.rolloverAt or os.path.exists(dfn):
                        return 1
                    return 0

                def doRollover(self):
                    """
                    执行滚动操作
                    1、文件句柄更新
                    2、存在文件处理
                    3、备份数处理
                    4、下次滚动时间点更新
                    """
                    if self.stream:
                        self.stream.close()
                        self.stream = None
                    # get the time that this sequence started at and make it a TimeTuple

                    dfn = self.dfn

                    # 存档log 已存在处理
                    if not os.path.exists(dfn):
                        self.rotate(self.baseFilename, dfn)

                    # 备份数控制
                    if self.backupCount > 0:
                        for s in self.getFilesToDelete():
                            os.remove(s)

                    # 延迟处理
                    if not self.delay:
                        self.stream = self._open()

                    # 更新滚动时间点
                    currentTime = int(time.time())
                    newRolloverAt = self.computeRollover(currentTime)
                    while newRolloverAt <= currentTime:
                        newRolloverAt = newRolloverAt + self.interval

                    # If DST changes and midnight or weekly rollover, adjust for this.
                    if (self.when == 'MIDNIGHT' or self.when.startswith('W')) and not self.utc:
                        dstAtRollover = time.localtime(newRolloverAt)[-1]
                        dstNow = time.localtime(currentTime)[-1]
                        if dstNow != dstAtRollover:
                            if not dstNow:  # DST kicks in before next rollover, so we need to deduct an hour
                                addend = -3600
                            else:           # DST bows out before next rollover, so we need to add an hour
                                addend = 3600
                            newRolloverAt += addend
                    self.rolloverAt = newRolloverAt
        ```



