---
title: Python_基础 (84)
date: 2021-03-10
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    日常积累(其实是踩坑)

<!-- more -->

#### 踩坑
> 要不你试试django中的group by, 看看有没有坑
1. models.py
    ```python
        class Tag(models.Model):
        """
        项目标签的数据库模型
        """
        tag = models.CharField(max_length=20)
        user = models.ForeignKey(User, on_delete=models.CASCADE)

        class Meta:
            """
            表特性
            """
            ordering = ('tag', ) # 按标签名排序
            unique_together = (("tag",),)# 唯一键是标签名
    ```
2. 需求
    * 按人查一下标签数量
        ```python
            import models
            from django.db.models import Count

            # SELECT count(user_id) AS c, user_id FROM tag GROUP BY user_id;
            group_by_info = models.Tag.objects.filter().values("user_id").annotate(c=Count("user_id"))
        ```
3. 输出结果
    ```sql
        mysql> SELECT count(user_id) AS c, user_id FROM tag GROUP BY user_id;
        +---+---------+
        | c | user_id |
        +---+---------+
        | 1 |       3 |
        | 2 |      24 |
        +---+---------+
    ```
    ```python
        >>> group_by_info = models.Tag.objects.filter().values("user_id").annotate(c=Count("user_id"))
        >>> group_by_info
        (0.000) SELECT `tag`.`user_id`, COUNT(`tag`.`user_id`) AS `c` FROM `tag` GROUP BY `tag`.`user_id`, `tag`.`tag` LIMIT 21; args=()
        <QuerySet [{'user_id': 3, 'c': 1}, {'user_id': 24, 'c': 1}, {'user_id': 24, 'c': 1}]>
    ```
4. 结论
    * 结果为什么不一样呀, 打开原始sql发现group_by_info时, groupby的是 user_id,tag
    * 当在model的Meta中定义了排序字段,那么在进行group by 时,会将排序字段作为分组的条件
    * 避免这种情况
        * 删除ordering字段(不太合理)
        * 使用annotate().order_by()覆盖掉Meta中的排序定义
            ```python
                >>> group_by_info = models.Tag.objects.filter().values("user_id").annotate(c=Count("user_id")).order_by()
                >>> group_by_info
                (0.000) SELECT `test_tag`.`user_id`, COUNT(`test_tag`.`user_id`) AS `c` FROM `test_tag` GROUP BY `test_tag`.`user_id` ORDER BY NULL LIMIT 21; args=()
                <QuerySet [{'user_id': 3, 'c': 1}, {'user_id': 24, 'c': 2}]
            ```
