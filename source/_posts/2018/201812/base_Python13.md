---
title: Python_基础 (13)
date: 2018-12-24
tags: Python
toc: true
---

### Python3条件控制
    Python3学习笔记

<!-- more -->

#### if语句
- 格式
    ```python
        if condition_1:
            statement_block_1
        elif condition_2:
            statement_block_2
        else:
            statement_block_3
    ```
- 说明
    * 如果 "condition_1" 为 True 将执行 "statement_block_1" 块语句
    * 如果 "condition_1" 为False,将判断 "condition_2"
    * 如果"condition_2" 为 True 将执行 "statement_block_2" 块语句
    * 如果 "condition_2" 为False,将执行"statement_block_3"块语句
- 注意
    * 每个条件后面要使用冒号 :,表示接下来是满足条件后要执行的语句块.
    * 使用缩进来划分语句块,相同缩进数的语句在一起组成一个语句块.
    * 在Python中没有switch – case语句.
- 常用操作运算符
    <table class="reference"><tbody><tr><th>操作符</th><th>描述</th></tr><tr><td><code>&lt;</code></td><td>小于</td></tr><tr><td><code>&lt;=</code></td><td>小于或等于</td></tr><tr><td><code>&gt;</code></td><td>大于</td></tr><tr><td><code>&gt;=</code></td><td>大于或等于</td></tr><tr><td><code>==</code></td><td>等于,比较对象是否相等</td></tr><tr><td><code>!=</code></td><td>不等于</td></tr></tbody></table>
- if嵌套
    ```python
        if 表达式1:
            语句
            if 表达式2:
                语句
            elif 表达式3:
                语句
            else:
                语句
        elif 表达式4:
            语句
        else:
            语句
    ```
- 不同数值类型的true和false情况
    <table class="reference"><thead><tr><th style="text-align:center">类型</th><th style="text-align:center">False</th><th style="text-align:center">True</th></tr></thead><tbody><tr><td style="text-align:center">布尔</td><td style="text-align:center">False(与0等价)</td><td style="text-align:center">True(与1等价)</td></tr><tr><td style="text-align:center">数值</td><td style="text-align:center">0, &nbsp;&nbsp;0.0</td><td style="text-align:center">非零的数值</td></tr><tr><td style="text-align:center">字符串</td><td style="text-align:center">'',&nbsp;&nbsp;""(空字符串)</td><td style="text-align:center">非空字符串</td></tr><tr><td style="text-align:center">容器</td><td style="text-align:center">[],&nbsp;&nbsp;(),&nbsp;&nbsp;{},&nbsp;&nbsp;set()</td><td style="text-align:center">至少有一个元素的容器对象</td></tr><tr><td style="text-align:center">None</td><td style="text-align:center">None</td><td style="text-align:center">非None对象</td></tr></tbody></table>

#### demo1
- 说明
    * 小狗的年龄对比
- 代码
    ```python
        #!/usr/bin/python3
        
        print("=======欢迎进入狗狗年龄对比系统========")
        control = "N"
        while control.lower() == "n":
            try:
                age = int(input("请输入您家狗的年龄:"))
                #print(" ")
                age = float(age)
                if age < 0:
                    print("您在逗我？")
                elif age == 1:
                    print("相当于人类14岁")
                    #break
                elif age == 2:
                    print("相当于人类22岁")
                    #break
                else:
                    human = 22 + (age - 2)*5
                    print("相当于人类: ",human)
                    #break
            except ValueError:
                print("输入不合法,请输入有效年龄")
            print("")
            control = input("退出(Y/N)？")
            print("")
        ###退出提示
        input("点击 enter 键退出")
    ```

#### demo2
- 说明
    * 身体质量指数计算
- 代码
    ```python
        #!/usr/bin/env python3

        print('----欢迎使用BMI计算程序----')

        sex = {"F", "M"}

        class SexError(BaseException):
            def __init__(self, msg):
                self.msg = msg
        
            def __str__(self):
                return self.msg

        try:
            height=eval(input('请键入您的身高(m):'))
            weight=eval(input('请键入您的体重(kg):'))
            gender=input('请键入你的性别(F代表女,M代表男)')
            BMI=float(float(weight)/(float(height)**2))
            
            if gender not in sex:
                raise SexError(gender)
            else:
                if gender == 'F':
                    sex = "女士"
                else:
                    sex = "先生"
            
            #公式
            if BMI<=18.4:
                print(sex,',身体状态:偏瘦')
            elif BMI<=23.9:
                print(sex,',身体状态:正常')
            elif BMI<=27.9:
                print(sex,',身体状态:超重')
            elif BMI>=28:
                print(sex,',身体状态:肥胖')
            
        except SexError as e:
            print(e,"不是你的性别吧")
        except (KeyboardInterrupt, SystemExit):
            print("你别瞎点呀");
        except NameError as e:
            print("输入不合法,请输入有效身高和体重", e)
    ```

