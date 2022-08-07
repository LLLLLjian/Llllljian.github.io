---
title: Go_基础 (25)
date: 2022-07-15
tags: Go
toc: true
---

### Go-struct-tag
    结构体struct-tag

<!-- more -->

#### omitempty坑

带来方便的同时,使用 omitempty 也有些小陷阱,一个是该关键字无法忽略掉嵌套结构体.还是拿地址类型说事,这回我们想要往地址结构体中加一个新 field 来表示经纬度,如果缺乏相关的数据,暂时可以忽略.新的结构体定义如下所示

```go
    type address struct {
        Street     string     `json:"street"`
        Ste        string     `json:"suite,omitempty"`
        City       string     `json:"city"`
        State      string     `json:"state"`
        Zipcode    string     `json:"zipcode"`
        Coordinate coordinate `json:"coordinate,omitempty"`
    }

    type coordinate struct {
        Lat float64 `json:"latitude"`
        Lng float64 `json:"longitude"`
    }
```

读入原来的地址数据,处理后序列化输出,我们就会发现即使加上了 omitempty 关键字,输出的 json 还是带上了一个空的坐标信息

```
    {
        "street": "200 Larkin St",
        "city": "San Francisco",
        "state": "CA",
        "zipcode": "94102",
        "coordinate": {
            "latitude": 0,
            "longitude": 0
        }
    }
```

为了达到我们想要的效果,可以把坐标定义为指针类型,这样 Golang 就能知道一个指针的“空值”是多少了,否则面对一个我们自定义的结构, Golang 是猜不出我们想要的空值的.于是有了如下的结构体定义

```go
    type address struct {
        Street     string      `json:"street"`
        Ste        string      `json:"suite,omitempty"`
        City       string      `json:"city"`
        State      string      `json:"state"`
        Zipcode    string      `json:"zipcode"`
        Coordinate *coordinate `json:"coordinate,omitempty"`
    }

    type coordinate struct {
        Lat float64 `json:"latitude"`
        Lng float64 `json:"longitude"`
    }
```

相应的输出为

```
    {
        "street": "200 Larkin St",
        "city": "San Francisco",
        "state": "CA",
        "zipcode": "94102"
    }
```

另一个“陷阱”是,对于用 omitempty 定义的 field ,如果给它赋的值恰好等于默认空值的话,在转为 json 之后也不会输出这个 field .比如说上面定义的经纬度坐标结构体,如果我们将经纬度两个 field 都加上 omitempty

```go
    type coordinate struct {
        Lat float64 `json:"latitude,omitempty"`
        Lng float64 `json:"longitude,omitempty"`
    }

    func main() {
        cData := `{
        "latitude": 0.0,
        "longitude": 0.0
        }`
        c := new(coordinate)
        json.Unmarshal([]byte(cData), &c)

        // 具体处理逻辑...
        coordinateBytes, _ := json.MarshalIndent(c, "", "    ")
        fmt.Printf("%s\n", string(coordinateBytes))
    }
```

最终我们得到了一个 {}

这个坐标消失不见了！但我们的设想是,如果一个地点没有经纬度信息,则悬空,这没有问题,但对于“原点坐标”,我们在确切知道它的经纬度的情况下,(0.0, 0.0)仍然被忽略了.正确的写法也是将结构体内的定义改为指针

```go
    type coordinate struct {
        Lat *float64 `json:"latitude,omitempty"`
        Lng *float64 `json:"longitude,omitempty"`
    }

    {
        "latitude": 0,
        "longitude": 0
    }
```

#### 结构体嵌套坑
> go结构体嵌套结构体指针, 必须先初始化指针结构体才能赋值
- code
    ```go
        package main
        import (
            "fmt"
        )

        type Address struct {
            Province string
            City string
            CreateTime string
        }

        type Email struct {
            Account string
            CreateTime string
        }

        type User struct {
            Username string
            Sex string
            City string  // 自己有的默认使用自己的
            Age int	
            AvatarUrl string
            *Address
            *Email
            // CreateTime string
        }

        func test(){
            var user User  // 变量名不能和包名相同,否则会 冲突了
            user.Username = "user01"
            user.Age =18
            user.Sex ="男"
            //user.Province ="湖北"
            user.City ="黄冈"
            fmt.Printf("00 user=%#v addr=%#v\n",user,user.Address)
            fmt.Printf("01 user=%#v addr=%#v\n",user,user.City)
        }


        func test2(){
            var user User  // 变量名不能和包名相同,否则会 冲突了
            user.Username = "user01"
            user.Age =18
            user.Sex ="男"
            user.Address = new(Address)  // 带*号是指针型的, 所以要先初始化这个Address
            user.Province ="湖北"
            user.Address.City ="黄冈"
            user.Email = new(Email)  // 带*号是指针型的, 所以要先初始化这个Address
            user.Email.CreateTime = "Email.CreateTime_002"
            user.Address.CreateTime = "Address.CreateTime_002"
            fmt.Printf("02 user=%#v\n",user)
            fmt.Printf("03 EmailCreateTime=%s\n",user.Email.CreateTime)
            fmt.Printf("04 AddressCreateTime=%s,\n",user.Address.CreateTime)
            fmt.Printf("05 Address=%s,\n",user.Email)
            fmt.Printf("06 Email=%s,\n",user.Address)
        }


        func main(){
            test()
            test2()
        }
    ```
- 输出结果
    ```
        00 user=main.User{Username:"user01", Sex:"男", City:"黄冈", Age:18, AvatarUrl:"", Address:(*main.Address)(nil), Email:(*main.Email)(nil)} addr=(*main.Address)(nil)
        01 user=main.User{Username:"user01", Sex:"男", City:"黄冈", Age:18, AvatarUrl:"", Address:(*main.Address)(nil), Email:(*main.Email)(nil)} addr="黄冈"
        02 user=main.User{Username:"user01", Sex:"男", City:"", Age:18, AvatarUrl:"", Address:(*main.Address)(0xc00006c330), Email:(*main.Email)(0xc000004480)}
        03 EmailCreateTime=Email.CreateTime_002
        04 AddressCreateTime=Address.CreateTime_002,
        05 Address=&{ Email.CreateTime_002},
        06 Email=&{湖北 黄冈 Address.CreateTime_002},
    ```

