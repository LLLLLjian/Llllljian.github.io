---
title: Linux_基础 (85)
date: 2021-04-02
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### wget
> 获取资源/内容下载都需要用到wget, 我基本上只会最简单的, 刚好从书上学一点其它的东西
1. 用wget可以下载网页或远程文件
    * wget URL
    * wget URL1 URL2 URL3 ..
2. 设置文件名并隐藏日志
    ```bash
        # 日志或进度信息被写入文件log, 输出文件为dloaded_file.img
        wget ftp://example_domain.com/somefile.img -O dloaded_file.img -o log
    ```
3. 设置重试次数
    ```bash
        # 尝试5次
        wget -t 5 URL
        # 不停的尝试
        wget -t 0 URL
    ```
4. 下载限速
    ```bash
        # 限速20k(在命令中用k(千字节)和m(兆字节)指定速度限制)
        wget --limit-rate 20k http://example.com/file.iso
        # 指定最大下载配额(quota).配额一旦用尽, 下载随之停止, 这里限制下载配额100m
        wget -Q 100m http://example.com/file1 http://example.com/file2
    ```
5. 断点续传
    ```bash
        # -c可以从断点处继续下载
        wget -c URL
    ```
6. 访问需要认证的HTTP或FTP页面 
    ```bash
        # 一些网页需要HTTP或FTP认证, 可以用--user和--password提供认证信息
        wget --user username --password pass URL
        wget --ftp-user=xxxx --ftp-password=xxx ftp://path/file_name -O new_file_name;
    ```