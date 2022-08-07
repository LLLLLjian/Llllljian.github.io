---
title: Go_基础 (30)
date: 2022-07-26
tags: Go
toc: true
---

### Go-xml
    因为我要解析manifest文件,所以需要看一下xml包

<!-- more -->

#### 前情提要
> 本来已经用xml的低阶功能把自定义标签解析的效果实现了, 但是我不光要解析, 我还要编码还原,用原生的写法就有点复杂了,所以我就找了一下三方库,就找到了etree

#### etree
- 创建一个xml
    ```go
        doc := etree.NewDocument()
        doc.CreateProcInst("xml", `version="1.0" encoding="UTF-8"`)
        doc.CreateProcInst("xml-stylesheet", `type="text/xsl" href="style.xsl"`)

        people := doc.CreateElement("People")
        people.CreateComment("These are all known people")

        jon := people.CreateElement("Person")
        jon.CreateAttr("name", "Jon")

        sally := people.CreateElement("Person")
        sally.CreateAttr("name", "Sally")
        // 设置缩进
        doc.Indent(2)
        // 设置标签闭合
        // doc.WriteSettings.CanonicalEndTags = true
        // 输出
        /*
        <?xml version="1.0" encoding="UTF-8"?>
        <?xml-stylesheet type="text/xsl" href="style.xsl"?>
        <People>
        <!--These are all known people-->
        <Person name="Jon"/>
        <Person name="Sally"/>
        </People>
        */
        doc.WriteTo(os.Stdout)
    ```
- 读取xml文件
    ```go
        doc := etree.NewDocument()
        // 直接读文件
        if err := doc.ReadFromFile("bookstore.xml"); err != nil {
            panic(err)
        }
        // func (d *Document) ReadFromBytes(b []byte) error             读字节流
        // func (d *Document) ReadFromFile(filename string) error       从文件中读
        // func (d *Document) ReadFromString(s string) error            从字符串中读
    ```
- 读取标签和属性
    ```go
        // 获取第一个bookstore标签内的所有内容
        root := doc.SelectElement("bookstore")
        // .Tag可以获取到标签名 .Path可以获取到标签路径
        fmt.Println("ROOT element:", root.Tag)
        // 获取bookstore标签下所有的book标签
        for _, book := range root.SelectElements("book") {
            // .Tag可以获取到标签名 .Path可以获取到标签路径
            fmt.Println("CHILD element:", book.Tag)
            if title := book.SelectElement("title"); title != nil {
                // 获取title标签的lang属性, 如果没有lang属性的话就返回unknown
                lang := title.SelectAttrValue("lang", "unknown")
                fmt.Printf("  TITLE: %s (%s)\n", title.Text(), lang)

                // title标签中如果没有属性lang1 就会直接返回nil
                if title.SelectAttr("lang1") != nil {

                }
            }
            // 遍历book的所有属性
            for _, attr := range book.Attr {
                fmt.Printf("  ATTR: %s=%s\n", attr.Key, attr.Value)
            }
        }
        // 获取bookstore下的所有标签
        for _, element := range root.SelectElements("./*") {
            print(element)
        }
    ```
- 高级功能
    ```go
        doc := etree.NewDocument()
        // 直接读文件
        if err := doc.ReadFromFile("bookstore.xml"); err != nil {
            panic(err)
        }
        root := doc.SelectElement("bookstore")
        // 复制节点(一般用于节点移动)
        root.Copy()
        // 输出xml格式-字节格式
        doc.WriteToBytes()
        // 输出xml格式-字符串格式
        doc.WriteToString()
        // 输出xml格式-文件格式
        doc.WriteToFile()
        // 添加节点(一般与Copy()联用)
        root.AddChild(t Token)
        // 获取所有子节点
        root.ChildElements()
        // 新增属性
        root.CreateAttr(key, value string)
        // 创建标签
        root.CreateElement(tag string)
        // 通过标签名查找节点(如果有多个的话就返回第一个)
        root.FindElement(path string)
        // 通过标签名查找所有节点
        root.FindElements(path string)
        // 基本同上, 但上边的两个方法传入的是字符串, 这个是Path struct
        root.FindElementPath(path Path)
        root.FindElementPaths(path Path)
        // 获取索引
        root.Index()
        // 往root的第index个索引处插入一个节点
        root.InsertChildAt(index int, t Token)
        // 移除属性
        root.RemoveAttr(key string)
        // 移除子节点
        root.RemoveChild(t Token)
        // 查询子标签
        root.SelectElement(tag string)
        // 查询所有子标签
        root.SelectElements(tag string)
    ```
- FindElement功能详细介绍
    * 如果你会一点jQuery 那就很好理解了
    * .               Select the current element.
    * ..              Select the parent of the current element.
    * \*               Select all child elements of the current element.
    * /               Select the root element when used at the start of a path.
    * //              Select all descendants of the current element.
    * tag             Select all child elements with a name matching the tag.
    * \[@attrib]       Keep elements with an attribute named attrib.
    * \[@attrib='val'] Keep elements with an attribute named attrib and value matching val.
    * \[tag]           Keep elements with a child element named tag.
    * \[tag='val']     Keep elements with a child element named tag and text matching val.
    * \[n]             Keep the n-th element, where n is a numeric index starting from 1.
    * \[text()]                    Keep elements with non-empty text.
    * \[text()='val']              Keep elements whose text matches val.
    * \[local-name()='val']        Keep elements whose un-prefixed tag matches val.
    * \[name()='val']              Keep elements whose full tag exactly matches val.
    * \[namespace-prefix()='val']  Keep elements whose namespace prefix matches val.
    * \[namespace-uri()='val']     Keep elements whose namespace URI matches val.

