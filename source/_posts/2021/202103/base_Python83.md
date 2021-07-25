---
title: Python_基础 (83)
date: 2021-03-01
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之json

<!-- more -->

#### 先说说我想做的事
> 嘻嘻嘻 关键节点的输出结果要记录到文件里呀 要不然查问题怎么查 字符串还好 有个字典类型的我该怎么搞

#### 自己封的一个笨办法
- eg
    ```python
        def record_log_into_file(file_path, file_content, content_type="dict"):
        """
        将关键的日志重定向到文件中
        """
        with open("%s" % (file_path), "w") as f:
            if (content_type == "dict"):
                f.write(json.dumps(
                    file_content,
                    indent=4,  # 设置缩进格数
                    ensure_ascii=False,  # 是否显示ascii这个码,默认是ture,设置为False可显示中文
                    sort_keys=False,  # 是否按照字典排序(a-z)输出,True代表是,False代表否
                    separators=(',', ':')  # 设置分隔符
                ))
            else:
                f.write(file_content)
    ```

#### json模块
- dump
    * eg
        ```python
            json.dump(obj, fp, *, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, default=None, sort_keys=False, **kw)
        ```
    * obj: 表示是要序列化的对象.
    * fp: 文件描述符,将序列化的str保存到文件中.json模块总是生成str对象,而不是字节对象；因此,fp.write()必须支持str输入.
    * skipkeys: 默认为False,如果skipkeysTrue,(默认值：False),则将跳过不是基本类型(str,int,float,bool,None)的dict键,不会引发TypeError
    * ensure_ascii: 默认值为True,能将所有传入的非ASCII字符转义输出.如果ensure_ascii为False,则这些字符将按原样输出.
    * check_circular:默认值为True,如果check_circular为False,则将跳过对容器类型的循环引用检查,循环引用将导致OverflowError.
    * allow_nan: 默认值为True,如果allow_nan为False,则严格遵守JSON规范,序列化超出范围的浮点值(nan,inf,-inf)会引发ValueError. 如果allow_nan为True,则将使用它们的JavaScript等效项(NaN,Infinity,-Infinity)
    * indent: 设置缩进格式,默认值为None,选择的是最紧凑的表示.如果indent是非负整数或字符串,那么JSON数组元素和对象成员将使用该缩进级别进行输入；indent为0,负数或“”仅插入换行符；indent使用正整数缩进多个空格；如果indent是一个字符串(例如“\t”),则该字符串用于缩进每个级别
    * separators: 去除分隔符后面的空格,默认值为None,如果指定,则分隔符应为(item_separator,key_separator)元组.如果缩进为None,则默认为(’,’,’：’);要获得最紧凑的JSON表示,可以指定(’,’,’:’)以消除空格
    * default: 默认值为None,如果指定,则default应该是为无法以其他方式序列化的对象调用的函数.它应返回对象的JSON可编码版本或引发TypeError.如果未指定,则引发TypeError
    * sort_keys: 默认值为False,如果sort_keys为True,则字典的输出将按键值排序
- dumps
    * eg
        ```python
            json.dumps(obj, *, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, default=None, sort_keys=False, **kw)
        ```
    * 与dump差异
        * dumps函数不需要传文件描述符,其他的参数和dump函数的一样
- load
    * eg
        ```python
            json.load(fp, *, cls=None, object_hook=None, parse_float=None, parse_int=None, parse_constant=None, object_pairs_hook=None, **kw)
        ```
    * fp: 文件描述符,将fp反序列化为Python对象.
    * object_hook: 默认值为None,object_hook是一个可选函数,此功能可用于实现自定义解码器.指定一个函数,该函数负责把反序列化后的基本类型对象转换成自定义类型的对象.
    * parse_float: 默认值为None,如果指定了parse_float,用来对JSON float字符串进行解码,这可用于为JSON浮点数使用另一种数据类型或解析器
    * parse_int: 默认值为None,如果指定了parse_int,用来对JSON int字符串进行解码,这可以用于为JSON整数使用另一种数据类型或解析器.
    * parse_constant:默认值为None,如果指定了parse_constant,对-Infinity,Infinity,NaN字符串进行调用.如果遇到了无效的JSON符号,会引发异常
    * 如果进行反序列化(解码)的数据不是一个有效的JSON文档,将会引发 JSONDecodeError异常
- loads
    * eg
        ```python
            json.loads(s, *, encoding=None, cls=None, object_hook=None, parse_float=None, parse_int=None, parse_constant=None, object_pairs_hook=None, **kw)
        ```
    * s: 将s(包含JSON文档的str,bytes或bytearray实例)反序列化为Python对象
    * encoding: 指定一个编码的格式.
    * 与load差异
        * loads也不需要文件描述符,其他参数的含义和load函数的一致
- 格式转化表
    <table><thead><tr><th>JSON</th><th>Python</th></tr></thead><tbody><tr><td>object</td><td>dict</td></tr><tr><td>array</td><td>list</td></tr><tr><td>string</td><td>str</td></tr><tr><td>number (int)</td><td>int</td></tr><tr><td>number (real)</td><td>float</td></tr><tr><td>true</td><td>True</td></tr><tr><td>false</td><td>False</td></tr><tr><td>null</td><td>None</td></tr></tbody></table>


