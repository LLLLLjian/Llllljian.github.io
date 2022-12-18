---
title: Python_基础 (139)
date: 2022-08-10
tags: Python
toc: true
---

### 从零开始学python
    之前也会一点python, 但都是工作中用的, 对于一些python的概念和语法, 都是凭感觉写的, 这次有时间就从头开始看一下. 打牢基础

<!-- more -->

#### 值传递和引用传递
1. 引用传递
> 引用传递传递的是可变的数据类型, 比如list(数组)、dict(字典)、set(集合)

```python
    # list
    nums = [1, 2, 3, 4, 5]
    def con(nums, x):
        nums[x] = 0
    con(nums, 1)
    # [1, 0, 3, 4, 5]
    print(nums)

    # dict
    nums = {
        1 : 0,
        2 : 0,
        3 : 0,
        4 : 0,
        5 : 0
    }
    def con(nums, x):
        nums[x] = 1
    con(nums, 1)
    # {1: 1, 2: 0, 3: 0, 4: 0, 5: 0}
    print(nums)

    # set
    s1 = set("abche")
    def con(s1, x):
        s1.remove(x)
    con(s1, "a")
    # {'c', 'e', 'b', 'h'}
    print(s1)
```

2. 值传递
> 值传递传递的是不可变的数据类型, 比如number(数字), string(字符), tuple(元组)

```python
    # number
    number = 2
    def con(x, y):
        x += y
    con(number, 1)
    # 2
    print(number)

    # string
    s = "abcd"
    def con(x, y):
        x += y
    con(s, "e")
    # abcd
    print(s)
```

#### copy
1. copy()与deepcopy()
对于简单的 object, 用shallow copy 和 deep copy 没区别；而对于复杂的 object,  如 list 中套着 list 的情况, shallow copy 中的 子list, 并未从原 object 真的「独立」出来.也就是说, 如果你改变原 object 的子 list 中的一个元素, 你的 copy 就会跟着一起变.这跟我们直觉上对「复制」的理解不同.

```python
    import copy
    from copy import deepcopy
    origin = [1,2,[3,4]]
    # origin里面有三个元素, 1,2,[3,4]
    copy1 = copy.copy(origin)
    copy2 = deepcopy(origin)
    print(copy1 == copy2)   # True
    print(copy1 is copy2)   # False
    # copy1 和copy2看上去相同, 但已经不是同一个object
    origin[2][0] = "hey!"
    print(origin)   # [1, 2, ['hey!', 4]]
    print(copy1)    # [1, 2, ['hey!', 4]]
    print(copy2)    # [1, 2, [3, 4]]
```

2. 字典数据类型的copy
> 字典数据类型的copy函数, 当简单的值替换的时候, 原始字典和复制过来的字典之间互不影响, 但是当添加, 删除等修改操作的时候, 两者之间会相互影响.相当于上述的赋值操作, 即在原来的对象的上面再贴上一个标签.

```python
    a = {
        "name":["An","Assan"]
    }
    b = a.copy()

    a["name"] = ["An"]

    print(a)
    print(b)
    del a['name']
    print(a)
    print(b)
    """
    {'name': ['An']}
    {'name': ['An', 'Assan']}
    {}
    {'name': ['An', 'Assan']}
    """
```

```python
    a = {
        "name":["An","Assan"]
    }
    b = a.copy()

    a["name"].append("Hunter")

    print(a)
    print(b)
    a['name'].remove('An')
    print(a)
    print(b)
    """
    {'name': ['An', 'Assan', 'Hunter']}
    {'name': ['An', 'Assan', 'Hunter']}
    {'name': ['Assan', 'Hunter']}
    {'name': ['Assan', 'Hunter']}
    """
```

```python
    a = {
        "name":["An","Assan"]
    }
    b = deepcopy(a)
    a["name"].append("Hunter")
    print(a)
    print(b)
    """
    {'name': ['An', 'Assan', 'Hunter']}
    {'name': ['An', 'Assan']}
    """
```

3. " = " 即一般意义的复制, 浅复制

```python
    list1 = [1,2,[3,4]]
    list2 = list1
    list1.append(5)
    print(list1)
    # [1, 2, [3, 4], 5]
    print(list2)
    # [1, 2, [3, 4], 5]
    list1[2].remove(3)
    print(list1)
    # [1, 2, [4], 5]
    print(list2)
    # [1, 2, [4], 5]
```

4. 列表切片等价于深复制

```python
    list1 = [1,2,[3,4]]
    list2 = list1[:]
    list1.append(5)
    print(list1)
    # [1, 2, [3, 4], 5]
    print(list2)
    # [1, 2, [3, 4]]
    list1[2].remove(3)
    print(list1)
    # [1, 2, [4], 5]
    print(list2)
    # [1, 2, [4]]
```