---
title: Git_基础 (6)
date: 2022-07-07
tags: Git
toc: true
---

### git工具
    git repo

<!-- more -->

#### 前情提要
> 最近让我干git工具相关的事, 基于的前提就是git repo.所以需要先学一下git-repo

#### 应用场景

现在App Project 有多个Module, 每个Module是各自团队自己维护编写的, 每个Module都有自己的git地址. Project Main = Module A + Module B + Module C.

#### 问题

如果团队A想编写并测试自己的Module A,必须要三个Module都clone下来, 然后自建一个project引入 Module B 和 Module C然后才能修改运行, 改代码的时候必须注意哪些文件不能加入git跟踪, 不然不能提交.三个团队都要这样, 非常麻烦.而且每个仓库还有对应的branch和tag需要切换.就比如团队A需要Module A、B、C的某个分支的某个版本, 这时候在clone下来后还要进行切分支切tag的操作, 非常不方便.假设仓库不止三个而是更多…

#### 解决方案

有没有这么一种工具它clone仓库时按照规则一次性clone了Module A B C仓库并将A B C仓库都切到对应的分支和tag？所以问题就回归到怎么定制这些规制上了.
Repo刚好能使用manifest.xml来制定这套规制.
那么manifest.xml长这样：

- manifest.xml
    ```
        <?xml version="1.0" encoding="UTF-8"?>
        <manifest>
            <remote name="remote1" alias="origin" fetch=".." review="https://android-review.googlesource.com/" />

            <remote name="remote2" alias="origin" fetch="git@github.com:group2/" review="https://android-review2.googlesource.com/" />

            <default revision="master" remote="remote1" sync-j="4" />

            <project path="build/make" name="platform/build" groups="pdk" >
                <copyfile src="core/root.mk" dest="Makefile" />
                <linkfile src="CleanSpec.mk" dest="build/ClearSpec.mk" />
            </project>

            <project path="build/blueprint" name="platform/build/blueprint" groups="pdk,tradefed" revision="other_branch" remote="remote1" />
            <!-- .. -->
        </manifest>
    ```




#### repo-Manifest

Repo 管理的核心就在于 Manifest, 每个采用 repo 管理的复杂多仓库项目都需要一个对应的 manifest 仓库, 如 AOSP 的 manifest , 此仓库用来存储所有子仓库的配置信息, repo 也是读取此仓库的配置文件来进行管理操作.里面的配置就是 xml 定义的结构, 一般有两个主要的配置：子仓库用到的仓库地址(remote)、子仓库详细配置信息(project).

- remote
    * 远程仓库地址配置, 可以多个
    * name
        * 是git在服务器上的相对路径git remote名称
    * alias
        * 远程仓库别名, 可省略, 建议设为 origin,  设置了那么子仓库的 git remote 即为此名, 方便不同的 name 下可以最终设置生成相同的 remote 名称
    * fetch
        * 仓库地址前缀, 即 project 的仓库地址为: remote.fetch + project.name
    * pushurl
        * 一般可省略, 省略了则直接用 fetch
    * review
        * Gerrit code review 的地址, 如果没有用 Gerrit 则不需要配置(也就不能用 repo upload 命令了)
    * revision
        * 使用此 remote 的默认分支可以是commit id、branch name、tag name, 利用branch name的特性, revision写branch name的话, 那总可以下载到并且checkout出该branch上最新的代码
    * path
        * repo sync 同步时, 相对于根目录的子仓库文件夹路径
    * name
        * 子仓库的 git 仓库名称
    * group
        * 分组
    * revision
        * 使用的分支名
    * clone-depth
        * 仓库同步 Git 的 depth
    * project
        * src: project 下的相对路径
        * dest: 整个仓库根路径下的相对路径
        * linkfile: project 的子节点属性, 类似 copyfile, 只是把复制文件变为创建链接文件.
    * default
        * project 没有设置属性时会使用的默认配置, 常用的是 remote 和 revision.














