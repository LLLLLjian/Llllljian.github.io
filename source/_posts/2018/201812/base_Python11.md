---
title: Python_基础 (11)
date: 2018-12-20
tags: Python
toc: true
---

### Python3字典
    Python3学习笔记

<!-- more -->

#### 字典类型说明
    字典是另一种可变容器模型，且可存储任意类型对象
    字典的每个键值(key=>value)对用冒号(:)分割，每个对之间用逗号(,)分割，整个字典包括在花括号({})中
    键必须是唯一的，但值则不必
    值可以取任何数据类型，但键必须是不可变的，如字符串，数字或元组

#### 访问字典里的值
    通过key进行访问
- eg
    ```python
        #!/usr/bin/python3
 
        dict = {'Name': 'llllljian', 'Age': 23}
        
        print ("dict['Name']: ", dict['Name'])
        print ("dict['Age']: ", dict['Age'])

        输出结果
        E:\python>py dict1.py
        dict['Name']:  llllljian
        dict['Age']:  23
    ```

#### 修改字典 
    增加新的键/值对，修改或删除已有键/值
- eg
    ```python
        #!/usr/bin/python3
 
        dict = {'Name': 'llllljian', 'Age': 23, 'test1': 'First'}
        
        dict['Age'] = 24;               # 更新 Age
        dict['test2'] = "Two"  # 添加
        
        
        print ("dict['Age']: ", dict['Age'])
        print ("dict['test2']: ", dict['test2'])

        输出结果
        dict['Age']:  24
        dict['test2']:  Two
    ```

#### 字典内置函数
- list
    <table class="reference"><tbody><tr><th width="5%">序号</th><th width="25%">函数及描述</th><th>实例</th></tr><tr><td>len(dict)</td><td>计算字典元素个数，即键的总数</td></tr><tr><td>str(dict)</td><td>输出字典，以可打印的字符串表示</td></tr><tr><td>type(variable)</td><td>返回输入的变量类型，如果变量是字典就返回字典类型</td></tr></tbody></table>

#### 字典内置方法
- list
    <table class="reference"><tbody><tr><th style="width:20%">函数</th><th style="width:60%">描述</th></tr><tr><td>radiansdict.clear()</td><td>删除字典内所有元素 </td></tr><tr><td>radiansdict.copy()</td><td>返回一个字典的浅复制</td></tr><tr><td>radiansdict.fromkeys()</td><td>创建一个新字典，以序列seq中元素做字典的键，val为字典所有键对应的初始值</td></tr><tr><td>radiansdict.get(key, default=None)</td><td>返回指定键的值，如果值不在字典中返回default值</td></tr><tr><td>key in dict</td><td>如果键在字典dict里返回true，否则返回false</td></tr><tr><td>radiansdict.items()</td><td>以列表返回可遍历的(键, 值) 元组数组</td></tr><tr><td>radiansdict.keys()</td><td>返回一个迭代器，可以使用 list() 来转换为列表</td></tr><tr><td>radiansdict.setdefault(key, default=None)</td><td>和get()类似, 但如果键不存在于字典中，将会添加键并将值设为default</td></tr><tr><td>radiansdict.update(dict2)</td><td>把字典dict2的键/值对更新到dict里</td></tr><tr><td>radiansdict.values()</td><td>返回一个迭代器，可以使用 list() 来转换为列表</td></tr><tr><td>pop(key[,default])</td><td>删除字典给定键 key 所对应的值，返回值为被删除的值。key值必须给出。否则，返回default值。</td></tr><tr><td>popitem()</td><td>随机返回并删除字典中的一对键和值(一般删除末尾对)。</td></tr></tbody></table>


