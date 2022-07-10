---
title: Go_基础 (20)
date: 2022-06-30
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-if语句、for语句和switch语句

<!-- more -->

#### if语句、for语句和switch语句
> 简单的语法就先不说了, 说一下其中容易错的题
- 使用携带range子句的for语句时需要注意哪些细节
    * 如果for语句中只有一个迭代变量i, 那么这个i就是从小到大的索引值(详情参见numbers1)
    * 要注意, range的值如果是数组的话, 操作的是值类型.但如果是切片的话, 操作的是引用值(数组参见numbers2, 切片参见numbes3)
- switch语句中的switch表达式和case表达式之间有着怎样的联系
    * 如果switch表达式的结果值是无类型的常量, 比如1 + 3的求值结果就是无类型的常量4, 那么这个常量会被自动地转换为此种常量的默认类型的值(详情参见value1)
    * 如果case表达式中子表达式的结果值是无类型的常量, 那么它的类型会被自动地转换为switch表达式的结果类型(详情参见value2)
    * case值如果是常量的话 不能有重复的(详情参见value3)
    * 可以通过索引表达式来绕开上述问题(详情参见value4)
    * uint8和byte是同一个东西的两种说法 所以不能编译(详情参见value5)
    * 代码实现
        ```go
            package main

            import "fmt"

            func main() {
                numbers1 := []int{1, 2, 3, 4, 5, 6}
                for i := range numbers1 {
                    if i == 3 {
                        numbers1[i] |= i
                    }
                }
                // [1 2 3 7 5 6]
                fmt.Println(numbers1)

                numbers2 := [...]int{1, 2, 3, 4, 5, 6}
                maxIndex2 := len(numbers2) - 1
                for i, e := range numbers2 {
                    if i == maxIndex2 {
                        numbers2[0] += e
                    } else {
                        numbers2[i+1] += e
                    }
                }
                // [7 3 5 7 9 11]
                fmt.Println(numbers2)

                numbers3 := []int{1, 2, 3, 4, 5, 6}
                maxIndex3 := len(numbers3) - 1
                for i, e := range numbers3 {
                    if i == maxIndex3 {
                        numbers3[0] += e
                    } else {
                        numbers3[i+1] += e
                    }
                }
                // [22 3 6 10 15 21]
                fmt.Println(numbers2)

                value1 := [...]int{0, 1, 2, 3, 4, 5, 6}
                switch 1 + 3 {
                    case value1[0], value1[1]:
                        fmt.Println("0 or 1")
                    case value1[2], value1[3]:
                        fmt.Println("2 or 3")
                    case value1[4], value1[5], value1[6]:
                        fmt.Println("4 or 5 or 6")
                }

                value2 := [...]int8{0, 1, 2, 3, 4, 5, 6}
                switch value2[4] {
                    case 0, 1:
                        fmt.Println("0 or 1")
                    case 2, 3:
                        fmt.Println("2 or 3")
                    case 4, 5, 6:
                        fmt.Println("4 or 5 or 6")
                }

                value3 := [...]int8{0, 1, 2, 3, 4, 5, 6}
                switch value3[4] {
                    case 0, 1, 2:
                        fmt.Println("0 or 1 or 2")
                    // case 2, 3, 4:
                    case 2, 3:
                        fmt.Println("2 or 3 or 4")
                    case 4, 5, 6:
                        fmt.Println("4 or 5 or 6")
                }

                value5 := [...]int8{0, 1, 2, 3, 4, 5, 6}
                switch value5[4] {
                    case value5[0], value5[1], value5[2]:
                        fmt.Println("0 or 1 or 2")
                    case value5[2], value5[3], value5[4]:
                        fmt.Println("2 or 3 or 4")
                    case value5[4], value5[5], value5[6]:
                        fmt.Println("4 or 5 or 6")
                }

                value6 := interface{}(byte(127))
                switch t := value6.(type) {
                    // case uint8, uint16:
                    case uint16:
                        fmt.Println("uint8 or uint16")
                    case byte:
                        fmt.Printf("byte")
                    default:
                        fmt.Printf("unsupported type: %T", t)
                }
            }
        ```





