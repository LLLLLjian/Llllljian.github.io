---
title: Python_基础 (72)
date: 2020-12-28
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python的文件夹/文件操作

<!-- more -->

#### 先说说我想做的事
> 我要删除七天之前的文件

#### 获取文件大小、创建时间、访问时间
- demo1
    ```python
        import time
        import datetime
        import os

        def TimeStampToTime(timestamp):
            """
            时间戳转为YYYY-mm-dd HH:MM:SS
            """
            timeStruct = time.localtime(timestamp)
            return time.strftime('%Y-%m-%d %H:%M:%S',timeStruct)

        def get_FileSize(filePath):
            """
            获取文件的大小,结果保留两位小数,单位为MB
            """
            filePath = unicode(filePath,'utf8')
            fsize = os.path.getsize(filePath)
            fsize = fsize/float(1024*1024)
            return round(fsize,2)
        
        def get_FileAccessTime(filePath):
            """
            获取文件的访问时间
            """
            filePath = unicode(filePath,'utf8')
            t = os.path.getatime(filePath)
            return TimeStampToTime(t)

        def get_FileCreateTime(filePath):
            """
            获取文件的创建时间
            """
            filePath = unicode(filePath,'utf8')
            t = os.path.getctime(filePath)
            return TimeStampToTime(t)

        def get_FileModifyTime(filePath):
            """
            获取文件的修改时间
            """
            filePath = unicode(filePath,'utf8')
            t = os.path.getmtime(filePath)
            return TimeStampToTime(t)
    ```

#### 保留7天备份文件
- demo2
    ```python
        #!/usr/bin/env python
        # coding: utf-8
        
        import os
        import datetime
        import shutil
        
        # confluence数据备份,因为confluence不能保留7天备份,并且每天全备份,占用空间很大,所以写脚本,保留7天备份文件.
        data_directory = "/data/var/atlassian/application-data/confluence/backups/"
        backup_directory = "/backup/"
        
        # backup file name: backup-2019_02_24.zip
        today_backup_file = "backup-" + str(datetime.date.today() + datetime.timedelta(days = -1)).replace("-", "_") + ".zip"
        day_list = []
        
        for i in range(1, 8):
            day = str(datetime.date.today() + datetime.timedelta(days = -i)).replace("-", "_")
            filename = "backup-" + day + ".zip"
            day_list.append(filename)
        
        if os.path.exists(data_directory) and os.path.exists(backup_directory):
            # 循环数据目录,将7天的数据文件保留,其他的删除,并将最新的数据备份包,拷贝到其他的盘上
            for file in os.listdir(data_directory):
                filepath = os.path.join(data_directory, file)
                if file == today_backup_file:
                    shutil.copy(filepath, backup_directory)
                elif file not in day_list:
                    file = os.remove(filepath)
    ```


