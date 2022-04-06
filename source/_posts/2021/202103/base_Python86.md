---
title: Python_基础 (86)
date: 2021-03-12
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之排序

<!-- more -->

#### sort
> 是Python列表的一个内置的排序方法,list.sort() 方法排序时直接修改原列表,返回None
1. desc
    ```python
        """
            ret = 参数1.sort(参数2, 参数3)
            参数1: 任意的可迭代对象
            参数2: key, 可省略, 默认ASCII码排序
            参数3: reverse 是否反转,默认为: reverse = False
            return: None  因为sort()改变的是参数1本身 
        """
    ```
2. demo1
    ```python
        fruit = ["apple1", "pear", "grape", "watermelon", "apple2", "banana"]
        fruit.sort(key=len, reverse=True)
        print(fruit)
        # out: ['watermelon', 'apple1', 'apple2', 'banana', 'grape', 'pear']
        
    ```

#### sorted
> 是Python内置的一个排序函数,它会从一个迭代器返回一个排好序的新列表.(注意: 即使是不可变的元组也可以进行排序,最后返回排序后的列表)
1. desc
    ```python
        """
            ret = sorted(参数1, 参数2, 参数3)
            参数1: 任意的可迭代对象
            参数2: key, 可省略, 默认ASCII码排序
            参数3: reverse 是否反转,默认为: reverse = False
            ret : 将结果以新列表形式返回, 并不会对参数1产生影响
        """
    ```
2. demo1
    ```python
        fruit = ["apple1", "pear", "grape", "watermelon", "apple2", "banana"]
        ret1 = sorted(fruit)    # 排序, 如果长度相同, 会根据原有的顺序进行排序  apple1/apple2/banana
        print(ret1)
        # out: ['apple1', 'apple2', 'banana', 'grape', 'pear', 'watermelon']
        print(fruit)        # 并不会对原列表造成影响
        # out: ['apple1', 'pear', 'grape', 'watermelon', 'apple2', 'banana']
        
        ret2 = sorted(fruit, reverse=True)  # 反转
        print(ret2)
        # out: ['watermelon', 'pear', 'grape', 'banana', 'apple2', 'apple1']
        
        ret3 = sorted(fruit, key=len)   # 按词长度排序
        print(ret3)
        # out: ['pear', 'grape', 'apple1', 'apple2', 'banana', 'watermelon'] 
        
        ret4 = sorted(fruit, key=len, reverse=True)  # 按词的长度反排序
        print(ret4)
        # out: ['watermelon', 'apple1', 'apple2', 'banana', 'grape', 'pear']
    ```
3. demo2
    ```python
        num_list = [1, '12', 7, '8', 10, '5']
        ret_num_list_int = sorted(num_list, key=int)        # 按int排序
        ret_num_list_str = sorted(num_list, key=str)        # 按str排序
        print(ret_num_list_int)
        # out: [1, '5', 7, '8', 10, '12']
        print(ret_num_list_str)
        # out: [1, 10, '12', '5', 7, '8']
    ```
4. demo3
    ```python
        # 字典排序
        mydict= {5: 'D', 7: 'B', 3: 'C', 4: 'E', 8: 'A'}
        print(sorted(mydict))#按字典键值排序
        # out:[3,4, 5, 7, 8]
        print(sorted(mydict.values()))#按字典值排序
        # out:['A','B', 'C', 'D', 'E']

        #也可以按照下面这种方式进行排序,如果字典的值是一个列表的话,可以对列表进行多参数排序
        print(sorted(mydict.items(),key=operator.itemgetter(0)))
        # out:[(3,'C'), (4, 'E'), (5, 'D'), (7, 'B'), (8, 'A')]
    ```
5. demo4
    ```python
        # 对tuple组成的list进行排序
        students= [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10),]
        sorted(students,key=lambda student : student[2])   # sortby age
        # out:[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
        sorted(students,key=itemgetter(2))  # sort by age
        # out:[('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 15)]
        sorted(students,key=itemgetter(1,2))  # sort by gradethen by age
        # out:[('john', 'A', 15), ('dave', 'B', 10), ('jane', 'B', 12)]
    ```
6. demo5
    ```python
        # 对dict组成的list进行排序
        info= [
            {'ID':11,'name':'lili','age':20},
            {'ID':2,'name':'jobs','age':40},
            {'ID':22,'name':'aces','age':30},
            {'ID':15,'name':'bob','age':18}
        ]

        print(sorted(info,key=lambdax:x['ID'])) # sort by ID
        # out:[{'ID':2, 'name': 'jobs', 'age': 40}, {'ID': 11, 'name': 'lili', 'age': 20}, {'ID':15, 'name': 'bob', 'age': 18}, {'ID': 22, 'name': 'aces', 'age': 30}]
        print(sorted(info,key=itemgetter('age')))# sort by ID
        # out:[{'ID':15, 'name': 'bob', 'age': 18}, {'ID': 11, 'name': 'lili', 'age': 20}, {'ID':22, 'name': 'aces', 'age': 30}, {'ID': 2, 'name': 'jobs', 'age': 40}]
        
        #多级排序
        print(sorted(info,key=lambdax:(x['name'],x['age'])))
        print(sorted(info,key=itemgetter("name",'age')))
        # out:[{'ID': 22, 'name': 'aces', 'age': 30}, {'ID': 15, 'name': 'bob', 'age': 18},{'ID': 2, 'name': 'jobs', 'age': 40}, {'ID': 11, 'name': 'lili', 'age': 20}]
    ```

#### itemgetter
> 一般与sorted联合使用
1. desc
    ```python
        """
            itemgetter  多条件排序
        """
    ```
2. demo1
    ```python
        from operator import itemgetter
        demo_b = [("a", 21, 4), ("x", 12, 0), ("g", 12, 3), ("d", 0, 10), ("l", 12, 3)]
        
        # 需求: 先按第2个元素排序, 再按第1个元素排序
        ret3 = sorted(demo_b, key=itemgetter(1, 0))
        print(ret3)
        # out: [('d', 0, 10), ('g', 12, 3), ('l', 12, 3), ('x', 12, 0), ('a', 21, 4)]
    ```
3. demo2
    ```python
        from operator import itemgetter

        my_dict = {
            "name": "小黄",
            "age":  20,
            "gender": "man",
            "class": "middle",
            "height": 150,
        }

        # 现在只想要gender和age属性
        request_key = ("name", "gender")
        ret = itemgetter(*request_key)(my_dict)
        print(ret)
        # out: ('小黄', 'man')

        print(dict(zip(request_key, ret)))
        # out: {'name': '小黄', 'gender': 'man'}
    ```
4. demo3
    ```python
        from operator import itemgetter
        # 按照元素中的第n个元素进行排序
        demo_b = [("a", 21, 4), ("x", 12, 0), ("g", 12, 3), ("d", 0, 10), ("l", 12, 3)]
        # 方法1:
        ret1 = sorted(demo_b, key=lambda x: x[1])
        print(ret1)
        # out: [('d', 0, 10), ('x', 12, 0), ('g', 12, 3), ('l', 12, 3), ('a', 21, 4)]
        
        # 方法2:
        ret2 = sorted(demo_b, key=itemgetter(1))
        print(ret2)
        # out: [('d', 0, 10), ('x', 12, 0), ('g', 12, 3), ('l', 12, 3), ('a', 21, 4)]
        
        # 需求: 先按第2个元素排序, 再按第1个元素拍序
        ret3 = sorted(demo_b, key=itemgetter(1, 0))
        ret4 = sorted(demo_b, key=lambda x: (x[1],x[0]))
        print(ret3)
        # out: [('d', 0, 10), ('g', 12, 3), ('l', 12, 3), ('x', 12, 0), ('a', 21, 4)]
        print(ret4)
        # out: [('d', 0, 10), ('g', 12, 3), ('l', 12, 3), ('x', 12, 0), ('a', 21, 4)]
    ```
5. demo4
    ```python
        from operator import itemgetter
        list_demo = [
            {
                "id": 10,
                "name": "a",
                "age": 15
            }, 
            {
                "id": 1,
                "name": "d",
                "age": 19
            },
            {
                "id": 5,
                "name": "c",
                "age": 18
            },
            {
                "id": 5,
                "name": "a",
                "age": 18
            }
        ]

        # 先按id排序, id相同时用name排序
        ret4 = sorted(list_demo, key=itemgetter("id", "name"))
        print(ret4)
        # out: [{'id': 1, 'name': 'd', 'age': 19}, {'id': 5, 'name': 'a', 'age': 18}, {'id': 5, 'name': 'c', 'age': 18}, {'id': 10, 'name': 'a', 'age': 15}]
    ```

