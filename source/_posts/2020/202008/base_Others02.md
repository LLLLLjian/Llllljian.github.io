---
title: 杂项_总结 (02)
date: 2020-08-31
tags: Others
toc: true
---

### ES之倒排索引
    ES之倒排索引

<!-- more -->

#### ES
> ES全称ElasticSearch, 是个开源分布式搜索引擎,它的特点有: 分布式,零配置,自动发现,索引自动分片,索引副本机制,restful风格接口,多数据源,自动搜索负载等

#### 全文索引
> 全文检索主要针对非结构化数据
- 顺序扫描法
    * 比如我们想要在成千上万的文档中,查找包含某一字符串的所有文档,顺序扫描法就必须逐个的扫描每个文档,并且每个文档都要从头看到尾,如果找到,就继续找下一个,直至遍历所有的文档；这种方法通常应用于数据量较小的场景,比如经常使用的 grep 命令就是这种查找方式
- 全文检索
    * 创建索引, 搜索索引

#### 问题1: 索引里究竟存了些什么
- 正向索引(正排索引 forward index)
    * 从文档中查找字符串,关系型数据库使用的是正向索引
    * 正排索引是从文档角度来找其中的单词,表示每个文档(用文档ID标识)都含有哪些单词,以及每个单词出现了多少次(词频)及其出现位置(相对于文档首部的偏移量).所以每次搜索都是遍历所有文章.
    * 文档 ---> 单词
- 反向索引(倒排索引 inverted index)
    * 从字符串查找文档,搜索引擎lucene使用的是反向索引
    * 倒排索引是从单词角度找文档,标识每个单词分别在那些文档中出现(文档ID),以及在各自的文档中每个单词分别出现了多少次(词频)及其出现位置(相对于该文档首部的偏移量)
    * 单词 ---> 文档

#### 举例说明正排和倒排
> 先来两个词条
文档1 doc1的内容: A computer is a device that can execute operations
文档2 doc2的内容: Early computers are big devices
对于 a, is , to ,that ,can ,the,are 这些词对搜索来说没什么意义,用户几乎不会用他们搜索,可以过滤掉
- 正排索引
|   LocalId文档局部编号  |   WordId索引词编号   |   NHits出现次数   |   HitList出现位置   |
|  ----  | ----  | ----  | ----  |
| doc1  | computer | 1 | 2 |
| &nbsp;&nbsp;  | device  | 1  | 5 |
| &nbsp;&nbsp;  | execute  | 1  | 8 |
| &nbsp;&nbsp;  | operations  | 1  | 9 |
| &nbsp;&nbsp;  | NULL  | &nbsp;&nbsp;  | &nbsp;&nbsp; |
| doc2  | early | 1 | 1 |
| &nbsp;&nbsp;  | computers  | 1  | 2 |
| &nbsp;&nbsp;  | big  | 1  | 4 |
| &nbsp;&nbsp;  | device  | 1  | 5 |
- 倒排索引
|   关键词  |   文档编号\[出现次数]   |   所在位置   |
|  ----  | ----  | ----  |
| computer  | 1\[1], 2\[1]  | 2, 2 |
| device  | 1\[1], 2\[1] | 5, 5 |
| execute  | 1\[1] | 8 |
| operations  | 1\[1] | 9 |
| early  | 2\[1] | 1 |
| big  | 2\[1] | 4 |


