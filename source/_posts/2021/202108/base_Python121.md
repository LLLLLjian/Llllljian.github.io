---
title: Python_基础 (121)
date: 2021-08-30
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### 路由app.route
- 示例代码
    ```python
        from flask import Flask

        app = Flask(__name__)

        @app.route('/index')
        def index():
            return 'hello world
    ```
- 路由加载源码分析
    * 先执行route函数
        ```python
            def route(self, rule, **options):
                def decorator(f):
                    endpoint = options.pop("endpoint", None)
                    self.add_url_rule(rule, endpoint, f, **options)
                    return f
                return decorator
        ```
    * 执行add_url_rule函数
        ```python
            def add_url_rule(
                self,
                rule,
                endpoint=None,
                view_func=None,
                provide_automatic_options=None,
                **options
            ):
                if endpoint is None:
                    endpoint = _endpoint_from_view_func(view_func)
                    options["endpoint"] = endpoint
                    methods = options.pop("methods", None)

                    if methods is None:
                        methods = getattr(view_func, "methods", None) or ("GET",)

                        rule = self.url_rule_class(rule, methods=methods, **options)

                        self.url_map.add(rule)
                        if view_func is not None:
                            self.view_functions[endpoint] = view_func
        ```
    * 过程分析
        * 将 url = /index 和 默认的请求方式 [ GET ]封装到Rule对象
        * 将Rule对象添加到 app.url_map中.
        * 把endpoint和函数的对应关系放到 app.view_functions中.
        * 当一个请求过来时, 先拿路由在app.url_map找对应的别名, 再在app.view_functions中找到别名对应的视图函数
- 变量规则
    * 通过把 URL 的一部分标记为 <variable_name> 就可以在 URL 中添加变量.标记的 部分会作为关键字参数传递给函数.通过使用 <converter:variable_name> , 可以 选择性的加上一个转换器, 为变量指定规则
    * eg
        ```python
            # escape()可以手动转义
            from markupsafe import escape

            @app.route('/user/<username>')
            def show_user_profile(username):
                # show the user profile for that user
                return f'User {escape(username)}'

            @app.route('/post/<int:post_id>')
            def show_post(post_id):
                # show the post with the given id, the id is an integer
                return f'Post {post_id}'

            @app.route('/path/<path:subpath>')
            def show_subpath(subpath):
                # show the subpath after /path/
                return f'Subpath {escape(subpath)}'
        ```
    * 转换器类型
        <table><tbody><tr><td><p><code class="docutils literal notranslate"><span class="pre">string</span></code></p></td><td><p>(缺省值) 接受任何不包含斜杠的文本</p></td></tr><tr class="row-even"><td><p><code class="docutils literal notranslate"><span class="pre">int</span></code></p></td><td><p>接受正整数</p></td></tr><tr class="row-odd"><td><p><code class="docutils literal notranslate"><span class="pre">float</span></code></p></td><td><p>接受正浮点数</p></td></tr><tr class="row-even"><td><p><code class="docutils literal notranslate"><span class="pre">path</span></code></p></td><td><p>类似<code class="docutils literal notranslate"><span class="pre">string</span></code> , 但可以包含斜杠</p></td></tr><tr class="row-odd"><td><p><code class="docutils literal notranslate"><span class="pre">uuid</span></code></p></td><td><p>接受 UUID 字符串</p></td></tr></tbody></table>
- 唯一的URL/重定向行为
    ```python
        # 访问/projects时, flask会自动进行重定向, 在尾部加上一个斜杠进行跳转/projects/
        # 127.0.0.1 - - [30/Aug/2021 21:38:56] "GET /projects HTTP/1.1" 308 -
        # 127.0.0.1 - - [30/Aug/2021 21:38:56] "GET /projects/ HTTP/1.1" 200 -
        @app.route('/projects/')
        def projects():
            return 'The project page'

        # /about会正常返回200, 但是访问/about/会直接404
        # 127.0.0.1 - - [30/Aug/2021 21:39:17] "GET /about HTTP/1.1" 200 -
        # 127.0.0.1 - - [30/Aug/2021 21:39:20] "GET /about/ HTTP/1.1" 404 -
        @app.route('/about')
        def about():
            return 'The about page'
    ```
- URL构建
    * url_for() 函数用于构建指定函数的 URL.它把函数名称作为第一个 参数.它可以接受任意个关键字参数, 每个关键字参数对应 URL 中的变量.未知变量 将添加到 URL 中作为查询参数.
    * 为什么不在把 URL 写死在模板中, 而要使用反转函数 url_for() 动态构建
        * 反转通常比硬编码 URL 的描述性更好.
        * 您可以只在一个地方改变 URL , 而不用到处乱找.
        * URL 创建会为您处理特殊字符的转义, 比较直观.
        * 生产的路径总是绝对路径, 可以避免相对路径产生副作用.
        * 如果您的应用是放在 URL 根路径之外的地方(如在 /myapplication 中, 不在 / 中),  url_for() 会为您妥善处理.
    * eg1
        ```python
            # 为动态路由传参
            # front
            <td>
                <a target="_blank" href="{{ url_for("front.post_detail",post_id=post.id) }}">
                    {{ post.title }}
                </a>
            </td>
            # backend
            @bp.route('/p/<post_id>/')
            def post_detail(post_id):
                post = PostModel.query.get(post_id)
                if not post:
                    abort(404)
                return render_template('front/front_pdetail.html',post=post)
        ```
    * eg2
        ```python
            # backend, 当_external为True时返回url绝对路径,否则返回相对路径
            url_for('static',filename='css/styles.css',_external=True)
            # 输出结果 http://localhost:5000/static/css/styles.css
            # front
            <link rel="stylesheet" href="{{ url_for('static',filename='assets/vendor/linearicons/style.css') }}">
        ```

#### 困扰
> 上述都是app.route, 那就以为着所有的路由都要写在启动文件中, 那维护起来也太呆瓜了. 所以就需要引入蓝图的概念

#### 蓝图Blueprint
- what
    * 用于实现单个应用的视图、模板、静态文件的集合.
    * 蓝图就是模块化处理的类.类似于django中app, 子应用.
    * 简单来说, 蓝图就是一个存储操作路由映射方法的容器, 主要用来实现客户端请求和URL相互关联的功能. 在Flask中, 使用蓝图可以帮助我们实现模块化应用的功能.
    * flask中, 将项目模块化, blueprint, 是flask自带的一种开发模式, 目的是为了方便开发大型的项目
- why
    * 可以把蓝图理解为模块划分的一个手段, 通过蓝图可以把不同功能的路由统一注册到启动文件中,  方便后期维护及开发
- where
    * func1
        * users/\__init__.py
        * users目录下的__init__.py文件中, 整个目录中的文件统一使用这一个蓝图
    * func2
        * user_view.py
        * 用户相关视图文件中创建一个蓝图, 专供这个文件使用
- attribute
    * 一个项目可以具有多个Blueprint
    * 可以将一个Blueprint注册到任何一个未使用的URL下比如 “/”、“/sample”或者子域名
    * 在一个应用中, 一个模块可以注册多次
    * Blueprint可以单独具有自己的模板、静态文件或者其它的通用操作方法, 它并不是必须要实现应用的视图和函数的
    * 在一个应用初始化时, 就应该要注册需要使用的Blueprint
- how
    * 方式1
        * views/\__init__.py
            ```python
                from flask import Blueprint

                # 创建了一个名称为'auth'的Blueprint.和应用对象一样, 蓝图需要知道
                # 是在哪里定义的, 因此把__name__作为函数的第二个参数, url_prefix会添加到所有与该蓝图关联的URL前面
                bp = Blueprint('auth', __name__, url_prefix='/auth')
                # 在脚本的末尾导入是为了避免循环导入依赖
                from . import auth
            ```
        * views/auth.py
            ```python
                from views import bp

                # @bp.route关联了/auth/hello
                @bp.route('/hello')
                def hello():
                    return "hello auth"
            ```
        * manage.py
            ```python
                from flask import Flask
                from views import auth

                app = Flask(__name__)
                app.register_blueprint(auth.bp)

                if __name__ == "__main__":
                    app.run()
            ```
    * 方式2
        * user_view.py
            ```python
                from flask import Blueprint

                user_route = Blueprint('user', __name__)


                @user_route.route('/user/hello')
                def hello():
                    return "/user/hello"


                @user_route.route('/user/new')
                def new():
                    return "/user/new"


                @user_route.route('/user/edit')
                def edit():
                    return "/user/edit"
            ```
        * admin_view.py
            ```python
                from flask import Blueprint

                admin_route = Blueprint('admin', __name__)


                @admin_route.route('/hello')
                def hello():
                    return "/admin/hello"


                @admin_route.route('/new')
                def new():
                    return "/admin/new"


                @admin_route.route('/edit')
                def edit():
                    return "/admin/edit"
            ```
        * manage.py
            ```python
                from flask import Flask
                from user_view import user_route
                from admin_view import admin_route

                app = Flask(__name__)
                # 注册蓝图
                app.register_blueprint(user_route)
                app.register_blueprint(admin_route, url_prefix='/admin')

                @app.route('/')
                def index():
                    return "index"

                @app.route('/list')
                def list():
                    return "list"

                if __name__ == '__main__':
                    print(app.url_map)
                    # 输出结果
                    # Map(
                    #     [
                    #         <Rule '路由' (HEAD, OPTIONS, GET) -> 蓝图的第一个参数.方法名>,
                    #         <Rule '/admin/hello' (HEAD, OPTIONS, GET) -> admin.hello>,
                    #         <Rule '/admin/edit' (HEAD, OPTIONS, GET) -> admin.edit>,
                    #         <Rule '/admin/new' (HEAD, OPTIONS, GET) -> admin.new>,
                    #         <Rule '/user/hello' (HEAD, OPTIONS, GET) -> user.hello>,
                    #         <Rule '/user/edit' (HEAD, OPTIONS, GET) -> user.edit>,
                    #         <Rule '/user/new' (HEAD, OPTIONS, GET) -> user.new>,
                    #         <Rule '/list' (HEAD, OPTIONS, GET) -> list>,
                    #         <Rule '/' (HEAD, OPTIONS, GET) -> index>,
                    #         <Rule '/static/<filename>' (HEAD, OPTIONS, GET) -> static>
                    #     ]
                    # )
                    app.run()
            ```
        * 请求地址及结果
            * http://127.0.0.1:5000/ => index
            * http://127.0.0.1:5000/user/hello => /user/hello
            * http://127.0.0.1:5000/admin/hello => /admin/hello

