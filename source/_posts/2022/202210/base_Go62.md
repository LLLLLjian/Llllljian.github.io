---
title: Go_基础 (62)
date: 2022-10-10
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(单例模式)

<!-- more -->

#### 单例模式
- 概念

单例是一种创建型设计模式, 让你能够保证一个类只有一个实例, 并提供一个访问该实例的全局节点. 


单例拥有与全局变量相同的优缺点. 尽管它们非常有用, 但却会破坏代码的模块化特性. 

- 示例

通过地球对象实现单例, earth不能导出, 通过TheEarth方法访问全局唯一实例, 并通过sync.Once实现多协程下一次加载. 

- 接口
    ```go
        package singleton

        import "sync"

        var once sync.Once

        // 不可导出对象
        type earth struct {
            desc string
        }

        func (e *earth) String() string {
            return e.desc
        }

        // theEarth 地球单实例
        var theEarth *earth

        // TheEarth 获取地球单实例
        func TheEarth() *earth {
            if theEarth == nil {
                once.Do(func() {
                theEarth = &earth{
                    desc: "美丽的地球, 孕育了生命. ",
                }
                })
            }
            return theEarth
        }
    ```
- 运用
    ```go
        package singleton

        import (
            "fmt"
            "testing"
        )

        func TestSingleton(t *testing.T) {
            fmt.Println(TheEarth().String())
        }
    ```
- 输出
    ```
        美丽的地球, 孕育了生命. 
    ```


