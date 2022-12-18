---
title: Go_基础 (36)
date: 2022-08-26
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-多参数优化

<!-- more -->

#### 构建类多参数优化
- 优化前
    ```go
        package newdemo

        type Foo struct {
            name string
            id int
            age int

            db interface{}
        }

        func NewFoo(name string, id int, age int, db interface{}) *Foo {
            return &Foo{
                name: name,
                id:   id,
                age:  age,
                db:   db,
            }
        }

        foo := NewFoo("jianfengye", 1, 0, nil)
    ```
- 优化后
    ```go
        type Foo struct {
            name string
            id int
            age int

            db interface{}
        }

        // FooOption 代表可选参数
        type FooOption func(foo *Foo)

        // WithName 代表Name为可选参数
        func WithName(name string) FooOption {
            return func(foo *Foo) {
                foo.name = name
            }
        }

        // WithAge 代表age为可选参数
        func WithAge(age int) FooOption {
            return func(foo *Foo) {
                foo.age = age
            }
        }

        // WithDB 代表db为可选参数
        func WithDB(db interface{}) FooOption {
            return func(foo *Foo) {
                foo.db = db
            }
        }

        // NewFoo 代表初始化
        func NewFoo(id int, options ...FooOption) *Foo {
            foo := &Foo{
                name: "default",
                id:   id,
                age:  10,
                db:   nil,
            }
            for _, option := range options {
                option(foo)
            }
            return foo
        }

        // 具体使用NewFoo的函数
        func Bar() {
            foo := NewFoo(1, WithAge(15), WithName("foo"))
            fmt.Println(foo)
        }
    ```





