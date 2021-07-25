---
title: 读书笔记 (12)
date: 2021-07-01
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### Kubernetes之YAML 语法
> YAML 是一种非常简洁/强大/专门用来写配置文件的语言！
YAML 全称是 ”YAML Ain’t a Markup Language” 的递归缩写, 该语言的设计参考了 JSON / XML 和 SDL 等语言,强调以数据为中心, 简洁易读, 编写简单
- YAML语法特点
    * 大小写敏感
    * 通过缩进表示层级关系
    * 禁止使用tab缩进, 只能使用空格键
    * 缩进的空格数目不重要, 只要相同层级左对齐
    * 使用#表示注释
    ```yaml
        # yaml
        languages:
            - Ruby
            - Perl
            - Python
        websites:
            YAML: yaml.org
            Ruby: ruby-lang.org
            Python: python.org
            Perl: use.perl.org

        # Json
        {
            languages: [
                'Ruby',
                'Perl',
                'Python'
            ],
            websites: {
                YAML: 'yaml.org',
                Ruby: 'ruby-lang.org',
                Python: 'python.org',
                Perl: 'use.perl.org'
            }
        }
    ```
- 数据结构
    * -对象: 键值对的字典
    * -数组: 一组按次序排列的列表
    * -纯量: 单个的且不可再分的值
    ```yaml
        # 纯量
        hello

        # 数组
        - Cat
        - Dog
        - Goldfish

        # 对象
        animal: pets
    ```
- 引号区别
    * 单引号(''): 特殊字符作为普通字符串处理
    * 双引号(""): 特殊字符作为本身想表示的意思
    ```yaml
        # 单引号
        name: 'Hi,\nTom'

        # 双引号
        name: "Hi,\nTom"
    ```
- 内置类型列表
    ```yaml
        # YAML允许使用个感叹号(!)强制转换数据类型
        # 单叹号通常是自定义类型, 双叹号是内置类型
        money: !!str
        123

        date: !Boolean
        true
    ```
- YAML特殊类型
    * 文本块
        ```yaml
            # 注意“|”与文本之间须另起一行
            # 使用|标注的文本内容缩进表示的块, 可以保留块中已有的回车换行
            value: |
            hello
            world!

            # 输出结果
            # hello 换行 world！

            # +表示保留文字块末尾的换行
            # -表示删除字符串末尾的换行
            value: |
            hello

            value: |-
            hello

            value: |+
            hello

            # 输出结果
            # hello\n hello hello\n\n

            # 注意“>”与文本之间的空格
            # 使用>标注的文本内容缩进表示的块, 将块中回车替换为空格最终连接成一行
            value: > hello
            world!

            # 输出结果
            # hello 空格 world！
        ```
    * 锚点与引用
        ```yaml
            # 复制代码注意*引用部分不能追加内容
            # 使用&定义数据锚点, 即要复制的数据
            # 使用*引用锚点数据, 即数据的复制目的地
            name: &a yaml
            book: *a
            books:
            - java
            - *a
            - python

            # 输出结果
            book： yaml
            books：[java, yaml, python]
        ```
