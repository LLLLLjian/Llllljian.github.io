---
title: Python_基础 (45)
date: 2020-11-02
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    快来跟我一起学Django！！！

<!-- more -->

#### 模型

##### 什么是模型
- ORM
    * Object Relation Mapping, 对象-关系-模型
- 本质
    * 类是对内存运行时的数据类型的抽象概念, 规定了某一类对象有哪些属性和方法
    * 对象是对内存运行时的具体数据的具体实现, 根据类为模板来实例化, 有具体的内存结构
    * 表是对外存永久存储时的数据类型的抽象概念, 规定了某一类数据有哪些字段(由哪些信息项组成)
    * 记录是对外存永久存储时的具体数据的具体实现, 在某表中填写一行数据, 表示一个具体的数据组合

##### 起步
1. 一个例子
    ```python
        from django.db import models

        class Person(models.Model):
            first_name = models.CharField(max_length=30)
            last_name = models.CharField(max_length=30)

        """
            对应的SQL代码

            CREATE TABLE myapp_person (
                "id" serial NOT NULL PRIMARY KEY,
                "first_name" varchar(30) NOT NULL,
                "last_name" varchar(30) NOT NULL
            );
        """
    ```
2. 如何使用Model
    * 先类后表
        * 使用backend来自动创建表
        * 表的属性, 编程属性直接在类中体现, 更容易地编程 ,  一套逻辑
    * 基本操作流程
        1. 创建、修改Model类
        2. 配置settings中关于INSTALLED_APPS和DATABASES相关设置项目
        3. 命令python manage.py makemigrations
        4. 命令python manage.py migrate

##### 字段 Field
> 表的字段, 由Model类的属性来生成. 每个Model类属性有两个重要的 关注点:  类型和选项.
类型规定了: 表字段的类型, 对应的默认的html form widget,  这点可以猜想model是可以直接创建form的form表单项的基本验证方式
选项, 是类型的进一步设置, 每个field都可以设置多个选项, 比如CharField的max_length
1. 常用的选项
    <table><thead><tr><th>option名字</th><th>值</th><th>说明</th><th></th></tr></thead><tbody><tr><td>null</td><td>False, True</td><td>默认为假, 数据库字段是否可以为null</td><td></td></tr><tr><td>blank</td><td>False,True</td><td>null is purely database-related, whereas blank is validation-related.</td><td></td></tr><tr><td>choice</td><td>二元组的序列</td><td>可选项</td><td></td></tr><tr><td>default</td><td>a value or a callable object</td><td>默认值, 如果为函数的话, 则每次创建时调用</td><td></td></tr><tr><td>help_text</td><td>text</td><td>form表单项中的帮助</td><td></td></tr><tr><td>primary_key</td><td>False, True</td><td>如果model中没有设置主键, 则可自动添加一个IntegerField的主键</td><td></td></tr><tr><td>unique</td><td>True、False</td><td>唯一性约束</td><td></td></tr><tr><td>db_column</td><td>text</td><td>字段名称, 如果没有的话, 则使用属性名</td><td></td></tr><tr><td>db_index</td><td>False、True</td><td>是否设置该列为索引</td><td></td></tr></tbody></table>
    * choices实例
        ```python
            from django.db import models

            class Student(models.Model):
                FRESHMAN = 'FR'
                SOPHOMORE = 'SO'
                JUNIOR = 'JR'
                SENIOR = 'SR'
                GRADUATE = 'GR'
                YEAR_IN_SCHOOL_CHOICES = [
                    (FRESHMAN, 'Freshman'),
                    (SOPHOMORE, 'Sophomore'),
                    (JUNIOR, 'Junior'),
                    (SENIOR, 'Senior'),
                    (GRADUATE, 'Graduate'),
                ]
                year_in_school = models.CharField(
                    max_length=2,
                    choices=YEAR_IN_SCHOOL_CHOICES,
                    default=FRESHMAN,
                )

                def is_upperclass(self):
                    return self.year_in_school in {self.JUNIOR, self.SENIOR}
        ```
2. 字段类型
> 按照数据类型大体分为: 布尔、整数、浮点数、时间、文本等类型, 每种类型又设置了多个小类用于特性化.同时又参考form设置了具有语意的类型, 比如MailField
    * 布尔
        * class BooleanField(**options)
        * class NullBooleanField(**options) null=True
    * 整数
        * class BigIntegerField
        * class IntegerField(**options)
        * class PositiveIntegerField(**options)
        * class PositiveSmallIntegerField(**options)
        * class SmallIntegerField(**options)
    * 浮点数
        * class DecimalField(max_digits=None, decimal_places=None, **options)
        * class FloatField(**options)
    * 日期时间
        * class DateField(auto_now=False, auto_now_add=False, **options)
            * auto_now 只要调用save方法, 就会改变
            * auto_now_add 当新增的时候会设置
        * class DateTimeField(auto_now=False, auto_now_add=False, **options)
        * class TimeField(auto_now=False, auto_now_add=False, **options)
        * class DurationField(**options)
    * 文本
        * class CharField(max_length=None, **options)
        * class TextField(**options)
        * class EmailField(max_length=254, **options)
        * class URLField(max_length=200, **options)
        * class SlugField(max_length=50, **options)
    * 文件类型
        * class FileField(upload_to=None, max_length=100, **options) 用于上传的文件表示
        * class FilePathField(path=None, match=None, recursive=False, max_length=100, **options)
        * class ImageField(upload_to=None, height_field=None, width_field=None, max_length=100, **options)
    * 其他
        * class AutoField(**options)
        * class BigAutoField(**options)
        * class BinaryField(max_length=None, **options)
        * class GenericIPAddressField(protocol='both', unpack_ipv4=False, **options)
        * class UUIDField(**options)

##### Meta 模型的元数据
> meta 元的意思, 指的是基础性的描述信息
1. db_table 设置的表的名字
2. db_tablespace 选用的表空间的名字
3. indexes = [] 索引
4. index_together=[()] 联合索引
5. unique_together=[()] 联合唯一索引
6. ordering=[] 默认的排序方式, 对选择结果的排序
7. verbose_name 更容易读的名字
8. verbose_name_plural 更容易读的名字的复数

##### 关联类型
1. ForeignKey many-to-one 多对一、一对多,  最基本的外键约束 , 比如学生与班级, 一个学生只能属于一个班级, 而一个班级可以有多个学生
2. ManyToManyField many-to-many 多对多,  学生和社团的关联关系, 一个学生可以参加多个社团, 每个社团也可以有多个学生
3. OneToOneField one-to-one 一对一, 比如学生基本信息和籍贯信息, 可以把籍贯信息看作学生基本信息的补充
4. on_delete参数说明
    * on_delete=None,               # 删除关联表中的数据时,当前表与其关联的field的行为
    * on_delete=models.CASCADE,     # 删除关联数据,与之关联也删除
    * on_delete=models.DO_NOTHING,  # 删除关联数据,什么也不做
    * on_delete=models.PROTECT,     # 删除关联数据,引发错误ProtectedError
    * on_delete=models.SET_NULL,    # 删除关联数据,与之关联的值设置为null(前提FK字段需要设置为可空,一对一同理)models.ForeignKey('关联表', on_delete=models.SET_NULL, blank=True, null=True)
    * on_delete=models.SET_DEFAULT, # 删除关联数据,与之关联的值设置为默认值(前提FK字段需要设置默认值,一对一同理)models.ForeignKey('关联表', on_delete=models.SET_DEFAULT, default='默认值')
    * on_delete=models.SET,         # 删除关联数据,
        a. 与之关联的值设置为指定值,设置: models.SET(值)
        b. 与之关联的值设置为可执行对象的返回值,设置: models.SET(可执行对象)
5. 实例
    ```python
        from django.db import models

        class SchoolClass(models.Model):
            name = models.CharField(max_length=50)
            director = models.CharField(max_length=50)
            class Meta:
                db_table = 't_class'

        class Team(models.Model):
            name = models.CharField(max_length=50)
            started_at = models.DateField(null=True)
            class Meta:
                db_table = 't_team'

        class Student(models.Model):
            SEX = ((1, 'BOY'), (2, 'GIRL'))
            name = models.CharField(max_length=100)
            sex = models.IntegerField(choices=SEX, blank=True, null=True)
            class_in  = models.ForeignKey(SchoolClass, on_delete=models.DO_NOTHING)
            teams  = models.ManyToManyField(Team)
            class Meta:
                db_table = 't_student'

        class StudentHome(models.Model):
            address = models.CharField(max_length=50)
            student = models.OneToOneField(Student, on_delete=models.CASCADE)

            class Meta:
                db_table = 't_student_home'
    ```

##### 操作
- 基本操作
    ```python
        # 增
        #
        # models.Tb1.objects.create(c1='xx', c2='oo')  增加一条数据, 可以接受字典类型数据 **kwargs

        # obj = models.Tb1(c1='xx', c2='oo')
        # obj.save()

        # 查
        #
        # models.Tb1.objects.get(id=123)         # 获取单条数据, 不存在则报错(不建议)
        # models.Tb1.objects.all()               # 获取全部
        # models.Tb1.objects.filter(name='seven') # 获取指定条件的数据

        # 删
        #
        # models.Tb1.objects.filter(name='seven').delete() # 删除指定条件的数据

        # 改
        # models.Tb1.objects.filter(name='seven').update(gender='0')  # 将指定条件的数据更新, 均支持 **kwargs
        # obj = models.Tb1.objects.get(id=1)
        # obj.c1 = '111'
        # obj.save()                                                 # 修改单条数据
    ```
- 进阶操作
    ```python
        # 获取个数
        #
        # models.Tb1.objects.filter(name='seven').count()

        # 大于, 小于
        #
        # models.Tb1.objects.filter(id__gt=1)              # 获取id大于1的值
        # models.Tb1.objects.filter(id__gte=1)              # 获取id大于等于1的值
        # models.Tb1.objects.filter(id__lt=10)             # 获取id小于10的值
        # models.Tb1.objects.filter(id__lte=10)             # 获取id小于10的值
        # models.Tb1.objects.filter(id__lt=10, id__gt=1)   # 获取id大于1 且 小于10的值

        # in
        #
        # models.Tb1.objects.filter(id__in=[11, 22, 33])   # 获取id等于11、22、33的数据
        # models.Tb1.objects.exclude(id__in=[11, 22, 33])  # not in

        # isnull
        # Entry.objects.filter(pub_date__isnull=True)

        # contains
        #
        # models.Tb1.objects.filter(name__contains="ven")
        # models.Tb1.objects.filter(name__icontains="ven") # icontains大小写不敏感
        # models.Tb1.objects.exclude(name__icontains="ven")

        # range
        #
        # models.Tb1.objects.filter(id__range=[1, 2])   # 范围bettwen and

        # 其他类似
        #
        # startswith, istartswith, endswith, iendswith,

        # order by
        #
        # models.Tb1.objects.filter(name='seven').order_by('id')    # asc
        # models.Tb1.objects.filter(name='seven').order_by('-id')   # desc

        # group by
        #
        # from django.db.models import Count, Min, Max, Sum
        # models.Tb1.objects.filter(c1=1).values('id').annotate(c=Count('num'))
        # SELECT "app01_tb1"."id", COUNT("app01_tb1"."num") AS "c" FROM "app01_tb1" WHERE "app01_tb1"."c1" = 1 GROUP BY "app01_tb1"."id"

        # limit 、offset
        #
        # models.Tb1.objects.all()[10:20]

        # regex正则匹配, iregex 不区分大小写
        #
        # Entry.objects.get(title__regex=r'^(An?|The) +')
        # Entry.objects.get(title__iregex=r'^(an?|the) +')

        # date
        #
        # Entry.objects.filter(pub_date__date=datetime.date(2005, 1, 1))
        # Entry.objects.filter(pub_date__date__gt=datetime.date(2005, 1, 1))

        # year
        #
        # Entry.objects.filter(pub_date__year=2005)
        # Entry.objects.filter(pub_date__year__gte=2005)

        # month
        #
        # Entry.objects.filter(pub_date__month=12)
        # Entry.objects.filter(pub_date__month__gte=6)

        # day
        #
        # Entry.objects.filter(pub_date__day=3)
        # Entry.objects.filter(pub_date__day__gte=3)

        # week_day
        #
        # Entry.objects.filter(pub_date__week_day=2)
        # Entry.objects.filter(pub_date__week_day__gte=2)

        # hour
        #
        # Event.objects.filter(timestamp__hour=23)
        # Event.objects.filter(time__hour=5)
        # Event.objects.filter(timestamp__hour__gte=12)

        # minute
        #
        # Event.objects.filter(timestamp__minute=29)
        # Event.objects.filter(time__minute=46)
        # Event.objects.filter(timestamp__minute__gte=29)

        # second
        #
        # Event.objects.filter(timestamp__second=31)
        # Event.objects.filter(time__second=2)
        # Event.objects.filter(timestamp__second__gte=31)
    ```

