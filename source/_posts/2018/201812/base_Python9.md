---
title: Python_基础 (9)
date: 2018-12-18
tags: Python
toc: true
---

### Python3列表
    Python3学习笔记

<!-- more -->

#### 列表
    序列是Python中最基本的数据结构.序列中的每个元素都分配一个数字 - 它的位置,或索引,第一个索引是0,第二个索引是1,依此类推
    列表的数据项不需要具有相同的类型

#### 访问列表中的值
    使用下标索引来访问列表中的值
    也可以使用方括号的形式截取字符
- eg
    ```python
        #!/usr/bin/python3
 
        list1 = ['llllljian', 'Runoob', 1997, 2000];
        list2 = [1, 2, 3, 4, 5, 6, 7 ];
        
        print ("list1[0]: ", list1[0])
        print ("list2[1:5]: ", list2[1:5])

        输出结果
        list1[0]:  llllljian
        list2[1:5]:  [2, 3, 4, 5]
    ```

#### 更新列表
- eg
    ```python
        #!/usr/bin/python3
 
        list = ['Google', 'llllljian', 1997, 2000]
        
        print ("第三个元素为 : ", list[2])
        list[2] = 2001
        print ("更新后的第三个元素为 : ", list[2])

        输出结果

        第三个元素为 :  1997
        更新后的第三个元素为 :  2001
    ```

#### 删除列表元素
- eg
    ```python
        #!/usr/bin/python3
 
        list = ['Google', 'llllljian', 1997, 2000]
        
        print ("原始列表 : ", list)
        del list[2]
        print ("删除第三个元素 : ", list)

        输出结果

        原始列表 :  ['Google', 'Runoob', 1997, 2000]
        删除第三个元素 :  ['Google', 'Runoob', 2000]
    ```

#### 列表脚本操作符
- list
    <table class="reference"><tbody><tr><th>Python 表达式</th><th>结果 </th><th> 描述</th></tr><tr><td>len([1, 2, 3])</td><td>3</td><td>长度</td></tr><tr><td>[1, 2, 3] + [4, 5, 6]</td><td>[1, 2, 3, 4, 5, 6]</td><td>组合</td></tr><tr><td>['Hi!'] * 4</td><td>['Hi!', 'Hi!', 'Hi!', 'Hi!']</td><td>重复</td></tr><tr><td>3 in [1, 2, 3]</td><td>True</td><td>元素是否存在于列表中</td></tr><tr><td>for x in [1, 2, 3]: print(x, end=" ")</td><td>1 2 3</td><td>迭代</td></tr></tbody></table>

#### 列表函数
- list
    <table class="reference"><tbody><tr><th style="width:20%">函数</th><th style="width:60%">说明</th></tr><tr><td>len(list)</td><td>列表元素个数</td></tr><tr><td>max(list)</td><td>返回列表元素最大值</td></tr><tr><td>min(list)</td><td>返回列表元素最小值</td></tr><tr><td>list(seq)</td><td>将元组转换为列表</td></tr></tbody></table>

#### 列表方法
- list
    <table class="reference"><tbody><tr><th style="width:20%">方法</th><th style="width:60%">说明</th></tr><tr><td>list.append(obj)</td><td>在列表末尾添加新的对象</td></tr><tr><td>list.count(obj)</td><td>统计某个元素在列表中出现的次数</td></tr><tr><td>list.extend(seq)</td><td>在列表末尾一次性追加另一个序列中的多个值（用新列表扩展原来的列表）</td></tr><tr><td>list.index(obj)</td><td>从列表中找出某个值第一个匹配项的索引位置</td></tr><tr><td>list.insert(index, obj)</td><td>将对象插入列表</td></tr><tr><td>list.pop([index=-1])</td><td>移除列表中的一个元素（默认最后一个元素），并且返回该元素的值</td></tr><tr><td>list.remove(obj)</td><td>移除列表中某个值的第一个匹配项</td></tr><tr><td>list.reverse()</td><td>反向列表中元素</td></tr><tr><td>list.sort(cmp=None, key=None, reverse=False)</td><td>对原列表进行排序</td></tr><tr><td>list.clear()</td><td>清空列表</td></tr><tr><td>list.copy()</td><td>复制列表</td></tr></tbody></table>

