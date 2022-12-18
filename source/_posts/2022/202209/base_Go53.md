---
title: Go_基础 (53)
date: 2022-09-20
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(组合模式)

<!-- more -->

#### 桥接模式
- 概念

组合是一种结构型设计模式, 你可以使用它将对象组合成树状结构, 并且能像使用独立对象一样使用它们. 


对于绝大多数需要生成树状结构的问题来说, 组合都是非常受欢迎的解决方案. 组合最主要的功能是在整个树状结构上递归调用方法并对结果进行汇总. 

- 示例

一般来说一个地区统计人口或经济总量, 总是通过行政区划一层层上报汇总得出结果, 区镇是最低一级行政区划, 需要落实统计人口及经济总量的工作, 再上一级行政区划需要将所辖区镇的数据汇总统计, 以此类推每一级行政区划都需要统计人口与经济总量, 就像一个倒过来的树状结构, 各级行政区划统一的组件接口是统计人口与经济总量, 区镇相当于最底层的叶子节点, 中间级别行政区划相当于组合节点；下面代码以苏州市为例；

- 组件接口
    ```go
        package composite

        // Region 行政区, 作为组合模式component接口
        type Region interface {
            Name() string    // 名称
            Population() int //人口
            GDP() float64    // gdp
        }
    ```
- 区镇实现
    ```go
        package composite

        // town 区镇, 组合模式中相当于叶子节点
        type town struct {
            name       string
            population int
            gdp        float64
        }

        // NewTown 创建区镇, 根据名称、人口、GDP
        func NewTown(name string, population int, gdp float64) *town {
            return &town{
                name:       name,
                population: population,
                gdp:        gdp,
            }
        }

        func (c *town) Name() string {
            return c.name
        }

        func (c *town) Population() int {
            return c.population
        }

        func (c *town) GDP() float64 {
            return c.gdp
        }
    ```
- 县市地市实现
    ```go
        package composite

        // cities 市, 包括县市或者地市, 组合模式中相当于composite
        type cities struct {
            name    string
            regions map[string]Region
        }

        // NewCities 创建一个市
        func NewCities(name string) *cities {
            return &cities{
                name:    name,
                regions: make(map[string]Region),
            }
        }

        func (c *cities) Name() string {
            return c.name
        }

        func (c *cities) Population() int {
            sum := 0
            for _, r := range c.regions {
                sum += r.Population()
            }
            return sum
        }

        func (c *cities) GDP() float64 {
            sum := 0.0
            for _, r := range c.regions {
                sum += r.GDP()
            }
            return sum
        }

        // Add 添加多个行政区
        func (c *cities) Add(regions ...Region) {
            for _, r := range regions {
                c.regions[r.Name()] = r
            }
        }

        // Remove 递归删除行政区
        func (c *cities) Remove(name string) {
            for n, r := range c.regions {
                if n == name {
                delete(c.regions, name)
                return
                }
                if city, ok := r.(*cities); ok {
                city.Remove(name)
                }
            }
        }

        func (c *cities) Regions() map[string]Region {
            return c.regions
        }
    ```
- 测试程序
    ```go
        package composite

        import (
            "fmt"
            "testing"
        )

        func TestComposite(t *testing.T) {
            gusu := NewTown("姑苏区", 100, 2000.00)
            fmt.Println(ShowRegionInfo(gusu))
            wuzhong := NewTown("吴中区", 150, 2600.00)
            fmt.Println(ShowRegionInfo(wuzhong))
            huqiu := NewTown("虎丘区", 80, 1800.00)
            fmt.Println(ShowRegionInfo(huqiu))

            kunshan := NewCities("昆山市")
            kunshan.Add(NewTown("玉山镇", 60, 1200.00),
                NewTown("周庄镇", 68, 1900.00),
                NewTown("花桥镇", 78, 2200.00))
            fmt.Println(ShowRegionInfo(kunshan))

            changshu := NewCities("常熟市")
            changshu.Add(NewTown("沙家浜镇", 55, 1100.00),
                NewTown("古里镇", 59, 1300.00),
                NewTown("辛庄镇", 68, 2100.00))
            fmt.Println(ShowRegionInfo(changshu))

            suzhou := NewCities("苏州市")
            suzhou.Add(gusu, wuzhong, huqiu, kunshan, changshu)
            fmt.Println(ShowRegionInfo(suzhou))
        }

        func ShowRegionInfo(region Region) string {
            return fmt.Sprintf("%s, 人口:%d万, GDP:%.2f亿", region.Name(), region.Population(), region.GDP())
        }
    ```
- 运行结果
    ```
        姑苏区, 人口:100万, GDP:2000.00亿
        吴中区, 人口:150万, GDP:2600.00亿
        虎丘区, 人口:80万, GDP:1800.00亿
        昆山市, 人口:206万, GDP:5300.00亿
        常熟市, 人口:182万, GDP:4500.00亿
        苏州市, 人口:718万, GDP:16200.00亿
    ```



