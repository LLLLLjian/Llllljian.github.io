---
title: Linux_基础 (98)
date: 2021-12-09
tags: Linux
toc: true
---

### Linux积累
    什么！我起的进程没了, 是谁给我杀了呀

<!-- more -->

#### 前情提要
> 其实也不是什么大事, 就是睡一觉起来发现起的进程没了, 因为是混布的,刚开始怀疑是被人误杀了, 后来查了半天才知道OOM这个东西 记录一下

#### OOM
- 全称
    * Out Of Memory killer
- 作用
    * linux内核机制, 会监控哪些占用内存过大,尤其是瞬间占用内存很快的进程,然后防止内存耗尽而主动把该进程杀掉
- 如何查看
    ```bash
        grep "Out of memory" /var/log/messages

        egrep -i -r 'killed process' /var/log
    ```
- 机制分析
    * /proc/\[pid]/oom_adj ,该pid进程被oom killer杀掉的权重,介于 \[-17,15]之间,越高的权重,意味着更可能被oom killer选中,-17表示禁止被kill掉.
    * /proc/\[pid]/oom_score,当前该pid进程的被kill的分数,越高的分数意味着越可能被kill,这个数值是根据oom_adj运算后的结果,是oom_killer的主要参考
- 如何防止特定进程被OOM
    *  英文资料里说的是lose some randomly picked processes, 这个说法其实是不对的, Linux是通过1个策略(杀掉尽量少的进程、释放最大的内存, 同时不伤及无辜的用了很大内存的进程)来实现的, 这个策略的核心机制–分数计算方式如下：对系统中正在运行的进程计算1个分值, 这个分值综合了进程的内存使用量、CPU时间、存活时间、oom_adj计算出来的.这个oom_adj是啥东西？它是Linux提供给用户、用于灵活控制每个进程的OOM概率的接口,   可以通过  /proc/进程id/oom_adj  进行查看和修改, 它的值是从  -16(最小概率)到15(最大概率), 如果我们要求进程不管内存使用情况怎么样, 都不能被oom killer干掉的话,  把这个值设置为  -17 即可.DuFault的内存异常插件就踩了这个坑, 导致内存异常插件被操作系统干掉、导致异常构造失败的问题, 在插件启动后, 设置该值即可解决问题.




