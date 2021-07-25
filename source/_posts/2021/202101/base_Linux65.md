---
title: Linux_基础 (65)
date: 2021-01-15
tags: Linux
toc: true
---

### Linux积累
    定时任务crontab

<!-- more -->

#### crond简介
> crond 是linux下用来周期性的执行某种任务或等待处理某些事件的一个守护进程,与windows下的计划任务类似,当安装完成操作系统后,默认会安装此服务工具,并且会自动启动crond进程,crond进程每分钟会定期检查是否有要执行的任务,如果有要执行的任务,则自动执行该任务

#### linux任务
1. 系统任务调度
    * 系统周期性所要执行的工作,比如写缓存数据到硬盘、日志清理等.在/etc目录下有一个crontab文件,这个就是系统任务调度的配置文件.
    ```bash
        [root@gzns-store-sandbox009 master]# cat /etc/crontab
        # 指定了系统要使用哪个shell
        SHELL=/bin/bash
        # 指定了系统执行命令的路径
        PATH=/sbin:/bin:/usr/sbin:/usr/bin
        # 指定了crond的任务执行信息将通过电子邮件发送给root用户,如果MAILTO变量的值为空,则表示不发送任务执行信息给用户
        MAILTO=root

        # For details see man 4 crontabs

        # Example of job definition:
        # .---------------- minute (0 - 59)
        # |  .------------- hour (0 - 23)
        # |  |  .---------- day of month (1 - 31)
        # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
        # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
        # |  |  |  |  |
        # *  *  *  *  * user-name  command to be executed
    ```
2. 用户任务调度
    * 用户定期要执行的工作,比如用户数据备份、定时邮件提醒等.用户可以使用 crontab 工具来定制自己的计划任务.所有用户定义的crontab 文件都被保存在 /var/spool/cron目录中.其文件名与用户名一致
    * 特殊符号
        * 星号(*)：代表所有可能的值,例如month字段如果是星号,则表示在满足其它字段的制约条件后每月都执行该命令操作.
        * 逗号(,)：可以用逗号隔开的值指定一个列表范围,例如,“1,2,5,7,8,9”
        * 中杠(-)：可以用整数之间的中杠表示一个整数范围,例如“2-6”表示“2,3,4,5,6”
        * 正斜线(/)：可以用正斜线指定时间的间隔频率,例如“0-23/2”表示每两小时执行一次.同时正斜线可以和星号一起使用,例如*/10,如果用在minute字段,表示每十分钟执行一次.

#### crond服务
1. 安装crontab
    ```bash
        yum install crontabs
    ```
2. 服务操作说明
    ```bash
        /sbin/service crond start //启动服务
        /sbin/service crond stop //关闭服务
        /sbin/service crond restart //重启服务
        /sbin/service crond reload //重新载入配置
    ```
3. 查看crontab服务状态
    ```bash
        service crond status
    ```
4. 手动启动crontab服务：
    ```bash
        service crond start
    ```
5. 查看crontab服务是否已设置为开机启动,执行命令：
    ```bash
        ntsysv
    ```
6. 加入开机自动启动
    ```bash
        chkconfig –level 35 crond on
    ```

#### 使用实例
1. 每1分钟执行一次command
    * \* * * * * command
2. 每小时的第3和第15分钟执行
    * 3,15 * * * * command
3. 在上午8点到11点的第3和第15分钟执行
    * 3,15 8-11 * * * command
4. 每隔两天的上午8点到11点的第3和第15分钟执行
    * 3,15 8-11 */2 * * command
5. 每个星期一的上午8点到11点的第3和第15分钟执行
    * 3,15 8-11 * * 1 command
6. 每晚的21:30重启smb
    * 30 21 * * * /etc/init.d/smb restart
7. 每月1、10、22日的4 : 45重启smb
    * 45 4 1,10,22 * * /etc/init.d/smb restart
8. 每周六、周日的1 : 10重启smb
    * 10 1 * * 6,0 /etc/init.d/smb restart
9. 每天18 : 00至23 : 00之间每隔30分钟重启smb
    * 0,30 18-23 * * * /etc/init.d/smb restart
10. 每星期六的晚上11 : 00 pm重启smb 
    * 0 23 * * 6 /etc/init.d/smb restart
11. 每一小时重启smb 
    * \* */1 * * * /etc/init.d/smb restart
12. 晚上11点到早上7点之间,每隔一小时重启smb 
    * \* 23-7/1 * * * /etc/init.d/smb restart
13. 每月的4号与每周一到周三的11点重启smb 
    * 0 11 4 * mon-wed /etc/init.d/smb restart
14. 一月一号的4点重启smb 
    * 0 4 1 jan * /etc/init.d/smb restart
15. 每小时执行/etc/cron.hourly目录内的脚本
    * run-parts这个参数了,如果去掉这个参数的话,后面就可以写要运行的某个脚本名,而不是目录名了
    * 01 * * * * root run-parts /etc/cron.hourly

#### 使用注意事项
1. 注意环境变量问题
    * 脚本中涉及文件路径时写全局路径
    * 脚本执行要用到java或其他环境变量时,通过source命令引入环境变量
    * 当手动执行脚本OK,但是crontab死活不执行时.这时必须大胆怀疑是环境变量惹的祸,并可以尝试在crontab中直接引入环境变量解决问题
2. 注意清理系统用户的邮件日志
3. 可以将用户级任务调度放到系统级任务调度来完成(不建议这么做),但是反过来却不行
4. 新创建的cron job,不会马上执行,至少要过2分钟才执行.如果重启cron则马上执行
5. 当crontab突然失效时,可以尝试/etc/init.d/crond restart解决问题.或者查看日志看某个job有没有执行/报错tail -f /var/log/cron
6. 千万别乱运行crontab -r.它从Crontab目录(/var/spool/cron)中删除用户的Crontab文件.删除了该用户的所有crontab都没了
7. 在crontab中%是有特殊含义的,表示换行的意思.如果要用的话必须进行转义\%,如经常用的date ‘+%Y%m%d’在crontab里是不会执行的,应该换成date ‘+\%Y\%m\%d’.

