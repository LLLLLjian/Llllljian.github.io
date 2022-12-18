---
title: Git_基础 (9)
date: 2022-08-01
tags: Git
toc: true
---

### git测试用例
    git源码

<!-- more -->

#### 前情提要
> 目前开发的git工具测试用例和git 原生的测试用例是类似的, 所以要先看一下

#### 参考文档
> https://github.com/git/git/blob/master/t/README

#### 执行步骤
- 执行所有测试用例
    ```bash
        cd  t
        make

        # 输出结果
        fixed       0
        success     254
        failed      0
        broken      0
        total       254
    ```
- 执行一部分测试用例
    ```bash
        prove --timeer --jobs 15 ./t01[0-9]*.sh
    ```
- 执行单个测试用例
    ```bash
        ./t01111-sync-with-fsck.sh
    ```
- 执行某个测试用例中的某个例子
    ```bash
        ./t01111-sync-with-fsck.sh --run="1"
    ```

#### 参数介绍
- -v/--verbose
    * 输出运行详情
- --verbose-only
    * 与--verbose类似, 但是可以具体到某个例子
- -x
    * 打印测试用例执行过程中运行的所有命令
- -d/--debug
    * debug用例执行的信息, 在执行完之后不会删除测试用例期间产生的临时文件
- -i/--immediate
    * 没看懂
- -l/--long-tests
    * 没看懂
- -r/--run
    * 执行单个测试用例中的某个例子
- --valgrind
    * 看样子也是在输出详细信息呀
- --valgrind-only
    * 同样支持指定单个例子
- --tee
    * 处理输出内容到终端外, 还会降内容往test-result/$TEST_NAME.out文件中写一份
- -V/--verbose-log
    * 与--tee命令类似, 但是不会输出到终端

#### 测试用例命名
> tNNNN-commandname-details.sh
- 4个N说明
    * 第一个N
        * 0 - the absolute basics and global stuff
        * 1 - the basic commands concerning database
        * 2 - the basic commands concerning the working tree
        * 3 - the other basic commands (e.g. ls-files)
        * 4 - the diff commands
        * 5 - the pull and exporting commands
        * 6 - the revision tree commands (even e.g. merge-base)
        * 7 - the porcelainish commands concerning the working tree
        * 8 - the porcelainish commands concerning forensics
        * 9 - the git tools
    * 第二个N
        * 表示我们正咋执行的特定命令
    * 第三个N
        * 表示特定开关或开关组

#### 写测试用例
- 注释/帮助文档/-h
    * 会输出test_description中的内容
- 需要注意的地方
    * 将测试标题和测试函数放在同一行
    * 以单引号结束行
    * 多行用<<-
    * 将所有代码都放在test_expect_success中
    * test_expect_success的意思是期望成功, 其中所有执行的语句都要成功, 如果一定是失败的, 可以使用test_might_fail或者test_must_fail
    * 可以通过测试覆盖率来查看测试的覆盖情况, 但这个只是参考, 并不是说覆盖率100%就一定没问题
- 要避免的地方
    * 不要使用exit(), 如果想终止的话 直接使用test_done
    * 不要使用 ! git cmd, 而是使用test_must_fail git cmd
    * 不要使用test_must_fail cmd, 使用!cmd就可以了
    * 不要使用管道命令, 如果希望获取输出的话, 可以把它分配给变量, e.g. "x=$(git ...)"
    * 可以使用 x=$\(git cat-file -p $sha), 但是不能使用 test "refs/heads/foo" = "$(git symbolic-ref HEAD)"
    * 不要在测试用使用chdir
    * 不要保存和验证复合命令的标准错误
        ```bash
            # 错误
            ( cd dir && git cmd ) 2>error &&
            test_cmp expect error
            # 正确
            ( cd dir && git cmd 2>../error ) &&
            test_cmp expect error
        ```
    * 不要破坏TAP的输出

#### 跳过测试用例
- e.g.
    ```bash
        # 跳过某个测试用例文件
        GIT_SKIP_TESTS="t01111" make
        # 跳过某个测试用例文件中的某个例子
        GIT_SKIP_TESTS="t01111.3" make
        # 跳过某个例子
        GIT_SKIP_TESTS="t01111.3" sh ./t0111-sync-with-fsck.sh
    ```

#### 可以直接使用的方法
- test_expect_success 
    * 通常将两个字符作为参数, 并判断script是否为true
- test_done
    * 所有的测试用例文件必须以test_done结尾
- test_must_fail 
    * 一定是失败的git-command命令
- test_cmp
    * 比较文件是否一样
- test_path_is_file
    * 文件是否存在 等同于 test -f
- test_path_is_dir 
    * 文件夹是否存在 等同于 test -d
- test_path_is_missing 
    * 文件/文件夹不存在


