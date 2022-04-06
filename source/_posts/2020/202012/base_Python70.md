---
title: Python_基础 (70)
date: 2020-12-24
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python的时间

<!-- more -->

#### 为什么要学时间
> 程序中用到时间的地方太多了, 快来学学时间

#### time系列
- 时间戳
    ```python
        >>> import time
        >>> print(time.time())
        1608739218.634012
        >>> print(int(ime.time()))
        1608739230
    ```
- 时间元祖
    ```python
        >>> print(time.localtime(time.time()))
        time.struct_time(tm_year=2020, tm_mon=12, tm_mday=11, tm_hour=0, tm_min=3, tm_sec=36, tm_wday=0, tm_yday=11, tm_isdst=0)
    ```
- 标准日期
    ```python
        >>> print(time.strftime("%Y%m%d_%H%M%S", time.localtime(time.time())))
        20201224_000434
        >>> print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time())))
        2020-12-24 00:05:59
        >>> print(time.strftime("%Y-%m-%d 02:00:00"))
        2020-12-24 02:00:00
    ```
- 日期转化
    ```python
        >>> print(int(time.mktime(time.strptime("2020-12-24 02:00:00", "%Y-%m-%d %H:%M:%S"))))
        1608746400
    ```

#### str类型的日期转换为时间戳
- eg
    ```python
        # 字符类型的时间
        tss1 = '2013-10-10 23:40:00'
        # 转为时间数组
        timeArray = time.strptime(tss1, "%Y-%m-%d %H:%M:%S")
        print timeArray
        # timeArray可以调用tm_year等
        print timeArray.tm_year   # 2013
        # 转为时间戳
        timeStamp = int(time.mktime(timeArray))
        print timeStamp  # 1381419600


        # 结果如下
        time.struct_time(tm_year=2013, tm_mon=10, tm_mday=10, tm_hour=23, tm_min=40, tm_sec=0, tm_wday=3, tm_yday=283, tm_isdst=-1)
        2013
        1381419600
    ```

#### 更改str类型日期的显示格式
- eg
    ```python
        tss2 = "2013-10-10 23:40:00"
        # 转为数组
        timeArray = time.strptime(tss2, "%Y-%m-%d %H:%M:%S")
        # 转为其它显示格式
        otherStyleTime = time.strftime("%Y/%m/%d %H:%M:%S", timeArray)
        print otherStyleTime  # 2013/10/10 23:40:00

        tss3 = "2013/10/10 23:40:00"
        timeArray = time.strptime(tss3, "%Y/%m/%d %H:%M:%S")
        otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)
        print otherStyleTime  # 2013-10-10 23:40:00
    ```

#### 时间戳转换为指定格式的日期
- eg
    ```python
        # 使用time
        timeStamp = 1381419600
        timeArray = time.localtime(timeStamp)
        otherStyleTime = time.strftime("%Y--%m--%d %H:%M:%S", timeArray)
        print(otherStyleTime)   # 2013--10--10 23:40:00
        # 使用datetime
        timeStamp = 1381419600
        dateArray = datetime.datetime.fromtimestamp(timeStamp)
        otherStyleTime = dateArray.strftime("%Y--%m--%d %H:%M:%S")
        print(otherStyleTime)   # 2013--10--10 23:40:00
        # 使用datetime,指定utc时间,相差8小时
        timeStamp = 1381419600
        dateArray = datetime.datetime.utcfromtimestamp(timeStamp)
        otherStyleTime = dateArray.strftime("%Y--%m--%d %H:%M:%S")
        print(otherStyleTime)   # 2013--10--10 15:40:00
    ```

#### 获取当前时间并且用指定格式显示
- eg
    ```python
        # time获取当前时间戳
        now = int(time.time())     # 1533952277
        timeArray = time.localtime(now)
        print timeArray
        otherStyleTime = time.strftime("%Y--%m--%d %H:%M:%S", timeArray)
        print otherStyleTime

        # 结果如下
        time.struct_time(tm_year=2018, tm_mon=8, tm_mday=11, tm_hour=9, tm_min=51, tm_sec=17, tm_wday=5, tm_yday=223, tm_isdst=0)
        2018--08--11 09:51:17


        # datetime获取当前时间,数组格式
        now = datetime.datetime.now()
        print now
        otherStyleTime = now.strftime("%Y--%m--%d %H:%M:%S")
        print otherStyleTime

        # 结果如下: 
        2018-08-11 09:51:17.362986
        2018--08--11 09:51:17
    ```

#### 获取指定时间
- eg
    ```python
        today = datetime.date.today()
        last_day_of_last_month = datetime.date(today.year, today.month, 1) - datetime.timedelta(1)
        first_day_of_last_month = datetime.date(last_day_of_last_month.year, last_day_of_last_month.month, 1)
    ```

#### 函数积累
- 获取七天/一个月之前的日期
    ```python
        def get_week_and_month(date=None):
            """
            返回指定时间(不传默认为昨天)七天/一个月之前的日期
            """
            if date is None:
                today = datetime.datetime.now()
                # 计算偏移量
                offset = datetime.timedelta(days=-1)
                # 获取想要的日期的时间
                date = (today + offset).strftime('%Y%m%d')

            end_date = datetime.datetime.strptime('%s 00:00:00' % date, '%Y%m%d %H:%M:%S')
            date_dict = {}
            date_dict["yesterday"] = {
                "type": "day",
                "date": date
            }
            date_dict["weekday"] = {
                "type": "week",
                "date": (end_date - datetime.timedelta(days=6)).strftime('%Y%m%d')
            }
            date_dict["monthday"] = {
                "type": "month",
                "date": (end_date - datetime.timedelta(days=29)).strftime('%Y%m%d')
            }
            return date_dict
    ```
- 获取某个时间段内的所有日期
    ```python
        def date_range(beginDate, endDate):
            """
            获取某个时间范围内的所有日期
            """
            dates = []
            dt = datetime.datetime.strptime(beginDate, "%Y%m%d")
            date = beginDate[:]
            while date <= endDate:
                dates.append(date)
                dt = dt + datetime.timedelta(1)
                date = dt.strftime("%Y%m%d")
            return dates
    ```
- 判断字符串是否为标准的时间格式
    ```python
        try:
            time.strptime(date, "%Y%m%d")
        except Exception:
            print("时间格式错误")
    ```
- 时间段
    ```python
        date_list = []
        try:
            time.strptime(startdate, "%Y%m%d")
            time.strptime(enddate, "%Y%m%d")

            dt = datetime.datetime.strptime(startdate, "%Y%m%d")
            date = startdate[:]
            while date <= enddate:
                date_list.append(date)
                dt = dt + datetime.timedelta(1)
                date = dt.strftime("%Y%m%d")
        except Exception:
            return "输入的日期格式不对, 格式应为YYYYMMDD的字符串"
    ```


