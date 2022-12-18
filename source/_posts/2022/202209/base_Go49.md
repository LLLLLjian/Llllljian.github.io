---
title: Go_基础 (49)
date: 2022-09-14
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(访问者模式)

<!-- more -->

#### 访问者模式
- 概念

访问者模式是一种行为设计模式, 它能将算法与其所作用的对象隔离开来. 允许你在不修改已有代码的情况下向已有类层次结构中增加新的行为. 

访问者接口需要根据被访问者具体类, 定义多个相似的访问方法, 每个具体类对应一个访问方法；每个被访问者需要实现一个接受访问者对象的方法, 方法的实现就是去调用访问者接口对应该类的访问方法；这个接受方法可以传入不同目的访问者接口的具体实现, 从而在不修改被访问对象的前提下, 增加新的功能；

- 示例

公司中存在多种类型的员工, 包括产品经理、软件工程师、人力资源等, 他们的KPI指标不尽相同, 产品经理为上线产品数量及满意度, 软件工程师为实现的需求数及修改bug数, 人力资源为招聘员工的数量；公司要根据员工完成的KPI进行表彰公示, 同时根据KPI完成情况定薪酬, 这些功能都是员工类职责之外的, 不能修改员工本身的类, 我们通过访问者模式, 实现KPI表彰排名及薪酬发放；

- 员工结构
    ```go
        package visitor

        import "fmt"

        // Employee 员工接口
        type Employee interface {
            KPI() string                    // 完成kpi信息
            Accept(visitor EmployeeVisitor) // 接受访问者对象
        }

        // productManager 产品经理
        type productManager struct {
            name         string // 名称
            productNum   int    // 上线产品数
            satisfaction int    // 平均满意度
        }

        func NewProductManager(name string, productNum int, satisfaction int) *productManager {
            return &productManager{
                name:         name,
                productNum:   productNum,
                satisfaction: satisfaction,
            }
        }

        func (p *productManager) KPI() string {
            return fmt.Sprintf("产品经理%s, 上线%d个产品, 平均满意度为%d", p.name, p.productNum, p.satisfaction)
        }

        func (p *productManager) Accept(visitor EmployeeVisitor) {
            visitor.VisitProductManager(p)
        }

        // softwareEngineer 软件工程师
        type softwareEngineer struct {
            name           string // 姓名
            requirementNum int    // 完成需求数
            bugNum         int    // 修复问题数
        }

        func NewSoftwareEngineer(name string, requirementNum int, bugNum int) *softwareEngineer {
            return &softwareEngineer{
                name:           name,
                requirementNum: requirementNum,
                bugNum:         bugNum,
            }
        }

        func (s *softwareEngineer) KPI() string {
            return fmt.Sprintf("软件工程师%s, 完成%d个需求, 修复%d个问题", s.name, s.requirementNum, s.bugNum)
        }

        func (s *softwareEngineer) Accept(visitor EmployeeVisitor) {
            visitor.VisitSoftwareEngineer(s)
        }

        // hr 人力资源
        type hr struct {
            name       string // 姓名
            recruitNum int    // 招聘人数
        }

        func NewHR(name string, recruitNum int) *hr {
            return &hr{
                name:       name,
                recruitNum: recruitNum,
            }
        }

        func (h *hr) KPI() string {
            return fmt.Sprintf("人力资源%s, 招聘%d名员工", h.name, h.recruitNum)
        }

        func (h *hr) Accept(visitor EmployeeVisitor) {
            visitor.VisitHR(h)
        }
    ```
- 员工访问者
    ```go
        package visitor

        import (
            "fmt"
            "sort"
        )

        // EmployeeVisitor 员工访问者接口
        type EmployeeVisitor interface {
            VisitProductManager(pm *productManager)     // 访问产品经理
            VisitSoftwareEngineer(se *softwareEngineer) // 访问软件工程师
            VisitHR(hr *hr)                             // 访问人力资源
        }

        // kpi kpi对象
        type kpi struct {
            name string // 完成kpi姓名
            sum  int    // 完成kpi总数量
        }

        // kpiTopVisitor 员工kpi排名访问者
        type kpiTopVisitor struct {
            top []*kpi
        }

        func (k *kpiTopVisitor) VisitProductManager(pm *productManager) {
            k.top = append(k.top, &kpi{
                name: pm.name,
                sum:  pm.productNum + pm.satisfaction,
            })
        }

        func (k *kpiTopVisitor) VisitSoftwareEngineer(se *softwareEngineer) {
            k.top = append(k.top, &kpi{
                name: se.name,
                sum:  se.requirementNum + se.bugNum,
            })
        }

        func (k *kpiTopVisitor) VisitHR(hr *hr) {
            k.top = append(k.top, &kpi{
                name: hr.name,
                sum:  hr.recruitNum,
            })
        }

        // Publish 发布KPI排行榜
        func (k *kpiTopVisitor) Publish() {
            sort.Slice(k.top, func(i, j int) bool {
                return k.top[i].sum > k.top[j].sum
            })
            for i, curKPI := range k.top {
                fmt.Printf("第%d名%s：完成KPI总数%d\n", i+1, curKPI.name, curKPI.sum)
            }
        }

        // salaryVisitor 薪酬访问者
        type salaryVisitor struct{}

        func (s *salaryVisitor) VisitProductManager(pm *productManager) {
            fmt.Printf("产品经理基本薪资：1000元, KPI单位薪资：100元, ")
            fmt.Printf("%s, 总工资为%d元\n", pm.KPI(), (pm.productNum+pm.satisfaction)*100+1000)
        }

        func (s *salaryVisitor) VisitSoftwareEngineer(se *softwareEngineer) {
            fmt.Printf("软件工程师基本薪资：1500元, KPI单位薪资：80元, ")
            fmt.Printf("%s, 总工资为%d元\n", se.KPI(), (se.requirementNum+se.bugNum)*80+1500)
        }

        func (s *salaryVisitor) VisitHR(hr *hr) {
            fmt.Printf("人力资源基本薪资：800元, KPI单位薪资：120元, ")
            fmt.Printf("%s, 总工资为%d元\n", hr.KPI(), hr.recruitNum*120+800)
        }
    ```
- 测试程序
    ```go
        package visitor

        import "testing"

        func TestVisitor(t *testing.T) {
            allEmployees := AllEmployees() // 获取所有员工
            kpiTop := new(kpiTopVisitor)   // 创建KPI排行访问者
            VisitAllEmployees(kpiTop, allEmployees)
            kpiTop.Publish() // 发布排行榜

            salary := new(salaryVisitor) // 创建薪酬访问者
            VisitAllEmployees(salary, allEmployees)
        }

        // VisitAllEmployees 遍历所有员工调用访问者
        func VisitAllEmployees(visitor EmployeeVisitor, allEmployees []Employee) {
            for _, employee := range allEmployees {
                employee.Accept(visitor)
            }
        }

        // AllEmployees 获得所有公司员工
        func AllEmployees() []Employee {
            var employees []Employee
            employees = append(employees, NewHR("小明", 10))
            employees = append(employees, NewProductManager("小红", 4, 7))
            employees = append(employees, NewSoftwareEngineer("张三", 10, 5))
            employees = append(employees, NewSoftwareEngineer("李四", 3, 6))
            employees = append(employees, NewSoftwareEngineer("王五", 7, 1))
            return employees
        }
    ```
- 运行结果
    ```
        第1名张三：完成KPI总数15
        第2名小红：完成KPI总数11
        第3名小明：完成KPI总数10
        第4名李四：完成KPI总数9
        第5名王五：完成KPI总数8
        人力资源基本薪资：800元, KPI单位薪资：120元, 人力资源小明, 招聘10名员工, 总工资为2000元
        产品经理基本薪资：1000元, KPI单位薪资：100元, 产品经理小红, 上线4个产品, 平均满意度为7, 总工资为2100元
        软件工程师基本薪资：1500元, KPI单位薪资：80元, 软件工程师张三, 完成10个需求, 修复5个问题, 总工资为2700元
        软件工程师基本薪资：1500元, KPI单位薪资：80元, 软件工程师李四, 完成3个需求, 修复6个问题, 总工资为2220元
        软件工程师基本薪资：1500元, KPI单位薪资：80元, 软件工程师王五, 完成7个需求
    ```


