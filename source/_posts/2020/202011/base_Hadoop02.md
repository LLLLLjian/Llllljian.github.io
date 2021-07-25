---
title: Hadoop_基础 (02)
date: 2020-11-23
tags: Hadoop
toc: true
---

### 快来跟我一起学HDFS
    还需要学一下大数据
    先看看Hadoop

<!-- more -->

#### Hadoop组成
> Hadoop = hdfs(存储) + mapreduce(计算) + yarn(资源管理) + common(工具包)
- 分布式存储系统 HDFS (Hadoop Distributed File System )
    * 分布式存储系统
    * 提供了高可靠性、高扩展性和高吞吐率的数据存储服务
- 分布式计算框架 MapReduce
    * 分布式计算框架(计算向数据移动)
    * 具有易于编程、高容错性和高扩展性等优点.
- 分布式资源管理框架 YARN(Yet Another Resource Management)
    * 负责集群资源的管理和调度

#### HDFS的功能模块及原理详解
1. HDFS数据存储单元(block)
    * 文件被切分成固定大小的数据块 block
        * 默认数据块大小为128MB(hadoop2.x),可自定义配置
        * 若文件大小不到128MB,则单独存成一个block
    * 一个文件存储方式
        * 按大小被切分成若干个block,存储到不同节点上
        * 默认情况下每个block都有3个副本
    * Block大小和副本数通过Client端上传文件时设置,文件上传成功后副本数可以变更,Block Size 不可变更
2. hdf存储模型:字节(byte)
    * 文件线性切割成块(Block):偏移量 offset (byte)
    * Block分散存储在集群节点中
    * 单一文件Block大小一致,文件与文件可以不一致
    * Block可以设置副本数,副本分散在不同节点中
        * 副本数不要超过节点数量
    * 文件上传可以设置Block大小和副本数
    * 已上传的文件Block副本数可以调整,大小不变
    * 只支持一次写入多次读取,同一时刻只有一个写入者 
    * 可以append追加数据
3. NameNode(简称 NN)
    * NameNode 主要功能
        * 接受客户端的读/写服务
        * 收集DataNode汇报的Block列表信息
    * 基于内存存储
        * 不会和磁盘发生交换
        * 只存在内存中
        * 持久化
    * NameNode 保存 metadata 信息:
        * 文件owership(归属)和permissions(权限)
        * 文件大小,时间
        * (Block列表:Block偏移量),位置信息(不会持久化)
        * Block保存在哪个DataNode信息(由DataNode启动时上报, 不保存在磁盘)
    * NameNode 持久化
        * NameNode的metadate信息在启动后会加载到内存
        * metadata存储到磁盘文件名为”fsimage”
        * Block的位置信息不会保存到fsimage
        * edits记录对metadata的操作日志
        * fsimage保存了最新的元数据检查点,类似快照
        * editslog 保存自最新检查点后的元信息变化,从最新检查点后,hadoop 将对每个文件的操作都保存在 edits 中.客户端修改文件时候,先写到 editlog,成功后才更新内存中的 metadata 信息.
        * Metadata = fsimage + editslog
4. DataNode(简称 DN)
    * 本地磁盘目录存储数据(Block),文件形式
    * 同时存储Block的元数据(md5值)信息文件
    * 启动DN进程的时候会向NameNode汇报block信息
    * 通过向NN发送心跳保持与其联系(3秒一次), 如果NN10分钟没有收到DN的心跳, 则认为其已经lost, 并copy其上的block到其它DN
5. SecondaryNameNode(简称 SNN)
    * 它的主要工作是帮助NN合并editslog文件,减少NN启动时间,它不是 NN 的备份(但可以做备份)
    * SNN执行合并时间和机制
        * 根据配置文件设置的时间间隔 fs.checkpoint.period 默 认 3600 秒
        * 根据配置文件设置 edits log 大小 fs.checkpoint.size规定edits文件的最大值默认是 64MB
6. SecondaryNameNode SNN合并流程
    * 首先是 NN 中的 Fsimage 和 edits 文件通过网络拷贝,到达 SNN 服务器中,拷贝的同时,用户的实时在操作数据,那么 NN 中就会从新生成一个 edits 来记录用户的操作,而另一边的 SN N将拷贝过来的 edits 和 fsimage 进行合并,合并之后就替换 NN 中的 fsimage.之后 NN 根据 fsimage 进行操作(当然每隔一 段时间就进行替换合并,循环).当然新的 edits 与合并之后传 输过来的 fsimage 会在下一次时间内又进行合并
7. Block 的副本放置策略
    * 第一个副本:放置在上传文件的DN
    * 第二个副本:放置在于第一个副本不同的机架的节点上.
    * 第三个副本:与第二个副本相同机架的不同节点.
    * 更多副本:随机节点
8. HDFS写文件流程
    * 切分文件Block
    * 按Block线性和NN获取DN列表(副本数)
    * 验证DN列表后以更小的单位(packet)流式传输数据
        * 各节点,两两通信确定可用
    * Block传输结束后:
        * DN向NN汇报Block信息 
        * DN 向 Client 汇报完成
        * Client 向 NN 汇报完成
    * 获取下一个Block存放的DN列表
    * .................
    * 最终Client汇报完成
    * NN会在写流程更新文件状态
9. HDFS读文件流程
    * 和NN获取一部分Block副本位置列表
    * 线性和DN获取Block,最终合并为一个文件
    * 在Block副本列表中按距离择优选取
10. HDFS文件权限
    *  与Linux文件权限类似
        * r: read
        * w: write
        * x: execute
    * 如果Linux系统用户zhangsan使用hadoop命令创建一个文件,那么这个文件在 HDFS 中 owner 就是 zhangsan.
    * HDFS的权限目的:阻止好人错错事,而不是阻止坏人做坏事.HDFS 相信,你告诉我你是谁,我就认为你是谁.
11. 安全模式
    * namenode启动的时候,首先将映像文件(fsimage)载入内存, 并执行编辑日志(edits)中的各项操作
    * 一旦在内存中成功建立文件系统元数据的映射,一个空的编辑 日志.
    * 此刻 namenode 运行在安全模式.即 namenode 的文件系统对 于客服端来说是只读的.(显示目录,显示文件内容等.写、删 除、重命名都会失败).
    * 在此阶段 Namenode 收集各个 datanode 的报告,当数据块达到 最小副本数以上时,会被认为是“安全”的, 在一定比例(可设置)的数据块被确定为“安全”后,再过若干时间,安全模式结束
    * 当检测到副本数不足的数据块时,该块会被复制直到达到最小副本数,系统中数据块的位置并不是由 namenode 维护的,而 是以块列表形式存储在 datanode 中

#### HDFS的优缺点
- 优点
    * 高容错性
        * 数据自动保存多个副本
        * 副本丢失后,自动恢复
    * 适合批处理
        * 移动计算而非数据
        * 数据位置暴露给计算框架(Block偏移量)
    * 适合大数据处理
        * TB 、甚至 PB 级数据
        * 百万规模以上的文件数量 • 10K+ 节点
    * 可构建在廉价机器上
        * 通过多副本提高可靠性
        * 提供了容错和恢复机制
- 缺点:
    * 低延迟
        * 比如支持秒级别反应,不支持毫秒级
        * 延迟与高吞吐率问题(吞吐量大但有限制于其延迟)
    * 小文件存取
        * 占用 NameNode 大量内存
        * 寻道时间超过读取时间
    * 并发写入、文件随机修改
        * 一个文件只能有一个写者
        * 仅支持append




