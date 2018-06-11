---
title: Linux_基础 (49)
date: 2018-06-11
tags: Linux
toc: true
---

### 例行性工作排程
    定时安排执行工作.我的理解就是定时.

<!-- more -->

#### 工作排程种类
- 例行性 : 每隔一段时间就要办理的事[crontab,主要学一下]
- 突发性 : 这次做完以后就没有下一次[at]  

#### crontab
- 使用者的设定
    * /etc/cron.allow
        * 将可以使用crontab的账号写入其中,若不在这个文件内的使用者不可使用crontab
        * 优先级高于/etc/cron.deny,但默认不存在
    * /etc/cron.deny
        * 将不可以使用crontab的账号写入其中,若不在这个文件内的使用者就可以使用crontab
        * 一般来说系统默认保留
- 使用之后
    * 当用户使用crontab指令建立工作排程后,该工作就会被记录到/var/spool/cron/`whoami`中,每个人一个文件夹
    * 一般不要使用vim直接去编辑该文件
    * cron执行的每一项工作都会被记录到/var/log/cron这个登录档中
- crontab命令相关
    * 命令格式
        * crontab [-u username] [-l|-e|-r]
    * 命令参数
        * -u 只有root才能进行这个任务,即帮其它使用者建立或移除crontab工作排程
        * -e 编辑crontab的工作内容
        * -l 查阅crontab的工作内容
        * -r 移除所有的crontab的工作内容,若仅要移除一项,请用-e编辑
    * crontab文件的含义
        * minute hour day month week command
        * minute： 表示分钟，可以是从0到59之间的任何整数。
        * hour：表示小时，可以是从0到23之间的任何整数。
        * day：表示日期，可以是从1到31之间的任何整数。
        * month：表示月份，可以是从1到12之间的任何整数。
        * week：表示星期几，可以是从0到7之间的任何整数，这里的0或7代表星期日。
        * command：要执行的命令，可以是系统命令，也可以是自己编写的脚本文件。
        * 星号（*）：代表所有可能的值，例如month字段如果是星号，则表示在满足其它字段的制约条件后每月都执行该命令操作。
        * 逗号（,）：可以用逗号隔开的值指定一个列表范围，例如，“1,2,5,7,8,9”
        * 中杠（-）：可以用整数之间的中杠表示一个整数范围，例如“2-6”表示“2,3,4,5,6”
        * 正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。
    * demo 
        ```bash
            [llllljian@llllljian-virtual-machine 20180611 21:14:29 #11]$ ls -al
            总用量 8
            drwxrwxr-x  2 llllljian llllljian 4096 6月  11 20:36 .
            drwxrwxr-x 10 llllljian llllljian 4096 6月  11 20:36 ..

            每天的21:15分到~/study/201806/20180611 创建文件test.txt
            [llllljian@llllljian-virtual-machine 20180611 21:14:33 #12]$ crontab -l
            15 21 * * * touch ~/study/201806/20180611/test.txt

            [llllljian@llllljian-virtual-machine 20180611 21:14:59 #13]$ ls -al
            总用量 8
            drwxrwxr-x  2 llllljian llllljian 4096 6月  11 21:15 .
            drwxrwxr-x 10 llllljian llllljian 4096 6月  11 20:36 ..
            -rw-rw-r--  1 llllljian llllljian    0 6月  11 21:15 test.txt

            [llllljian@llllljian-virtual-machine 20180611 21:15:01 #17]$ crontab -r

            [llllljian@llllljian-virtual-machine 20180611 21:17:43 #18]$ crontab -l
            no crontab for llllljian

            [llllljian@llllljian-virtual-machine 20180611 21:42:46 #102]$ ll
            总用量 12
            drwxrwxr-x  2 llllljian llllljian 4096 6月  11 21:42 .
            drwxrwxr-x 10 llllljian llllljian 4096 6月  11 20:36 ..
            -rwxrwxr-x  1 llllljian llllljian  415 6月  11 21:28 1.sh
            -rw-rw-r--  1 llllljian llllljian    0 6月  11 21:15 test.txt

            [llllljian@llllljian-virtual-machine 20180611 21:42:48 #103]$ crontab -l
            * * * * * /bin/date >>~/study/201806/20180611/date.txt
            * * * * * sleep 10; /bin/date >>~/study/201806/20180611/date.txt
            * * * * * sleep 20; /bin/date >>~/study/201806/20180611/date.txt
            * * * * * sleep 30; /bin/date >>~/study/201806/20180611/date.txt
            * * * * * sleep 40; /bin/date >>~/study/201806/20180611/date.txt
            * * * * * sleep 50; /bin/date >>~/study/201806/20180611/date.txt
            */1 * * * * ~/study/201806/20180611/1.sh >> ~/study/201806/20180611/test.txt

            [llllljian@llllljian-virtual-machine 20180611 21:42:55 #104]$ ll
            总用量 16
            drwxrwxr-x  2 llllljian llllljian 4096 6月  11 21:42 .
            drwxrwxr-x 10 llllljian llllljian 4096 6月  11 20:36 ..
            -rwxrwxr-x  1 llllljian llllljian  415 6月  11 21:28 1.sh
            -rw-rw-r--  1 llllljian llllljian   43 6月  11 21:42 date.txt
            -rw-rw-r--  1 llllljian llllljian    0 6月  11 21:15 test.txt

            [llllljian@llllljian-virtual-machine 20180611 21:43:00 #105]$ cat test.txt
            21:43:01

            [llllljian@llllljian-virtual-machine 20180611 21:43:06 #106]$ cat date.txt
            2018年 06月 11日 星期一 21:42:52 CST
            2018年 06月 11日 星期一 21:43:01 CST

            [llllljian@llllljian-virtual-machine 20180611 21:43:10 #107]$ cat date.txt
            2018年 06月 11日 星期一 21:42:52 CST
            2018年 06月 11日 星期一 21:43:01 CST
            2018年 06月 11日 星期一 21:43:11 CST

            [llllljian@llllljian-virtual-machine 20180611 21:43:14 #108]$ cat date.txt
            2018年 06月 11日 星期一 21:42:52 CST
            2018年 06月 11日 星期一 21:43:01 CST
            2018年 06月 11日 星期一 21:43:11 CST
        ```
- 系统的配置文件 /etc/crontab,/etc/cron.d/*

#### 总结
- 个人化的行为使用[crontab-e]
- 系统维护管理使用[vim /etc/crontab]
- 自己开发软件使用[vim /etc/cron.d/newfile]
- 固定每小时每日每周每天执行的特别工作建议放在/etc/crontab中集中管理比较好

#### 注意事项
- 资源分配不均的问题
- 取消不要的输出项目
- 安全的检验
- 周与日月不可同时并存