---
title: Python_基础 (50)
date: 2020-11-12
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django ORM中的表关系

<!-- more -->

#### 前情提要
> 这还是毕业到现在第一次用外键呢 我人都傻了 快来捡一捡外键吧

#### 一对一
> 为了方便理解,设定使用OneToOneField字段所在的表为从表,OneToOneField字段连接的表为主表
- 使用场景
    * 一般网站做用户信息统计的时候,通常会做两张表,一张存储常用信息,一张存储不常用的信息,这样做的目的也是为了查询的效率,此时这两张表就是一对一的关系
- eg
    ```python
        class User(models.Model):
            """用户模型"""
            name = models.CharField(max_length=64)
            password = models.CharField(max_length=64)
            age = models.PositiveSmallIntegerField()
        
        class UserExtra(models.Model):
            """用户拓展模型"""
            user = models.OneToOneField(User,on_delete=models.CASCADE,related_name='extra')
            birthday = models.DateField()
            address = models.CharField(max_length=128)
    ```
- 详解
    * 在使用OneToOneField时,在从表中会生成一个该字段名+_id的字段,如user_id,而在主表中则会生成一个从表名小写的属性,用来关联从表中的相关数据,如userextra.当然在OneToOneField中你也可以传递一个related_name的参数,如'extra',这时候主表中数据就可以使用该参数的值去关联从表中的相关数据.
- 一对一**增**
    ```python
        user = User(name='李毛毛',password='limaomao',age=23)
        user.save()
        userextra = UserExtra(birthday=date,address='杭州市西湖区')
        userextra.user = user
        userextra.save()
    ```
- 一对一**查**
    * 已知从表中的一条数据,查询主表中相关数据
        ```python
            userextra = UserExtra.objects.first()
            print(userextra.user)
        ```
    * 已知主表中的一条数据,查询从表中相关数据
        ```python
            user = User.objects.first()
            userextra = user.extra
            print(userextra)
        ```

#### 一对多
> 为了方便理解,两个表之间使用ForeignKey连接时,使用ForeignKey的字段所在的表为从表,被ForeignKey连接的表为主表.
- 使用场景
    * 书和出版社之间的关系,一本书只能由一个出版社出版,一个出版社却可以出版很多书. 
    * 出版社的主键是书的外键
    * 出版社是主表 书是从表
- eg
    ```python
        class Publisher(models.Model):
            """出版社模型"""
            id = models.AutoField(primary_key=True)
            name = models.CharField(max_length=64,blank=True)
            mobile = models.CharField(max_length=11,unique=True)

        class Book(models.Model):
            """图书模型"""
            name = models.CharField(max_length=64,blank=True)
            content = models.TextField(blank=True)
            pub_time = models.DateTimeField(auto_now_add=True)
            publisher= models.ForeignKey(Publisher,on_delete=models.SET_NULL,null=True,related_name='books')
    ```
- 详解
    * 表中使用ForeignKey时,从表中会生成(该字段名+_id)的字段,该示例中在Book表中会生成publisher_id的字段,而在主表中则会默认的为我们添加一个(从表名小写+_set的属性),该属性是一个类似于objects的ReleatedManager对象,在该示例中默认应该是生成一个book_set的ReleatedManager对象,如果我们想要使用其他的名字代替(从表名小写+_set),我们需要在从表中使用ForeignKey的时候传递一个related_name参数,以后这个参数的值就会代替(从表名小写+_set),并且拥有其的所有属性和方法
- 一对多**增**
    ```bash
        # 写法1
        publisher = Publisher(name='北京大学出版社',mobile='13395676110')
        publisher.save()
        book = Book(name='三国',content='东汉末年群雄争霸的故事')
        book.publisher = publisher
        book.save()

        # 写法2
        publisher = Publisher(name='安徽出版社',mobile='16665678912',email='2399364196@qq.com')
        publisher.save()
        book = Book(name='梁祝',content='梁山伯与祝英台的爱情故事')
        publisher.books.add(book,bulk=False)　　 # 注意bulk参数的使用,如果book还没有在数据库中,当设置为FALSE,同时books的使用是因为我们设置了related_name='books'.
    ```
- 一对多**查**
    * 已知从表中的数据,查询主表中的数据,在此例中就是已知图书,查询这本书的出版社
        ```bash
            book = Book.objects.filter(pk=2).first()
            print(book.publisher)
        ```
    * 已知主表中的一条数据,查询出从表使用外键与之关联的所有数据,这时候我们就应该使用(从表名小写+_set)这个RelatedManager对象进行查询
        ```bash
            publisher = Publisher.objects.filter(pk=2).get()
            books = publisher.book_set.all()
            for book in books:
                print(book)
        ```

#### 多对多
> 首先,为了方便理解,我们把使用ManyToManyField的字段所在的表称为从表,被连接的表称为主表
- 使用场景
    * 图书和作者之间关系,一本书可以有多个作者,一个作者可以写多本书
- eg
    ```python
        class Author(models.Model):
            """作者模型"""
            name = models.CharField(max_length=32)
            age = models.PositiveSmallIntegerField()
            books = models.ManyToManyField('Book',related_name='authors')

        class Book(models.Model):
            """图书模型"""
            name = models.CharField(max_length=64,blank=True)
            content = models.TextField(blank=True)
            publisher = models.ForeignKey(Publisher, on_delete=models.SET_NULL, null=True, related_name='books')
    ```
- 详解
    * 当使用多对多的方式实现连表操作时,主表中将会自动被赋予一个从表名小写+_set的属性,这是一个ManyRelatedManager对象,这个属性名称当然也同样可以被简化成related_name所赋予的值,利用这个属性,我们可以在已知主表中的一条数据的情况下,查询出从表中所有与之关联的数据,同样这个属性同样也支持add函数,但是这个add函数与多对一之中的add函数不同,不能使用bulk参数,所以这里的添加操作都是已经在数据库中存在的数据,如果原先不存在,则必须先使用save函数保存到数据库.其实在从表中使用ManyToManyField的字段同样会变成一个属性,它同样也是一个ManyRelatedManager对象,因此多对多可以看做一个对称的过程
- 多对多**增**
    ```python
        def many_to_many_view(request):
            author = Author(name='徐大蒙',age=24)
            author.save()
            book = Book.objects.first()
            book.author_set.add(author)
            return HttpResponse('success')
    ```
- 多对多**查**
    * 已知从表中的数据,查询主表中与之关联的所有数据
        ```python
            author = Author.objects.first()
            books = author.books.all()　　 
            for book in books：
                print(book)
        ```
    * 已知主表中的数据查询从表中所有与之相关的数据
        ```python
            book = Book.objects.get(pk=2)
            authors = book.author_set.all()
            for author in authors:
                print(author)
        ```

