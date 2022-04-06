---
title: Python_基础 (130)
date: 2022-01-13
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=mongoengine
    pymongo来操作mongodb数据库, 但是直接把数据库的操作代码写在脚本中, 使得应用代码的耦合性太强, 不利于代码的优化管理
    mongoengine是一个对象文档映射器(ODM), 相当于基于sql对象关系映射器(ORM)

<!-- more -->

#### 安装
- code
    ```bash
        pip install mongoengine
    ```

#### 创建model
- 创建model
    ```python
        from mongoengine import *
        connect('test', host='localhost', port=27017)

        # 文档都是继承Document类
        class User(Document):
            email = StringField(required=True)
            first_name = StringField(max_length=50)
            last_name = StringField(max_length=50)
    ```
- 数据库连接
    ```python
        # 直接写数据库名, 会默认使用localhost 和 27017
        connect('project1')
        # 类原生
        connect(host="mongodb://127.0.0.1:27017/my_db")
        connect(host="mongodb://my_user:my_password@127.0.0.1:27017/my_db")
        # 集群模式
        connect(host="mongodb://localhost,localhost:27018,localhost:27019/?replicaSet=test")
        # 设置每个关键字
        connect(
            db='test',
            username='user',
            password='12345',
            host='mongodb://admin:qwerty@localhost/production'
        )
        # 多个数据库
        connect(alias='user-db-alias', db='user-db')
        connect(alias='book-db-alias', db='book-db')
        connect(alias='users-books-db-alias', db='users-books-db')
    ```
- 多个数据库
    ```python
        connect(alias='user-db-alias', db='user-db')
        connect(alias='book-db-alias', db='book-db')
        connect(alias='users-books-db-alias', db='users-books-db')

        class User(Document):
            name = StringField()

            meta = {'db_alias': 'user-db-alias'}

        class Book(Document):
            name = StringField()

            meta = {'db_alias': 'book-db-alias'}

        class AuthorBooks(Document):
            author = ReferenceField(User)
            book = ReferenceField(Book)

            meta = {'db_alias': 'users-books-db-alias'}
    ```
- 链接另一个数据库
    ```python
        from mongoengine import connect, disconnect
        connect('a_db', alias='db1')

        class User(Document):
            name = StringField()
            meta = {'db_alias': 'db1'}

        disconnect(alias='db1')

        connect('another_db', alias='db1')
    ```
- 切换数据库/文档
    ```python
        # 切换数据库
        from mongoengine.context_managers import switch_db

        class User(Document):
            name = StringField()

            meta = {'db_alias': 'user-db'}

        with switch_db(User, 'archive-user-db') as User:
            User(name='Ross').save()  # Saves the 'archive-user-db'

        # 切换文档
        from mongoengine.context_managers import switch_collection

        class Group(Document):
            name = StringField()

        Group(name='test').save()  # Saves in the default db

        with switch_collection(Group, 'group2000') as Group:
            Group(name='hello Group 2000 collection!').save()  # Saves in group2000 collection
    ```
- 不固定字段
    ```python
        from mongoengine import *

        # 继承 DynamicDocument 即可
        class Page(DynamicDocument):
            title = StringField(max_length=200, required=True)

        # Create a new page and add tags
        >>> page = Page(title='Using MongoEngine')
        >>> page.tags = ['mongodb', 'mongoengine']
        >>> page.save()

        >>> Page.objects(tags='mongoengine').count()
        >>> 1
    ```
- 字段类型
    * StringField: 字符串.
    * ListField: 列表.列表里还可以传入字段规定列表内的字段类型, 例如ListField(StringField(max_length=30))
    * ReferenceField: 这是一个保存相关文档的filed
    * StringFiled(regex=None,max_length=None,min_lenght=None): 字符串类型
    * IntField(min_value=None,max_value=None): 整数类型
    * FloatField(min_value=None,max_value=None): 字符串类型
    * BooleanField(): 布尔类型
    * DateTimeField(): 时间类型
    * listField(): 可以插入列表的
    * DictField(): 字典类型
    * ReferenceField(): 参照类型
    * SequenceField(): 自动产生一个数列、 递增的
- 字段限制
    * required: 必须的.
    * max_length: 最大长度.
    * default: 默认值 也可以是一个函数 可调用类型
    * primary_key: 插入数据是否重复
    * null: 赋值是否可以为空
    * choices: 列表的范围
    * unique: 当前field只能是唯一的
    * unique_with: 和xxx联合成唯一键
- 继承model
    ```python
        class Post(Document):
            title = StringField(max_length=120, required=True)
            author = ReferenceField(User)
            # allow_inheritance设置为true是必须的
            meta = {'allow_inheritance': True}

        class TextPost(Post):
            content = StringField()

        class ImagePost(Post):
            image_path = StringField()

        class LinkPost(Post):
            link_url = StringField()
    ```
- 内嵌文档
    ```python
        # 继承了EmbeddedDocument类, 声明了他就是一个内嵌的文档
        class Comment(EmbeddedDocument):
            content = StringField()
            name = StringField(max_length=120)

        class Post(Document):
            title = StringField(max_length=120, required=True)
            author = ReferenceField(User)
            tags = ListField(StringField(max_length=30))
            comments = ListField(EmbeddedDocumentField(Comment))
    ```
- 关联删除
    ```python
        class Post(Document):
            title = StringField(max_length=120, required=True)
            # DO_NOTHING (0) - don’t do anything (default).
            # NULLIFY (1) - Updates the reference to null.
            # CASCADE (2) - Deletes the documents associated with the reference.
            # DENY (3) - Prevent the deletion of the reference object.
            # PULL (4) - Pull the reference from a ListField of references
            author = ReferenceField(User, reverse_delete_rule=CASCADE)
            tags = ListField(StringField(max_length=30))
            comments = ListField(EmbeddedDocumentField(Comment))
    ```


