---
title: Git_基础 (7)
date: 2022-07-08
tags: Git
toc: true
---

### git工具
    git repo

<!-- more -->

#### 前情提要
> 最近让我干git工具相关的事, 基于的前提就是git repo.所以需要先学一下git-repo

#### 开始
##### 快速开始
- 步骤1: 安装 git-repo
    ```bash
        curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
    ```
- 步骤2：运行 git-repo
    ```bash
        git repo version
    ```
- 步骤3：单仓库下发起代码评审
    ```bash
        # 建立和 origin 远程仓库的 master 分支建立关联
        git branch -u origin/master
        # 发起代码审核
        git pr
    ```
    ![单仓](/img/20220708_1.gif)
- 步骤4：多仓库工作流
    ```bash
        # 1. 创建工作区
        mkdir workspace
        cd workspace
        # 2. 下载 manifest 清单仓库, 初始化工作区
        git repo init -u <manifest repository>
        # 3. 按照 Manifest 清单仓库中的文件, 下载各个子仓库的代码, 并检出到工作区
        git repo sync
        # 4. 创建开发分支
        git repo start --all <branch/name>
        # 5. 在工作区中开发, 每个仓库的改动, 在各自仓库中完成提交
        # 6. 执行下面命令, 扫描工作区所有仓库的改动, 逐个向上游仓库发起代码评审
        git repo upload
    ```
    ![多仓](/img/20220708_2.gif)

https://git-repo.info/zh_cn/docs/multi-repos/manifest-format/



