---
title: Python_基础 (25)
date: 2019-01-10
tags: Python
toc: true
---

### 类实例
    Python3学习笔记
    写一个关于学生的实例

<!-- more -->

#### 学生类实例
- eg
    ```python
        class Student():
            studentCount = 0
            t1="开始展示学生信息"
            t2="学生信息展示结束"

            def __init__(self, name, score, age = "20"):
                self.__name = name
                self.__score = score
                self.age = age
                Student.studentCount += 1

            def set_name(self, name):
                self.__name = name

            def set_score(self, score):
                self.__score = score
            
            def set_age(self, age):
                self.age = age

            def get_name(self):
                return self.__name

            def get_score(self):
                return self.__score
            
            def get_age(self):
                return self.age

            def print_score(self):
                grade = self.get_grade()
                ageGrade = self.get_Agegrade(self.age)
                print(self.t1.center(50,"*"))
                print('这是第%s个学生' % (self.studentCount))
                print('学生姓名是%s' % (self.__name))
                print('学生年龄为%s' % (self.age))
                print('学生为%s' % (ageGrade))
                print('学生成绩为%s' % (self.__score))
                print('成绩等级为%s' % (grade))
                print(self.t2.center(50,"*"))

            def get_grade(self):
                if int(self.__score) >= 90:
                    return 'A'
                elif int(self.__score) >= 60:
                    return 'B'
                else:
                    return 'C'
            
            def get_Agegrade(self, age):
                if int(age) >= 80:
                    return '老年'
                elif int(age) >= 50:
                    return '中年'
                elif int(age) >= 20:
                    return '青年'
                else:
                    return '少年'

        s = Student("llllljian", "95")
        s.print_score()

        s1 = Student("llllljian1", "20", "10")
        s1.print_score()
        s1.set_age(100)
        s1.set_score(88)
        s1.set_name("llllljian2")
        s1.print_score()

        s2 = Student("llllljian3", "1", "1")
        s2.print_score()
        s2._Student__score = 100
        s2.print_score()

        print("实例化了%s个学生" % Student.studentCount)

        class schoolOne(Student):
            def __init__(self, name, score, age = "20", schoolName = "一中"):
                super(schoolOne, self).__init__(name, score, age)
                self.schoolName = schoolName

        s3 = schoolOne("llllljian4", 88)
        s3.print_score()
        print("实例化了%s个学生" % Student.studentCount)
    ```

