---
title: Go_基础 (11)
date: 2022-02-28
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-content

<!-- more -->

#### 为什么需要context

先举个例子
> 在 Go http包的Server中, 每一个请求在都有一个对应的 goroutine 去处理.请求处理函数通常会启动额外的 goroutine 用来访问后端服务, 比如数据库和RPC服务.用来处理一个请求的 goroutine 通常需要访问一些与请求特定的数据, 比如终端用户的身份认证信息、验证相关的token、请求的截止时间. 当一个请求被取消或超时时, 所有用来处理该请求的 goroutine 都应该迅速退出, 然后系统才能释放这些 goroutine 占用的资源.

对于多并发的情况下, 传统的方案：等待组sync.WaitGroup以及通过通道channel的方式的问题就会显现出来；

对于等待组控制多并发的情况：只有所有的goroutine都结束了才算结束, 只要有一个goroutine没有结束,  那么就会一直等, 这显然对资源的释放是缓慢的；

而对于通道Channel的方式下：通过在main goroutine中像chan中发送关闭停止指令, 并配合select, 从而达到关闭goroutine的目的, 这种方式显然比等待组优雅的多, 但是在goroutine中在嵌套goroutine的情况就变得异常复杂.

- 等待code
    ```go
        package main

        import (
            "fmt"
            "strconv"
            "sync"
            "time"
        )

        var wg sync.WaitGroup

        func run(task string) {
            fmt.Println(task, "start ....")
            time.Sleep(time.Second * 2)
            // 每个goroutine运行完毕后就释放等待组的计数器
            wg.Done()
        }

        func main() {
            // 需要开启几个goroutine就给等待组的计数器赋值为多少, 这里为2
            wg.Add(2)
            for i := 1; i < 3; i++ {
                taskName := "task" + strconv.Itoa(i)
                go run(taskName)
            }
            wg.Wait()
            fmt.Println("所有任务结束 ....")
        }

        /*
        输出结果：
        task2 start...
        task1 start...
        所有任务结束...
        */
    ```

上面例子中, 一个任务结束了必须等待另外一个任务也结束了才算全部结束了, 先完成的必须等待其他未完成的, 所有的goroutine都要全部完成才OK.

这种方式的优点：使用等待组的并发控制模型, 尤其适用于好多个goroutine协同做一件事情的时候, 因为每个goroutine做的都是这件事情的一部分, 只有全部的goroutine都完成, 这件事情才算完成；

这种方式的缺陷：在实际生产中, 需要我们主动的通知某一个 goroutine 结束.

- 通道chan+select
    ```go
        package main

        import (
            "fmt"
            "time"
        )

        func main() {
            stop := make(chan bool)
            // 开启goroutine
            go func() {
                for {
                    select {
                    case <-stop:
                        fmt.Println("任务1 结束了....")
                    default:
                        fmt.Println("任务1 正在运行中.....")
                        time.Sleep(time.Second * 2)
                    }
                }
            }()

            // 运行10s后停止
            time.Sleep(time.Second * 10)
            fmt.Println("需要停止任务1.....")
            stop <- true
            time.Sleep(time.Second * 3)
        }

        /*
        运行结果
        任务1 正在运行中.....
        任务1 正在运行中.....
        任务1 正在运行中.....
        任务1 正在运行中.....
        任务1 正在运行中.....
        需要停止任务1.....
        任务1 结束了....
        任务1 正在运行中.....
        任务1 正在运行中.....
        */
    ```

channel配合select方式的优点：比较优雅, 

channel配合select方式的劣势：如果有很多 goroutine 都需要控制结束怎么办？,  如果这些 goroutine 又衍生了其它更多的goroutine 怎么办？

- context
    ```go
        package main

        import (
            "context"
            "fmt"
            "time"
        )

        func main() {
            ctx, cancel := context.WithCancel(context.Background())
            go func(ctx context.Context) {
                for {
                    select {
                    case <-ctx.Done():
                        fmt.Println("任务1 结束了....")
                        return
                    default:
                        fmt.Println(" 任务1 正在运行中.")
                        time.Sleep(time.Second * 2)
                    }
                }
            }(ctx)

            // 运行10s后停止
            time.Sleep(time.Second * 10)
            fmt.Println("需要停止任务1...")
            // 使用context的cancel函数停止goroutine
            cancel()
            // 为了检测监控过是否停止, 如果没有监控输出, 就表示停止了
            time.Sleep(time.Second * 3)
        }

        /*
        任务1 正在运行中.
        任务1 正在运行中.
        任务1 正在运行中.
        任务1 正在运行中.
        任务1 正在运行中.
        需要停止任务1...
        任务1 结束了....
        */
    ```
- context控制多个goroutine
    ```go
        package main

        import (
            "context"
            "fmt"
            "time"
        )

        func watch(ctx context.Context, name string) {
            for {
                select {
                case <-ctx.Done():
                    fmt.Println(name, "退出 , 停止了...")
                    return
                default:
                    fmt.Println(name, "运行中...")
                    time.Sleep(2 * time.Second)
                }
            }
        }

        func main() {
            ctx, cancel := context.WithCancel(context.Background())
            go watch(ctx, "【任务1】")
            go watch(ctx, "【任务2】")
            go watch(ctx, "【任务3】")

            time.Sleep(time.Second * 10)
            fmt.Println("通知任务停止....")
            cancel()
            time.Sleep(time.Second * 5)
            fmt.Println("真的停止了...")
        }
        /*
        【任务1】 运行中...
        【任务2】 运行中...
        【任务3】 运行中...
        【任务3】 运行中...
        【任务1】 运行中...
        【任务2】 运行中...
        【任务2】 运行中...
        【任务1】 运行中...
        【任务3】 运行中...
        【任务3】 运行中...
        【任务2】 运行中...
        【任务1】 运行中...
        【任务3】 运行中...
        【任务2】 运行中...
        【任务1】 运行中...
        通知任务停止....
        【任务1】 退出 , 停止了...
        【任务2】 退出 , 停止了...
        【任务3】 退出 , 停止了...
        真的停止了...
        */
    ```

