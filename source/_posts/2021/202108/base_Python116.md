---
title: Python_基础 (116)
date: 2021-08-23
tags: Python
toc: true
---

### python之unittest
    python之unittest

<!-- more -->

#### unittest
> unittest单元测试框架最初受JUnit的启发, 与其他语言中的主要单元测试框架具有相似的风格. 它支持测试自动化、共享测试的设置和关闭代码、将测试聚合到集合中以及测试与报告框架的独立性. 

#### 简介

![unittest简介](/img/20210823_1.png)

#### 运行流程
1. 写好一个完整的TestCase
2. 多个TestCase 由TestLoder被加载到TestSuite里面, TestSuite也可以嵌套TestSuite
3. 由TextTestRunner来执行TestSuite, 测试的结果保存在TextTestResult中
4. TestFixture指的是环境准备和恢复

##### Test Fixture
> 用于测试环境的准备和恢复还原, 一般用到下面几个函数
* setUp(): 准备环境, 执行每个测试用例的前置条件
* tearDown(): 环境还原, 执行每个测试用例的后置条件
* setUpClass(): 必须使用@classmethod装饰器, 所有case执行的前置条件, 只运行一次
* tearDownClass(): 必须使用@classmethod装饰器, 所有case运行完后只运行一次

##### Test Case
* 参数verbosity可以控制错误报告的详细程度: 默认为1. 0, 表示不输出每一个用例的执行结果；2表示详细的执行报告结果. 
* Verbosity=1情况下成功是 ., 失败是 F, 出错是 E, 跳过是 S
* 测试的执行跟方法的顺序没有关系, 默认按字母顺序
* 每个测试方法均以 test 开头
* Verbosity=2情况下会打印测试的注释

##### Test Suite
* 一般通过addTest()或者addTests()向suite中添加. case的执行顺序与添加到Suite中的顺序是一致的
    * @unittest.skip()装饰器跳过某个case
    * (1)skip():无条件跳过
    * @unittest.skip("i don't want to run this case. ")
    * (2)skipIf(condition,reason):如果condition为true, 则 skip
    * @unittest.skipIf(condition,reason)
    * (3)skipUnless(condition,reason):如果condition为False,则skip
    * @unittest.skipUnless(condition,reason)

##### Test Loder
* TestLoadder用来加载TestCase到TestSuite中. 
* loadTestsFrom*()方法从各个地方寻找testcase, 创建实例, 然后addTestSuite, 再返回一个TestSuite实例
* defaultTestLoader() 与 TestLoader()功能差不多, 复用原有实例

##### Testing Report
终端报告:  如上terminal 分支
TXT报告:  如上txt 分支, 当前目录会生成ut_log.txt文件
HTML 报告: 如上html 分支, 终端上打印运行信息同时会在当前目录生成report文件夹,  文件夹下有test.html和test.log文件

##### demo
- demo.py
    ```python
        #!/usr/bin/python
        # -*- coding: utf-8 -*-

        def add(a, b):
            return a+b

        def minus(a, b):
            return a-b
    ```
- test_demo_class.py
    ```python
        #!/usr/bin/python
        # -*- coding: utf-8 -*-

        import unittest
        from demo import add, minus


        class TestDemo(unittest.TestCase):
            """Test mathfuc.py"""

            @classmethod
            def setUpClass(cls):
                print("this setupclass() method only called once.\n")

            @classmethod
            def tearDownClass(cls):
                print("this teardownclass() method only called once too.\n")

            def setUp(self):
                print("do something before test : prepare environment.\n")

            def tearDown(self):
                print("do something after test : clean up.\n")

            def test_add(self):
                """Test method add(a, b)"""
                self.assertEqual(3, add(1, 2))
                self.assertNotEqual(3, add(2, 2))

            def test_minus(self):
                """Test method minus(a, b)"""
                self.assertEqual(1, minus(3, 2))
                self.assertNotEqual(1, minus(3, 2))

            @unittest.skip("do't run as not ready")
            def test_minus_with_skip(self):
                """Test method minus(a, b, c, d, e, f)"""
                self.assertEqual(1, minus(3, 2))
                self.assertNotEqual(1, minus(3, 2))


        if __name__ == '__main__':
            # verbosity=*: 默认是1；设为0, 则不输出每一个用例的执行结果；2-输出详细的执行结果
            unittest.main(verbosity=1)


        # -------------运行结果-----
        $ python3 test_demo_class.py
        this setupclass() method only called once.

        do something before test : prepare environment.

        do something after test : clean up.

        .do something before test : prepare environment.

        do something after test : clean up.

        Fsthis teardownclass() method only called once too.


        ======================================================================
        FAIL: test_minus (__main__.TestDemo)
        Test method minus(a, b)
        ----------------------------------------------------------------------
        Traceback (most recent call last):
        File "test_demo_class.py", line 33, in test_minus
            self.assertNotEqual(1, minus(3, 2))
        AssertionError: 1 == 1

        ----------------------------------------------------------------------
        Ran 3 tests in 0.001s

        FAILED (failures=1, skipped=1)
    ```
- test_demo_module.py
    ```python
        #!/usr/bin/python
        # -*- coding: utf-8 -*-
        import sys
        import HTMLReport
        import unittest
        import test_demo_class
        from test_demo_class import TestDemo


        if __name__ == '__main__':
            paras = sys.argv[1:]
            args = paras[0]
            report = paras[1]

            suite = unittest.TestSuite()
            if args == 'test':
                tests = [TestDemo("test_minus"), TestDemo("test_add"), TestDemo("test_minus_with_skip")]
                suite.addTests(tests)
            elif args == 'tests':
                suite.addTest(TestDemo("test_minus"))
                suite.addTest(TestDemo("test_add"))
                suite.addTest(TestDemo("test_minus_with_skip"))
            elif args == 'class':
                suite.addTests(unittest.TestLoader().loadTestsFromTestCase(TestDemo))
            elif args == 'module':
                suite.addTests(unittest.TestLoader().loadTestsFromModule(test_demo_class))
            elif args == 'mix':
                suite.addTests(unittest.TestLoader().loadTestsFromName('test_demo_class.TestDemo.test_minus'))
            elif args == 'mixs':
                suite.addTests(unittest.TestLoader().loadTestsFromNames([
                    'test_demo_class.TestDemo.test_minus',
                    'test_demo_class.TestDemo',
                    'test_demo_class'
                    ])
                )
            elif args == 'discover':
                suite.addTests(unittest.TestLoader().discover('.', 'test_*.py', top_level_dir=None))

            if report == 'terminal':
                runner = unittest.TextTestRunner(verbosity=1)
                runner.run(suite)
            elif report == 'txt':
                with open('ut_log.txt', 'a') as fp:
                    runner = unittest.TextTestRunner(stream=fp, verbosity=1)
                    runner.run(suite)
            elif report == 'html':
                runner = HTMLReport.TestRunner(
                    report_file_name='test',
                    output_path='report',
                    title='测试报告',
                    description='测试描述',
                    sequential_execution=True
                )
                runner.run(suite)

        # ----------------输出结果---------------
        python3 test_demo_module.py test txt
        this setupclass() method only called once.

        do something before test : prepare environment.

        do something after test : clean up.

        do something before test : prepare environment.

        do something after test : clean up.

        this teardownclass() method only called once too.

        python3 test_demo_module.py tests txt
        this setupclass() method only called once.

        do something before test : prepare environment.

        do something after test : clean up.

        do something before test : prepare environment.

        do something after test : clean up.

        this teardownclass() method only called once too.
    ```

