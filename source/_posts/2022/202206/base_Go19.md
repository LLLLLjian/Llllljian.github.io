---
title: Go_基础 (19)
date: 2022-06-29
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-GO语句执行规则(下)

<!-- more -->

#### 问题1
- 怎样才能让主 goroutine 等待其他 goroutine
    * 最简单粗暴的办法就是让主 goroutine“小睡”一会儿
    * 但这种方法的弊端在魚, 我们不能很好的控制住goroutine休息的时间, 休息多了影响效率, 休息少了又干不完
    * 所以我们能想到的是 能不能让其他goroutine在运行完毕的时候直接告诉主goroutine, 所以想到了通道.我们先创建一个通道, 它的长度应该与我们手动启用的 goroutine 的数量一致.在每个手动启用的 goroutine 即将运行完毕的时候, 我们都要向该通道发送一个值.
    * 代码实现
        ```go
            package main

            import (
                "fmt"
                //"time"
            )

            func main() {
                num := 10
                sign := make(chan struct{}, num)

                for i := 0; i < num; i++ {
                    go func() {
                        fmt.Println(i)
                        // struct{}类型值的表示法只有一个, 即：struct{}{}.并且, 它占用的内存空间是0字节.确切地说, 这个值在整个 Go 程序中永远都只会存在一份.虽然我们可以无数次地使用这个值字面量, 但是用到的却都是同一个值.
                        sign <- struct{}{}
                    }()
                }

                // 办法1.
                //time.Sleep(time.Millisecond * 500)

                // 办法2.
                for j := 0; j < num; j++ {
                    <-sign
                }
            }
        ```

#### 问题2
- 怎样让我们启用的多个 goroutine 按照既定的顺序运行
    * 代码实现
        ```go
            package main

            import (
                "fmt"
                "sync/atomic"
                "time"
            )

            func main() {
                var count uint32
                trigger := func(i uint32, fn func()) {
                    for {
                        if n := atomic.LoadUint32(&count); n == i {
                            fn()
                            atomic.AddUint32(&count, 1)
                            break
                        }
                        time.Sleep(time.Nanosecond)
                    }
                }
                for i := uint32(0); i < 10; i++ {
                    go func(i uint32) {
                        fn := func() {
                            fmt.Println(i)
                        }
                        trigger(i, fn)
                    }(i)
                }
                trigger(10, func() {})
            }
        ```


