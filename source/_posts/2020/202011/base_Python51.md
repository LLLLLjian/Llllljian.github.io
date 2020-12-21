---
title: Python_基础 (51)
date: 2020-11-13
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    再来一碗ORM

<!-- more -->

#### 前情提要
> 今天仔细想了一下为啥要用外键！为啥要用ORM！为啥不让我写原生SQL连表查！今天想到了呀, 不是所有人都要一直使用mysql的, 如果换个数据库 你要把整套代码全重写一遍吗?

#### demo1
- model.py
    ```python
        '''
            1. 一个商品对应一个类别 一对一
            2. 多个商家对应多个类别 多对多
        '''
        # 商品
        class Goods(models.Model):
            g_name = models.CharField(max_length=20)
            g_price = models.DecimalField(max_digits=5, decimal_places=2)
            gc = models.ForeignKey("Category", null=True, on_delete=models.SET_NULL)

        # 类别
        class Category(models.Model):
            c_name = models.CharField(max_length=20)

        # 商家
        class Store(models.Model):
            s_name = models.CharField(max_length=30)
            s_detail = models.TextField(blank=True, null=True)
            sc = models.ManyToManyField("Category")#与类别表进行多对多关联
    ```
- POST
    ```python
        # 添加商家
        >>> from blog.models import Store
        >>> Store.objects.create(s_name="商家A", s_detail="物美价廉，抄底折扣。。。。")
        <Store: Store object (1)>
        >>> >>> Store(s_name="商家B", s_detail="大促销").save()

        # 添加分类
        >>> from blog import models
        >>> models.Category.objects.create(c_name="电脑整机")
        <Category: Category object (1)>
        >>> Category(c_name="文具耗材").save()
        >>> models.Category(c_name="文具耗材").save()

        # 为商家C添加全部的分类(商家C不存在)
        >>> category_list = models.Category.objects.all()
        >>> print(category_list)
        <QuerySet [<Category: Category object (1)>, <Category: Category object (2)>]>
        >>> models.Store.objects.create(s_name="商家C").sc.add(*category_list)

        # 为商家C添加全部的分类(商家C已存在)
        store_info = models.Store.objects.get(s_name="商家C")
        store_info.sc=(Category.objects.all())
        store_info.save()

        # 创建商家D添加指定分类
        store = Store.objects.create(s_name="商家D")
        category = Category.objects.filter(c_name__in=["电脑整机","文具耗材"])#单个改成get，全部改成all
        store.sc.add(*category)#add是追加模式
        store.sc.clear()#清空此商家的商品

        # 让指定商品分类添加指定的商家，反向查询
        store = Store.objects.create(s_name="商家E")
        category = Category.objects.get(c_name="电脑整机")
        category.store_set.add(store)

        # 让所有商家都添加这个分类
        stores = Store.objects.all()
        category = Category.objects.get(c_name="电脑整机")
        category.store_set.add(*stores)

        category.store_set.clear()# 让所有商家去除这个分类
        category.store_set.all().delete()# 是删除store_set的所有商家
        # 只有子表才有"子表名小写_set"的写法，得到的是一个QuerySet集合，后边可以接.add(),.remove(),.update(),.delete(),.clear()
    ```
- GET
    ```python
        # 查询商家C所有的类别(从商家表查) 
        # 子表对象.子表多对多字段.过滤条件(all()/filter())
        >>> models.Store.objects.get(s_name="商家C").sc.all()
        <QuerySet [<Category: Category object (1)>, <Category: Category object (2)>]>
        Category.objects.filter(store__s_name="商家C")
        # 查询商家C所有的类别(从类别表查)
        # 母表对象.filter(子表表名小写__子表字段名="过滤条件")
        >>> models.Category.objects.filter(store__s_name="商家C")
        <QuerySet [<Category: Category object (1)>, <Category: Category object (2)>]>

        # 查询某个类别的所有商家
        >>> models.Category.objects.get(c_name="电脑整机").store_set.all() # 子表对象.母表__set.all()
        <QuerySet [<Store: Store object (4)>]>
        >>> models.Store.objects.filter(sc=models.Category.objects.get(c_name="电脑整机")) # filete(子表外键字段=母表主键对象)
        <QuerySet [<Store: Store object (4)>]>
        >>> models.Store.objects.filter(sc__c_name="电脑整机") # filter(子表外键字段__母表字段='过滤条件')
        <QuerySet [<Store: Store object (4)>]>
    ```
- DELETE
    ```python
        # 让指定商家清空分类
        >>> store_info = models.Store.objects.get(s_name="商家C")
        >>> store_info.sc.set("")
        >>> store_info.save() # 方法1 设置为空
        >>> category_info = models.Category.objects.all()
        >>> store_info.sc.remove(*category_info) # 方法2 移除所有
        >>> store_info.sc.clear() # 方法3 清除所有

        # 让所有商家去掉指定分类
        >>> store_list = models.Store.objects.all()
        >>> category_info = models.Category.objects.get(c_name="电脑整机")
        (0.002) SELECT `blog_category`.`id`, `blog_category`.`c_name` FROM `blog_category` WHERE `blog_category`.`c_name` = '电脑整机' LIMIT 21; args=('电脑整机',)
        >>> category_info.store_set.remove(*store_list)
        (0.001) SELECT `blog_store`.`id`, `blog_store`.`s_name`, `blog_store`.`s_detail` FROM `blog_store`; args=()
        (0.001) DELETE FROM `blog_store_sc` WHERE (`blog_store_sc`.`category_id` = 1 AND `blog_store_sc`.`store_id` IN (1, 2, 3, 4)); args=(1, 1, 2, 3, 4)

        category_info = Category.objects.get(c_name="电脑整机")
        category_info.store_set.clear()

        # 删除商家子表数据
        # 删除所有指定分类的全部商家
        >>> category_info = models.Category.objects.get(c_name="电脑整机")
        (0.000) SELECT `blog_category`.`id`, `blog_category`.`c_name` FROM `blog_category` WHERE `blog_category`.`c_name` = '电脑整机' LIMIT 21; args=('电脑整机',)
        >>> category_info.store_set.all().delete()
        (0.001) SELECT `blog_store`.`id`, `blog_store`.`s_name`, `blog_store`.`s_detail` FROM `blog_store` INNER JOIN `blog_store_sc` ON (`blog_store`.`id` = `blog_store_sc`.`store_id`) WHERE `blog_store_sc`.`category_id` = 1; args=(1,)
        (0, {})

        # 删除所有商家
        >>> models.Store.objects.all().delete()
        (0.001) SELECT `blog_store`.`id`, `blog_store`.`s_name`, `blog_store`.`s_detail` FROM `blog_store`; args=()
        (0.000) DELETE FROM `blog_store_sc` WHERE `blog_store_sc`.`store_id` IN (1, 2, 3, 4); args=(1, 2, 3, 4)
        (0.002) DELETE FROM `blog_store` WHERE `blog_store`.`id` IN (4, 3, 2, 1); args=(4, 3, 2, 1)
        (4, {'blog.Store': 4})
    ```


