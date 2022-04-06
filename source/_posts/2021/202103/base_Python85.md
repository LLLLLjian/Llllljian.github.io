---
title: Python_基础 (85)
date: 2021-03-11
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    日常积累(其实是踩坑)

<!-- more -->

#### 踩坑
> 我们项目用的是logging存放日志, 刚开始是按照周切割的, 后来考虑到按周存放日志的话,按天读取的时候会读取到很多的重复日志,所以我就想着把它改了, 改成按天存储,这样的话 每天只用上传当天的,但是偶然间发现日志没有滚动,或者滚动的19号的时候还在往18号的日志文件里写,虽然是个小问题,但也是要解决的
1. 我们的代码
    ```python
        log_fmt = '%(asctime)s\tFile \"%(filename)s\",line %(lineno)s\t%(levelname)s: %(message)s'
        formatter = logging.Formatter(log_fmt)
        # 创建TimedRotatingFileHandler对象
        # filename: 日志文件名的prefix；
        # when: 是一个字符串,用于描述滚动周期的基本单位,字符串的值及意义如下: 
        # + “S”: Seconds
        # + “M”: Minutes
        # + “H”: Hours
        # + “D”: Days
        # + “W”: Week day (0=Monday)
        # + “midnight”: Roll over at midnight
        # interval: 滚动周期,单位有when指定,比如: when=’D’,interval=1,表示每天产生一个日志文件；
        # backupCount: 表示日志文件的保留个数
        # suffix是指日志文件名的后缀,suffix中通常带有格式化的时间字符串,filename和suffix由“.”连接构成文件名(例如: filename=“runtime”, suffix=“%Y-%m-%d.log”,生成的文件名为runtime.2015-07-06.log)
        # extMatch是一个编译好的正则表达式,用于匹配日志文件名的后缀,它必须和suffix是匹配的,如果suffix和extMatch匹配不上的话,过期的日志是不会被删除的.比如,suffix=“%Y-%m-%d.log”, extMatch的只应该是re.compile(r”^\d{4}-\d{2}-\d{2}.log$”).默认情况下,在TimedRotatingFileHandler对象初始化时,suffxi和extMatch会根据when的值进行初始化
        log_file_handler = TimedRotatingFileHandler(filename="ds_update", when="D", interval=2, backupCount=2)
        #log_file_handler.suffix = "%Y-%m-%d_%H-%M.log"
        #log_file_handler.extMatch = re.compile(r"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}.log$")
        log_file_handler.setFormatter(formatter)    
        logging.basicConfig(level=logging.INFO)
        log = logging.getLogger()
        log.addHandler(log_file_handler)
        # 循环打印日志
        log_content = "test log"
        count = 0
        while count < 30:
            log.error(log_content)
            time.sleep(20)
            count = count + 1
        log.removeHandler(log_file_handler)
    ```
2. TimedRotatingFileHandler源码
    ```python
        def __init__(self, filename, when='h', interval=1, backupCount=0, encoding=None, delay=False, utc=False, atTime=None):
            BaseRotatingHandler.__init__(self, filename, 'a', encoding, delay)
            self.when = when.upper()
            self.backupCount = backupCount
            self.utc = utc
            self.atTime = atTime
            # Calculate the real rollover interval, which is just the number of
            # seconds between rollovers.  Also set the filename suffix used when
            # a rollover occurs.  Current 'when' events supported:
            # S - Seconds
            # M - Minutes
            # H - Hours
            # D - Days
            # midnight - roll over at midnight
            # W{0-6} - roll over on a certain day; 0 - Monday
            #
            # Case of the 'when' specifier is not important; lower or upper case
            # will work.
            if self.when == 'S':
                self.interval = 1 # one second
                self.suffix = "%Y-%m-%d_%H-%M-%S"
                self.extMatch = r"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}(\.\w+)?$"
            elif self.when == 'M':
                self.interval = 60 # one minute
                self.suffix = "%Y-%m-%d_%H-%M"
                self.extMatch = r"^\d{4}-\d{2}-\d{2}_\d{2}-\d{2}(\.\w+)?$"
            elif self.when == 'H':
                self.interval = 60 * 60 # one hour
                self.suffix = "%Y-%m-%d_%H"
                self.extMatch = r"^\d{4}-\d{2}-\d{2}_\d{2}(\.\w+)?$"
            elif self.when == 'D' or self.when == 'MIDNIGHT':
                self.interval = 60 * 60 * 24 # one day
                self.suffix = "%Y-%m-%d"
                self.extMatch = r"^\d{4}-\d{2}-\d{2}(\.\w+)?$"
            elif self.when.startswith('W'):
                self.interval = 60 * 60 * 24 * 7 # one week
                if len(self.when) != 2:
                    raise ValueError("You must specify a day for weekly rollover from 0 to 6 (0 is Monday): %s" % self.when)
                if self.when[1] < '0' or self.when[1] > '6':
                    raise ValueError("Invalid day specified for weekly rollover: %s" % self.when)
                self.dayOfWeek = int(self.when[1])
                self.suffix = "%Y-%m-%d"
                self.extMatch = r"^\d{4}-\d{2}-\d{2}(\.\w+)?$"
            else:
                raise ValueError("Invalid rollover interval specified: %s" % self.when)
        
            self.extMatch = re.compile(self.extMatch, re.ASCII)
            self.interval = self.interval * interval # multiply by units requested
            if os.path.exists(filename):
                t = os.stat(filename)[ST_MTIME]
            else:
                t = int(time.time())
            self.rolloverAt = self.computeRollover(t)
    ```
3. TimedRotatingFileHandler源码解析
    * 它在初始化时会计算出什么时候日志文件需要进行分割.实例变量self.rolloverAt便存放着下次分割的时间.而判断是否需要把日志分割开来的逻辑,居然是根据当前文件的修改时间或当前时间戳来的.每次初始化这个类,这个时间就会重新算一次.这就是在测试环境两三天都无法进分割日志的原因！！！因为测试环境经常需要发布版本,而这个类经常被重新初始化,然后就会重新计算24小时才会进行日志分割
4. computeRollover源码
    ```python
        def computeRollover(self, currentTime):
            """
            Work out the rollover time based on the specified time.
            """
            result = currentTime + self.interval
            # If we are rolling over at midnight or weekly, then the interval is already known.
            # What we need to figure out is WHEN the next interval is.  In other words,
            # if you are rolling over at midnight, then your base interval is 1 day,
            # but you want to start that one day clock at midnight, not now.  So, we
            # have to fudge the rolloverAt value in order to trigger the first rollover
            # at the right time.  After that, the regular interval will take care of
            # the rest.  Note that this code doesn't care about leap seconds. :)
            if self.when == 'MIDNIGHT' or self.when.startswith('W'):
                # This could be done with less code, but I wanted it to be clear
                if self.utc:
                    t = time.gmtime(currentTime)
                else:
                    t = time.localtime(currentTime)
                currentHour = t[3]
                currentMinute = t[4]
                currentSecond = t[5]
                currentDay = t[6]
                # r is the number of seconds left between now and the next rotation
                if self.atTime is None:
                    rotate_ts = _MIDNIGHT
                else:
                    rotate_ts = ((self.atTime.hour * 60 + self.atTime.minute)*60 +
                        self.atTime.second)
    
                r = rotate_ts - ((currentHour * 60 + currentMinute) * 60 +
                    currentSecond)
                if r < 0:
                    # Rotate time is before the current time (for example when
                    # self.rotateAt is 13:45 and it now 14:15), rotation is
                    # tomorrow.
                    r += _MIDNIGHT
                    currentDay = (currentDay + 1) % 7
                    result = currentTime + r
                    # If we are rolling over on a certain day, add in the number of days until
                    # the next rollover, but offset by 1 since we just calculated the time
                    # until the next day starts.  There are three cases:
                    # Case 1) The day to rollover is today; in this case, do nothing
                    # Case 2) The day to rollover is further in the interval (i.e., today is
                    #         day 2 (Wednesday) and rollover is on day 6 (Sunday).  Days to
                    #         next rollover is simply 6 - 2 - 1, or 3.
                    # Case 3) The day to rollover is behind us in the interval (i.e., today
                    #         is day 5 (Saturday) and rollover is on day 3 (Thursday).
                    #         Days to rollover is 6 - 5 + 3, or 4.  In this case, it's the
                    #         number of days left in the current week (1) plus the number
                    #         of days in the next week until the rollover day (3).
                    # The calculations described in 2) and 3) above need to have a day added.
                    # This is because the above time calculation takes us to midnight on this
                    # day, i.e. the start of the next day.
                    if self.when.startswith('W'):
                        day = currentDay # 0 is Monday
                        if day != self.dayOfWeek:
                            if day < self.dayOfWeek:
                                daysToWait = self.dayOfWeek - day
                            else:
                                daysToWait = 6 - day + self.dayOfWeek + 1
                            newRolloverAt = result + (daysToWait * (60 * 60 * 24))
                            if not self.utc:
                                dstNow = t[-1]
                                dstAtRollover = time.localtime(newRolloverAt)[-1]
                                if dstNow != dstAtRollover:
                                    if not dstNow:  # DST kicks in before next rollover, so we need to deduct an hour
                                        addend = -3600
                                    else:           # DST bows out before next rollover, so we need to add an hour
                                        addend = 3600
                                    newRolloverAt += addend
                            result = newRolloverAt
            return result
    ```
5. computeRollover源码解析
    * 如果项目是持续运行的,这个类只初始化一次,那这个日志分割还是可以达到目的的.而且里面还设计有按年,按月分割的,一年内项目不重启不升级,说实话概率还是蛮低的,一重启这个时间就会重新算,然后日志分割时间就会推迟了.阅读源码后看到它有一个按midnight分割日期的功能.就是它会在计算当前时间到凌晨零点的秒数,然后每次写日志时都会判断过没过凌晨,到了后就会自动分割日志
6. 是否需要分割源代码
    ```python
        def shouldRollover(self, record):
            """
            Determine if rollover should occur.
            record is not used, as we are just comparing times, but it is needed so
            the method signatures are the same
            """
            t = int(time.time())
            if t >= self.rolloverAt:
                return 1
    ```
