---
title: Go_基础 (17)
date: 2022-06-27
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-结构体

<!-- more -->

#### 结构体类型基础知识

我们可以把结构体类型中的一个字段看作是它的一个属性或者一项数据, 再把隶属于它的一个方法看作是附加在其中数据之上的一个能力或者一项操作.将属性及其能力(或者说数据及其操作)封装在一起, 是面向对象编程(object-oriented programming)的一个主要原则

- 代码介绍
    ```go
        package main

        import "fmt"

        // AnimalCategory 代表动物分类学中的基本分类法.
        type AnimalCategory struct {
            kingdom string // 界.
            phylum  string // 门.
            class   string // 纲.
            order   string // 目.
            family  string // 科.
            genus   string // 属.
            species string // 种.
        }

        func (ac AnimalCategory) String() string {
            return fmt.Sprintf("%s%s%s%s%s%s%s",
                ac.kingdom, ac.phylum, ac.class, ac.order,
                ac.family, ac.genus, ac.species)
        }

        type Animal struct {
            scientificName string // 学名.
            AnimalCategory        // 动物基本分类.
        }

        // 该方法会"屏蔽"掉嵌入字段中的同名方法.
        func (a Animal) String() string {
            return fmt.Sprintf("%s (category: %s)",
                a.scientificName, a.AnimalCategory)
        }

        type Cat struct {
            name string
            Animal
        }

        // 该方法会"屏蔽"掉嵌入字段中的同名方法.
        func (cat Cat) String() string {
            return fmt.Sprintf("%s (category: %s, name: %q)",
                cat.scientificName, cat.Animal.AnimalCategory, cat.name)
        }

        func main() {
            // 示例1.
            category := AnimalCategory{species: "cat", genus: "dog"}
            fmt.Printf("The animal category: %s\n", category)

            // 示例2.
            animal := Animal{
                scientificName: "American Shorthair",
                AnimalCategory: category,
            }
            fmt.Printf("The animal: %s\n", animal)

            // 示例3.
            cat := Cat{
                name:   "little pig",
                Animal: animal,
            }
            fmt.Printf("The cat: %s\n", cat)
        }
    ```

![结构体](/img/20220627_1.jpg)

- 问题1：GO语言是用嵌入字段实现了继承吗
    * Go 语言中根本没有继承的概念, 它所做的是通过嵌入字段的方式实现了类型之间的组合.
    * 简单来说, 面向对象编程中的继承, 其实是通过牺牲一定的代码简洁性来换取可扩展性, 而且这种可扩展性是通过侵入的方式来实现的
    * 类型之间的组合采用的是非声明的方式, 我们不需要显式地声明某个类型实现了某个接口, 或者一个类型继承了另一个类型.
    * 同时, 类型组合也是非侵入式的, 它不会破坏类型的封装或加重类型之间的耦合.
    * 我们要做的只是把类型当做字段嵌入进来, 然后坐享其成地使用嵌入字段所拥有的一切.如果嵌入字段有哪里不合心意, 我们还可以用“包装”或“屏蔽”的方式去调整和优化.
    * 另外, 类型间的组合也是灵活的, 我们总是可以通过嵌入字段的方式把一个类型的属性和能力“嫁接”给另一个类型.
    * 这时候, 被嵌入类型也就自然而然地实现了嵌入字段所实现的接口.再者, 组合要比继承更加简洁和清晰, Go 语言可以轻而易举地通过嵌入多个字段来实现功能强大的类型, 却不会有多重继承那样复杂的层次结构和可观的管理成本.
- 问题2：值方法和指针方法都是什么意思, 有什么区别
    * 值方法的接收者是该方法所属的那个类型值的一个副本.我们在该方法内对该副本的修改一般都不会体现在原值上, 除非这个类型本身是某个引用类型(比如切片或字典)的别名类型.而指针方法的接收者, 是该方法所属的那个基本类型值的指针值的一个副本.我们在这样的方法内对该副本指向的值进行修改, 却一定会体现在原值上.
    * 一个自定义数据类型的方法集合中仅会包含它的所有值方法, 而该类型的指针类型的方法集合却囊括了前者的所有方法, 包括所有值方法和所有指针方法.严格来讲, 我们在这样的基本类型的值上只能调用到它的值方法.但是, Go 语言会适时地为我们进行自动地转译, 使得我们在这样的值上也能调用到它的指针方法.比如, 在Cat类型的变量cat之上, 之所以我们可以通过cat.SetName("monster")修改猫的名字, 是因为 Go 语言把它自动转译为了(&cat).SetName("monster"), 即：先取cat的指针值, 然后在该指针值上调用SetName方法.
    * 在后边你会了解到, 一个类型的方法集合中有哪些方法与它能实现哪些接口类型是息息相关的.如果一个基本类型和它的指针类型的方法集合是不同的, 那么它们具体实现的接口类型的数量就也会有差异, 除非这两个数量都是零.比如, 一个指针类型实现了某某接口类型, 但它的基本类型却不一定能够作为该接口的实现类型.
- 具体例子
    ```go
        package main

        import "fmt"

        type Cat struct {
            name           string // 名字.
            scientificName string // 学名.
            category       string // 动物学基本分类.
        }

        func New(name, scientificName, category string) Cat {
            return Cat{
                name:           name,
                scientificName: scientificName,
                category:       category,
            }
        }

        func (cat *Cat) SetName(name string) {
            cat.name = name
        }

        func (cat Cat) SetNameOfCopy(name string) {
            cat.name = name
        }

        func (cat Cat) Name() string {
            return cat.name
        }

        func (cat Cat) ScientificName() string {
            return cat.scientificName
        }

        func (cat Cat) Category() string {
            return cat.category
        }

        func (cat Cat) String() string {
            return fmt.Sprintf("%s (category: %s, name: %q)",
                cat.scientificName, cat.category, cat.name)
        }

        func main() {
            cat := New("little pig", "American Shorthair", "cat")
            cat.SetName("monster") // (&cat).SetName("monster")
            fmt.Printf("The cat: %s\n", cat)

            cat.SetNameOfCopy("little pig")
            fmt.Printf("The cat: %s\n", cat)

            type Pet interface {
                SetName(name string)
                Name() string
                Category() string
                ScientificName() string
            }

            _, ok := interface{}(cat).(Pet)
            fmt.Printf("Cat implements interface Pet: %v\n", ok)
            _, ok = interface{}(&cat).(Pet)
            fmt.Printf("*Cat implements interface Pet: %v\n", ok)
        }
    ```


