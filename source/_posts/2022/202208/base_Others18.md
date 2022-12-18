---
title: 杂项_总结 (18)
date: 2022-08-02
tags: Others
toc: true
---

### 杂项
    jsonpath

<!-- more -->

#### 前情提要
> 最近在做xml解析, 才知道有个东西叫xpath. 对应的还有个jsonpath, 那就先看看jsonpath

#### 关于JSON
> JSON是一个标记符序列. 这套标记符包括：构造字符、字符串、数字和三个字面值

#### 构造字符
> JSON包括六个构造字符, 分别是：左方括号、右方括号、左大括号、右大括号、冒号与逗号

#### JSON值
> JSON值可以是对象、数组、数字、字符串或者三个字面值(false、true、null), 并且字面值必须是小写英文字母. 

#### 为什么要使用JSON
> JSON是一种轻量级的数据交互格式, 它使得人们很容易的进行阅读和编写. 同时也方便机器进行解析和生成. 适用于进行数据交互的场景, 比如网站前台与后台之间的数据交互. 

#### JSON的使用方法
- json.loads()
    * 把JSON格式字符串解码转成Python对象, 从JSON到Python类型转换表如下
    * <table><thead><tr><th style="text-align:center">JSON</th><th style="text-align:center">Python</th></tr></thead><tbody><tr><td style="text-align:center">object</td><td style="text-align:center">dict</td></tr><tr><td style="text-align:center">array</td><td style="text-align:center">list</td></tr><tr><td style="text-align:center">string</td><td style="text-align:center">str</td></tr><tr><td style="text-align:center">number(int)</td><td style="text-align:center">int</td></tr><tr><td style="text-align:center">number(real)</td><td style="text-align:center">float</td></tr><tr><td style="text-align:center">true</td><td style="text-align:center">True</td></tr><tr><td style="text-align:center">false</td><td style="text-align:center">False</td></tr><tr><td style="text-align:center">null</td><td style="text-align:center">None</td></tr></tbody></table>
- json.dumps()
    * 将Python类型的对象转换为json字符串
    * <table><thead><tr><th style="text-align:center">python</th><th style="text-align:center">JSON</th></tr></thead><tbody><tr><td style="text-align:center">dict</td><td style="text-align:center">object</td></tr><tr><td style="text-align:center">list,tuple</td><td style="text-align:center">array</td></tr><tr><td style="text-align:center">str</td><td style="text-align:center">string</td></tr><tr><td style="text-align:center">int,float</td><td style="text-align:center">number</td></tr><tr><td style="text-align:center">True</td><td style="text-align:center">true</td></tr><tr><td style="text-align:center">False</td><td style="text-align:center">false</td></tr><tr><td style="text-align:center">None</td><td style="text-align:center">null</td></tr></tbody></table>

#### jsonpath

XML精彩强调的优点是提供了大量的工具来分析、转换和有选择地从XML文档中提取数据. Xpath是这些功能强大的工具之一. 

对于JSON数据来说, 是否应该出现jsonpath这样的工具来解决这个问题. 

数据可以通过交互方式从客户端上的JSON结构提取, 不需要特殊的脚本. 
客户端请求的JSON数据可以减少到服务器的上的相关部分, 从而大幅度减少服务器响应的带宽使用. 
jsonpath表达式始终引用JSON结构的方式与Xpath表达式与XML文档使用的方式相同. 

#### jsonpath的安装方法
- code
    ```bash
        pip install jsonpath
    ```

#### jsonpath与Xpath
- jsonpath语法与Xpath的完整概述和比较
    * <table><thead><tr><th style="text-align:center">Xpath</th><th style="text-align:center">jsonpath</th><th style="text-align:center">概述</th></tr></thead><tbody><tr><td style="text-align:center">/</td><td style="text-align:center">$</td><td style="text-align:center">根节点</td></tr><tr><td style="text-align:center">.</td><td style="text-align:center">@</td><td style="text-align:center">当前节点</td></tr><tr><td style="text-align:center">/</td><td style="text-align:center">.or[]</td><td style="text-align:center">取子节点</td></tr><tr><td style="text-align:center">*</td><td style="text-align:center">*</td><td style="text-align:center">匹配所有节点</td></tr><tr><td style="text-align:center">[]</td><td style="text-align:center">[]</td><td style="text-align:center">迭代器标识(如数组下标, 根据内容选值)</td></tr><tr><td style="text-align:center"><td style="text-align:center">...</td><td style="text-align:center">不管在任何位置, 选取符合条件的节点</td></tr><tr><td style="text-align:center">n/a</td><td style="text-align:center">[,]</td><td style="text-align:center">支持迭代器中多选</td></tr><tr><td style="text-align:center">n/a</td><td style="text-align:center">?()</td><td style="text-align:center">支持过滤操作</td></tr><tr><td style="text-align:center">n/a</td><td style="text-align:center">()</td><td style="text-align:center">支持表达式计算</td></tr></tbody></table>
- json
    ```json
        { 
            "store": {
                "book": [
                    { "category": "reference",
                        "author": "Nigel Rees",
                        "title": "Sayings of the Century",
                        "price": 8.95
                    },
                    { "category": "fiction",
                        "author": "Evelyn Waugh",
                        "title": "Sword of Honour",
                        "price": 12.99
                    },
                    { "category": "fiction",
                        "author": "Herman Melville",
                        "title": "Moby Dick",
                        "isbn": "0-553-21311-3",
                        "price": 8.99
                    },
                    { "category": "fiction",
                        "author": "J. R. R. Tolkien",
                        "title": "The Lord of the Rings",
                        "isbn": "0-395-19395-8",
                        "price": 22.99
                    }
                    ],
                    "bicycle": {
                    "color": "red",
                    "price": 19.95
                }
            }
        }
    ```
- code
    ```python
        import jsonpath
        # 获取所有书的作者名
        # author = jsonpath.jsonpath(data_json, '$.store.book[*].author')
        author = jsonpath.jsonpath(data_json, '$..author')
        # 获取第三本书的价格
        third_book_price = jsonpath.jsonpath(data_json, '$.store.book[2].price')
        # 将含有isbn编号的书籍过滤出来
        isbn_book = jsonpath.jsonpath(data_json, '$..book[?(@.isbn)]')
        # 将价格小于10元的书提取出来
        book = jsonpath.jsonpath(data_json, '$..book[?(@.price<10)]')
    ```















