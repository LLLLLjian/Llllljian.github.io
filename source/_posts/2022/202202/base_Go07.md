---
title: Go_基础 (7)
date: 2022-02-22
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-更多类型：struct、slice 和映射

<!-- more -->

#### Range

for 循环的 range 形式可遍历切片或映射.

当使用 for 循环遍历切片时, 每次迭代都会返回两个值.第一个值为当前元素的下标, 第二个值为该下标所对应元素的一份副本.

- code
    ```go
        package main

        import "fmt"

        var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

        func main() {
            for i, v := range pow {
                fmt.Printf("2**%d = %d\n", i, v)
            }

            // 可以将下标或值赋予 _ 来忽略它
            for i, _ := range pow {
                fmt.Println(i)
            }
            for _, value := range pow {
                fmt.Println(value)
            }

            // 只需要索引, 忽略第二个变量即可
            // for i := range pow
        }
    ```

#### 映射

映射将键映射到值.

映射的零值为 nil .nil 映射既没有键, 也不能添加键.

make 函数会返回给定类型的映射, 并将其初始化备用.

- code
    ```go
        package main

        import "fmt"

        type Vertex struct {
            Lat, Long float64
        }

        var m map[string]Vertex

        func main() {
            m = make(map[string]Vertex)
            m["Bell Labs"] = Vertex{
                40.68433, -74.39967,
            }
            fmt.Println(m["Bell Labs"])
        }
    ```

映射的文法与结构体相似, 不过必须有键名

- code1
    ```go
        package main

        import "fmt"

        type Vertex struct {
            Lat, Long float64
        }

        var m = map[string]Vertex{
            "Bell Labs": Vertex{
                40.68433, -74.39967,
            },
            "Google": Vertex{
                37.42202, -122.08408,
            },
        }

        func main() {
            fmt.Println(m)
        }
    ```

若顶级类型只是一个类型名, 你可以在文法的元素中省略它

- code2
    ```go
        package main

        import "fmt"

        type Vertex struct {
            Lat, Long float64
        }

        var m = map[string]Vertex{
            "Bell Labs": {40.68433, -74.39967},
            "Google":    {37.42202, -122.08408},
        }

        func main() {
            fmt.Println(m)
        }
    ```

#### 修改映射
- code
    ```go
        /*
        // 在映射 m 中插入或修改元素
        m[key] = elem
        // 获取元素
        elem = m[key]
        // 删除元素
        delete(m, key)
        // 通过双赋值检测某个键是否存在
        // 若 key 在 m 中, ok 为 true ；否则, ok 为 false.
        // 若 key 不在映射中, 那么 elem 是该映射元素类型的零值.
        elem, ok = m[key]
        */

        package main

        import "fmt"

        func main() {
            m := make(map[string]int)

            m["Answer"] = 42
            fmt.Println("The value:", m["Answer"])

            m["Answer"] = 48
            fmt.Println("The value:", m["Answer"])

            delete(m, "Answer")
            fmt.Println("The value:", m["Answer"])

            v, ok := m["Answer"]
            fmt.Println("The value:", v, "Present?", ok)
        }

        /*
        输出结果
        The value: 42
        The value: 48
        The value: 0
        The value: 0 Present? false
        */
    ```




