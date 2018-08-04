---
title: Git_基础 (3)
date: 2018-08-02
tags: 
    - Git
    - Interview
toc: true
---

### Git面试点
    持续更新

<!-- more -->

#### Git和SVN的优缺点
- SVN优缺点
    * 优点 
        * 管理方便,逻辑明确,符合一般人思维习惯 
        * 易于管理,集中式服务器更能保证安全性 
        * 代码一致性非常高
        * 适合开发人数不多的项目开发
    * 缺点 
        * 服务器压力太大,数据库容量暴增
        * 如果不能连接到服务器上,基本上不可以工作
- Git优缺点
    * 优点 
        * 适合分布式开发,强调个体
        * 公共服务器压力和数据量都不会太大
        * 速度快、灵活
        * 任意两个开发者之间可以很容易的解决冲突. 
        * 离线工作
    * 缺点 
        * 学习周期相对而言比较长
        * 不符合常规思维
        * 代码保密性差,一旦开发者把整个库克隆下来就可以完全公开所有代码和版本信息

#### pull与fetch的区别
- git fetch 
    * 取回远端更新,不会对本地执行merge操作,不会去动本地的内容
- git pull 
    * pull=fetch+merge,
    * git pull会更新本地代码到服务器上对应分支的最新版本

#### git reset、git revert和git checkout区别
- git本地库回退到暂存区
    * git reset --soft HEAD^
- git本地库回退到修改之后
    * git reset HEAD^
- git本地库回退到工作区
    * git reset --hard HEAD^
- 暂存区回退到修改之后
    * git reset HEAD fileName
- 修改之后回退到修改之前
    * git checkout -- fileName


