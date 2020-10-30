---
title: Python_基础 (41)
date: 2020-10-27
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    快来跟我一起学Django！！！

<!-- more -->

#### Django 如何处理一个请求
- 当一个用户请求Django 站点的一个页面，下面是Django 系统决定执行哪个Python 代码使用的算法：
    * Django 确定使用根 URLconf 模块。通常，这是 ROOT_URLCONF 设置的值，但如果传入 HttpRequest 对象拥有 urlconf 属性（通过中间件设置），它的值将被用来代替 ROOT_URLCONF 设置。
    * Django 加载该 Python 模块并寻找可用的 urlpatterns 。它是 django.urls.path() 和(或) django.urls.re_path() 实例的序列(sequence)。
    * Django 会按顺序遍历每个 URL 模式，然后会在所请求的URL匹配到第一个模式后停止，并与 path_info 匹配。
    * 一旦有 URL 匹配成功，Djagno 导入并调用相关的视图，这个视图是一个Python 函数（或基于类的视图 class-based view ）。视图会获得如下参数：
        * 一个 HttpRequest 实例。
        * 如果匹配的 URL 包含未命名组，那么来自正则表达式中的匹配项将作为位置参数提供。
        * 关键字参数由路径表达式匹配的任何命名部分组成，并由 django.urls.path() 或 django.urls.re_path() 的可选 kwargs 参数中指定的任何参数覆盖。
        * 如果没有 URL 被匹配，或者匹配过程中出现了异常，Django 会调用一个适当的错误处理视图。参加下面的错误处理( Error handling )。

#### URL路由系统（URLconf）
- 概念
    > URL配置(URLconf)就像Django 所支撑网站的目录，它的本质是URL与要为该URL调用的视图函数之间的映射表；你就是以这种方式告诉Django，对于这个URL调用这段代码，对于那个URL调用那段代码
    ```bash
        urlpatterns = [
            url(正则表达式, views视图函数，参数，别名),
            re_path(正则表达式, views视图函数，参数，别名), （在2.0以上版本中使用re_path),
        ]
    ```
    * 参数说明
        <table class="relative-table wrapped confluenceTable tablesorter tablesorter-default" style="width: 100.0%;" role="grid"><colgroup><col style="width: 6.17181%;"><col style="width: 93.8282%;"></colgroup><thead><tr role="row" class="tablesorter-headerRow"><th class="confluenceTh tablesorter-header sortableHeader tablesorter-headerUnSorted" data-column="0" tabindex="0" scope="col" role="columnheader" aria-disabled="false" unselectable="on" aria-sort="none" aria-label="参数: No sort applied, activate to apply an ascending sort" style="user-select: none;"><div class="tablesorter-header-inner">参数</div></th><th class="confluenceTh tablesorter-header sortableHeader tablesorter-headerUnSorted" data-column="1" tabindex="0" scope="col" role="columnheader" aria-disabled="false" unselectable="on" aria-sort="none" aria-label="说明: No sort applied, activate to apply an ascending sort" style="user-select: none;"><div class="tablesorter-header-inner">说明</div></th></tr></thead><tbody aria-live="polite" aria-relevant="all"><tr role="row"><td class="confluenceTd">正则表达式</td><td class="confluenceTd"><p>regex是正则表达式的通用缩写，它是<span style="color: rgb(0,0,255);">一种匹配字符串或url地址的语法</span>。</p><p>Django拿着<span style="color: rgb(0,0,255);">用户请求的url地址，在urls.py文件中对urlpatterns列表中的每一项条目从头开始进行逐一对比，一旦遇到匹配项，立即执行该条目映射的视图函数或二级路由，其后的条目将不再继续匹配</span>。因此，url路由的编写顺序至关重要！</p><p>需要注意的是，<span style="color: rgb(0,0,255);">regex不会去匹配GET或POST参数或域名</span>，例如：https://www.example.com/myapp/，regex只尝试匹配myapp/。对于https://www.example.com/myapp/?page=3，regex也只尝试匹配myapp/。如果你想深入研究正则表达式，可以读一些相关的书籍或专论，但是在Django的实践中，你不需要多高深的正则表达式知识。</p><p><span style="color: rgb(0,0,0);"><strong>性能注释</strong>：<span style="color: rgb(0,0,0);">当URLconf模块加载的时候，</span>正则表达式会进行预先编译，因此它的匹配搜索速度非常快，你通常感觉不到</span></p></td></tr><tr role="row"><td class="confluenceTd">view视图函数</td><td class="confluenceTd"><p>当正则表达式匹配到某个条目时，<span style="color: rgb(0,0,255);">自动将封装的HttpRequest对象作为第一个参数，正则表达式“捕获”到的值作为第二个参数，传递给该条目指定的视图</span>。</p><p><strong>注</strong>：如果是简单捕获，那么捕获值将作为一个位置参数进行传递，如果是命名捕获，那么将作为关键字参数进行传递。</p></td></tr><tr role="row"><td class="confluenceTd">参数（kwargs）</td><td class="confluenceTd">任意数量的关键字参数可以作为一个字典传递给目标视图</td></tr><tr role="row"><td class="confluenceTd">别名name</td><td class="confluenceTd">对你的URL进行命名，可以让你能够在Django的任意处，尤其是模板内显式地引用它。相当于给URL取了个全局变量名，避免了高额的维护成本</td></tr></tbody></table>

#### Django中url与path及re_path区别
- url
    * django.conf.urls url
    * Django 1.x中的写法
    * 使用url也是可以的,为了简便起见,尽量使用符合版本的字段,另外在写路径时应该严格按照语法,比如'^' 和/$就不能缺,不能前面写url,括号里面确按照path的写法,这样很容易出错,到了关键时刻,很难定位问题点,很浪费时间.
- path
    * django.urls path
    * django2.x中的写法
- re_path
    * django.urls re_path
    * django2.x中的写法

#### 路由映射方式
1. 最基础映射
    * 简单来说就是硬性匹配，写的什么就去匹配什么，没有一点回旋余地
        ```python
            # urls.py

            from django.conf.urls import include, url
            from django.contrib import admin
            from app01 import views

            urlpatterns = [
                url(r'^admin/', admin.site.urls),
                url(r'^index/$', views.index), # http://127.0.0.1:8000/index 
            ]
        ```
2. 按照顺序放置的动态路由
    * 可以使用正则来匹配URL，将一组url使用一条映射搞定, 此参数的顺序严格按照url中匹配的顺序
        ```python
            # urls.py
            urlpatterns = [
                url(r'^host/(\d+)$', views.host), # http://127.0.0.1/host/2
                url(r'^host_list/(\d+)/(\d+)$', views.host_list), # http://127.0.0.1/host/8/9
            ]

            # view.py
            def user_list(request, id):
                return HttpResponse(id)

            def user_list(request, hid, hid2): 
                return HttpResponse(hid+hid2)
        ```
3. 传参形势的路由
    * 利用正则表达式的分组方法，将url以参数的形式传递到函数，可以不按顺序排列
        ```python
            # urls.py
            urlpatterns = [ 
                url(r'^user_list/(?P<v1>\d+)/(?P<v2>\d+)$',views.user_list), 
            ]

            # views.py
            def user_list(request,v2,v1):
                return HttpResponse(v1+v2)
        ```
4. 根据不同的app来分发不同的url(include方法)
    * 如果一个项目下有很多的app，那么在urls.py里面就要写巨多的urls映射关系。这样看起来很不灵活，而且杂乱无章。我们可以根据不同的app来分类不同的url请求
        ```python
            # urls.py
            from django.conf.urls import include, url
            from django.contrib import admin
            from app01 import app01_urls
            from app02 import app02_urls
            urlpatterns = [ 
                url(r'^app01/', include('app01.urls')), # 将url为”app01/“的请求都交给app01下的urls去处理
                url(r'^app02/', include('app02.urls')), 
            ]

            # app01/urls.py
            from django.conf.urls import include, url
            from app01 import views

            urlpatterns = [
                url(r'index/$', views.index), # http://127.0.0.1/app01/index/
            ]
        ```
5. 通过反射机制，为django开发一套动态的路由系统
    ```python
        # urls.py
        from django.conf.urls import patterns, include, url
        from django.contrib import admin
        from DynamicRouter.activator import process

        urlpatterns = patterns('',
            # Examples:
            # url(r'^$', 'DynamicRouter.views.home', name='home'),
            # url(r'^blog/', include('blog.urls')),

            url(r'^admin/', include(admin.site.urls)),
            
            
            ('^(?P<app>(\w+))/(?P<function>(\w+))/(?P<page>(\d+))/(?P<id>(\d+))/$',process),
            ('^(?P<app>(\w+))/(?P<function>(\w+))/(?P<id>(\d+))/$',process),
            ('^(?P<app>(\w+))/(?P<function>(\w+))/$',process),
            ('^(?P<app>(\w+))/$',process,{'function':'index'}),
        )

        # activater.py
        from django.shortcuts import render_to_response,HttpResponse,redirect

        def process(request,**kwargs):
            '''接收所有匹配url的请求，根据请求url中的参数，通过反射动态指定view中的方法'''
            
            app =  kwargs.get('app',None)
            function = kwargs.get('function',None)
            
            try:
                appObj = __import__("%s.views" %app)
                viewObj = getattr(appObj, 'views')
                funcObj = getattr(viewObj, function)
                
                #执行view.py中的函数，并获取其返回值
                result = funcObj(request,kwargs)
                
            except (ImportError,AttributeError),e:
                #导入失败时，自定义404错误
                return HttpResponse('404 Not Found')
            except Exception,e:
                #代码执行异常时，自动跳转到指定页面
                return redirect('/app01/index/')
            
            return result
    ```


#### 实例说明
    ```python
        urlpatterns = [
            # url
            url(r"^register",views.register,name="reg"),   # 127.0.0.1:8080/register  reg是URL别名,在模板中,例如<a href="{% url 'reg' %}"></a>
            url(r'^admin/', admin.site.urls),
            url(r'^index/$', views.index),

            url(r'^articles/2003/$', views.special_case_2003),
            url(r'^articles/(?P<year>[0-9]{4})/$', views.year_archive),
            url(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$', views.month_archive),
            url(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<day>[0-9]{2})/$', views.article_detail),

            # 1、/articles/2005/03/   
            # 请求将调用views.month_archive(request, year='2005', month='03')函数
            # 2、/articles/2003/03/03/
            # 请求将调用函数views.article_detail(request, year='2003', month='03', day='03')函数

            # path
            path('index/', views.index, name='main-view'),
            path('bio/<username>/', views.bio, name='bio'),
            path('articles/<slug:title>/', views.article, name='article-detail'),
            path('articles/<slug:title>/<int:section>/', views.section, name='article-section'),
            path('weblog/', include('blog.urls')),

            # re_path
            re_path(r'^$', views.index),            # 当用户访问 http://127.0.0.1:8080 时，后端用view.py中的index()函数处理。$表示结尾
            re_path(r"^host/(\d+)",views.host),    # URL示例：127.0.0.1:8080/host/100 \d代表数字；()表示无名分组且可以传参，函数内参数和次顺序一一对应； +表示重复一次或多次前面类型的字符。(\d+)表示不定位数的数字
            re_path(r'^host_list/(\d{4})/(\d{2})$', views.host_list),  # URL示例： 127.0.0.1:8080/host_list/2015/10   {4}表示重复四次前面的数字
            re_path(r"^login",views.login,name="log"),    # 127.0.0.1:8080/login
            re_path(r'^article/(?P<year>\d{4})/(?P<month>\d{2})/(?P<day>\d{2})',views.article_month),  # 127.0.0.1:8080/article/2015/09/10  ?P表示有名分组, ()内是分组，<>内是组名函数内参数名必须和组名相同，顺序可以乱。
        ]
    ```

#### 其他状态定义
- handler400
    * 如果HTTP客户端发送了导致错误情况的请求和状态码为400的响应，则该字符串为可调用的或表示视图的完整Python导入路径的字符串。默认情况下是django.views.defaults.bad_request()。如果您实现自定义视图，请确保它接受request和exception 参数并返回HttpResponseBadRequest。
- handler403
    * 如果用户不具有访问资源所需的权限，则该可调用的或一个字符串，代表应调用的视图的完整Python导入路径。默认情况下是django.views.defaults.permission_denied()。如果您实现自定义视图，请确保它接受request和exception 参数并返回HttpResponseForbidden。
- handler404
    * 一个可调用的或一个字符串，代表如果没有URL模式匹配，则应调用的视图的完整Python导入路径。默认情况下是django.views.defaults.page_not_found()。如果您实现自定义视图，请确保它接受request和exception 参数并返回HttpResponseNotFound。
- handler500
    * 一个可调用的或一个字符串，表示在发生服务器错误时应调用的视图的完整Python导入路径。当视图代码中出现运行时错误时，就会发生服务器错误。默认情况下是django.views.defaults.server_error()。如果您实现自定义视图，请确保它接受request参数并返回HttpResponseServerError。

