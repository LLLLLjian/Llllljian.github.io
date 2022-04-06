---
title: Python_基础 (110)
date: 2021-08-12
tags: Python
toc: true
---

### 快来跟我一起学装饰器
    python之装饰器

<!-- more -->

#### 装饰器类
> 现在我们有了能用于正式环境的logit装饰器, 但当我们的应用的某些部分还比较脆弱时, 异常也许是需要更紧急关注的事情. 比方说有时你只想打日志到一个文件. 而有时你想把引起你注意的问题发送到一个email, 同时也保留日志, 留个记录. 这是一个使用继承的场景, 但目前为止我们只看到过用来构建装饰器的函数. 幸运的是, 类也可以用来构建装饰器. 那我们现在以一个类而不是一个函数的方式, 来重新构建logit. 
- code
    ```python
        from functools import wraps
 
        class logit(object):
            def __init__(self, logfile='out.log'):
                self.logfile = logfile
        
            def __call__(self, func):
                @wraps(func)
                def wrapped_function(*args, **kwargs):
                    log_string = func.__name__ + " was called"
                    print(log_string)
                    # 打开logfile并写入
                    with open(self.logfile, 'a') as opened_file:
                        # 现在将日志打到指定的文件
                        opened_file.write(log_string + '\n')
                    # 现在, 发送一个通知
                    self.notify()
                    return func(*args, **kwargs)
                return wrapped_function
        
            def notify(self):
                # logit只打日志, 不做别的
                pass

        @logit()
        def myfunc1():
            """
            会记录日志的一个方法
            """
            pass

        class email_logit(logit):
            """
            一个logit的实现版本, 可以在函数调用时发送email给管理员
            """
            def __init__(self, email='admin@myproject.com', *args, **kwargs):
                self.email = email
                super(email_logit, self).__init__(*args, **kwargs)
        
            def notify(self):
                # 发送一封email到self.email
                # 这里就不做实现了
                pass

        @email_logit()
        def myfunc2():
            """
            会记录日志并发送邮件的一个方法
            """
            pass
    ```


#### 装饰器执行顺序
- 一个简单的装饰器
    * code
        ```python
            >>> def log_time(func):
            ...     """
            ...     此函数的作用时接受被修饰的函数的引用test, 然后被内部函数使用
            ...     """
            ...     print("走进装饰器")
            ...     def make_decorater():
            ...         print('现在开始装饰')
            ...         func()
            ...         print('现在结束装饰')
            ...     # log_time()被调用后, 运行此函数返回make_decorater()函数的引用make_decorater
            ...     print("退出装饰器")
            ...     return make_decorater
            ... 
            >>> @log_time  # 此行代码等同于, test=log_time(test)=make_decorater
            ... def test():
            ...     print('我是被装饰的函数')
            ... 
            走进装饰器
            退出装饰器
            >>> test()  # test()=log_time(test())
            现在开始装饰
            我是被装饰的函数
            现在结束装饰
        ```
- 当被装饰的函数有形参时
    * code
        ```python
            def log_time(func):
                # 接受调用语句的实参, 在下面传递给被装饰函数(原函数)
                def make_decorater(*args,**kwargs):
                    print('现在开始装饰')
                    # 如果在这里return, 则下面的代码无法执行, 所以引用并在下面返回
                    test_func = func(*args,**kwargs)
                    print('现在结束装饰')
                    return test_func  # 因为被装饰函数里有return, 所以需要给调用语句(test(2))一个返回, 又因为test_func = func(*args,**kwargs)已经调用了被装饰函数, 这里就不用带()调用了, 区别在于运行顺序的不同. 
                return make_decorater
            
            
            @log_time
            def test(num):
                print('我是被装饰的函数')
                return num+1
            
            a = test(2)  # test(2)=make_decorater(2)
            print(a)
        ```
- 当@装饰器后有参数时
    * code
        ```python
            def get_parameter(*args,**kwargs):
                """
                工厂函数, 用来接受@get_parameter('index.html/')的'index.html/'
                """
                def log_time(func):
                    def make_decorater():
                        # ('index.html/',) {}
                        print(args,kwargs)
                        print('现在开始装饰')
                        func()
                        print('现在结束装饰')
                    return make_decorater
                return log_time
            
            @get_parameter('index.html/')
            def test():
                print('我是被装饰的函数')
                # return num+1
            
            test()  # test()=make_decorater()
        ```
- 两个装饰器同时修饰一个函数(重点看执行顺序)
    * code
        ```python
            def log_time1(func):
                def make_decorater(*args,**kwargs): 
                    print('1现在开始装饰')
                    test_func = func(*args,**kwargs) 
                    print('1现在结束装饰') 
                    return test_func 
                return make_decorater
            
            def log_time2(func):
                def make_decorater(*args,**kwargs):  # 接受调用语句的实参, 在下面传递给被装饰函数(原函数)
                    print('2现在开始装饰')
                    test_func = func(*args,**kwargs)  # 如果在这里return, 则下面的代码无法执行, 所以引用并在下面返回
                    print('2现在结束装饰')
                    return test_func  # 因为被装饰函数里有return, 所以需要给调用语句(test(2))一个返回, 又因为test_func = func(*args,**kwargs)已经调用了被装饰函数, 这里就不用带()调用了, 区别在于运行顺序的不同. 
                return make_decorater
            
            @log_time1
            @log_time2
            def test(num):
                print('我是被装饰的函数')
                return num+1
            
            a = test(2)  # test(2)=make_decorater(2)
            print(a)
            # 1现在开始装饰
            # 2现在开始装饰
            # 我是被装饰的函数
            # 2现在结束装饰
            # 1现在结束装饰
            # 3
        ```
- 总结一下
    ```python
        # 执行顺序是从里到外, 最先调用最里层的装饰器, 最后调用最外层的装饰器
        @a
        @b
        @c
        def f ():
            pass
        # 它等效于 f = a(b(c(f)))
    ```
