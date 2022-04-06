---
title: Redis_基础 (22)
date: 2021-11-01
tags: Redis
toc: true
---

### 复习之redis
    从头再看一遍redis

<!-- more -->

#### Redis二值状态统计
> Bitmap
- 引子

在移动应用的业务场景中, 我们需要保存这样的信息: 一个 key 关联了一个数据集合. 
常见的场景如下: 

给一个 userId , 判断用户登陆状态；
显示用户某个月的签到次数和首次签到时间；
两亿用户最近 7 天的签到情况, 统计 7 天内连续签到的用户总数；
通常情况下, 我们面临的用户数量以及访问量都是巨大的, 比如百万、千万级别的用户数量, 或者千万级别、甚至亿级别的访问信息. 

所以, 我们必须要选择能够非常高效地统计大量数据(例如亿级)的集合类型

##### 二值状态统计
> 集合中的元素的值只有 0 和 1 两种, 在签到打卡和用户是否登陆的场景中, 只需记录签到(1)或 未签到(0), 已登录(1)或未登陆(0)
- 为什么不用字符串
    * 假如我们在判断用户是否登陆的场景中使用 Redis 的 String 类型实现(key -> userId, value -> 0 表示下线, 1 - 登陆), 假如存储 100 万个用户的登陆状态, 如果以字符串的形式存储, 就需要存储 100 万个字符串了, 内存开销太大
    * 字符串为什么开销大
        * String 类型除了记录实际数据以外, 还需要额外的内存记录数据长度、空间使用等信息. 当保存的数据包含字符串, String 类型就使用简单动态字符串(SDS)结构体来保存
        ![redis 字符串](/img/20211101_1.png)
        * len: 占 4 个字节, 表示 buf 的已用长度. 
        * alloc: 占 4 个字节, 表示 buf 实际分配的长度, 通常 > len. 
        * buf: 字节数组, 保存实际的数据, Redis 自动在数组最后加上一个 “\0”, 额外占用一个字节的开销. 
        * 还有一个 RedisObject 结构的开销, 因为 Redis 的数据类型有很多, 而且, 不同数据类型都有些相同的元数据要记录(比如最后一次访问的时间、被引用的次数等). 所以, Redis 会用一个 RedisObject 结构体来统一记录这些元数据, 同时指向实际数据. 
- Bitmap为什么省储存空间
    * Bitmap 的底层数据结构用的是 String 类型的 SDS 数据结构来保存位数组, Redis 把每个字节数组的 8 个 bit 位利用起来, 每个 bit 位 表示一个元素的二值状态(不是 0 就是 1). 
    * 可以将 Bitmap 看成是一个 bit 为单位的数组, 数组的每个单元只能存储 0 或者 1, 数组的下标在 Bitmap 中叫做 offset 偏移量. 
    * 为了直观展示, 我们可以理解成 buf 数组的每个字节用一行表示, 每一行有 8 个 bit 位, 8 个格子分别表示这个字节中的 8 个 bit 位
    ![Bitmap](/img/20211101_2.png)
    * 8 个 bit 组成一个 Byte, 所以 Bitmap 会极大地节省存储空间.  这就是 Bitmap 的优势. 
- 判断用户登陆态
    * Bitmap 提供了 GETBIT、SETBIT 操作, 通过一个偏移值 offset 对 bit 数组的 offset 位置的 bit 位进行读写操作, 需要注意的是 offset 从 0 开始. 
    * 只需要一个 key = login_status 表示存储用户登陆状态集合数据,  将用户 ID 作为 offset, 在线就设置为 1, 下线设置 0. 通过 GETBIT判断对应的用户是否在线. 50000 万 用户只需要 6 MB 的空间. 
    * SETBIT命令
        ```bash
            # 设置或者清空 key 的 value 在 offset 处的 bit 值(只能是 0 或者 1)
            SETBIT <key> <offset> <value>
        ```
    * GETBIT命令
        ```bash
            # 获取 key 的 value 在 offset 处的 bit 位的值, 当 key 不存在时, 返回 0
            GETBIT <key> <offset>
        ```
    * eg1
        ```bash
            # 判断 ID = 10086 的用户的登陆情况
            SETBIT login_status 10086 1 # 登录时设置为1
            GETBIT login_status 10086 # 判断用户10086是否登陆, 返回1表示已经登录
            SETBIT login_status 10086 0 # 退出时再设置为0

            > SETBIT login_status 10086 1
            0
            > GETBIT login_status 10086
            1
            > GETBIT login_status 10087
            0
            > SETBIT login_status 10086 0
            1
            > GETBIT login_status 10086
            0
        ```
- 用户每个月的签到情况
    * 在签到统计中, 每个用户每天的签到用 1 个 bit 位表示, 一年的签到只需要 365 个 bit 位. 一个月最多只有 31 天, 只需要 31 个 bit 位即可
    * key 可以设计成 uid:sign:{userId}:{yyyyMM}, 月份的每一天的值 - 1 可以作为 offset(因为 offset 从 0 开始, 所以 offset = 日期 - 1). 
    * eg
        ```bash
            # 用户在2021年11月16号打卡
            SETBIT uid:sign:89757:202111 15 1
            # 判断用户在2021年11月16号是否打卡
            GETBIT uid:sign:89757:202111 15
            # 统计该用户在11月份的打卡次数
            BITCOUNT uid:sign:89757:202111
            # 得到用户11月份的首次打卡时间
            BITPOS uid:sign:89757:202111 1

            > SETBIT uid:sign:89757:202111 15 1
            0
            > SETBIT uid:sign:89757:202111 16 1
            0
            > GETBIT uid:sign:89757:202111 15
            1
            > GETBIT uid:sign:89757:202111 14
            0
            > BITCOUNT uid:sign:89757:202111
            2
            > BITPOS uid:sign:89757:202111 1
            (integer) 15
        ```
- 连续签到用户总数
    * 在记录了一个亿的用户连续7天的打卡数据, 如何统计出这连续7天连续打卡用户总数呢
    ```bash
        # 我们把每天的日期作为 Bitmap 的 key, userId 作为 offset, 若是打卡则将 offset 位置的 bit 设置成 1
        # key 对应的集合的每个 bit 位的数据则是一个用户在该日期的打卡记录. 
        # 一共有 7 个这样的 Bitmap, 如果我们能对这 7 个 Bitmap 的对应的 bit 位做 『与』运算. 
        # 同样的 UserID  offset 都是一样的, 当一个 userID 在 7 个 Bitmap 对应对应的 offset 位置的 bit = 1 就说明该用户 7 天连续打卡. 
        # 结果保存到一个新 Bitmap 中, 我们再通过 BITCOUNT 统计 bit = 1 的个数便得到了连续打卡 7 天的用户总数了. 
        # Redis 提供了 BITOP operation destkey key [key ...]这个指令用于对一个或者多个 键 = key 的 Bitmap 进行位元操作. 
        # opration 可以是 and、OR、NOT、XOR. 当 BITOP 处理不同长度的字符串时, 较短的那个字符串所缺少的部分会被看作 0 . 空的 key 也被看作是包含 0 的字符串序列

        # 2021-11-01 用户10086签到 
        > SETBIT login_status_20211101 10086 1
        0
        # 2021-11-01 用户10087签到 
        > SETBIT login_status_20211101 10087 1
        0
        # 2021-11-01 用户10088签到 
        > SETBIT login_status_20211101 10088 1
        0
        # 2021-11-02 用户10088签到 
        > SETBIT login_status_20211102 10088 1
        0
        # 2021-11-03 用户10088签到
        > SETBIT login_status_20211103 10088 1
        0
        # 使用and 将login_status_20211101 login_status_20211102 login_status_20211103中都为1的数据聚合到login_status_20211w1中
        > BITOP AND login_status_20211w1 login_status_20211101 login_status_20211102 login_status_20211103
        1262
        # 获取login_status_20211w1中1的数量
        > BITCOUNT login_status_20211w1
        1
        # 2021-11-03 用户10087签到 
        > SETBIT login_status_20211103 10087 1
        0
        # 2021-11-02 用户10087签到 
        > SETBIT login_status_20211102 10087 1
        0
        # 重新聚合
        > BITOP AND login_status_20211w1 login_status_20211101 login_status_20211102 login_status_20211103
        1262
        # 得到数量
        > BITCOUNT login_status_20211w1
        2
    ```




