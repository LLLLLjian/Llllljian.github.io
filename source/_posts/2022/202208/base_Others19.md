---
title: 杂项_总结 (19)
date: 2022-08-03
tags: Others
toc: true
---

### 杂项
    xpath

<!-- more -->

#### 前情提要
> 看了jsonpath 也要看看xpath了

#### XPath 节点
- 节点(Node)
    * 在 XPath 中, 有七种类型的节点：元素、属性、文本、命名空间、处理指令、注释以及文档(根)节点. XML 文档是被作为节点树来对待的. 树的根被称为文档节点或者根节点. 
    ```xml
        <?xml version="1.0" encoding="ISO-8859-1"?>

        <bookstore>
            <book>
                <title lang="en">Harry Potter</title>
                <author>J K. Rowling</author> 
                <year>2005</year>
                <price>29.99</price>
            </book>
        </bookstore>
        <!--
            <bookstore> (文档节点)
            <author>J K. Rowling</author> (元素节点)
            lang="en" (属性节点) 
        -->
    ```
- 节点关系
    * e.g.
        ```xml
            <bookstore>
                <book>
                    <title>Harry Potter</title>
                    <author>J K. Rowling</author>
                    <year>2005</year>
                    <price>29.99</price>
                </book>
            </bookstore>
        ```
    * 父(Parent)
        * book 元素是 title、author、year 以及 price 元素的父
    * 子(Children)
        * title、author、year 以及 price 元素都是 book 元素的子
    * 同胞(Sibling)
        * title、author、year 以及 price 元素都是同胞
    * 先辈(Ancestor)
        * title 元素的先辈是 book 元素和 bookstore 元素
    * 后代(Descendant)
        * bookstore 的后代是 book、title、author、year 以及 price 元素
