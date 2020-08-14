---
title: MySQL_基础 (46)
date: 2020-06-28
tags: 
    - MySQL 
    - Interview
toc: true
---

### 更好的理解MySQL
    Mysql日志文件

<!-- more -->

#### redo log
- 是什么
    * redo log叫做重做日志, 是用来实现事务的持久性.该日志文件由两部分组成：重做日志缓冲(redo log buffer)以及重做日志文件(redo log),前者是在内存中, 后者在磁盘中.当事务提交之后会把所有修改信息都会存到该日志中
- 能做什么
    * mysql 为了提升性能不会把每次的修改都实时同步到磁盘, 而是会先存到Boffer Pool(缓冲池)里头, 把这个当作缓存来用.然后使用后台线程去做缓冲池和磁盘之间的同步
- 总结
    * redo log是用来恢复数据的 用于保障, 已提交事务的持久化特性
- 图文并茂
    ![事务提交过程](/img/20200628_1.png)
    ```sql
        # 开启事务
        start transaction;

        select balance from bank where name="zhangsan";

        # 生成 重做日志 balance=600
        update bank set balance = balance - 400;

        # 生成 重做日志 amount=400
        update finance set amount = amount + 400;

        # 提交事务
        commit;
    ```

#### undo log
- 是什么
    * undo log 叫做回滚日志, 用于记录数据被修改前的信息.他正好跟前面所说的重做日志所记录的相反, 重做日志记录数据被修改后的信息.undo log主要记录的是数据的逻辑变化, 为了在发生错误时回滚之前的操作, 需要将之前的操作都记录下来, 然后在发生错误时才可以回滚
- 能做什么
    * undo log 记录事务修改之前版本的数据信息, 因此假如由于系统错误或者rollback操作而回滚的话可以根据undo log的信息来进行回滚到没被修改前的状态
- 总结
    * undo log是用来回滚数据的用于保障 未提交事务的原子性
- 图文并茂
    ![事务回滚过程](/img/20200628_1.png)


