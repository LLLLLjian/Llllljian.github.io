---
title: Git_基础 (8)
date: 2022-07-11
tags: Git
toc: true
---

### git工具
    git repo

<!-- more -->

#### 前情提要
> 最近让我干git工具相关的事, 基于的前提就是git repo.所以需要先学一下git-repo
 源码阅读

#### 入口
> repo

入口文件启动里只有一行, 获取repo关键字之后的所有参数, 以列表形式进行上传

![repo](/img/20220711_1.PNG)

将命令行传入的所有参数 按照cmd、opt、args进行分割

![repo](/img/20220711_2.PNG)

- eg
    ```bash
        repo init -h
        # 输出结果
        cmd = init
        opt.help = False
        args = ["-h"]

        repo -h
        cmd = None
        opt.help = True
        args = []
    ```


#### Init

这里直接简单举个例子 说明一下 命令行是怎么执行到 subcmds/init.py里的
1. 可以看到main.py中的核心代码 cmd = self.commands\[name](....)
2. self.commands = all_commands, 所以看all_commands的逻辑
3. 再看subcmds/\_\_init__.py中的代码, 其实是在加载subcmds文件夹中的所有文件
4. 再看subcmds\init.py中的代码, Init类继承了InteractiveCommand 和 MirrorSafeCommand
5. 再看command.py中的代码, 他们又继承了 Command, 所以初始化的init操作在 Command 类中
6. 再返回去看mani.py中的Execute方法, 所以subcmds中的所有文件的入口文件都是Execute
7. 所以要对repo进行子程序扩展的话 也要类似的操作

- main.py
    ```python
        ...
        from subcmds import all_commands
        ...
        cmd = self.commands[name](
          repodir=self.repodir,
          client=repo_client,
          manifest=repo_client.manifest,
          outer_client=outer_client,
          outer_manifest=outer_client.manifest,
          gitc_manifest=gitc_manifest,
          git_event_log=git_trace2_event_log)
        ...
        result = cmd.Execute(copts, cargs)
    ```

- subcmds/\_\_init__.py
    ```python
        # Copyright (C) 2008 The Android Open Source Project
        #
        # Licensed under the Apache License, Version 2.0 (the "License");
        # you may not use this file except in compliance with the License.
        # You may obtain a copy of the License at
        #
        #      http://www.apache.org/licenses/LICENSE-2.0
        #
        # Unless required by applicable law or agreed to in writing, software
        # distributed under the License is distributed on an "AS IS" BASIS,
        # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        # See the License for the specific language governing permissions and
        # limitations under the License.

        import os

        # A mapping of the subcommand name to the class that implements it.
        all_commands = {}

        my_dir = os.path.dirname(__file__)
        for py in os.listdir(my_dir):
        if py == '__init__.py':
            continue

        if py.endswith('.py'):
            name = py[:-3]

            clsn = name.capitalize()
            while clsn.find('_') > 0:
            h = clsn.index('_')
            clsn = clsn[0:h] + clsn[h + 1:].capitalize()

            mod = __import__(__name__,
                            globals(),
                            locals(),
                            ['%s' % name])
            mod = getattr(mod, name)
            try:
            cmd = getattr(mod, clsn)
            except AttributeError:
            raise SyntaxError('%s/%s does not define class %s' % (
                __name__, py, clsn))

            name = name.replace('_', '-')
            cmd.NAME = name
            all_commands[name] = cmd

        # Add 'branch' as an alias for 'branches'.
        all_commands['branch'] = all_commands['branches']
    ```

- subcmds\init.py
    ```python
        ...
        class Init(InteractiveCommand, MirrorSafeCommand):
        ...
        def Execute(self, opt, args):
    ```
- command.py
    ```python
        ...
        class InteractiveCommand(Command):
        ...
        class Command(object):
            def __init__(self, repodir=None, client=None, manifest=None, gitc_manifest=None,
               git_event_log=None, outer_client=None, outer_manifest=None):
        ....
    ```
