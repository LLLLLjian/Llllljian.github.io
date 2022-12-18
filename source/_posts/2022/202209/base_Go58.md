---
title: Go_基础 (58)
date: 2022-09-27
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(工厂方法模式)

<!-- more -->

#### 工厂方法模式
- 概念

工厂方法模式是一种创建型设计模式, 其在父类中提供一个创建对象的方法,  允许子类决定实例化对象的类型. 

- 示例

摊煎饼的小贩需要先摊个煎饼, 再卖出去, 摊煎饼就可以类比为一个工厂方法, 根据顾客的喜好摊出不同口味的煎饼. 

- 接口
    ```go
        package factorymethod

        // Pancake 煎饼
        type Pancake interface {
            // ShowFlour 煎饼使用的面粉
            ShowFlour() string
            // Value 煎饼价格
            Value() float32
        }

        // PancakeCook 煎饼厨师
        type PancakeCook interface {
            // MakePancake 摊煎饼
            MakePancake() Pancake
        }

        // PancakeVendor 煎饼小贩
        type PancakeVendor struct {
            PancakeCook
        }

        // NewPancakeVendor ...
        func NewPancakeVendor(cook PancakeCook) *PancakeVendor {
            return &PancakeVendor{
                PancakeCook: cook,
            }
        }

        // SellPancake 卖煎饼, 先摊煎饼, 再卖
        func (vendor *PancakeVendor) SellPancake() (money float32) {
            return vendor.MakePancake().Value()
        }
    ```
- 各种面的煎饼
    ```go
        package factorymethod

        // cornPancake 玉米面煎饼
        type cornPancake struct{}

        // NewCornPancake ...
        func NewCornPancake() *cornPancake {
            return &cornPancake{}
        }

        func (cake *cornPancake) ShowFlour() string {
            return "玉米面"
        }

        func (cake *cornPancake) Value() float32 {
            return 5.0
        }

        // milletPancake 小米面煎饼
        type milletPancake struct{}

        func NewMilletPancake() *milletPancake {
            return &milletPancake{}
        }

        func (cake *milletPancake) ShowFlour() string {
            return "小米面"
        }

        func (cake *milletPancake) Value() float32 {
            return 8.0
        }
    ```
- 制作各种口味煎饼
    ```go
        package factorymethod

        // cornPancakeCook 制作玉米面煎饼厨师
        type cornPancakeCook struct{}

        func NewCornPancakeCook() *cornPancakeCook {
            return &cornPancakeCook{}
        }

        func (cook *cornPancakeCook) MakePancake() Pancake {
            return NewCornPancake()
        }

        // milletPancakeCook 制作小米面煎饼厨师
        type milletPancakeCook struct{}

        func NewMilletPancakeCook() *milletPancakeCook {
            return &milletPancakeCook{}
        }

        func (cook *milletPancakeCook) MakePancake() Pancake {
            return NewMilletPancake()
        }
    ```
- 运用
    ```go
        package factorymethod

        import (
            "fmt"
            "testing"
        )

        func TestFactoryMethod(t *testing.T) {
            pancakeVendor := NewPancakeVendor(NewCornPancakeCook())
            fmt.Printf("Corn pancake value is %v\n", pancakeVendor.SellPancake())

            pancakeVendor = NewPancakeVendor(NewMilletPancakeCook())
            fmt.Printf("Millet pancake value is %v\n", pancakeVendor.SellPancake())
        }
    ```
- 输出
    ```
        Corn pancake value is 5
        Millet pancake value is 8
    ```


