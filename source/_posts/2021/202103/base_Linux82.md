---
title: Linux_基础 (82)
date: 2021-03-25
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    日常积累

<!-- more -->

#### 查看linux上次启动时间
- eg
    ```bash
        last reboot
        who -b
        uptime
    ```

#### 统计一个目录下文件数
- eg
    ```bash
        find . -name "*.java" | xargs wc -l
    ```

#### 目录下按文件大小排序
1. 方法1
    * 按照文件大小进行降序排列
        ```bash
            ll -hS
        ```
    * 按照文件大小进行升序排列
        ```bash
            ll -hrS
        ```
2. 方法2
    * 按照字节单位转换升序
        ```bash
            du -b * | sort -n
        ```
    * 按照字节单位转换降序
        ```bash
            du -b * | sort -nr
            du -k * | sort -nr
            du -m * | sort -nr
        ```
3. 方法3
    ```bash
        find ./ -type f -printf '%s %p\n' | sort -n

        find ./ -type f -printf '%s %p\n' | sort -rn
    ```

#### 绝对路径压缩文件去除目录结构
> 在打包时如果源文件包含绝对路径, 打包的文件重新解压也会包含有目录信息, 所以如果不需要目录信息需要自己在打包的地方配置一下
1. cmd
    ```bash
        # 打包命令+空格+压缩后文件存放目录及名称+空格+"-C"+源文件目录+空格+文件名称(注意：-C与文件夹之间没有空格, 文件夹与文件中间有空格)
        tar -zcvf /opt/test/a.tar.gz -C/opt/test/ a.log
    ```
2. 使用tar命令只打包
    <table><tbody><tr><td style="vertical-align:middle;width:365px;"><strong>命 &nbsp;令</strong></td><td style="vertical-align:middle;width:484px;"><strong>作 &nbsp;用</strong></td></tr><tr><td style="vertical-align:top;width:365px;">tar -cvf 123.tar 123</td><td style="vertical-align:top;width:484px;">打包单个文件</td></tr><tr><td style="vertical-align:top;width:365px;">tar -cvf 123.tar 1.txt 123</td><td style="vertical-align:top;width:484px;">打包多个文件</td></tr><tr><td style="vertical-align:top;width:365px;">tar -xvf 123.tar</td><td style="vertical-align:top;width:484px;">解包</td></tr><tr><td style="vertical-align:top;width:365px;">tar -tf 123.tar</td><td style="vertical-align:top;width:484px;">查看打包文件列表</td></tr><tr><td style="vertical-align:top;width:365px;">tar -cvf 123.tar --exclude 1.txt --exclude 23</td><td style="vertical-align:top;width:484px;">打包时排除不需要打包的文件或文件夹(<span style="color:#7c79e5;">排除文件夹是最后不能有‘/’</span>)</td></tr></tbody></table>
3. 使用tar命令并压缩
    <table><tbody><tr><td style="vertical-align:middle;"><strong>命 &nbsp;令</strong></td><td style="vertical-align:middle;"><strong>作 &nbsp;用</strong></td></tr><tr><td style="vertical-align:top;">tar -zcvf 123.tar.gz 123</td><td style="vertical-align:top;">打包并压缩成gzip压缩包</td></tr><tr><td style="vertical-align:top;">tar -zxvf 123.tar.gz</td><td style="vertical-align:top;">解包并解压缩gzip压缩包</td></tr><tr><td style="vertical-align:top;">tar -jcvf 123.bz2 123</td><td style="vertical-align:top;">打包并压缩成bzip2压缩包</td></tr><tr><td style="vertical-align:top;">tar -jxvf 123.bz2</td><td style="vertical-align:top;">解包并解压缩bzip2压缩包</td></tr><tr><td style="vertical-align:top;">tar -Jcvf 123.xz 123</td><td style="vertical-align:top;">打包并压缩成xz压缩包</td></tr><tr><td style="vertical-align:top;">tar -Jxvf 123.xz</td><td style="vertical-align:top;">解包并解压缩xz压缩包</td></tr><tr><td style="vertical-align:top;">tar -tf 123.bz2/123.gz/123.xz</td><td style="vertical-align:top;">查看压缩包文件列表</td></tr></tbody></table>


