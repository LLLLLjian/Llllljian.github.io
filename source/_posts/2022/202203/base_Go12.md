---
title: Go_基础 (12)
date: 2022-03-01
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-content

<!-- more -->

#### context接口
- code
    ```go
        type Context interface {
            Deadline() (deadline time.Time, ok bool)
            Done() <-chan struct{}
            Err() error
            Value(key interface{}) interface{}
        }
    ```
- desc
    1. Deadline: 是获取设置的截止时间的意思, 第一个返回值是截止时间, 到了这个时间点, Context 会自动发起取消请求；第二个返回值 ok==false 时表示没有设置截止时间, 如果需要取消的话, 需要调用取消函数进行取消
    2. Done: 该方法返回一个只读的 chan, 类型为 struct{}, 我们在 goroutine 中, 如果该方法返回的 chan 可以读取, 则意味着parent context已经发起了取消请求, 我们通过 Done 方法收到这个信号后, 就应该做清理操作, 然后退出 goroutine, 释放资源
    3. Err 方法返回取消的错误原因, 因为什么 Context 被取消
    4. Value方法获取该 Context 上绑定的值, 是一个键值对, 所以要通过一个 Key 才可以获取对应的值, 这个值一般是线程安全的

#### context的继承衍生
1. func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
2. func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)
3. func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
4. func WithValue(parent Context, key, val interface{}) Context

#### context传递元数据
- code
    ```go
        package main

        import (
            "fmt"
            "time"
            "context"
        )

        var key string = "name"

        // 使用通过context向goroutinue传递值
        func watch(ctx context.Context) {
            for {
                select{
                case <- ctx.Done():
                    fmt.Println(ctx.Value(key), "退出, 停止了...")
                    return
                default:
                    fmt.Println(ctx.Value(key), "运行中...")
                    time.Sleep(2 * time.Second)
                }
            }
        } 

        func main() {
            ctx, cancel := context.WithCancel(context.Background())
            // 给ctx绑定键值, 传递给goroutine
            valuectx := context.WithValue(ctx, key, "【监控1】")
            // 启动goroutine
            go watch(valuectx)

            time.Sleep(time.Second * 10)
            fmt.Println("该结束了...")
            // 运行结束函数
            cancel()
            time.Sleep(time.Second * 3)
            fmt.Println("真的结束了..")
        }
    ```
- 注意点
    1. context.WithValue 方法附加一对 K-V 的键值对, 这里 Key 必须是等价性的, 也就是具有可比性；Value 值要是线程安全的.
    2. 在使用值的时候, 可以通过 Value 方法读取 ctx.Value(key).
    3. 使用 WithValue 传值, 一般是必须的值, 不要什么值都传递.

#### Context最佳实战
1. 不要把 Context 放在结构体中, 要以参数的方式传递
2. 以 Context 作为参数的函数方法, 应该把 Context 作为第一个参数, 放在第一位
3. 给一个函数方法传递 Context 的时候, 不要传递 nil, 如果不知道传递什么, 就使用 context.TODO
4. Context 的 Value 相关方法应该传递必须的数据, 不要什么数据都使用这个传递
5. Context 是线程安全的, 可以放心的在多个 goroutine 中传递

