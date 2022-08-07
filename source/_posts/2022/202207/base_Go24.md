---
title: Go_基础 (24)
date: 2022-07-14
tags: Go
toc: true
---

### Go-struct-tag
    结构体struct-tag

<!-- more -->

#### struct tag简介

在Go语言中我们通常使用struct来的表示复杂的数据结构,比如二维平面上的一个点,可以用下面的struct表示

```go
    type Point struct {
        X int64
        Y int64
    }
```

struct提供的功能不仅限于此,下面介绍下struct中的tag.

我们可以在struct中的每一个field后面添加一段额外的注释或者说明,来引导struct的encoding到某种格式中,这部分额外的注释说明,我们称之为struct中的field tag,比如:

```go
    type Person struct {
        FirstName  string `json:"first_name"`
        LastName   string `json:"last_name"`
        MiddleName string `json:"middle_name,omitempty"`
    }
```

这里我们定义了一个名为Person的struct,使用tag来指定encoding到json后,各个field在json中的key名称,在最后一个field tag中,我们额外添加了额外的omitempty选项,指示在encoding成json时,如果MiddleName=="",那么encoding成json的时候忽略它.如:

```go
    p = Person{FirstName: "chen", LastName:"he"}
```

对应的encoding后的json就是

```
    {
        "first_name":"chen",
        "last_name":"he"
    }
```

#### struct tag的解析

在Go语言中field tag是用 reflect.StructTag 这个结构表示的,reflect.StructTag对应于一个string

```
    package reflect
    type StructTag string
```

这个string的按照惯例是由多个 key:"value" 连接而成,每一组 key:"value"都代表一种encoding格式,例如:

```
    Name string `json:"name" xml:"name"`
```

但是我们也可以完全不用遵守这种惯例,自定义一套解释规则.

我们可以使用Go提供的 reflect 包来读取tag中的信息,首先我们需要先获取struct的Type,接着使用 Type.Field 、Type.FieldByIndex 或者 Type.FieldByName 来获取struct中的某一个field,获取到的field中就包含了StructTag信息.举例:

```go
    type User struct {
        Name  string `mytag:"MyName"`
        Email string `mytag:"MyEmail"`
    }

    u := User{"Bob", "bob@mycompany.com"}
    t := reflect.TypeOf(u)

    for _, fieldName := range []string{"Name", "Email"} {
        field, found := t.FieldByName(fieldName)
        if !found {
            continue
        }
        fmt.Printf("\nField: User.%s\n", fieldName)
        fmt.Printf("\tWhole tag value : %q\n", field.Tag)
        fmt.Printf("\tValue of 'mytag': %q\n", field.Tag.Get("mytag"))
    }
```

结果:

```
    Field: User.Name
        Whole tag value : "mytag:\"MyName\""
        Value of 'mytag': "MyName"

    Field: User.Email
        Whole tag value : "mytag:\"MyEmail\""
        Value of 'mytag': "MyEmail"
```

上面说到按惯例tag string是由多个 key:"value" 连接组成的,如果遵循这个惯例,我们就可以用 StructTag.Get(key string) 方法来获取key对应的value,如果不遵循这个惯例,我们就没法直接获取对应的value,而是必须自定义一套解析tag string的规则.

Go提供了另外一个方法 StructTag.Lookup()来获取key对应的value,下面的例子可以清楚知道他们的差别:

```go
    type User struct {
        Name string
    }
    u := User{"Bob"}
    t := reflect.TypeOf(u)
    field, _ := t.FieldByName("Name")
    fmt.Printf("\tValue of 'mytag': %q\n", field.Tag.Get("mytag"))
    if _, ok := field.Tag.Lookup("mytag"); !ok {
        fmt.Printf("\tmytag is not set")
    }
```

结果:

```
    Value of 'mytag': ""
    mytag is not set
```

#### 和其它编程语言的对比

其实StructTag只是作为一个信息存放的地方,并没有和具体的功能绑定,你可以往里面丢任何的信息,但是信息包含的意思是由你自己来定义的,这意味着StructTag提供了强大的灵活性,绝大部分的用法都和encoding有关系,说明它的确非常合适做这件事,但是它并不和encoding功能绑定在一起.

相对于其它语言而言,Go处理encoding不得不说比较巧妙,比如在Ruby中,我们需要将一个Hash encoding为json,但是有很多时候Hash和json中的field并不是一一对应关系,所以我们需要先生成一个和目标json一一对应的Hash对象,然后再encoding.

为啥Go中的encoding会使用这种方式来实现呢？

不得不说这是Go本身的限制带来的,在struct中,我们都知道大小写关乎到每个field的对外可见性,Go使用大小写实现了类似其它强类型语言中public/private一套control access,但对于json而言,大小写其实无关紧要.所以使用这种tag的方式为struct field添加了一些encoding信息,无疑是一种折中选择,但感觉误打误撞变成了一种合适的方式,不得不说还是设计本身的精妙.

#### 常见格式的tag选项

json - used by the encoding/json package, detailed at json.Marshal()

json - used by the encoding/json package, detailed at json.Marshal()

xml - used by the encoding/xml package, detailed at xml.Marshal()

bson - used by gobson, detailed at bson.Marshal()

protobuf - used by github.com/golang/protobuf/proto, detailed in the package doc

yaml - used by the gopkg.in/yaml.v2 package, detailed at yaml.Marshal()

db - used by the github.com/jmoiron/sqlx package; also used by github.com/go-gorp/gorp package

orm - used by the github.com/astaxie/beego/orm package, detailed at Models – Beego ORM

gorm - used by the github.com/jinzhu/gorm package, examples can be found in their doc: Models

valid - used by the github.com/asaskevich/govalidator package, examples can be found in the project page

datastore - used by appengine/datastore (Google App Engine platform, Datastore service), detailed at Properties

schema - used by github.com/gorilla/schema to fill a struct with HTML form values, detailed in the package doc

asn - used by the encoding/asn1 package, detailed at asn1.Marshal() and asn1.Unmarshal()
