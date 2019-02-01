---
title: Python_基础 (21)
date: 2019-01-04
tags: Python
toc: true
---

### Python3面向对象
    Python3学习笔记

<!-- more -->

#### 类定义
- 格式
    ```python
        class ClassName:
            <statement-1>
            .
            .
            .
            <statement-N>
    ```

#### 类对象
- 定义
    ```python
        #!/usr/bin/python3
 
        class MyClass:
            """一个简单的类实例"""
            i = 12345
            def f(self):
                return 'hello world'
        
        # 实例化类
        x = MyClass()
        
        # 访问类的属性和方法
        print("MyClass 类的属性 i 为：", x.i)
        print("MyClass 类的方法 f 输出为：", x.f())
    ```

#### 类方法
    def关键字定义一个方法
    类方法必须包含参数self且self为第一个参数[self代表的是类的实例]
- eg
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
        
        # 实例化类
        p = people('llllljian',10,30)
        p.speak()
    ```

#### 类继承
- 格式
    ```python
        class DerivedClassName(BaseClassName1):
            <statement-1>
            .
            .
            .
            <statement-N>
    ```
- eg
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
                print("%s 说: 我 %d 岁了,我在读 %d 年级"%(self.name,self.age,self.grade))
        
        
        
        s = student('ken',10,60,3)
        s.speak()
    ```

#### 类多继承
- 格式
    ```python
        class DerivedClassName(Base1, Base2, Base3):
            <statement-1>
            .
            .
            .
            <statement-N>
    ```
- eg
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
                print("%s 说: 我 %d 岁了,我在读 %d 年级"%(self.name,self.age,self.grade))
        
        #另一个类,多重继承之前的准备
        class speaker():
            topic = ''
            name = ''
            def __init__(self,n,t):
                self.name = n
                self.topic = t
            def speak(self):
                print("我叫 %s,我是一个演说家,我演讲的主题是 %s"%(self.name,self.topic))
        
        #多重继承
        class sample(speaker,student):
            a =''
            def __init__(self,n,a,w,g,t):
                student.__init__(self,n,a,w,g)
                speaker.__init__(self,n,t)
        
        test = sample("Tim",25,80,4,"Python")
        test.speak()   #方法名同,默认调用的是在括号中排前地父类的方法

        # 输出结果
        我叫 Tim,我是一个演说家,我演讲的主题是 Python
    ```

#### 方法重写
- eg
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

        # 输出结果
        调用子类方法
        调用父类方法
    ```

#### 类属性与方法
- 类的私有属性
    * __private_attrs：两个下划线开头,声明该属性为私有,不能在类的外部被使用或直接访问.在类内部的方法中使用时 self.__private_attrs
- 类的方法
    * 在类地内部,使用 def 关键字来定义一个方法,与一般函数定义不同,类方法必须包含参数 self,且为第一个参数,self 代表的是类的实例
    * self 的名字并不是规定死的,也可以使用 this,但是最好还是按照约定是用 self
- 类的私有方法
    * __private_method：两个下划线开头,声明该方法为私有方法,只能在类的内部调用 ,不能在类地外部调用.self.__private_methods
- eg
    ```python
        #!/usr/bin/python3
 
        class Site:
            def __init__(self, name, url):
                self.name = name       # public
                self.__url = url   # private
        
            def who(self):
                print('name  : ', self.name)
                print('url : ', self.__url)
        
            def __foo(self):          # 私有方法
                print('这是私有方法')
        
            def foo(self):            # 公共方法
                print('这是公共方法')
                self.__foo()
        
        x = Site('llllljian', 'https://llllljian.github.io/')
        x.who()        # 正常输出
        x.foo()        # 正常输出
        x.__foo()      # 报错
    ```
- 方法
    * \__init__ : 构造函数,在生成对象时调用
    * \__del__ : 析构函数,释放对象时使用
    * \__repr__ : 打印,转换
    * \__setitem__ : 按照索引赋值
    * \__getitem__: 按照索引获取值
    * \__len__: 获得长度
    * \__cmp__: 比较运算
    * \__call__: 函数调用
    * \__add__: 加运算
    * \__sub__: 减运算
    * \__mul__: 乘运算
    * \__truediv__: 除运算
    * \__mod__: 求余运算
    * \__pow__: 乘方






