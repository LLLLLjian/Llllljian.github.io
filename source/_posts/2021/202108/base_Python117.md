---
title: Python_基础 (117)
date: 2021-08-24
tags: Python
toc: true
---

### python之unittest之discover
    unittest之discover()方法批量执行用例

<!-- more -->

#### python之unittest之discover
> 自动化测试过程中, 自动化覆盖的功能点和对应测试用例之间的关系基本都是1 VS N, 如果每次将测试用例一个个单独执行, 不仅效率很低, 无法快速反馈测试结果, 而且维护起来很麻烦. 在python的单元测试框架unittest中, 提供了批量执行的测试用例的方法. 

#### TestSuite()类

该类代表单个测试用例和测试套件的集合. 它提供了运行测试所需的接口以使其可以像其他测试一样运行. TestSuite实例和遍历套件相同, 单独运行每个测试用例. 

TestSuite的行为和TestCase非常相似, 但它并未实际执行测试, 而是用于将测试用例聚合到一起, 下面的2个方法用于向TestSuite实例中添加测试用例: 

addTest(): 添加测试用例到TestCase或TestSuite套件中；
addTests(): 将迭代TestCase和TestSuite实例中的所有测试用例添加到此测试组件, 相当于调用addTest()的每个元素. 

#### discover()方法

discover(start_dir, pattern ='test *.py', top_level_dir = None )

start_dir: 要测试的模块名或测试用例目录；

pattern='test*.py': 表示用例文件名的匹配原则, 下面的例子中匹配文件名为以“test”开头的“.py”文件, 星号“*”表示任意多个字符；

top_level_dir=None: 测试模块的顶层目录, 如果没有顶层目录, 默认为None；

该方法通过从指定的开始目录递归到子目录中查找所有测试模块, 并返回包含它们的TestSuite对象, 只有与模式匹配测试文件和可导入的模块名称才会被加载. 

所有测试模块必须可以从项目的顶层导入, 如果起始目录不是顶层目录, 则顶层目录必须单独指定. 

如果一个测试文件的名称符合pattern, 将检查该文件是否包含 load_tests() 函数, 如果 load_tests() 函数存在, 则由该函数负责加载本文件中的测试用例. 

如果不存在, 就会执行loadTestsFromModule(), 查找该文件中派生自TestCase 的类包含的 test 开头的方法. 

#### addTest()实例

![addTest_demo](/img/20210824_1.png)
- code
    ```python
        # coding=utf-8
        import unittest

        # 加载测试用例
        import test_user
        import test_mobile
        import test_mobcode
        import test_txtcode
        import test_pwd
        import test_signup
        import test_login
        import test_vipcenter
        import test_search

        # 将测试用例添加到测试集合
        suite = unittest.TestSuite()
        suite.addTest(test_user.UserTest("test_user"))           # 用户名
        suite.addTest(test_mobile.MobileTest("test_mobile"))     # 手机号码
        suite.addTest(test_mobcode.MobCodeTest("test_mobcode"))  # 手机验证码
        suite.addTest(test_txtcode.TxtCodeTest("test_txtcode"))  # 图形验证码
        suite.addTest(test_pwd.PasswordTest("test_pwd"))         # 密码
        suite.addTest(test_signup.SignUpTest("test_signup"))     # 注册功能
        suite.addTest(test_login.LoginTest("test_loggin"))       # 登录功能
        suite.addTest(test_vipcenter.VipTest("test_vip"))        # 会员中心
        suite.addTest(test_search.SearchTest("test_search"))     # 搜索功能

        # 运行测试用例
        runner = unittest.TextTestRunner()
        runner.run(suite)
    ```

#### discover()实例
- code
    ```python
        # coding=utf-8
        import unittest
        from unittest import defaultTestLoader

        # 测试用例存放路径
        case_path = './Testcase/case'   

        # 获取所有测试用例
        def get_allcase():
            discover = unittest.defaultTestLoader.discover(case_path, pattern="test*.py")
            suite = unittest.TestSuite()
            suite.addTest(discover)
            return suite

        if __name__ == '__main__':
            # 运行测试用例
            runner = unittest.TextTestRunner()
            runner.run(get_allcase())

        # 相比于addTest()方法, discover()方法更方便高效, 也可以提高测试反馈速率. 
        # 使用discover()方法, 切记测试用例中需要执行的测试方法必须以test开头, 否则无法加载！！！
    ```

