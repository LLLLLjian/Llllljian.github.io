---
title: Python_基础 (39)
date: 2020-10-23
tags: Python
toc: true
---

### 重新开始学Python
    之前学都是业务的, 现在要用到工作中了！！！

<!-- more -->

#### Python3 面向对象
- 面向对象技术简介
    * 类(Class): 用来描述具有相同的属性和方法的对象的集合.它定义了该集合中每个对象所共有的属性和方法.对象是类的实例.
    * 方法: 类中定义的函数.
    * 类变量: 类变量在整个实例化的对象中是公用的.类变量定义在类中且在函数体之外.类变量通常不作为实例变量使用.
    * 数据成员: 类变量或者实例变量用于处理类及其实例对象的相关的数据.
    * 方法重写: 如果从父类继承的方法不能满足子类的需求, 可以对其进行改写, 这个过程叫方法的覆盖(override), 也称为方法的重写.
    * 局部变量: 定义在方法中的变量, 只作用于当前实例的类.
    * 实例变量: 在类的声明中, 属性是用变量来表示的, 这种变量就称为实例变量, 实例变量就是一个用 self 修饰的变量.
    * 继承: 即一个派生类(derived class)继承基类(base class)的字段和方法.继承也允许把一个派生类的对象作为一个基类对象对待.例如, 有这样一个设计: 一个Dog类型的对象派生自Animal类, 这是模拟"是一个(is-a)"关系(例图, Dog是一个Animal).
    * 实例化: 创建一个类的实例, 类的具体对象.
    * 对象: 通过类定义的数据结构实例.对象包括两个数据成员(类变量和实例变量)和方法.
- 类定义
    ```python
        class ClassName:
            <statement-1>
            .
            .
            .
            <statement-N>
    ```
- 类对象
> 类对象支持两种操作: 属性引用和实例化.
属性引用使用和 Python 中所有的属性引用一样的标准语法: obj.name.
类对象创建后, 类命名空间中所有的命名都是有效属性名
- 类的实例化
    ```python
        #!/usr/bin/env python3
 
        class people:
            def __init__(self, age, sex):
                self.age = age
                self.sex = sex

        temp = people("10", "男");
        print(temp.age, temp.sex)
    ```
- 使用类中的方法
    ```python
        #!/usr/bin/env python3
 
        class people:
            # 定义基本属性
            name = ''
            age = ''
            sex = ''
            # 定义私有属性,私有属性在类外部无法直接进行访问
            __weight = 0

            '''
                这是注释, 类的构造函数,  类初始化时自动调用
            '''
            def __init__(self, n, a, s="男", w="120"):
                self.name = n
                self.age = a
                self.sex = s
                self.__weight = w
            
            '''
                人的自我介绍
            '''
            def introduceOneselfTo(self):
                print("我的名字是 {} , 我的年龄是 {} , 我的性别是 {}, 我的体重是{}".format(self.name, self.age, self.sex, self.__weight))
                return

        temp = people("小A", "10", "男");
        temp.introduceOneselfTo()


        temp = people("小B", "20", "女");
        temp.introduceOneselfTo()

        temp = people("小C", "30");
        temp.introduceOneselfTo()

        # 私有属性访问不到会报错
        # print(temp.name + "的体重为" + temp)
    ```
- 单继承
    ```python
        #!/usr/bin/env python3
 
        class people:
            # 定义基本属性
            name = ''
            age = ''
            sex = ''
            # 定义私有属性,私有属性在类外部无法直接进行访问
            __weight = 0

            '''
                这是注释, 类的构造函数,  类初始化时自动调用
            '''
            def __init__(self, n, a, s="男", w="120") :
                self.name = n
                self.age = a
                self.sex = s
                self.__weight = w
            
            '''
                人的自我介绍
            '''
            def introduceOneselfTo(self) :
                print("我的名字是 {} , 我的年龄是 {} , 我的性别是 {}, 我的体重是{}".format(self.name, self.age, self.sex, self.__weight))
                return

        class student(people) :
            grade = ''
            def __init__(self, n, a, s, w, g) :
                people.__init__(self, n, a, s, w)
                self.grade = g

            def introduceOneselfTo(self) :

                print("我的名字是 {} , 我的年龄是 {} , 我的性别是 {}, 我的成绩是{}".format(self.name, self.age, self.sex, self.grade))
                return

        temp = student("小D", '18', '男', '120', '80')
        temp.introduceOneselfTo()


        # 继承的类中不能使用父类中的私有元素
    ```
- 多继承
    ```python
        #!/usr/bin/python3
 
        #类定义
        class people:
            #定义基本属性
            name = ''
            age = 0
            #定义私有属性,私有属性在类外部无法直接进行访问
            __weight = 0
            #定义构造方法
            def __init__(self,n,a,w):
                self.name = n
                self.age = a
                self.__weight = w
            def speak(self):
                print("%s 说: 我 %d 岁." %(self.name,self.age))
        
        #单继承示例
        class student(people):
            grade = ''
            def __init__(self,n,a,w,g):
                #调用父类的构函
                people.__init__(self,n,a,w)
                self.grade = g
            #覆写父类的方法
            def speak(self):
                print("%s 说: 我 %d 岁了, 我在读 %d 年级"%(self.name,self.age,self.grade))
        
        #另一个类, 多重继承之前的准备
        class speaker():
            topic = ''
            name = ''
            def __init__(self,n,t):
                self.name = n
                self.topic = t
            def speak(self):
                print("我叫 %s, 我是一个演说家, 我演讲的主题是 %s"%(self.name,self.topic))
        
        #多重继承
        class sample(speaker,student):
            a =''
            def __init__(self,n,a,w,g,t):
                student.__init__(self,n,a,w,g)
                speaker.__init__(self,n,t)
        
        test = sample("Tim",25,80,4,"Python")
        test.speak()   #方法名同, 默认调用的是在括号中排前地父类的方法

        # 输出结果
        # 我叫 Tim, 我是一个演说家, 我演讲的主题是 Python
    ```
- 方法重写
    ```python
        #!/usr/bin/python3
 
        class Parent:        # 定义父类
        def myMethod(self):
            print ('调用父类方法')
        
        class Child(Parent): # 定义子类
        def myMethod(self):
            print ('调用子类方法')
        
        c = Child()          # 子类实例
        c.myMethod()         # 子类调用重写方法
        super(Child,c).myMethod() #用子类对象调用父类已被覆盖的方法
    ```




