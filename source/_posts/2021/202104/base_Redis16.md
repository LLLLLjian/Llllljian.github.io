---
title: Redis_基础 (16)
date: 2021-04-09
tags: 
    - Redis
    - Python
toc: true
---

### 关于集合
    python集合的应用

<!-- more -->

#### 示例
> 假设, 要做一个学生选课情况实时监控系统, 则需要实时知道以下几个数据:(1)当前一共有多少学生至少选了一门课. (2)选了A课没有选B课的学生有多少. (3)既选了A课又选了B课的学生有多少. (4)A、B两门课至少选了一门的学生有多少.
1. code
    ```python
        import redis

        client = redis.Redis(host='xx.xx.xx.xx')
        all_class = [
            'algorithm',
            'computer',
            'history',
            'circuit_design',
            'math'
        ]

        def all_student():
            students = client.sunion(*all_class)
            return len(students)

        def in_a_and_in_b(class_a, class_b):
            students = clinet.sinter(class_a, class_b)
            return len(students)

        def in_a_not_in_b(class_a, class_b):
            students = clinet.sdiff(class_a, class_b)
            return len(students)

        def in_a_or_in_b(class_a, class_b):
            students = clinet.sunion(class_a, class_b)
            return len(students)

        if __name__ == '__main__':
            print(f'当前一共有 {all_student()} 名学生至少选了一门课')
            print(f'当前选了math, 没有选computer的学生有: {in_a_not_in_b("match", "computer")}')
            print(f'当前选了math, 也选了computer的学生有: {in_a_and_in_b("match", "computer")}')
            print(f'当前选了math, 或者选了computer的学生有: {in_a_or_in_b("match", "computer")}')
    ```


