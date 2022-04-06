---
title: Interview_总结 (49)
date: 2019-11-04
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * Linux文件属性有哪些
- A
    * 总共有10位, - --- --- ---
    * 文件类型识别符: -表示普通文件；c表示字符设备(character)；b表示块设备(block)；d表示目录 (directory)；l表示链接文件(link)；
    * 第一个三个连续的短横是用户权限位(User)
    * 第二个三个连续短横是组权限位 (Group)
    * 第三个三个连续短横是其他权限位(Other)

#### 问题2
- Q
    * Redis和Memcache的异同
- A
    * 同
        * 都是内存数据库
        * 都可以做一主多从的分布式集群
    * 异
        * Redis支持hash、list、set、sorted set等多种数据, Memcache 仅支持字符串键值数据
        * Redis 只使用单核；Memcache可使用多核多线程.所以100K以下数据Redis性能好, 以上Memcache性能好
        * Redis 数据可以持久化到磁盘；Memcache 不支持数据持久化, 关闭后数据随之消失
        * Redis 单个key(变量)存放的数据有1GB的限制；Memcache 单个key(变量)存放的数据有1M的限制
        * Redis 利用单线程模型提供了事务的功能；Memcached提供了cas命令来保证数据一致性
        * redis 支持master-slave复制模式做分布式；memcache可以使用magent的一致性hash做分布式

#### 问题3
- Q
    * POST和GET的区别
- A
    * GET参数通过URL传递, POST放在请求Body中
    * GET请求在URL中传送的参数是有长度限制的, 而POST通过Body传送数据, 长度没有限制
    * POST比GET更安全, 因为参数直接暴露在URL上, 所以不能用来传递敏感信息
    * GET在浏览器回退时是无害的, 而POST会再次提交请求
    * GET产生的URL地址可以被保存为书签, 而POST不可以
    * GET请求会被浏览器主动cache, 而POST不会, 除非手动设置
    * GET请求只能进行url编码, 而POST支持多种编码方式
    * GET请求参数会被完整保留在浏览器历史记录里, 而POST中的参数不会被保留
    * GET产生一个TCP数据包, POST产生两个TCP数据包

#### 问题4
- Q
    * InnoDB和MyISAM存储引擎区别
- A
    * 存储结构
        * MyISAM: 每个MyISAM在磁盘上存储成三个文件.第一个文件的名字以表的名字开始, 扩展名指出文件类型..frm文件存储表定义.数据文件的扩展名为.MYD (MYData).索引文件的扩展名是.MYI (MYIndex).
        * InnoDB: 所有的表都保存在同一个数据文件中(也可能是多个文件, 或者是独立的表空间文件), InnoDB表的大小只受限于操作系统文件的大小, 一般为2GB.
    * 存储空间
        * MyISAM: 可被压缩, 存储空间较小.支持三种不同的存储格式: 静态表(默认, 但是注意数据末尾不能有空格, 会被去掉)、动态表、压缩表.
        * InnoDB: 需要更多的内存和存储, 它会在主内存中建立其专用的缓冲池用于高速缓冲数据和索引.
    * 可移植性、备份及恢复
        * MyISAM: 数据是以文件的形式存储, 所以在跨平台的数据转移中会很方便.在备份和恢复时可单独针对某个表进行操作.
        * InnoDB: 免费的方案可以是拷贝数据文件、备份 binlog, 或者用 mysqldump, 在数据量达到几十G的时候就相对痛苦了.
    * 事务支持
        * MyISAM: 强调的是性能, 每次查询具有原子性,其执行数度比InnoDB类型更快, 但是不提供事务支持.
        * InnoDB: 提供事务支持事务, 外部键等高级数据库功能. 具有事务(commit)、回滚(rollback)和崩溃修复能力(crash recovery capabilities)的事务安全(transaction-safe (ACID compliant))型表.
    * AUTO_INCREMENT
        * MyISAM: 可以和其他字段一起建立联合索引.引擎的自动增长列必须是索引, 如果是组合索引, 自动增长可以不是第一列, 他可以根据前面几列进行排序后递增.
        * InnoDB: InnoDB中必须包含只有该字段的索引.引擎的自动增长列必须是索引, 如果是组合索引也必须是组合索引的第一列.
    * 表锁差异
        * MyISAM: 只支持表级锁, 用户在操作myisam表时, select, update, delete, insert语句都会给表自动加锁, 如果加锁以后的表满足insert并发的情况下, 可以在表的尾部插入新的数据.
        * InnoDB: 支持事务和行级锁, 是innodb的最大特色.行锁大幅度提高了多用户并发操作的新能.但是InnoDB的行锁, 只是在WHERE的主键是有效的, 非主键的WHERE都会锁全表的.
    * 全文索引
        * MyISAM: 支持 FULLTEXT类型的全文索引
        * InnoDB: 5.7之后支持FULLTEXT类型的全文索引
    * 表主键
        * MyISAM: 允许没有任何索引和主键的表存在, 索引都是保存行的地址.
        * InnoDB: 如果没有设定主键或者非空唯一索引, 就会自动生成一个6字节的主键(用户不可见), 数据是主索引的一部分, 附加索引保存的是主索引的值.
    * 表的具体行数
        * MyISAM: 保存有表的总行数, 如果select count(*) from table;会直接取出出该值.
        * InnoDB: 没有保存表的总行数, 如果使用select count(*) from table；就会遍历整个表, 消耗相当大, 但是在加了wehre条件后, myisam和innodb处理的方式都一样.
    * CURD操作
        * MyISAM: 如果执行大量的SELECT, MyISAM是更好的选择.
        * InnoDB: 如果你的数据执行大量的INSERT或UPDATE, 出于性能方面的考虑, 应该使用InnoDB表.DELETE 从性能上InnoDB更优, 但DELETE FROM table时, InnoDB不会重新建立表, 而是一行一行的删除, 在innodb上如果要清空保存有大量数据的表, 最好使用truncate table这个命令.
    * 外键
        * MyISAM: 不支持
        * InnoDB: 支持
    * 崩溃自动恢复
        * MyISAM: 不支持
        * InnoDB: 支持

#### 问题5
- Q
    * 常用的设计模式及其应用场景
- A
    * 工单组适观策装
    * 工厂模式
        * 负责生成其他对象的类或方法.
    * 单例模式
        * 创建一个而且只能创建一个对象的类.(要求生产唯一序列号、创建对象消耗较多资源比如IO与数据库连接、Web计数器可以再单例缓存定期存到数据库中)
    * 组合模式
        * 将对象组合成树形结构, 以表示‘部分–整体’的层次结构.(树形菜单、目录文件管理)
    * 适配器模式
        * 将某个类的接口转换成特定样式的接口, 以解决类之间的兼容问题.(支付接口)
    * 观察者模式
        * 也称发布–订阅模式, 定义了一个被观察者和多个观察者的、一对多的对象关系
    * 策略模式
        * 策略模式定义了一族相同类型的算法, 算法之间独立封装, 并且可以互换代替
    * 装饰器模式
        * 向一个已有的对象添加新的功能, 而不改变其结构

