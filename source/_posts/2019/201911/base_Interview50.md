---
title: Interview_总结 (50)
date: 2019-11-05
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * 简述MySQL聚簇索引和非聚簇索引
- A
    * 聚簇索引
        * 聚簇索引并不是一种单独的索引类型, 而是一种数据存储方式.比如, InnoDB的聚簇索引使用B+Tree的数据结构存储索引和数据
        * 当表有聚簇索引时, 它的数据行实际上存放在索引的叶子页(leaf page)中.因为无法同时把数据行存放在两个不同的地方, 所以一个表只能有一个聚簇索引(不过, 覆盖索引可以模拟多个聚簇索引的情况)
        * 术语“聚簇”表示数据行和相邻的键值紧凑地存储在一起.
        * 聚簇索引的二级索引：叶子节点不会保存引用的行的物理位置, 而是保存行的主键值.
        * 对于聚簇索引的存储引擎, 数据的物理存放顺序与索引顺序是一致的, 即：只要索引是相邻的, 那么对应的数据一定也是相邻地存放在磁盘上的, 如果主键不是自增id, 可以想象, 它会干些什么, 不断地调整数据的物理地址、分页, 当然也有其他一些措施来减少这些操作, 但却无法彻底避免.但, 如果是自增的, 那就简单了, 它只需要一页一页地写, 索引结构相对紧凑, 磁盘碎片少, 效率也高
        * 优点
    * 非聚簇索引
        * 表数据存储顺序与索引顺序无关, 叶结点包含索引字段值及指向数据页数据行的逻辑指针, 其行数量与数据表行数据量一致.

#### InnoDB和MyISAM的数据分布对比
- eg
    ```sql
        create table layout_test(
            col1 int not null,
            col2 int not null,
            primary key(col1),
            key(col2)
        );

        假设该表的主键取值为1~10000, 按照随机顺序播放并使用optimize table命令做了优化.换句话说, 数据在磁盘上的存储方式已经最优, 但行的顺序是随机的.列col2的值是从1~100之间随机赋值, 所以有很多重复的值.
    ```
- MyISAM的数据布局
    * 非聚簇索引的主键
    * MyISAM的叶子节点中保存的实际上是指向存放数据的物理块的指针.从MYISAM存储的物理文件看出, MyISAM引擎的索引文件(.MYI)和数据文件(.MYD)是相互独立的, 索引文件仅仅保存数据记录的地址
    ![非聚簇索引的主键](/img/20191105_1.png)
    * 非聚簇索引的二级索引
    * 索引中每一个叶子节点仅仅包含行号(row number), 且叶子节点按照col2的顺序存储
    ![非聚簇索引的二级索引](/img/20191105_2.png)
- InnoDB的数据布局
    * 聚簇索引的主键
    ![聚簇索引的主键](/img/20191105_3.png)
    * 聚簇索引的二级索引
    ![聚簇索引的二级索引](/img/20191105_4.png)
- InnoDB与MyIASM索引和数据布局对比
    ![InnoDB与MyIASM索引和数据布局对比](/img/20191105_5.png)
    ![InnoDB与MyIASM索引和数据布局形象对比](/img/20191105_6.png)

#### 在InnoDB表中按主键顺序插入行
- eg
    ```sql
        CREATE TABLE `shopinfo` (
        `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
        `shop_id` int(11) NOT NULL COMMENT '商店ID',
        `goods_id` int(11) NOT NULL COMMENT '物品ID',
        `pay_type` int(11) NOT NULL COMMENT '支付方式',
        `price` decimal(10,2) NOT NULL COMMENT '物品价格',
        `comment` varchar(4000) DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `shop_id` (`shop_id`,`goods_id`),
        KEY `price` (`price`),
        KEY `pay_type` (`pay_type`),
        KEY `idx_comment` (`comment`(255))
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商店物品表';

        CREATE TABLE `shopinfo_uuid` (
        `uuid` varchar(36) NOT NULL,
        `shop_id` int(11) NOT NULL COMMENT '商店ID',
        `goods_id` int(11) NOT NULL COMMENT '物品ID',
        `pay_type` int(11) NOT NULL COMMENT '支付方式',
        `price` decimal(10,2) NOT NULL COMMENT '物品价格',
        `comment` varchar(4000) DEFAULT NULL,
        PRIMARY KEY (`uuid`),
        UNIQUE KEY `shop_id` (`shop_id`,`goods_id`),
        KEY `price` (`price`),
        KEY `pay_type` (`pay_type`),
        KEY `idx_comment` (`comment`(255))
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商店物品表';
    ```
- res
![在InnoDB表中按主键顺序插入行](/img/20191105_7.png)
- 说明
    * 使用自增id可以避免页分裂. mysql的InnoDB引擎底层数据结构是 B+ 树, 所谓的索引其实就是一颗 B+ 树, 一个表有多少个索引就会有多少颗 B+ 树, mysql 中的数据都是按顺序保存在 B+ 树上的(所以说索引本身是有序的). 然后 mysql 在底层又是以数据页为单位来存储数据的, 一个数据页大小默认为 16k, 当然你也可以自定义大小, 也就是说如果一个数据页存满了, mysql 就会去申请一个新的数据页来存储数据.如果主键为自增 id 的话, mysql 在写满一个数据页的时候, 直接申请另一个新数据页接着写就可以了.如果主键是非自增 id, 为了确保索引有序, mysql 就需要将每次插入的数据都放到合适的位置上.当往一个快满或已满的数据页中插入数据时, 新插入的数据会将数据页写满, mysql 就需要申请新的数据页, 并且把上个数据页中的部分数据挪到新的数据页上.这就造成了页分裂, 这个大量移动数据的过程是会严重影响插入效率的.其实对主键 id 还有一个小小的要求, 在满足业务需求的情况下, 尽量使用占空间更小的主键 id, 因为普通索引的叶子节点上保存的是主键 id 的值, 如果主键 id 占空间较大的话, 那将会成倍增加 mysql 空间占用大小
    * 对于InnoDB这种聚集主键类型的引擎来说, 数据会按照主键进行排序, 由于UUID的无序性, InnoDB会产生巨大的IO压力, 而且由于索引和数据存储在一起, 字符串做主键会造成存储空间增大一倍.在存储和检索的时候, innodb会对主键进行物理排序, 这对auto_increment_int是个好消息, 因为后一次插入的主键位置总是在最后.但是对uuid来说, 这却是个坏消息, 因为uuid是杂乱无章的, 每次插入的主键位置是不确定的, 可能在开头, 也可能在中间, 在进行主键物理排序的时候, 势必会造成大量的 IO操作影响效率, 在数据量不停增长的时候, 特别是数据量上了千万记录的时候, 读写性能下降的非常厉害.
