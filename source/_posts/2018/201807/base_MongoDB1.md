---
title: MongoDB_基础 (1)
date: 2018-07-25
tags: MongoDB
toc: true
---

### MongoDB简介
    先记录一下MongoDB一些简单的内容

<!-- more -->

#### 什么是MongoDB
    MongoDB 是由C++语言编写的,是一个基于分布式文件存储的开源数据库系统.
    在高负载的情况下,添加更多的节点,可以保证服务器性能.
    MongoDB 旨在为WEB应用提供可扩展的高性能数据存储解决方案.
    MongoDB 将数据存储为一个文档,数据结构由键值(key=>value)对组成.
    MongoDB 文档类似于 JSON 对象.字段值可以包含其他文档,数组及文档数组.
- demo
    ```sql
        {
            _id: 1,
            name: 'llllljian',
            age: '23',
            email: [
                'demo1@gmail.com',
                'demo2@gmail.com'
            ]
        }
    ```

#### 主要特点
- MongoDB 是一个面向文档存储的数据库,操作起来比较简单和容易.
- 你可以在MongoDB记录中设置任何属性的索引 (如：FirstName="Sameer",Address="8 Gandhi Road")来实现更快的排序.
- 你可以通过本地或者网络创建数据镜像,这使得MongoDB有更强的扩展性.
- 如果负载的增加（需要更多的存储空间和更强的处理能力） ,它可以分布在计算机网络中的其他节点上这就是所谓的分片.
- Mongo支持丰富的查询表达式.查询指令使用JSON形式的标记,可轻易查询文档中内嵌的对象及数组.
- MongoDb 使用update()命令可以实现替换完成的文档（数据）或者一些指定的数据字段 .
- Mongodb中的Map/reduce主要是用来对数据进行批量处理和聚合操作.
- Map和Reduce.Map函数调用emit(key,value)遍历集合中所有的记录,将key与value传给Reduce函数进行处理.
- Map函数和Reduce函数是使用Javascript编写的,并可以通过db.runCommand或mapreduce命令来执行MapReduce操作.
- GridFS是MongoDB中的一个内置功能,可以用于存放大量小文件.
- MongoDB允许在服务端执行脚本,可以用Javascript编写某个函数,直接在服务端执行,也可以把函数的定义存储在服务端,下次直接调用即可.
- MongoDB支持各种编程语言:RUBY,PYTHON,JAVA,C++,PHP,C#等多种语言.
- MongoDB安装简单.

#### MongoDB工具
- GUI
    * RockMongo — 最好的PHP语言的MongoDB管理工具,轻量级, 支持多国语言.

#### MongoDB概念解析
- 与SQL概念对比
    <table><tbody><tr><th>SQL术语/概念</th><th>MongoDB术语/概念</th><th>解释/说明</th><tr><td>database<td>database<td>数据库<tr><td>table<td>collection<td>数据库表/集合<tr><td>row<td>document<td>数据记录行/文档<tr><td>column<td>field<td>数据字段/域<tr><td>index<td>index<td>索引<tr><td>table joins<td>&nbsp;<td>表连接,MongoDB不支持<tr><td>primary key<td>primary key<td>主键,MongoDB自动将_id字段设置为主键</table>

#### 数据库操作
- 展示所有数据库
    * MySQL
        * SHOW DATABASES;[不区分大小写]
    * MongoDB
        * show databases;[区分大小写]
        * show dbs
- 展示当前数据库对象或集合
    * MongoDB
        * db
- 选择指定的数据库
    * MySQL
        * use 数据库名;
    * MongoDB
        * use 数据库名
- 显示集合/表
    * MySQL
        * ：show tables;
    * MongoDB
        * show tables

#### MongoDB命名规范
- 数据库
    * UTF-8字符串
    * 不能是空字符串
    * 不得含有' '（空格)、.、$、/、\和\0 (空字符)
    * 应全部小写
    * 最多64字节
- 文档
    * 键不能含有\0 (空字符).这个字符用来表示键的结尾
    * .和$有特别的意义,只有在特定环境下才能使用
    * 以下划线"_"开头的键是保留的(不是严格要求的)
- 集合
    * 集合名不能是空字符串"".
    * 集合名不能含有\0字符（空字符),这个字符表示集合名的结尾.
    * 集合名不能以"system."开头,这是为系统集合保留的前缀.
    * 用户创建的集合名字不能含有保留字符.有些驱动程序的确支持在集合名里面包含,这是因为某些系统生成的集合中包含该字符.除非你要访问这种系统创建的集合,否则千万不要在名字里出现$

#### MongoDB数据类型
- 数据类型列表
    <table><tbody><tr><th>数据类型</th><th>描述</th><tr><td>String<td>字符串.存储数据常用的数据类型.在 MongoDB 中,UTF-8 编码的字符串才是合法的.<tr><td>Integer<td>整型数值.用于存储数值.根据你所采用的服务器,可分为 32 位或 64 位.<tr><td>Boolean<td>布尔值.用于存储布尔值（真/假）.<tr><td>Double<td>双精度浮点值.用于存储浮点值.<tr><td>Min/Max keys<td>将一个值与 BSON（二进制的 JSON）元素的最低值和最高值相对比.<tr><td>Array<td>用于将数组或列表或多个值存储为一个键.<tr><td>Timestamp<td>时间戳.记录文档修改或添加的具体时间.<tr><td>Object<td>用于内嵌文档.<tr><td>Null<td>用于创建空值.<tr><td>Symbol<td>符号.该数据类型基本上等同于字符串类型,但不同的是,它一般用于采用特殊符号类型的语言.<tr><td>Date<td>日期时间.用 UNIX 时间格式来存储当前日期或时间.你可以指定自己的日期时间：创建 Date 对象,传入年月日信息.<tr><td>Object ID<td>对象 ID.用于创建文档的 ID.<tr><td>Binary Data<td>二进制数据.用于存储二进制数据.<tr><td>Code<td>代码类型.用于在文档中存储 JavaScript 代码.<tr><td>Regular expression<td>正则表达式类型.用于存储正则表达式.</table>
- ObjectId类型
    * MongoDB生成的类似关系型DB表主键的唯一key,生成快速.具体由12个字节组成：
    * 前4个字节是unix秒,3个字节的机器标识符（为了分布式下的主键唯一）,2个字节的进程id,3个字节的计数器数字
    * MongoDB中存储的文档必须有一个_id键.这个键的值可以是任何类型的,默认是个ObjectId对象
- 字符串
    * BSON字符串都是UTF-8编码
- 日期
    * 注意ISODate()显示出来的是格林尼治时间,有八个小时的时间间隔
    * 可以通过ISODate().valueOf()转换为毫秒时间戳
