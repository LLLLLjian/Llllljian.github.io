---
title: Python_基础 (52)
date: 2020-11-16
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    D哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    什么 一碗都喝不够？ 那再来一碗！

<!-- more -->

#### 前情提要
> 我为什么又不会ORM了 再干一碗！！

#### ORM单表操作
- orm使用方式
    * orm操作可以使用类实例化,obj.save的方式,也可以使用create()的形式
- QuerySet数据类型介绍
    * 惰性机制
        * Publisher.objects.all()或者.filter()等都只是返回了一个QuerySet(查询结果集对象),它并不会马上执行sql,而是当调用QuerySet的时候才执行.
    * 特点
        * 可迭代的 
        * 可切片
        * 惰性计算和缓存机制
- demo
    ```python
        def queryset(request):
            books=models.Book.objects.all()[:10]  #切片 应用分页
            books = models.Book.objects.all()[::2]
            book= models.Book.objects.all()[6]    #索引
            print(book.title)
            for obj in books:                     #可迭代
                print(obj.title)
            books=models.Book.objects.all()          #惰性计算--->等于一个生成器,不应用books不会执行任何SQL操作
            # query_set缓存机制1次数据库查询结果query_set都会对应一块缓存,再次使用该query_set时,不会发生新的SQL操作；
            #这样减小了频繁操作数据库给数据库带来的压力;
            authors=models.Author.objects.all()
            for author in  authors:
                print(author.name)
            print('-------------------------------------')
            models.Author.objects.filter(id=1).update(name='张某')
            for author in  authors:
                print(author.name)
            #但是有时候取出来的数据量太大会撑爆缓存,可以使用迭代器优雅得解决这个问题；
            models.Publish.objects.all().iterator()
            return HttpResponse('OK')
    ```
- POST
    ```python
        # 单表
        # 1. 表.objects.create()
        models.Publish.objects.create(name='浙江出版社', addr="浙江.杭州")
        models.Classify.objects.create(category='武侠')
        models.Author.objects.create(name='金庸', sex='男', age=89, university='东吴大学')
        # 2. 类实例化：obj=类(属性=XX) obj.save()
        obj = models.Author(name='吴承恩', age=518, sex='男', university='龙溪学院')
        obj.save()

        # 1对多
        # 1. 表.objects.create()
        models.Book.objects.create(title='笑傲江湖', price=200, date=1968, classify_id=6, publish_id=6)
        # 2. 类实例化：obj=类(属性=X,外键=obj)obj.save()
        classify_obj = models.Classify.objects.get(category='武侠')
        publish_obj = models.Publish.objects.get(name='河北出版社')
        # 注意以上获取得是和 book对象 向关联的(外键)的对象
        book_obj=models.Book(title='西游记', price=234, date=1556, classify=classify_obj, publish=publish_obj)
        book_obj.save()
    
        # 多对多
        # 如果两表之间存在双向1对N关系,就无法使用外键来描述其关系了；只能使用多对多的方式,新增第三张表关系描述表；
        book = models.Book.objects.get(title='笑傲江湖')
        author1 = models.Author.objects.get(name='金庸')
        author2 = models.Author.objects.get(name='张根')
        book.author.add(author1, author2)

        # 书籍和作者是多对多关系,
        # 切记：如果两表之间存在多对多关系,例如书籍相关的所有作者对象集合,作者也关联的所有书籍对象集合
        book = models.Book.objects.get(title='西游记')
        author = models.Author.objects.get(name='吴承恩')
        author2 = models.Author.objects.get(name='张根')
        book.author.add(author, author2)
        #add()   添加
        #clear() 清空
        #remove() 删除某个对象
    ```
- DELETE
    * 这个操作太敏感了 不学了
- PUT
    ```python
        # 修改方式1 update()
        models.Book.objects.filter(id=1).update(price=3)

        # 修改方式2 obj.save() 
        book_obj = models.Book.objects.get(id=1)
        book_obj.price=5
        book_obj.save()
    ```
- GET
    ```python
        books = models.Book.objects.all()                               #------query_set对象集合 [对象1、对象2、.... ]
        books = models.Book.objects.filter(id__gt=2,price__lt=100) 
        book = models.Book.objects.get(title__endswith='金')            #---------单个对象,没有找到会报错
        book1 = models.Book.objects.filter(title__endswith='金').first()
        book2 = models.Book.objects.filter(title__icontains='瓶').last()
        books = models.Book.objects.values('title','price',             #-------query_set字典集合 [{一条记录},{一条记录} ]
                                    'publish__name',
                                    'date',
                                    'classify__category',         #切记 正向连表:外键字段___对应表字段
                                    'author__name',               #反向连表： 小写表名__对应表字段
                                    'author__sex',                #区别：正向 外键字段__,反向 小写表名__
                                    'author__age',
                                    'author__university')
        books = models.Book.objects.values('title','publish__name').distinct()  # exclude 按条件排除...
                                                                                # distinct()去重
                                                                                # exits()查看数据是否存在？ 返回 true 和false

        # 连表查询
        # 1. 通过object的形式反向连表, obj.小写表名_set.all()
        publish = models.Publish.objects.filter(name__contains='湖南').first()
        books = publish.book_set.all()
        for book in  books:
            print(book.title)
        # 通过object的形式反向绑定外键关系
        authorobj = models.Author.objects.filter(id=1).first()
        objects = models.Book.objects.all()
        authorobj.book_set.add(*objects)
        authorobj.save()
    
        # 2. 通过values双下滑线的形式,objs.values("小写表名__字段")
        # 注意对象集合调用values(),正向查询是外键字段__XX,而反向是小写表名__YY看起来比较容易混淆；
        books = models.Publish.objects.filter(name__contains='湖南').values('name','book__title')
        authors = models.Book.objects.filter(title__icontains='我的').values('author__name')
        print(authors)
        # fifter()也支持__小写表名语法进行连表查询：在publish标查询 出版过《笑傲江湖》的出版社
        publishs = models.Publish.objects.filter(book__title='笑傲江湖').values('name')
        print(publishs)
        # 查询谁(哪位作者)出版过的书价格大于200元
        authors = models.Author.objects.filter(book__price__gt=200).values('name')
        print(authors)
        # 通过外键字段正向连表查询,出版自保定的书籍；
        city = models.Book.objects.filter(publish__addr__icontains='保定').values('title')
        print(city)
    ```


