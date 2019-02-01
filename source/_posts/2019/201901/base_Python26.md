---
title: Python_基础 (26)
date: 2019-01-11
tags: Python
toc: true
---

### 内建模块datetime
    Python3学习笔记

<!-- more -->

#### datetime简介
    datetime是Python处理日期和时间的标准库

#### 获取当前日期和时间
    引入datetime模块中的datetime类
- eg
    ```python
        >>> from datetime import datetime
        >>> datetime.now()
        datetime.datetime(2019, 1, 11, 14, 30, 29, 807957)
        >>> now = datetime.now()
        >>> print(now)
        2019-01-11 14:30:49.270070
    ```

#### 获取指定日期和时间
- eg
    ```python
        >>> from datetime import datetime
        >>> dt = datetime(2018, 12, 31, 12, 30, 30)
        >>> print(dt)
        2018-12-31 12:30:30
    ```

#### 获取指定日期的时间戳
- eg
    ```python
        >>> from datetime import datetime
        >>> dt = datetime(2018, 12, 31, 12, 30, 30)
        >>> dt.timestamp()
        1546230630.0
    ```

#### 时间戳转化为日期
- eg
    ```python
        >>> from datetime import datetime
        >>> t = 1546230630
        >>> print(datetime.fromtimestamp(t))
        2018-12-31 12:30:30
    ```

#### str转换为datetime
- eg
    ```python
        >>> from datetime import datetime
        >>> cday = datetime.strptime("2018-8-29 10:23:59", "%Y-%m-%d %H:%M:%S")
        >>> print(cday)
        2018-08-29 10:23:59
    ```

#### 对datetime加减
- eg
    ```python
        >>> from datetime import datetime, timedelta
        >>> now = datetime.now()
        >>> now
        datetime.datetime(2019, 1, 11, 14, 51, 5, 894657)
        >>> now + timedelta(hours=10)
        datetime.datetime(2019, 1, 12, 0, 51, 5, 894657)
        >>> now - timedelta(days=1)
        datetime.datetime(2019, 1, 10, 14, 51, 5, 894657)
        >>> now - timedelta(days=2, hours=12)
        datetime.datetime(2019, 1, 09, 2, 51, 5, 894657)
    ```
