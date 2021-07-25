---
title: Python_基础 (60)
date: 2020-12-10
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django的ORM深入学习

<!-- more -->

#### 先说说我想做的事
1. 我需要查询的一张表, 里边有个字段类型是text, 查询的结果用到的时候就很烦, 那mysql我肯定是用什么才取什么呀, 所以就查到了value

#### orm.value
1. values
    * 字典列表
    ```python
        >>> test_values = models.Project.objects.all().values("project")
        >>> 
        >>> print(test_values)
        <QuerySet [{'project': 'bai8700'}, {'project': 'bai8700_12'}, {'project': 'bai8700_123'}, {'project': 'bai8700_234567234'}, {'project': 'bai8700_3'}, {'project': 'bai8700_4'}, {'project': 'bai8700_5'}, {'project': 'hognse'}, {'project': 'opencdn'}, {'project': 'testproject3'}, {'project': 'testproject3444'}]>
    ```
2. values_list
    * 元组列表
    ```python
        >>> test_values_list = models.Project.objects.all().values_list("project")
        >>> 
        >>> print(test_values_list)
        <QuerySet [('bai8700',), ('bai8700_12',), ('bai8700_123',), ('bai8700_234567234',), ('bai8700_3',), ('bai8700_4',), ('bai8700_5',), ('hognse',), ('opencdn',), ('testproject3',), ('testproject3444',)]>
    ```
3. values_list&flat
    * 值列表
    ```python
        >>> test_values_list = models.Project.objects.all().values_list("project", flat=True)
        >>> 
        >>> print(test_values_list)
        <QuerySet ['bai8700', 'bai8700_12', 'bai8700_123', 'bai8700_234567234', 'bai8700_3', 'bai8700_4', 'bai8700_5', 'hognse', 'opencdn', 'testproject3', 'testproject3444']>
    ```

#### 那肯定也学学别的呀
1. 获取个数
    * count
    ```python
        >>> models.Project.objects.filter().count()
        SELECT COUNT(*) AS `__count` 
        FROM `project`;
        11
    ```
2. 大于, 小于
    * gt/lt/gte/lte
    ```python
        >>> models.Project.objects.filter(id__gt=1)
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `project` 
        WHERE `id` > 1 
        ORDER BY `project` ASC 
        LIMIT 21

        >>> models.Project.objects.filter(id__gte=1)
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `id` >= 1 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter(id__lt=1)
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `id` < 1 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter(id__lte=1)
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `id` <= 1 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter(id__lte=1, id__gte=5)
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE (`id` >= 5 AND `id` <= 1) 
        ORDER BY `project` ASC 
        LIMIT 21;
    ```
3. in
    ```python
        >>> models.Project.objects.filter(id__in=[1, 2, 3])
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `id` IN (1, 2, 3) 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.exclude(id__in=[1, 2, 3])
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE NOT (`id` IN (1, 2, 3)) 
        ORDER BY `project` ASC 
        LIMIT 21;
    ```
4. like
    ```python
        >>> models.Project.objects.filter(project__contains="llllljian")
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `project` 
        LIKE BINARY '%llllljian%' 
        ORDER BY `project` ASC LIMIT 21;

        >>> models.Project.objects.filter(project__icontains="llllljian")
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `project` LIKE '%llllljian%' 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.exclude(project__icontains="llllljian")
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE NOT (`project` LIKE '%llllljian%') 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter(project__startswith='llllljian')
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `project` 
        LIKE BINARY 'llllljian%' 
        ORDER BY `project` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter(project__endswith='llllljian')
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `project` 
        LIKE BINARY '%llllljian' 
        ORDER BY `project` ASC 
        LIMIT 21;
    ```
5. range
    ```python
        >>> models.Project.objects.filter(id__range=[1, 2])
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        WHERE `id` BETWEEN 1 AND 2 
        ORDER BY `project` ASC 
        LIMIT 21;
    ```
6. order by
    ```python
        >>> models.Project.objects.filter().order_by("id")
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        ORDER BY `id` ASC 
        LIMIT 21;

        >>> models.Project.objects.filter().order_by("-id")
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        ORDER BY `id` DESC 
        LIMIT 21;
    ```
7. group by
    ```python
        >>> models.Project.objects.filter().values('id').annotate(c=Max('id'))
        SELECT `id`, MAX(`id`) AS `c` 
        FROM `test_project` 
        GROUP BY `id` 
        LIMIT 21;
    ```
8. limit offset
    ```python
        >>> models.Project.objects.all()[5:10]
        SELECT `id`, `project`, `chinese_name`, `description`, `open_source` 
        FROM `test_project` 
        ORDER BY `project` ASC 
        LIMIT 5 
        OFFSET 5;
    ```
9. as
    ```python
        >>> models.Project.objects.filter().extra(select={'new_project': 'project', 'new_chinese_name': 'chinese_name'}).values('new_project', 'new_chinese_name')
        SELECT (project) AS `new_project`, (chinese_name) AS `new_chinese_name` 
        FROM `test_project` 
        ORDER BY `project` ASC 
        LIMIT 21;
    ```






