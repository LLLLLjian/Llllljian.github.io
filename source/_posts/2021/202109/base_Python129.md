---
title: Python_基础 (129)
date: 2021-09-09
tags: Python
toc: true
---

### python小积累
    python程序内获取文件信息

<!-- more -->

#### 前言
> 有一些操作要记录下当前文件名、方法、行号, 我也不能写死呀, 所以就需要在文件里动态获取

#### 方法1
- code
    ```python
        # 文件名
        os.path.basename(__file__)
        # 方法名
        sys._getframe().f_code.co_name
        # 行号
        sys._getframe().f_lineno
    ```
- 缺陷
    * _getframe好像是个私有的方法, 不推荐在程序中调用
    * 跨方法不能准确打印出方法名

#### 方法2
- code
    ```python
        import inspect

        current_file = inspect.currentframe()
        # 当前文件名
        current_file.f_code.co_filename
        # 当前方法名
        current_file.f_code.co_name
        # 当前行号
        current_file.f_lineno
    ```

#### 示例
1. 获取函数名称,获取类名称
    ```python
        ## 获取函数名称
        def test_func():
            pass

        print('函数名称为: ',test_func.__name__)

        ##获取类名称
        class Test:
            def test(self):
                print(self.__class__.__name__)

        print('类名称为: ',Test().__class__.__name__)

        t = Test().test()

        # 输出结果
        # 函数名称为:  test_func
        # 类名称为:  Test
        # Test
    ```
2. 在函数内部或者类内部获取函数名称,可以使用sys模块中的sys._getframe().f_code.co_name
    ```python
        import sys
        ## 函数获取函数名称
        def test_sys():
            print('当前函数名称:',sys._getframe().f_code.co_name)

        test_sys()

        ##类获取函数名称
        class TestSys:
            def ts(self):
                print('当前函数名称:', sys._getframe().f_code.co_name)

        t = TestSys()
        t.ts()

        # 输出结果
        # 当前函数名称: test_sys
        # 当前函数名称: ts
    ```
3. 但是在不同的函数里调用的他,想要打印调用他的函数就出问题
    ```python
        import sys
        ## 函数获取函数名称
        def a():
            print('当前函数名称:',sys._getframe().f_code.co_name)

        def use_a():
            ## 使用a函数
            a()

        ## 调用使用a函数
        print('------函数调用------')
        use_a()

        ##类获取函数名称
        class TestSys:
            def testa(self):
                print('当前函数名称:', sys._getframe().f_code.co_name)

            def testb(self):
                self.testa()
        ## 一个类时
        print('------单个类时内部调用------')
        t = TestSys()
        t.testb()


        class Testsys:
            def testc(self):
                TestSys().testa()

        ## 两个类时,第二个类调用第一个类
        print('------多个类时内部调用------')
        t = Testsys()
        t.testc()

        # 输出结果
        # ------函数调用------
        # 当前函数名称: a
        # ------单个类时内部调用------
        # 当前函数名称: testa
        # ------多个类时内部调用------
        # 当前函数名称: testa
    ```
4. 使用inspect模块中的inspect.stack()方法,动态获取当前运行的函数名(或方法名称)
    ```python
        import inspect
        ## 函数获取函数名称
        def a():
            print('当前函数名称:',inspect.stack()[1][3])

        def use_a():
            ## 使用a函数
            a()

        ## 调用使用a函数
        print('------函数调用------')
        use_a()

        ##类获取函数名称
        class TestSys:
            def testa(self):
                print('当前函数名称:', inspect.stack()[1][3])

            def testb(self):
                self.testa()
        ## 一个类时
        print('------单个类时内部调用------')
        t = TestSys()
        t.testb()


        class Testsys:
            def testc(self):
                TestSys().testa()

        ## 两个类时,第二个类调用第一个类
        print('------多个类时内部调用------')
        t = Testsys()
        t.testc()

        # 输出结果
        # ------函数调用------
        # 当前函数名称: use_a
        # ------单个类时内部调用------
        # 当前函数名称: testb
        # ------多个类时内部调用------
        # 当前函数名称: testc
    ```

#### inspect模块
- 属性
    <table class="docutils align-default"><thead><tr class="row-odd"><th class="head"><p>类型</p></th><th class="head"><p>属性</p></th><th class="head"><p>描述</p></th></tr></thead><tbody><tr class="row-even"><td><p>module</p></td><td><p>__doc__</p></td><td><p>文档字符串</p></td></tr><tr class="row-odd"><td></td><td><p>__file__</p></td><td><p>文件名(内置模块没有文件名)</p></td></tr><tr class="row-even"><td><p>class -- 类</p></td><td><p>__doc__</p></td><td><p>文档字符串</p></td></tr><tr class="row-odd"><td></td><td><p>__name__</p></td><td><p>类定义时所使用的名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>__module__</p></td><td><p>该类型被定义时所在的模块的名称</p></td></tr><tr class="row-even"><td><p>method 方法</p></td><td><p>__doc__</p></td><td><p>文档字符串</p></td></tr><tr class="row-odd"><td></td><td><p>__name__</p></td><td><p>该方法定义时所使用的名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>__func__</p></td><td><p>实现该方法的函数对象</p></td></tr><tr class="row-even"><td></td><td><p>__self__</p></td><td><p>该方法被绑定的实例,若没有绑定则为<code class="docutils literal notranslate"><span class="pre">None</span></code></p></td></tr><tr class="row-odd"><td></td><td><p>__module__</p></td><td><p>定义此方法的模块的名称</p></td></tr><tr class="row-even"><td><p>function -- 函数</p></td><td><p>__doc__</p></td><td><p>文档字符串</p></td></tr><tr class="row-odd"><td></td><td><p>__name__</p></td><td><p>用于定义此函数的名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>__code__</p></td><td><p>包含已编译函数的代码对象<a class="reference internal" href="../glossary.html#term-bytecode"><span class="xref std std-term">bytecode</span></a></p></td></tr><tr class="row-even"><td></td><td><p>__defaults__</p></td><td><p>所有位置或关键字参数的默认值的元组</p></td></tr><tr class="row-odd"><td></td><td><p>__kwdefaults__</p></td><td><p>mapping of any defaultvalues for keyword-onlyparameters</p></td></tr><tr class="row-even"><td></td><td><p>__globals__</p></td><td><p>global namespace in whichthis function was defined</p></td></tr><tr class="row-odd"><td></td><td><p>__annotations__</p></td><td><p>mapping of parametersnames to annotations;<code class="docutils literal notranslate"><span class="pre">"return"</span></code> key isreserved for returnannotations.</p></td></tr><tr class="row-even"><td></td><td><p>__module__</p></td><td><p>name of module in whichthis function was defined</p></td></tr><tr class="row-odd"><td><p>回溯</p></td><td><p>tb_frame</p></td><td><p>此级别的框架对象</p></td></tr><tr class="row-even"><td></td><td><p>tb_lasti</p></td><td><p>index of last attemptedinstruction in bytecode</p></td></tr><tr class="row-odd"><td></td><td><p>tb_lineno</p></td><td><p>current line number inPython source code</p></td></tr><tr class="row-even"><td></td><td><p>tb_next</p></td><td><p>next inner tracebackobject (called by thislevel)</p></td></tr><tr class="row-odd"><td><p>框架</p></td><td><p>f_back</p></td><td><p>next outer frame object(this frame's caller)</p></td></tr><tr class="row-even"><td></td><td><p>f_builtins</p></td><td><p>builtins namespace seenby this frame</p></td></tr><tr class="row-odd"><td></td><td><p>f_code</p></td><td><p>code object beingexecuted in this frame</p></td></tr><tr class="row-even"><td></td><td><p>f_globals</p></td><td><p>global namespace seen bythis frame</p></td></tr><tr class="row-odd"><td></td><td><p>f_lasti</p></td><td><p>index of last attemptedinstruction in bytecode</p></td></tr><tr class="row-even"><td></td><td><p>f_lineno</p></td><td><p>current line number inPython source code</p></td></tr><tr class="row-odd"><td></td><td><p>f_locals</p></td><td><p>local namespace seen bythis frame</p></td></tr><tr class="row-even"><td></td><td><p>f_trace</p></td><td><p>tracing function for thisframe, or<code class="docutils literal notranslate"><span class="pre">None</span></code></p></td></tr><tr class="row-odd"><td><p>code</p></td><td><p>co_argcount</p></td><td><p>number of arguments (notincluding keyword onlyarguments, * or **args)</p></td></tr><tr class="row-even"><td></td><td><p>co_code</p></td><td><p>原始编译字节码的字符串</p></td></tr><tr class="row-odd"><td></td><td><p>co_cellvars</p></td><td><p>单元变量名称的元组(通过包含作用域引用)</p></td></tr><tr class="row-even"><td></td><td><p>co_consts</p></td><td><p>字节码中使用的常量元组</p></td></tr><tr class="row-odd"><td></td><td><p>co_filename</p></td><td><p>创建此代码对象的文件的名称</p></td></tr><tr class="row-even"><td></td><td><p>co_firstlineno</p></td><td><p>number of first line inPython source code</p></td></tr><tr class="row-odd"><td></td><td><p>co_flags</p></td><td><p>bitmap of<code class="docutils literal notranslate"><span class="pre">CO_*</span></code> flags,read more<a class="reference internal" href="#inspect-module-co-flags"><span class="std std-ref">here</span></a></p></td></tr><tr class="row-even"><td></td><td><p>co_lnotab</p></td><td><p>编码的行号到字节码索引的映射</p></td></tr><tr class="row-odd"><td></td><td><p>co_freevars</p></td><td><p>tuple of names of freevariables (referenced viaa function's closure)</p></td></tr><tr class="row-even"><td></td><td><p>co_posonlyargcount</p></td><td><p>number of positional onlyarguments</p></td></tr><tr class="row-odd"><td></td><td><p>co_kwonlyargcount</p></td><td><p>number of keyword onlyarguments (not including** arg)</p></td></tr><tr class="row-even"><td></td><td><p>co_name</p></td><td><p>定义此代码对象的名称</p></td></tr><tr class="row-odd"><td></td><td><p>co_names</p></td><td><p>局部变量名称的元组</p></td></tr><tr class="row-even"><td></td><td><p>co_nlocals</p></td><td><p>局部变量的数量</p></td></tr><tr class="row-odd"><td></td><td><p>co_stacksize</p></td><td><p>需要虚拟机堆栈空间</p></td></tr><tr class="row-even"><td></td><td><p>co_varnames</p></td><td><p>参数名和局部变量的元组</p></td></tr><tr class="row-odd"><td><p>generator -- 生成器</p></td><td><p>__name__</p></td><td><p>名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>gi_frame</p></td><td><p>框架</p></td></tr><tr class="row-even"><td></td><td><p>gi_running</p></td><td><p>生成器在运行吗？</p></td></tr><tr class="row-odd"><td></td><td><p>gi_code</p></td><td><p>code</p></td></tr><tr class="row-even"><td></td><td><p>gi_yieldfrom</p></td><td><p>object being iterated by<code class="docutils literal notranslate"><span class="pre">yield</span><span class="pre">from</span></code>, or<code class="docutils literal notranslate"><span class="pre">None</span></code></p></td></tr><tr class="row-odd"><td><p>coroutine -- 协程</p></td><td><p>__name__</p></td><td><p>名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>cr_await</p></td><td><p>object being awaited on,or<code class="docutils literal notranslate"><span class="pre">None</span></code></p></td></tr><tr class="row-even"><td></td><td><p>cr_frame</p></td><td><p>框架</p></td></tr><tr class="row-odd"><td></td><td><p>cr_running</p></td><td><p>is the coroutine running?</p></td></tr><tr class="row-even"><td></td><td><p>cr_code</p></td><td><p>code</p></td></tr><tr class="row-odd"><td></td><td><p>cr_origin</p></td><td><p>where coroutine wascreated, or<code class="docutils literal notranslate"><span class="pre">None</span></code>. See<a class="reference internal" href="sys.html#sys.set_coroutine_origin_tracking_depth" title="sys.set_coroutine_origin_tracking_depth"><code class="xref py py-func docutils literal notranslate"><span class="pre">sys.set_coroutine_origin_tracking_depth()</span></code></a></p></td></tr><tr class="row-even"><td><p>builtin</p></td><td><p>__doc__</p></td><td><p>文档字符串</p></td></tr><tr class="row-odd"><td></td><td><p>__name__</p></td><td><p>此函数或方法的原始名称</p></td></tr><tr class="row-even"><td></td><td><p>__qualname__</p></td><td><p>qualified name -- 限定名称</p></td></tr><tr class="row-odd"><td></td><td><p>__self__</p></td><td><p>instance to which amethod is bound, or<code class="docutils literal notranslate"><span class="pre">None</span></code></p></td></tr></tbody></table>
