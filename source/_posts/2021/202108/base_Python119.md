---
title: Python_基础 (119)
date: 2021-08-26
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### 创建一个虚拟环境

建议在开发环境和生产环境下都使用虚拟环境来管理项目的依赖.

为什么要使用虚拟环境？随着你的 Python 项目越来越多, 你会发现不同的项目 会需要不同的版本的 Python 库.同一个 Python 库的不同版本可能不兼容.

虚拟环境可以为每一个项目安装独立的 Python 库, 这样就可以隔离不同项目之 间的 Python 库, 也可以隔离项目与操作系统之间的 Python 库.

Python 内置了用于创建虚拟环境的 venv 模块.

##### 创建一个虚拟环境
- code
    ```bash
        $ mkdir myproject
        $ cd myproject
        $ python3 -m venv venv
        $ . venv/bin/activate
    ```

#### 快速上手
- code
    ```bash
        $ cat hello.py
        from flask import Flask

        app = Flask(__name__)

        @app.route("/")
        def hello_world():
            return "<p>Hello, World!</p>"

        $ export FLASK_APP=hello
        $ flask run
        * Serving Flask app 'hello' (lazy loading)
        * Environment: production
        * Debug mode: off
        * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
    ```
- code2
    ```bash
        $ cat hello1.py
        from flask import Flask

        app = Flask(__name__)


        @app.route("/")
        def hello_world():
            return "<p>Hello, World!</p>"


        if __name__ == "__main__":
            app.run(debug=True)

        $ python3 hello1.py
        * Serving Flask app 'hello1' (lazy loading)
        * Environment: production
        * Debug mode: on
        * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
        * Restarting with stat
        * Debugger is active!
        * Debugger PIN: 100-834-711
    ```

#### app.run分析
- run源码
    ```python
        def run(self, host=None, port=None, debug=None, **options):
            """
            host: 默认为127.0.0.1, 只允许本机访问, 若需要其他人访问, 可设置为0.0.0.0
            port: web服务启动端口号, 默认5000
            debug: 是否开启调试模式
            """
            from werkzeug.serving import run_simple
            if host is None:
                host = '127.0.0.1'
            if port is None:
                server_name = self.config['SERVER_NAME']
                if server_name and ':' in server_name:
                    port = int(server_name.rsplit(':', 1)[1])
                else:
                    port = 5000
            if debug is not None:
                self.debug = bool(debug)
            options.setdefault('use_reloader', self.debug)
            options.setdefault('use_debugger', self.debug)
            try:
                run_simple(host, port, self, **options)
            finally:
                # reset the first request information if the development server
                # reset normally.  This makes it possible to restart the server
                # without reloader and that stuff from an interactive shell.
                self._got_first_request = False
    ```
- run_simple源码
    ```python
        def run_simple(
            hostname,
            port,
            application,
            use_reloader=False,
            use_debugger=False,
            use_evalex=True,
            extra_files=None,
            reloader_interval=1,
            reloader_type="auto",
            threaded=False,
            processes=1,
            request_handler=None,
            static_files=None,
            passthrough_errors=False,
            ssl_context=None,
        ):
            """
            .....................
            """
            def inner():
                try:
                    fd = int(os.environ["WERKZEUG_SERVER_FD"])
                except (LookupError, ValueError):
                    fd = None
                srv = make_server(
                    hostname,
                    port,
                    application,
                    threaded,
                    processes,
                    request_handler,
                    passthrough_errors,
                    ssl_context,
                    fd=fd,
                )#第二步        if fd is None:
                    log_startup(srv.socket)
                srv.serve_forever() #第三步
        　　if use_reloader:
                # If we're not running already in the subprocess that is the
                # reloader we want to open up a socket early to make sure the
                # port is actually available.
                if not is_running_from_reloader():
                    if port == 0 and not can_open_by_fd:
                        raise ValueError(
                            "Cannot bind to a random port with enabled "
                            "reloader if the Python interpreter does "
                            "not support socket opening by fd."
                        )

                    # Create and destroy a socket so that any exceptions are
                    # raised before we spawn a separate Python interpreter and
                    # lose this ability.
                    address_family = select_address_family(hostname, port)
                    server_address = get_sockaddr(hostname, port, address_family)
                    s = socket.socket(address_family, socket.SOCK_STREAM)
                    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                    s.bind(server_address)
                    if hasattr(s, "set_inheritable"):
                        s.set_inheritable(True)

                    # If we can open the socket by file descriptor, then we can just
                    # reuse this one and our socket will survive the restarts.
                    if can_open_by_fd:
                        os.environ["WERKZEUG_SERVER_FD"] = str(s.fileno())
                        s.listen(LISTEN_QUEUE)
                        log_startup(s)
                    else:
                        s.close()
                        if address_family == af_unix:
                            _log("info", "Unlinking %s" % server_address)
                            os.unlink(server_address)

                # Do not use relative imports, otherwise "python -m werkzeug.serving"
                # breaks.
                from ._reloader import run_with_reloader

                run_with_reloader(inner, extra_files, reloader_interval, reloader_type)
            else:
                inner() # 第一步
    ```

#### app.config分析

在很多情况下, 你需要设置程序的某些行为, 这时你就需要使用配置变量.在Flask中, 配置变量就是一些大写形式的Python变量, 

你也可以称之为配置参数或配置键.使用统一的配置变量可以避免在程序中以硬编码的形式设置程序.

在一个项目中, 你会用到许多配置, Flask提供的配置, 扩展(比如flask-sqlalchemy,flask-mail)提供的配置, 还有程序特定的配置.

和平时使用的变量不同, 这些配置变量都通过Flask对象的app.config属性作为统一的接口来设置和获取, 它指向的Config类实际上是字典的的子类, 

所以你可以像操作其它字典一样操作它. 

- eg
    ```python
        from flask import Flask
        app=Flask(__name__)

        print(type(app.config))
        <class 'flask.config.Config'>#app.config的类型

        print(app.config)#app.config 以键值对的形式 保存app的配置信息
        <Config {'ENV': 'production', 'DEBUG': False, 'TESTING': False, 'PROPAGATE_EXCEPTIONS': None, 'PRESERVE_CONTEXT_ON_EXCEPTION': None, 'SECRET_KEY': None, 'PERMANENT_SESSION_LIFETIME': datetime.timedelta(days=31), 'USE_X_SENDFILE': False, 'SERVER_NAME': None, 'APPLICATION_ROOT': '/', 'SESSION_COOKIE_NAME': 'session', 'SESSION_COOKIE_DOMAIN': None, 'SESSION_COOKIE_PATH': None, 'SESSION_COOKIE_HTTPONLY': True, 'SESSION_COOKIE_SECURE': False, 'SESSION_COOKIE_SAMESITE': None, 'SESSION_REFRESH_EACH_REQUEST': True, 'MAX_CONTENT_LENGTH': None, 'SEND_FILE_MAX_AGE_DEFAULT': None, 'TRAP_BAD_REQUEST_ERRORS': None, 'TRAP_HTTP_EXCEPTIONS': False, 'EXPLAIN_TEMPLATE_LOADING': False, 'PREFERRED_URL_SCHEME': 'http', 'JSON_AS_ASCII': True, 'JSON_SORT_KEYS': True, 'JSONIFY_PRETTYPRINT_REGULAR': False, 'JSONIFY_MIMETYPE': 'application/json', 'TEMPLATES_AUTO_RELOAD': None, 'MAX_COOKIE_SIZE': 4093}>


        app.config['ADMIN_NAME']='llllljian'
        print(app.config["ADMIN_NAME"])

        print(app.config)#app.config 以键值对的形式 保存app的配置信息
        <Config {'ENV': 'production', 'DEBUG': False, 'TESTING': False, 'PROPAGATE_EXCEPTIONS': None, 'PRESERVE_CONTEXT_ON_EXCEPTION': None, 'SECRET_KEY': None, 'PERMANENT_SESSION_LIFETIME': datetime.timedelta(days=31), 'USE_X_SENDFILE': False, 'SERVER_NAME': None, 'APPLICATION_ROOT': '/', 'SESSION_COOKIE_NAME': 'session', 'SESSION_COOKIE_DOMAIN': None, 'SESSION_COOKIE_PATH': None, 'SESSION_COOKIE_HTTPONLY': True, 'SESSION_COOKIE_SECURE': False, 'SESSION_COOKIE_SAMESITE': None, 'SESSION_REFRESH_EACH_REQUEST': True, 'MAX_CONTENT_LENGTH': None, 'SEND_FILE_MAX_AGE_DEFAULT': None, 'TRAP_BAD_REQUEST_ERRORS': None, 'TRAP_HTTP_EXCEPTIONS': False, 'EXPLAIN_TEMPLATE_LOADING': False, 'PREFERRED_URL_SCHEME': 'http', 'JSON_AS_ASCII': True, 'JSON_SORT_KEYS': True, 'JSONIFY_PRETTYPRINT_REGULAR': False, 'JSONIFY_MIMETYPE': 'application/json', 'TEMPLATES_AUTO_RELOAD': None, 'MAX_COOKIE_SIZE': 4093, 'ADMIN_NAME': 'llllljian'}>
    ```
- 修改配置
    * demo1
        ```python
            # 通过 键值对 配置app.config
            from flask import Flask
            app = Flask(__name__)
            print('配置前',app.config.get('FLASK_ENV'))
            #使用键值对配置app环境变量
            app.config['FLASK_ENV']='ABC'
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------
            配置前 None
            配置后 ABC
        ```
    * demo2
        ```python
            # 使用update()方法可以一次加载多个值
            from flask import Flask
            app = Flask(__name__)

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 update()方法可以一次加载多个值
            app.config.update(
                FLASK_ENV='ABC',
                AAAA=123456
            )
            print('配置后',app.config.get('FLASK_ENV'))
            print('配置后',app.config.get('AAAA'))

            #------运行结果----------------
            配置前 None
            配置后 ABC
            配置后 123456
        ```
    * demo3
        ```python
            # settings.json文件内容
            {
                "FLASK_ENV":"json"
            }
            # 通过 json文件 配置app.config:app.config.from_json
            from flask import Flask
            app =Flask(__name__)

            import os
            basedir = os.path.abspath(os.path.dirname(__file__))
            jsondir =os.path.join(basedir,'settings.json')

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 json文件 配置app环境变量
            app.config.from_json(jsondir)
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------

            配置前 None
            配置后 json
        ```
    * demo4
        ```python
            # 通过 字典 配置app.config: app.config.from_mapping
            from flask import Flask
            app = Flask(__name__)

            configDict={
            'FLASK_ENV':'dictConfig'
            }

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 json文件 配置app环境变量
            app.config.from_mapping(configDict)
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------
            配置前 None
            配置后 dictConfig
        ```
    * demo5
        ```python
            # settings.py
            # py文件中的变量名将作为 app.config配置的key, 变量值作为app.config[key]的value
            FLASK_ENV='pyConfig'
            # 通过 python文件 配置app.config
            from flask import Flask
            app = Flask(__name__)

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 json文件 配置app环境变量
            app.config.from_pyfile('settings.py')
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------
            配置前 None
            配置后 pyConfig
        ```
    * demo6
        ```python
            # classConfig.py
            # 类中的属性作为 app.config的key, 类中的属性值作为app.config[key]的value
            class BaseConfig(object):
                FLASK_ENV='objectConfig'

            # 通过 配置类 配置app.config
            from flask import Flask
            app = Flask(__name__)

            from demoConfig.classConfig import BaseConfig
            objConfig=BaseConfig()

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 json文件 配置app环境变量
            app.config.from_object(objConfig)
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------
            配置前 None
            配置后 objectConfig
        ```
    * demo7
        ```python
            # from_object可以接收类或者模块
            # conf/config.py
            # py文件中的变量名将作为 app.config配置的key, 变量值作为app.config[key]的value
            FLASK_ENV='moduleConfig'

            # 通过 配置类 配置app.config
            from flask import Flask
            app = Flask(__name__)

            print('配置前',app.config.get('FLASK_ENV'))
            #使用 json文件 配置app环境变量
            app.config.from_object('conf.config')
            print('配置后',app.config.get('FLASK_ENV'))

            #------运行结果----------------
            配置前 None
            配置后 moduleConfig
        ```


