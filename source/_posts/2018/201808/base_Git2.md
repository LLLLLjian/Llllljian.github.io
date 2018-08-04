---
title: Git_基础 (2)
date: 2018-08-01
tags: Git
toc: true
---

### Git远程操作
![Git远程操作](/img/20180801_1.jpg)
    
<!-- more -->

#### 克隆操作
- 命令
    * git clone &lt;repository> [&lt;directory>]
- 功能
    * 将储存库克隆到新目录中
- 克隆指定分支
    * git clone -b 分支名 &lt;repository>
- 克隆到指定文件夹
    * git clone <repository> [<directory>]
 
#### 执行变更操作
- 命令
    * git status
    * git add
    * git commit
- 功能
    * git status命令用于显示工作目录和暂存区的状态
    * git add命令将文件内容添加到索引(将修改添加到暂存区)
    * git commit命令用于将更改记录(提交)到存储库
- git status -s
    * M 被修改
    * A 被添加
    * D 被删除
    * R 重命名
    * ?? 未被跟踪
- git add
    * git add &lt;path> [将指定文件添加到暂存区]
    * git add .  # 将所有修改添加到暂存区
    * git add *  # Ant风格添加修改
    * git add *Controller   # 将以Controller结尾的文件的所有修改添加到暂存区
- git commit -m "comment"
    * 将暂存区的修改提交到仓库,后面添加上有意义的注视信息
- git commit --amend -m "comment"
    * 对文件进行修改之后进行的追加操作

#### 查看更改
- 命令
    * git log
    * git show
- 功能
    * git log命令用于显示提交日志信息
    * git show命令用于展示某一次提交详细信息
- git log
    * -num 显示最近的几条记录
    * --stat 显示每次更新的文件修改统计信息.
    * --shortstat 只显示 --stat 中最后的行数修改添加移除统计.
    * --name-only 仅在提交信息后显示已修改的文件清单.
    * --name-status 显示新增、修改、删除的文件清单.
    * --abbrev-commit 仅显示 SHA-1 的前几个字符,而非所有的 40 个字符.
    * --relative-date 使用较短的相对时间显示（比如,“2 weeks ago”）.
    * --graph 显示 ASCII 图形表示的分支合并历史.
    * --pretty 使用其他格式显示历史提交信息.
        * oneline 将每个提交放在一行显示
        * format 设置显示的记录格式
    * -(n)	仅显示最近的 n 条提交
    * --since, --after 仅显示指定时间之后的提交.
    * --until, --before 仅显示指定时间之前的提交.
    * --author 仅显示指定作者相关的提交.
    * --committer 仅显示指定提交者相关的提交.
- git show [SHA-1提交ID]

#### 推送(push)操作
- 命令
    * git push 源 分支名
- 功能
    * 将本地分支的更新,推送到远程主机

#### 修正错误
- 撤销本地目录下的修改
    * git checkout &lt;fileName>
- 恢复本地目录下误删除的文件
    * git checkout &lt;fileName>
- 撤销已经提交到暂存区的文件[本地修改也撤销]
    * git checkout head -- &lt;fileName>
- 撤销已经提交到暂存区的文件[保留本地修改]
    * git reset HEAD &lt;fileName>

#### 更新操作
- 命令
    * git fetch
    * git pull
- git fetch
    * 个人理解: 将代码从远程仓库更新到本地仓库中
- git pull
    * 个人理解: 将代码从远程仓库更新到本地仓库中并合并到工作目录中
