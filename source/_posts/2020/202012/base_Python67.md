---
title: Python_基础 (67)
date: 2020-12-21
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    连表查询

<!-- more -->

#### 使用场景
> 因为涉及到多个表的字段, 让我用原生sql还好, 我直接左连或者内联就完事了, 但设计到orm就有点懵, 我也不想一个表一个表查, 然后循环每个查询结果去下一个表里查, 感觉有点呆瓜, 专门学一下吧, 可以简化好多代码

#### 建立外键
- models.py
    ```python
        # 一对一建立外键
        # 外键名称 = models.OneToOneField(to='要连接的类名', to_field='字段')

        # 一对多建立外键
        # 外键名称 = models.ForeignKey(to='要连接的类名',to_field='字段')

        # 外键要写在一对多的 那个多的类 下面,比如一个老师对应很多学生,外键就要写在学生的下面
        # 多对多建立外键
        # 外键名称 = models.ManyToManyField(to='另一个类名')
        # 这个外键名称(属性)要写在其中一个类的下面,然后to=另一个类名, 这个外键就相当于第三张表(多对多建立外键必须通过第三张表)
    ```

#### 多表查询(基于子查询)
- models.py
    ```python
        # models.py创建表
        class Author(models.Model):
            id = models.AutoField(primary_key=True)
            name = models.CharField(max_length=16)
            age = models.IntegerField()
            # to后面加类名 to_field后面写类名中的字段名   这是一对一的外键写法
            author_detail = models.OneToOneField(to='AuthorDetail', to_field='id')
            def __str__(self):
                return self.name

        class AuthorDetail(models.Model):
            id = models.AutoField(primary_key=True)
            addr = models.CharField(max_length=16)
            tel = models.IntegerField()

        class Publish(models.Model):
            id = models.AutoField(primary_key=True)
            name = models.CharField(max_length=16)
            addr = models.CharField(max_length=16)

        class Book(models.Model):
            id = models.AutoField(primary_key=True)
            name = models.CharField(max_length=16)
            price = models.DecimalField(max_digits=6,decimal_places=2)
            # 在Book上publish变成了publish_id   这是一对多的外键写法
            publish = models.ForeignKey(to='Publish',to_field='id')
            #  这个authors不是字段,他只是Book类里面的一个属性  这是多对多的建立第三张表的写法
            authors = models.ManyToManyField(to='Author')
    ```
- 再来一张图说明一下
    ![models.py说明](/img/20201221_1.png)

#### 多对多第三张表的操作
- book_authors
    ```python
        # 给id=1的书籍添加id=5和id=6这两个作者
        book_obj = models.Book.objects.filter(id=1)[0]
        book_obj.authors.add(*[5, 6])   #  数字的类型是int或者str都行

        # 把id=1的书籍的作者全部删掉
        book_obj = models.Book.objects.filter(id=1)[0]
        book_obj.authors.clear()

        # 把id=1的书籍中的id=5和id=6的这两个作者删掉 
        book_obj = models.Book.objects.filter(id=1)[0]
        book_obj.authors.remove(*[5, 6])

        # 把id=1的书籍中的作者名更新成id=7和id=8这两个作者
        book_obj = models.Book.objects.filter(id=1)[0]
        book_obj.authors.set([7, 8])
        # set 不能用*[7, 8]      set的执行流程是先把作者全部删除,然后添加[7, 8]
    ```

#### 一对一正向查询
- 外键在哪个表,他找别人就是正向
    ```python
        # 萧峰的住址
        author_obj = models.Author.objects.get(name='萧峰')
        # author_obj.外键名.要查字段  
        print(author_obj.author_detail.addr)

    　　 # author_detail = models.OneToOneField(to='AuthorDetail', to_field='id')
        # 这个author_detail就是外键名
    ```

#### 一对一反向查询
- 没有外键的表查询有外键的表就是反向查询
    ```python
        # 地址是大理的英雄名字
        author_detail_obj = models.AuthorDetail.objects.get(addr='大理')
        # author_detail_obj.要查询的表名(要小写).要查字段
        print(author_detail_obj.author.name)
    ```

#### 一对多正向查询
- eg
    ```python
         # 出版天龙八部的出版社名字
        book_obj = models.Book.objects.get(name='天龙八部')
        # book_obj.外键名.要查字段    
        print(book_obj.publish.name)
    ```

#### 一对多反向查询
- eg
    ```python
        # 查询城市是西夏的出版社 出版的图书
        pub_obj = models.Publish.objects.get(addr='西夏')
        # pub_obj.表名_set.all().values('name')   因为不止一个所以需要  表名_set
        print(pub_obj.book_set.all().values('name'))
    ```

#### 多对多正向查询
- eg
    ```python
        # 天龙八部的作者都有谁
        book_obj = models.Book.objects.get(name='天龙八部')
        # book_obj.第三张表的属性.all().values(字段)
        print(book_obj.authors.all().values('name'))  # 这个authors虽然在Book类下面,但是它不是字段,只是属性.
    ```

#### 多对多反向查询
- eg
    ```python
        # 令狐冲写了哪些书
        author_obj = models.Author.objects.get(name='令狐冲')
        # author_obj.表名_all().values(字段)
        print(author_obj.book_set.all().values('name'))
    ```
#### 跨表查询
- 一对一
    ```python
        # 查询萧峰作者的电话号
        # 正向查询     按照外键    "__" 这个是双下划线
        # models.类名(表名).objects.filter(条件).values(外键名__字段)
        ret = models.Author.objects.filter(name='萧峰').values('author_detail__tel')

        # 反向查询   按照类名(小写)
        # models.类名.objects.filter(另一个类名(小写)__条件).values(字段)
        ret = models.AuthorDetail.objects.filter(book__name='萧峰').values('tel')
    ```
- 一对多
    ```python
        # 金庸出版社出版过的所有书籍的名字
        # 正向查询  按照外键
        # models.类名.objects.filter(外键名__条件).values(字段)
        ret = models.Book.objects.filter(publish__name='金庸出版社').values('name')

        # 反向查询 按照类名(小写)
        # models.类名.objects.filter(条件).values(另一个类名(小写)__字段)
        ret = models.Publish.objects.filter(name='金庸出版社').values('book__name')
    ```
- 多对多
    ```python
        # 萧峰这个作者写了哪几本书
        # 正向查询  按照外键
        # models.类名.objects.filter(外键__条件).values(字段)
        ret = models.Book.objects.filter(authors__name='萧峰').values('name')

        # 反向查询  按照类名
        # models.类名.objects.filter(条件).values(另一个类名__字段)
        ret = models.Author.objects.filter(name='萧峰').values('book__name')
    ```
- 连续跨表
    ```python
        # 查询金庸出版社出版的所有的书名及作者名
        # 正向查询
        ret = models.Book.objects.filter(publish__name='金庸出版社').values('name','authors__name')

        # 反向查询
        ret = models.Publish.objects.filter(name='金庸出版社').values('book__name','book__authors__name')
        # 由于Author和Publish两个表没有外键关系所以需要通过Book表找到作者名

            # 电话以6开头的作者出版过的书名及出版社名
        # 正向查询 
        ret = models.Book.objects.filter(authors__author_detail__tel__startswith='6').values('name','publish__name')    

        # 反向查询 
        # 方法一
        ret = models.Publish.objects.filter(book__authors__author_detail__tel__startswith='6').values('name','book__name')

        # 方法二
        ret = models.AuthorDetail.objects.filter(tel__startswith='6').values('author__book__name','author__book__publish__name')
        # 由于Author与Book是多对多的关系,并且authors写在Book下面,所以通过author往回找的时候直接author__book.
    ```

#### 聚合查询
- eg
    ```python
        # aggregate(*args, **kwargs)    是queryset的终结,queryset对象后面.aggregate得到一个字典不再是queryset对象
        # 计算所有书的平均价格
        from django.db.models import Avg
        models.Book.objects.all().aggregate(Avg('price'))   # 也可以给它起名字 aggregate(a = Avg('price'))  
        # 这个objects后面的 all()写不写都行  可以直接在控制器(models.Book.objects)后面写
            
        # 还可以不止生成一个聚合函数
        from django.db.models import Avg,Max,Min
        models.Book.objects.aggregate(Avg('price'),Max('price'),Min('price'))
    ```

#### 分组查询
- eg
    ```python
        # 查询每个出版社出版了多少本书      annotate里面写聚合函数(Max,Min,Avg,Count)  得到一个queryset对象
        models.Book.objects.values('publish').annotate(c=Count('id'))  
        # values里面写的是要分组的字段,每个出版社意思就是以出版社为分组, annotate里面写你要统计的, 而且必须是 别名=聚合函数这个格式

        # 查询每个出版社出版了多少本书
        models.Publish.objects.values('name').annotate(c=Count('book__id'))
        # 下面这个方法比较常用
        models.Publish.objects.annotate(c=Count('book__id')).values('name','c')
    ```

#### F查询
- eg
    ```python
        # 比如说在Book表里面加上评论数comment_num 和点赞数support_num
        # 查询评论数大于点赞数的书
        from django.db.models import F
        models.Book.objects.filter(comment_num__gt=F('support_num'))
    
        # django 还支持F()对象之间以及F()对象与常数之间的加减乘除
        models.Book.objects.filter(comment_num__gt=F('support_num')*2)

        # 也可以用F()来进行修改
        # 把每本书的价格添加1000
        models.Book.objects.update(price=F('price')+1000)
    ```

#### Q查询
- eg
    ```python
        # Q对象可以使用$(and)   |(or)   ~(not) 操作组合起来. 当一个操作符用在两个Q对象上面时,这两个Q对象由于操作符的作用就变成了一个新的对象.
        # 查询作者名字为萧峰或者段誉出版的书
        models.Book.objects.filter(Q(authors__name='萧峰')|Q(authors__name='段誉'))

        # 可以组合其他的操作符进行操作
        # 查询作者是萧峰或者是段誉价格不高于100的书
        models.Book.objects.filter(Q(author__name='萧峰')|Q(author__name='段誉')& ~Q(price__gt=100))

        # 如果有关键字参数和Q查询同时在筛选条件里面,Q查询必须要写到关键字参数前面
        # 查询作者名字是萧峰或者是段誉的价格为100 的书
        models.Book.objects.filter(Q(author__name='萧峰')|Q(author__name='段誉'),price=100)
        # 这个关键字参数要写到Q查询的后面,中间用逗号隔开,表示and的意思
    ```

