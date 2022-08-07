---
title: Go_基础 (29)
date: 2022-07-25
tags: Go
toc: true
---

### Go-xml
    因为我要解析manifest文件,所以需要看一下xml包

<!-- more -->

#### 前情提要
> 其实上一篇的高阶用法已经基本实现解析xml的功能了, 但是它有个缺陷是 要提前设定要strut进行映射, 所以这种情况的话 对自定义标签就无法解析了,因为没办法规定用户的自定义标签或者自定义属性

#### xml数据结构
- Token和XML数据结构
    * 低阶方法是以Token为单位操纵XML,Token有四种类型：StartElement,用来表示XML开始节点；EndElement,用来表示XML结束节点；CharData,即为XML的原始文本(raw text)；Comment,表示注释
    * StartElement: &lg;action application="answer">
    * EndElement: &lg;/action>
    * CharData: raw text
    * Comment: &lg;!-- -->
    * e.g.
        ```xml
            <!-- comment -->
            <action application="answer">raw text</action>
        ```
    * 源码
        ```go
            // 名字
            type Name struct {
                Space string  // 名称空间,例如 <space:action></space:action>
                Local string  // 名称,例如<action></action>
            }

            // 属性
            type Attr struct {
                Name  Name
                Value string
            }

            // 差别联合体类型,包含StartElement,EndElement,CharData,Comment等类型
            type Token interface{}

            // 开始节点
            type StartElement struct {
                Name Name
                Attr []Attr
            }
            func (e StartElement) End() EndElement // 用来产生对应的结束节点

            // 结束节点
            type EndElement struct {
                Name Name
            }

            // raw text
            type CharData []byte

            // 注释
            type Comment []byte
        ```

#### 解码
- demo
    ```go
        package main

        import (
            "bytes"
            "encoding/xml"
            "fmt"
            "io"
            "os"
        )

        func main() {
            // 要解析的XML如下,为了提高可读性,用+号连接若干字符串,用以进行排版
            data :=
                `<extension name="rtp_multicast_page">` +
                    `<condition field="destination_number" expression="^pagegroup$|^7243$">` +
                        `<!-- comment -->` +
                        `<action application="answer">raw text</action>` +
                        `<action application="esf_page_group"/>` +
                    `</condition>` +
                `</extension>`

            // 创建一个reader,以满足io.Reader接口
            reader := bytes.NewReader([]byte(data))
            // 以io.Reader为参数,创建解码器
            dec := xml.NewDecoder(reader)

            // 开始遍历解码
            indent := "" // 控制缩进
            sep := "    "  // 每层的缩进量为四个空格
            // 死循环, 一直在读xml 直到读完
            for {
                tok, err := dec.Token()  // 返回下一个Token
                // 错误处理
                if err == io.EOF { // 如果读到结尾,则退出循环
                    break
                } else if err != nil { // 其他错误则退出程序
                    os.Exit(1)
                }
                switch tok := tok.(type) {  // Type switch
                case xml.StartElement:  // 开始节点,打印名字和属性
                    fmt.Print(indent)
                    fmt.Printf("<%s ", tok.Name.Local)
                    s := ""
                    for _, v := range tok.Attr {
                        fmt.Printf(`%s%s="%s"`, s, v.Name.Local, v.Value)
                        s = " "
                    }
                    fmt.Println(">")
                    indent += sep  // 遇到开始节点,则增加缩进量
                case xml.EndElement:  // 结束节点,打印名字
                    indent = indent[:len(indent)-len(sep)]  // 遇到结束节点,则减少缩进量
                    fmt.Printf("%s</%s>\n", indent, tok.Name.Local)
                case xml.CharData:  // 原始字符串,直接打印
                    fmt.Printf("%s%s\n", indent, tok)
                case xml.Comment:  // 注释,直接打印
                    fmt.Printf("%s<!-- %s -->\n", indent, tok)
                }
            }
        }
    ```
- 输出结果
    ```xml
        <extension name="rtp_multicast_page">
        <condition field="destination_number" expression="^pagegroup$|^7243$">
            <!--  comment  -->
            <action application="answer">
                raw text
            </action>
            <action application="esf_page_group">
            </action>
        </condition>
    </extension>
    ```


#### 编码
- demo
    ```go
        package main

        import (
            "bytes"
            "encoding/xml"
            "fmt"
        )

        // 为了少敲几个字符,声明了attrmap类型和start函数
        type attrmap map[string]string  // 属性的键值对容器

        // start()用来构建开始节点
        func start(tag string, attrs attrmap) xml.StartElement {
            var a []xml.Attr
            for k, v := range attrs {
                a = append(a, xml.Attr{xml.Name{"", k}, v})
            }
            return xml.StartElement{xml.Name{"", tag}, a}
        }

        func main() {
            // 创建编码器
            buffer := new(bytes.Buffer)
            enc := xml.NewEncoder(buffer)

            // 设置缩进,这里为4个空格
            enc.Indent("", "    ")

            // 开始生成XML
            startExtension := start("extension", attrmap{"name": "rtp_multicast_page"})
            enc.EncodeToken(startExtension)
            startCondition := start("condition", attrmap{"field": "destination_number",
                "expression": "^pagegroup$|^7243$"})
            enc.EncodeToken(startCondition)
            startAction := start("action", attrmap{"application": "answer"})
            enc.EncodeToken(startAction)
            enc.EncodeToken(xml.CharData("raw text"))
            enc.EncodeToken(startAction.End())
            startAction = start("action", attrmap{"application": "esf_page_group"})
            enc.EncodeToken(startAction)
            enc.EncodeToken(startAction.End())
            enc.EncodeToken(startCondition.End())
            enc.EncodeToken(startExtension.End())

            // 写入XML
            enc.Flush()

            // 打印结果
            fmt.Println(buffer)
        }
    ```
- 输出结果
    ```xml
        <extension name="rtp_multicast_page">
            <condition field="destination_number" expression="^pagegroup$|^7243$">
                <action application="answer">raw text</action>
                <action application="esf_page_group"></action>
            </condition>
        </extension>
    ```








