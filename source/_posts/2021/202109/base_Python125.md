---
title: Python_基础 (125)
date: 2021-09-03
tags: Python
toc: true
---

### python之Click
    本来是想学一下flask的自定义命令, 看了文档才知道它是基于Click来实现的, 那我就得先学Click了,  但是我翻到Click的时候, 又知道了Click是基于Argparse的, 嘻嘻嘻嘻, 被俄罗斯套娃了

<!-- more -->

#### Click模块
> Click 是 Flask 的开发团队 Pallets 的另一款开源项目, 它是用于快速创建命令行的第三方模块
我们知道, Python 内置了一个 Argparse 的标准库用于创建命令行, 但使用起来有些繁琐, Click 相比于 Argparse, 就好比 requests 相比于 urllib.
- 安装
    ```bash
        pip install click
    ```
- demo1
    ```python
        import click

        # 使函数 hello 成为命令行接口
        @click.command()
        # 指定了命令行选项的名称count, 默认值是 1
        @click.option('--count', default=1, help='Number of greetings.')
        @click.option('--name', prompt='Your name', help='The person to greet.')
        def hello(count, name):
            """
            Simple program that greets NAME for a total of COUNT times.
            """
            for x in range(count):
                # 使用 click.echo 进行输出是为了获得更好的兼容性, 因为 print 在 Python2 和 Python3 的用法有些差别
                click.echo('Hello %s!' % name)
        
        if __name__ == '__main__':
            hello()

        # 输出结果
        $ python3 click_demo1.py
        Your name: llllljian
        Hello llllljian!

        $ python3 click_demo1.py --help
        Usage: click_demo1.py [OPTIONS]

        Simple program that greets NAME for a total of COUNT times.

        Options:
        --count INTEGER  Number of greetings.
        --name TEXT      The person to greet.
        --help           Show this message and exit.

        $ python3 click_demo1.py --count 3 --name llllljian
        Hello llllljian!
        Hello llllljian!
        Hello llllljian!

        $ python3 click_demo1.py --count=3 --name=llllljian
        Hello llllljian!
        Hello llllljian!
        Hello llllljian!
    ```

###### click.options
- param
    * default: 设置命令行参数的默认值
    * help: 参数说明
    * type: 参数类型, 可以是 string, int, float 等
    * prompt: 当在命令行中没有输入相应的参数时, 会根据 prompt 提示用户输入
    * nargs: 指定命令行参数接收的值的个数
    * metavar: 如何在帮助页面表示值
- Basic Value Options
    ```python
        @click.command()
        @click.option('--n', default=1)
        def dots(n):
            click.echo('.' * n)

        # 输出结果
        $ dots --n=2
        ..
    ```
- Multi Value Options
    ```python
        @click.command()
        @click.option('--pos', nargs=2, type=float)
        def findme(pos):
            click.echo('%s / %s' % pos)

        # 输出结果
        $ findme --pos 2.0 3.0
        2.0 / 3.0
    ```
- Tuples as Multi Value Options
    ```python
        @click.command()
        @click.option('--item', type=(str, int))
        def putitem(item):
            click.echo('name=%s id=%d' % item)

        @click.command()
        @click.option('--item', nargs=2, type=click.Tuple([str, int]))
        def putitem1(item):
            click.echo('name=%s id=%d' % item)

        # 输出结果
        $ putitem --item peter 1338
        name=peter id=1338
        $ putitem1 --item peter 1338
        name=peter id=1338
    ```
- Multiple Options
    ```python
        @click.command()
        @click.option('--message', '-m', multiple=True)
        def commit(message):
            click.echo('\n'.join(message))

        # 输出结果
        $ commit -m foo -m bar
        foo
        bar
    ```
- Counting
    ```python
        @click.command()
        @click.option('-v', '--verbose', count=True)
        def log(verbose):
            click.echo('Verbosity: %s' % verbose)

        # 输出结果
        $ log -vvv
        Verbosity: 3
    ```
- Feature Switches
    ```python
        import sys

        @click.command()
        @click.option('--upper', 'transformation', flag_value='upper', default=True)
        @click.option('--lower', 'transformation', flag_value='lower')
        def info(transformation):
            click.echo(getattr(sys.platform, transformation)())

        # 输出结果
        $ info --upper
        LINUX
        $ info --lower
        linux
        $ info
        LINUX
    ```
- Choice Options
    ```python
        @click.command()
        @click.option('--hash-type', type=click.Choice(['md5', 'sha1']))
        def digest(hash_type):
            click.echo(hash_type)

        $ digest --hash-type=md5
        md5

        $ digest --hash-type=foo
        Usage: digest [OPTIONS]

        Error: Invalid value for "--hash-type": invalid choice: foo. (choose from md5, sha1)

        $ digest --help
        Usage: digest [OPTIONS]

        Options:
        --hash-type [md5|sha1]
        --help                  Show this message and exit.
    ```
- Password Prompts
    ```python
        # hide_input 用于隐藏输入, confirmation_promt 用于重复输入
        @click.command()
        @click.option('--password', prompt=True, hide_input=True, confirmation_prompt=True)
        def encrypt(password):
            click.echo('Encrypting password to %s' % password.encode('rot13'))

        @click.command()
        @click.password_option()
        def encrypt1(password):
            click.echo('Encrypting password to %s' % password.encode('rot13'))

        $ encrypt
        Password: 
        Repeat for confirmation: 
    ```
- Yes Parameters
    ```python
        def abort_if_false(ctx, param, value):
            if not value:
                ctx.abort()

        # is_eager=True 表明该命令行选项优先级高于其他选项
        # expose_value=False 表示如果没有输入该命令行选项, 会执行既定的命令行流程；
        # callback 指定了输入该命令行选项时, 要跳转执行的函数
        # is_flag=True 表明参数值可以省略
        @click.command()
        @click.option('--yes', is_flag=True, callback=abort_if_false, expose_value=False, prompt='Are you sure you want to drop the db?')
        def dropdb():
            click.echo('Dropped all tables!')

        ---------------------------------------------------------------

        @click.command()
        @click.confirmation_option(prompt='Are you sure you want to drop the db?')
        def dropdb():
            click.echo('Dropped all tables!')

        ---------------------------------------------------------------

        $ dropdb
        Are you sure you want to drop the db? [y/N]: n
        Aborted!
        $ dropdb --yes
        Dropped all tables!
    ```

##### click.group
- demo2
    ```python
        import click


        @click.group()
        def cli():
            """
            这是cli()的注释
            """
            pass


        @click.command()
        def initdb():
            click.echo('Initialized the database')


        @click.command()
        def dropdb():
            click.echo('Droped the database')


        cli.add_command(initdb)
        cli.add_command(dropdb)

        if __name__ == "__main__":
            cli()

        # 输出信息
        $ python3 click_demo2.py --help
        Usage: click_demo2.py [OPTIONS] COMMAND [ARGS]...

        这是cli()的注释

        Options:
        --help  Show this message and exit.

        Commands:
        dropdb
        initdb

        $ python3 click_demo2.py dropdb
        Droped the database

        $ python3 click_demo2.py initdb
        Initialized the database
    ```

##### click.argument
- demo
    ```python
        # 单个argument
        import click
        @click.command()
        @click.argument('coordinates')
        def show(coordinates):
            click.echo('coordinates: %s' % coordinates)
        if __name__ == '__main__':
            show()

        $ python click_argument.py                     # 错误, 缺少参数 coordinates
        Usage: click_argument.py [OPTIONS] COORDINATES
        Error: Missing argument "coordinates".
        $ python click_argument.py --help              # argument 指定的参数在 help 中没有显示
        Usage: click_argument.py [OPTIONS] COORDINATES
        Options:
        --help  Show this message and exit.
        $ python click_argument.py --coordinates 10    # 错误用法, 这是 option 参数的用法
        Error: no such option: --coordinates
        $ python click_argument.py 10                  # 正确, 直接输入值即可
        coordinates: 10
    ```
- demo1
    ```python
        # 多个argument
        import click
        @click.command()
        @click.argument('x')
        @click.argument('y')
        @click.argument('z')
        def show(x, y, z):
            click.echo('x: %s, y: %s, z:%s' % (x, y, z))
        if __name__ == '__main__':
            show()

        $ python click_argument.py 10 20 30
        x: 10, y: 20, z:30
        $ python click_argument.py 10
        Usage: click_argument.py [OPTIONS] X Y Z
        Error: Missing argument "y".
        $ python click_argument.py 10 20
        Usage: click_argument.py [OPTIONS] X Y Z
        Error: Missing argument "z".
        $ python click_argument.py 10 20 30 40
        Usage: click_argument.py [OPTIONS] X Y Z
        Error: Got unexpected extra argument (40)
    ```
