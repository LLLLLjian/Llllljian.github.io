---
title: Go_基础 (34)
date: 2022-08-24
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-切片

<!-- more -->

#### go的切片数据结构是什么样子的

切片是有可能在编译器就被内联的, 而如果在编译器没有被内联, 进入运行期, 就是直接使用SliceHeader数据结构. 

```go
    type SliceHeader struct {
        Data uintptr // 指针
        Len  int // 长度
        Cap  int // 容量
    }
```

#### 为什么在初始化slice的时候尽量补全cap

当我们要创建一个slice结构, 并且往slice中append元素的时候, 我们可能有两种写法来初始化这个slice. 

- func1
    ```go
        package main

        import "fmt"

        func main() {
            arr := []int{}
            arr = append(arr, 1,2,3,4, 5)
            fmt.Println(arr)
        }
    ```

- func2
    ```go
        package main

        import "fmt"

        func main() {
            arr := make([]int, 0, 5)
            arr = append(arr, 1,2,3,4, 5)
            fmt.Println(arr)
        }
    ```

方法2相较于方法1, 就只有一个区别：在初始化[]int slice的时候在make中设置了cap的长度, 就是slice的大小. 

这两种方法对应的功能和输出结果是没有任何差别的, 但是实际运行的时候, 方法2会比少运行了一个growslice的命令. 

这个growslice的作用就是扩充slice的容量大小. 就好比是原先我们没有定制容量, 系统给了我们一个能装两个鞋子的盒子, 但是当我们装到第三个鞋子的时候, 这个盒子就不够了, 我们就要换一个盒子, 而换这个盒子, 我们势必还需要将原先的盒子里面的鞋子也拿出来放到新的盒子里面. 所以这个growsslice的操作是一个比较复杂的操作, 它的表现和复杂度会高于最基本的初始化make方法. 对追求性能的程序来说, 应该能避免尽量避免. 

#### 如果不设置cap, make slice的时候, 创建的cap为多大

如果不设置cap, 不管是使用make, 还是直接使用[]slice 进行初始化, 编译器都会计算初始化所需的空间, 使用最小化的cap进行初始化. 

```go
    a := make([]int, 0)  // cap 为0
    a := []int{1,2,3} // cap 为3
```
