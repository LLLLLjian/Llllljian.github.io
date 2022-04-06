---
title: Python_基础 (120)
date: 2021-08-27
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### session处理机制

##### 前言
> flask_session是flask框架实现session功能的一个插件, 用来替代flask自带的session实现机制, flask默认的session信息保存在cookie中, 不够安全和灵活.

##### flask的session机制
> session是用来干什么的呢？由于http协议是一个无状态的协议, 也就是说同一个用户第一次请求和第二次请求是完全没有关系的, 但是现在的网站基本上有登录使用的功能, 这就要求必须实现有状态, 而session机制实现的就是这个功能.
- 实现的原理
    * 用户第一次请求后, 将产生的状态信息保存在session中, 这时可以把session当做一个容器, 它保存了正在使用的所有用户的状态信息；这段状态信息分配了一个唯一的标识符用来标识用户的身份, 将其保存在响应对象的cookie中；当第二次请求时, 解析cookie中的标识符, 拿到标识符后去session找到对应的用户的信息.
- 简单使用
    ```python
        from flask import Flask,session
        app = Flask(__name__)
        @app.route('/test1/')
        def test():
            session.setdefault('name', 'xiaoming')
            return 'OK'
        if __name__ == '__main__':
            app.run(port=5000, debug=True)
    ```
- session源码分析
    ```python
        def open_session(self, request):
            # 调用了app的session_interface对象的方法
            return self.session_interface.open_session(self, request)

        def save_session(self, session, response):
            return self.session_interface.save_session(self, session, response)

        class SecureCookieSessionInterface(SessionInterface):
            pass

            def open_session(self, app, request):
                # 检测是否设置了secret_key参数, 返回一个签名对象
                s = self.get_signing_serializer(app)
                if s is None:
                    return None
                # 去cookie中获取session信息
                val = request.cookies.get(app.session_cookie_name)
                # 如果是第一次请求, 返回一个空的SecureCookieSession对象, 会被交给请求上下文的session属性管理
                if not val:
                    return self.session_class()
                # 获取session的失效时间
                max_age = total_seconds(app.permanent_session_lifetime)
                try:
                    # 对session信息进行解码得到用户信息
                    data = s.loads(val, max_age=max_age)
                    # 返回有用户信息的session对象
                    return self.session_class(data)
                except BadSignature:
                    return self.session_class()

            def save_session(self, app, session, response):
                # 获取cookie设置的域
                domain = self.get_cookie_domain(app)
                # 获取cookie设置的路径
                path = self.get_cookie_path(app)
                ...

                # 检测SESSION_REFRESH_EACH_REQUEST参数配置
                if not self.should_set_cookie(app, session):
                    return
                # 返回SESSION_COOKIE_HTTPONLY参数配置
                httponly = self.get_cookie_httponly(app)
                # 返回SESSION_COOKIE_SECURE参数配置
                secure = self.get_cookie_secure(app)
                # 返回失效的时间点
                expires = self.get_expiration_time(app, session)
                #将用户的数据加密
                val = self.get_signing_serializer(app).dumps(dict(session))
                # 设置cookie
                response.set_cookie(app.session_cookie_name, val,
                                    expires=expires, httponly=httponly,
                                    domain=domain, path=path, secure=secure)
    ```
- 相关配置参数
    * SESSION_COOKIE_NAME:设置返回给客户端的cookie的名称, 默认是“session”;放置在response的头部；
    * SESSION_COOKIE_DOMAIN:设置会话的域, 默认是当前的服务器, 因为Session是一个全局的变量, 可能应用在多个app中；
    * SESSION_COOKIE_PATH:设置会话的路径, 即哪些路由下应该设置cookie, 如果不设置, 那么默认为‘/’, 所有的路由都会设置cookie；这个参数和SESSION_COOKIE_DOMAIN是互斥的
    * SERVER_NAME:设置服务器的名字, 一般不用；
    * SESSION_COOKIE_SECURE: 如果 cookie 标记为“ secure ”, 那么浏览器只会使用基于 HTTPS 的请求发 送 cookie, 应用必须使用 HTTPS 服务来启用本变量, 默认False
    * APPLICATION_ROOT: 设置应用的根路径；
    * SESSION_REFRESH_EACH_REQUEST:是否应该为每一个请求设置cookie, 默认为True, 如果为False则必须显性调用set_cookie函数；
    * SESSION_COOKIE_HTTPONLY: cookie应该和httponly标志一起设置, 默认为True, 这个一般采用默认.
    * PERMANENT_SESSION_LIFETIME: 设置session的有效期, 即cookie的失效时间, 单位是s.这个参数很重要, 因为默认会话是永久性的.
    * SESSION_COOKIE_HTTPONLY: 默认为true, 表示允许js脚本访问cookie；

##### 自定义session存储
> 通过分析flask的session实现机制, 一般认为将session信息放在cookie中不够保险, 那么我们可以实现自己的session机制, 思路是创建一个类继承SessionInterface, 然后重写open_session方法和save_session方法, 再使用我们的类替换app的session_interface属性即可.
- 创建自己的SessionInterface的子类
    ```python
        from flask.sessions import *
        try:
            import cPickle as pickle
        except ImportError:
            import pickle

        import json
        from uuid import uuid4
        import time

        # 我们需要自定义一个Session对象用来存储用户的信息, 它使用一个唯一的id标识, 模仿SecureCookieSession的实现方法
        class SecureFileSession(CallbackDict, SessionMixin):
            def __init__(self, initial=None, sid=None, permanent=None):
                def on_update(self):
                    self.modified = True
                CallbackDict.__init__(self, initial, on_update)
                self.sid = sid  # session的标识
                if permanent:
                    self.permanent = permanent  # 失效时间
                self.modified = False

        # 我们使用uuid作为签名, 省略校验过程
        class NewSessionInterface(SessionInterface):

            def _generate_sid(self):
                return str(uuid4())

        class JsonFileSessionInterface(NewSessionInterface):
            # 用来序列化的包
            serializer = pickle
            session_class = SecureFileSession

            def __init__(self, app=None):
                self.app = app
                if app is not None:
                    self.init_app(app)

            def init_app(self, app):
                """
                替换app的session_interface属性
                :param app:
                :return:
                """
                app.session_interface = self._get_interface(app)

            def _get_interface(self, app):
                """
                加载配置参数返回本身,必须配置'SESSION_TYPE'和'MY_SESSION_PATH'参数, 否则使用默认的session
                :param app:
                :return:
                """
                config = app.config.copy()
                if config['SESSION_TYPE'] == 'file':
                    if not config['MY_SESSION_PATH']:
                        return SecureCookieSessionInterface()
                    self.path = app.static_folder + config['MY_SESSION_PATH']  # session文件路径
                    self.permanent = total_seconds(app.permanent_session_lifetime)  # 失效时间
                    return self
                return SecureCookieSessionInterface()

            def open_session(self, app, request):
                """
                从文件中获取session数据
                :param app:
                :param request:
                :return:
                """
                # 获取session签名
                sid = request.cookies.get(app.session_cookie_name)
                permanent = int(time.time()) + self.permanent
                # 如果没有说明是第一次访问, 返回空session对象
                if not sid:
                    # 获取一个uuid
                    sid = self._generate_sid()
                    return self.session_class(sid=sid, permanent=permanent)

                with open(self.path, 'r', encoding='utf-8') as f:
                    v = f.read()
                    # 如果session为空, 返回空session对象
                    if not v:
                        return self.session_class(sid=sid, permanent=permanent)
                    try:
                        val = json.loads(v)
                    except ValueError as e:
                        print('配置参数错误: {}'.format(e))
                        return self.session_class(sid=sid, permanent=permanent)
                    else:
                        self.val = val
                        # 通过sid获取信息
                        data = val.get(sid)
                        if not data:
                            return self.session_class(sid=sid, permanent=permanent)
                        # 判断以前的信息是否超时
                        if permanent - int(data['permanent']) > self.permanent:
                            return self.session_class(sid=sid, permanent=permanent)
                        return self.session_class(data, sid=sid)

            def save_session(self, app, session, response):
                """
                保存session信息
                :param app:
                :param session:
                :param response:
                :return:
                """
                # 前面借鉴flask默认的实现方式
                domain = self.get_cookie_domain(app)
                path = self.get_cookie_path(app)
                if not session:
                    if session.modified:
                        response.delete_cookie(app.session_cookie_name,
                                            domain=domain, path=path)
                    return
                if not self.should_set_cookie(app, session):
                    return
                httponly = self.get_cookie_httponly(app)
                secure = self.get_cookie_secure(app)
                expires = self.get_expiration_time(app, session)

                # 将session信息保存在文件中
                session.update({'permanent': int(time.time()) + self.permanent})
                if hasattr(self, 'val') and isinstance(self.val, dict):
                    self.val.update({session.sid: dict(session)})
                else:
                    self.val = {session.sid: dict(session)}

                with open(self.path, 'w', encoding='utf-8') as f:
                    result = json.dumps(self.val)
                    f.write(result)
                    response.set_cookie(app.session_cookie_name, session.sid,
                                        expires=expires, httponly=httponly,
                                        domain=domain, path=path, secure=secure)
    ```
- 初始化替换app的session_interface
    ```python
        app = Flask(__name__,template_folder='static/html')
        app.config.update({
            'SECRET_KEY':'123',
            'SESSION_USE_SIGNER':True,
            'SESSION_TYPE':'file',
            'MY_SESSION_PATH':'\session.json'
        })
        from session_file import JsonFileSessionInterface
        se = JsonFileSessionInterface(app=app)
        if __name__ == '__main__':
            app.run(host='127.0.0.1', port=5000, debug=True)
    ```

##### flask_session扩展
> flask_session插件就是官方推荐的session实现插件, 整合了redis,memcached,mysql, file,mongodb等多种第三方存储session信息,它的实现原理就是我上面自定义session所做的工作.
- 安装
    ```bash
        $ pip install Flask-Session
    ```
- cookie
    ```python
        # 采用flask默认的保存在cookie中
        SESSION_TYPE = 'null'
    ```
- redis
    ```python
        # 指明对session数据进行保护
        SECRET_KEY = '123'
        # 是否为cookie设置签名来保护数据不被更改, 默认是False；如果设置True,那么必须设置flask的secret_key参数
        SESSION_USE_SIGNER = True  
        # 指明保存到redis中
        SESSION_TYPE = "redis"
        # 连接哪个redis, 其是一个连接对象；如果不设置的话, 默认连接127.0.0.1:6379/0
        SESSION_REDIS = redis.StrictRedis(host="127.0.0.1", port=6390, db=4)
        # session的有效期, 单位: 秒
        PERMANENT_SESSION_LIFETIME = 7200
        # session存储时的键的前缀
        SESSION_KEY_PREFIX = 'redis:'
    ```
- memcached
    ```python
        #!/usr/bin/env python
        # -*- coding:utf-8 -
        from flask import Flask, session
        from flask_session import Session
        import memcache

        app = Flask(__name__)
        app.debug = True
        app.secret_key = 'xxxx'
          
        app.config['SESSION_TYPE'] = 'memcached' # session类型为memcached
        app.config['SESSION_PERMANENT'] = True # 如果设置为True, 则关闭浏览器session就失效.
        app.config['SESSION_USE_SIGNER'] = False # 是否对发送到浏览器上session的cookie值进行加密
        app.config['SESSION_KEY_PREFIX'] = 'memcached:' # 保存到session中的值的前缀
        app.config['SESSION_MEMCACHED'] = memcache.Client(['127.0.0.1:12000'])
        Session(app) 

        @app.route('/index')
        def index():
            session['k1'] = 'v1'
            return 'xx'

        if __name__ == '__main__':
            app.run()
    ```
- filesystem
    ```python
        #!/usr/bin/env python
        # -*- coding:utf-8 -
        from flask import Flask, session
        from flask_session import Session
        
        app = Flask(__name__)
        app.debug = True
        app.secret_key = 'xxxx'
  
        app.config['SESSION_TYPE'] = 'filesystem' # session类型为filesystem
        app.config['SESSION_FILE_DIR'] = '/home/work/flask-session' # session文件存放位置
        app.config['SESSION_FILE_THRESHOLD'] = 500 # 存储session的个数如果大于这个值时, 就要开始进行删除了
        app.config['SESSION_FILE_MODE'] = 384 # 文件权限类型
        app.config['SESSION_PERMANENT'] = True # 如果设置为True, 则关闭浏览器session就失效.
        app.config['SESSION_USE_SIGNER'] = False # 是否对发送到浏览器上session的cookie值进行加密
        app.config['SESSION_KEY_PREFIX'] = 'filesystem:' # 保存到session中的值的前缀
        Session(app)

        @app.route('/index')
        def index():
            session['k1'] = 'v1'
            session['k2'] = 'v1'
            return 'xx'
        
        if __name__ == '__main__':
            app.run() 
    ```
- mongodb
    ```python
        #!/usr/bin/env python
        # -*- coding:utf-8 -
        from flask import Flask, session
        from flask_session import Session
        import pymongo
        app = Flask(__name__)
        app.debug = True
        app.secret_key = 'xxxx'
        # session类型为mongodb
        app.config['SESSION_TYPE'] = 'mongodb'
        # mongodb客户端
        app.config['SESSION_MONGODB'] = pymongo.MongoClient()
        # mongo的db名称(数据库名称)
        app.config['SESSION_MONGODB_DB'] = 'blog'
        # mongo的collect名称(表名称)
        app.config['SESSION_MONGODB_COLLECT'] = 'session'
        # 如果设置为True, 则关闭浏览器session就失效.
        app.config['SESSION_PERMANENT'] = True
        # 是否对发送到浏览器上session的cookie值进行加密
        app.config['SESSION_USE_SIGNER'] = False
        # 保存到session中的值的前缀
        app.config['SESSION_KEY_PREFIX'] = 'mongodb:'
        Session(app)
  
        @app.route('/index')
        def index():
            session['k1'] = 'v1'
            session['k2'] = 'v1'
            return 'xx'
        
        if __name__ == '__main__':
            app.run()
    ```
- sqlalchemy
    ```python
        #!/usr/bin/env python
        # -*- coding:utf-8 -
        from flask import Flask, session
        from flask_session import Session
        from flask_sqlalchemy import SQLAlchemy
        app = Flask(__name__)
        app.debug = True
        app.secret_key = 'xxxx'
        # 设置数据库链接 
        # 数据类型://登录账号:登录密码@数据库主机IP:数据库访问端口/数据库名称
        app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:123@127.0.0.1:3306/fssa?charset=utf8'
        # 设置mysql的错误跟踪信息显示
        app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
        # 打印每次模型操作对应的SQL语句
        app.config['SQLALCHEMY_ECHO'] = True
        # 实例化SQLAlchemy
        db = SQLAlchemy(app)
        # session类型为sqlalchemy
        app.config['SESSION_TYPE'] = 'sqlalchemy'
        # SQLAlchemy对象
        app.config['SESSION_SQLALCHEMY'] = db
        # session要保存的表名称
        app.config['SESSION_SQLALCHEMY_TABLE'] = 'session'
        # 如果设置为True, 则关闭浏览器session就失效.
        app.config['SESSION_PERMANENT'] = True
        # 是否对发送到浏览器上session的cookie值进行加密
        app.config['SESSION_USE_SIGNER'] = False
        # 保存到session中的值的前缀
        app.config['SESSION_KEY_PREFIX'] = 'mysql:'
        Session(app)
  
        @app.route('/index')
        def index():
            session['k1'] = 'v1'
            session['k2'] = 'v1'
            return 'xx'
        
        if __name__ == '__main__':
            app.run()

        # 建表语句
        # python3
        # from app import db
        # db.create_all()
    ```

