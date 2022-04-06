---
title: Python_基础 (12)
date: 2018-12-21
tags: Python
toc: true
---

### Python3集合
    Python3学习笔记

<!-- more -->

#### 集合定义
    无序的不重复元素序列

#### 创建集合
    大括号{ }或者set()函数创建集合
    注意: 创建一个空集合必须用 set() 而不是 { },因为 { } 是用来创建一个空字典
- eg
    ```python
        1 :
        basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}

        2 :
        set(value)
    ```

#### 集合的基本操作
- 添加元素
    * 格式
        * s.add( x )
        * s.update( x )
    * eg
        ```python
            >>> testSet1 = set(("llllljian1", "llllljian2", "llllljian3"))
            >>> testSet1
            {'llllljian1', 'llllljian3', 'llllljian2'}
            >>> testSet1.add("llllljian4")
            >>> testSet1
            {'llllljian1', 'llllljian4', 'llllljian3', 'llllljian2'}

            >>> testSet1.update({"llllljian5", "llllljian6"})
            >>> testSet1
            {'llllljian2', 'llllljian4', 'llllljian1', 'llllljian5', 'llllljian6', 'llllljian3'}
            >>> testSet1.update("llllljian7")
            >>> testSet1
            {'llllljian6', '7', 'n', 'llllljian2', 'l', 'llllljian4', 'i', 'llllljian5', 'a', 'j', 'llllljian1', 'llllljian3'}
        ```
    * 注意的点
        * 使用update方法的时候要将新加入的元素包在花括号中,否则会拆分成单个字符插入集合中
- 移除元素
    * 格式
        * s.remove( x )
        * s.discard( x )
        * s.pop() 
    * eg
        ```python
            >>> testSet1.remove("llllljian1")
            >>> testSet1
            {'llllljian6', '7', 'n', 'llllljian2', 'l', 'llllljian4', 'i', 'llllljian5', 'a', 'j', 'llllljian3'}
            >>> testSet1.discard("llllljian7")
            >>> testSet1
            {'llllljian6', '7', 'n', 'llllljian2', 'l', 'llllljian4', 'i', 'llllljian5', 'a', 'j', 'llllljian3'}

            >>> thisSet = set((2, 5, 4, 3, 1))
            >>> thisSet
            {1, 2, 3, 4, 5}
            >>> thisSet.pop()
            1
            >>> thisSet
            {2, 3, 4, 5}
        ```
    * 注意的点
        * remove元素不存在,则会发生错误
        * discard元素不存在,不会发生错误
        * 交互模式下pop删除的是排序后的第一个元素,而在脚本模式则是随机删除一个
- 计算集合元素个数
    * 格式
        * len(s)
- 清空集合
    * 格式
        * s.clear()
- 判断元素是否在集合中存在
    * 格式
        * x in s
- list
    <table class="reference"><tbody><tr><th>方法</th><th>描述</th></tr><tr><td>add()</td><td>为集合添加元素</td></tr><tr><td>clear()</td><td>移除集合中的所有元素</td></tr><tr><td>copy()</td><td>拷贝一个集合</td></tr><tr><td>difference()</td><td>返回多个集合的差集</td></tr><tr><td>difference_update()</td><td>移除集合中的元素,该元素在指定的集合也存在</td></tr><tr><td>discard()</td><td>删除集合中指定的元素</td></tr><tr><td>intersection()</td><td>返回集合的交集</td></tr><tr><td>intersection_update()</td><td>  删除集合中的元素,该元素在指定的集合中不存在.</td></tr><tr><td>isdisjoint()</td><td>判断两个集合是否包含相同的元素,如果没有返回 True,否则返回 False.</td></tr><tr><td>issubset()</td><td>判断指定集合是否为该方法参数集合的子集.</td></tr><tr><td>issuperset()</td><td>判断该方法的参数集合是否为指定集合的子集</td></tr><tr><td>pop()</td><td>随机移除元素</td></tr><tr><td>remove()</td><td>移除指定元素</td></tr><tr><td>symmetric_difference()</td><td>返回两个集合中不重复的元素集合.</td></tr><tr><td>symmetric_difference_update()</td><td>  移除当前集合中在另外一个指定集合相同的元素,并将另外一个指定集合中不同的元素插入到当前集合中</td></tr><tr><td>union()</td><td>返回两个集合的并集</td></tr><tr><td>update()</td><td>给集合添加元素</td></tr></tbody></table>

#### 集合间的运算
- eg
    ```python
        >>> a = set('abracadabra')
        >>> b = set('alacazam')
        >>> a                                  
        {'a', 'r', 'b', 'c', 'd'}
        >>> a - b                              # 集合a中包含而集合b中不包含的元素
        {'r', 'd', 'b'}
        >>> a | b                              # 集合a或b中包含的所有元素
        {'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
        >>> a & b                              # 集合a和b中都包含了的元素
        {'a', 'c'}
        >>> a ^ b                              # 不同时包含于a和b的元素
        {'r', 'd', 'b', 'm', 'z', 'l'}
    ```




