---
title: Linux_基础 (46)
date: 2018-06-08
tags: Linux
toc: true
---

### shell运算符
    主要说一下涉及到数字的运算和比较

<!-- more -->

#### 算数运算符
- 算术运算符列表
    <table><tr><th>运算符</th><th>说明</th><th>举例[b=20 a=10]</th></tr><tr><td>+</td><td>加法</td><td>\`expr a+b\` 结果为 30</td> </tr> <tr>  <td>-</td>  <td>减法</td> <td>\`expr a−b\` 结果为 10.</td></tr><tr><td>*</td><td>乘法</td><td>\`expr a\*b\` 结果为  200.</td></tr><tr><td>/</td> <td>除法</td><td>\`expr b/a\` 结果为 2.</td> </tr> <tr>  <td>%</td><td>取余</td><td>\`expr ba\` 结果为 0.</td></tr> <tr> <td>=</td><td>赋值</td><td>a=$b将把变量 b 的值赋给 a.</td></tr><tr><td>==</td><td>相等.用于比较两个数字,相同则返回 true.</td>  <td>[ a==b ] 返回 false.</td> </tr><tr><td>!=</td>  <td>不相等.用于比较两个数字,不相同则返回 true.</td> <td>[ a!=b ] 返回 true.</td></tr></table>
- 在shell脚本中的应用
    ```bash
        [llllljian@llllljian-virtual-machine 20180608 21:27:10 #131]$ cat 1.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 1.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 21时26分29秒
        # 更新时间: 2018年06月08日 星期五 21时26分29秒
        # 注释: 算数运算符
        #########################################################################

        a=10
        b=20
        echo "a : $a"
        echo "b : $b\n"

        val=\`expr $a + $b\`
        echo "a + b : $val"

        echo "a + b : $((${a} + ${b})) \n"

        val=\`expr $a - $b\`
        echo "a - b : $val"

        echo "a - b : $((${a} - ${b})) \n"

        val=\`expr $a \* $b\`
        echo "a * b : $val"

        echo "a * b : $((${a} * ${b})) \n"

        val=\`expr $b / $a\`
        echo "b / a : $val"

        echo "b / a : $((${b} / ${a})) \n"

        val=\`expr $b % $a\`
        echo "b % a : $val"

        echo "b % a : $((${b} % ${a}))"

        [llllljian@llllljian-virtual-machine 20180608 21:27:14 #132]$ sh 1.sh
        a : 10
        b : 20

        a + b : 30
        a + b : 30

        a - b : -10
        a - b : -10

        a * b : 200
        a * b : 200

        b / a : 2
        b / a : 2

        b % a : 0
        b % a : 0
    ```

#### 关系运算符
- 关系运算符列表
    <table><tr><th>运算符</th><th>说明</th><th>举例</th></tr><tr><td>-eq</td><td>检测两个数是否相等,相等返回 true</td><td>[ a−eqa−eqb ] 返回 true</td></tr><tr><td>-ne</td><td>检测两个数是否相等,不相等返回 true</td><td>[ a−nea−neb ] 返回 true</td></tr><tr><td>-gt</td><td>检测左边的数是否大于右边的,如果是,则返回 true</td><td>[ a−gta−gtb ] 返回 false</td></tr><tr><td>-lt</td><td>检测左边的数是否小于右边的,如果是,则返回 true</td><td>[ a−lta−ltb ] 返回 true</td></tr><tr><td>-ge</td><td>检测左边的数是否大等于右边的,如果是,则返回 true</td><td>[ a−gea−geb ] 返回 false</td></tr><tr><td>-le</td><td>检测左边的数是否小于等于右边的,如果是,则返回 true</td><td>[ a−lea−leb ] 返回 true</td></tr><table>
- 在shell脚本中的应用
    ```bash
        [llllljian@llllljian-virtual-machine 20180608 22:20:10 #22]$ cat 3.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 3.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 22时18分39秒
        # 更新时间: 2018年06月08日 星期五 22时18分39秒
        # 注释: 关系运算符
        #########################################################################

        a=10
        b=20

        if [ $a -eq $b ]; then
            echo "$a -eq $b : a is equal to b"
        else
            echo "$a -eq $b: a is not equal to b"
        fi

        if [ $a -ne $b ]; then
            echo "$a -ne $b: a is not equal to b"
        else
            echo "$a -ne $b : a is equal to b"
        fi

        if [ $a -gt $b ]; then
            echo "$a -gt $b: a is greater than b"
        else
            echo "$a -gt $b: a is not greater than b"
        fi

        if [ $a -lt $b ]; then
            echo "$a -lt $b: a is less than b"
        else
            echo "$a -lt $b: a is not less than b"
        fi

        if [ $a -ge $b ]; then
            echo "$a -ge $b: a is greater or equal to b"
        else
            echo "$a -ge $b: a is not greater or equal to b"
        fi

        if [ $a -le $b ]; then
            echo "$a -le $b: a is less or equal to b"
        else
            echo "$a -le $b: a is not less or equal to b"
        fi

        [llllljian@llllljian-virtual-machine 20180608 22:20:12 #23]$ sh 3.sh
        10 -eq 20: a is not equal to b
        10 -ne 20: a is not equal to b
        10 -gt 20: a is not greater than b
        10 -lt 20: a is less than b
        10 -ge 20: a is not greater or equal to b
        10 -le 20: a is less or equal to b
    ```

#### 布尔运算符
- 布尔运算符列表
    <table><tr><th>运算符</th><th>说明</th><th>举例</th></tr><tr><td>!</td><td>非运算,表达式为 true 则返回 false,否则返回 true</td><td>[ ! false ] 返回 true</td></tr><tr><td>-o</td><td>或运算,有一个表达式为 true 则返回 true</td><td>[ a−lt20−oa−lt20−ob -gt 100 ] 返回 true</td></tr><tr><td>-a</td><td>与运算,两个表达式都为 true 才返回 true</td><td>[ a−lt20−aa−lt20−ab -gt 100 ] 返回 false</td></tr></table>
- 在shell脚本中的应用
    ```bash
        [llllljian@llllljian-virtual-machine 20180608 22:31:00 #27]$ cat 4.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 4.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 22时30分39秒
        # 更新时间: 2018年06月08日 星期五 22时30分39秒
        # 注释: 布尔运算符
        #########################################################################

        a=10
        b=20

        if [ $a != $b ]; then
            echo "$a != $b : a is not equal to b"
        else
            echo "$a != $b: a is equal to b"
        fi

        if [ $a -lt 100 -a $b -gt 15 ]; then
            echo "$a -lt 100 -a $b -gt 15 : returns true"
        else
            echo "$a -lt 100 -a $b -gt 15 : returns false"
        fi

        if [ $a -lt 100 -o $b -gt 100 ]; then
            echo "$a -lt 100 -o $b -gt 100 : returns true"
        else
            echo "$a -lt 100 -o $b -gt 100 : returns false"
        fi

        if [ $a -lt 5 -o $b -gt 100 ]; then
            echo "$a -lt 100 -o $b -gt 100 : returns true"
        else
            echo "$a -lt 100 -o $b -gt 100 : returns false"
        fi

        [llllljian@llllljian-virtual-machine 20180608 22:31:04 #28]$ sh 4.sh
        10 != 20 : a is not equal to b
        10 -lt 100 -a 20 -gt 15 : returns true
        10 -lt 100 -o 20 -gt 100 : returns true
        10 -lt 100 -o 20 -gt 100 : returns false
    ```

#### 字符串运算符
- 字符串运算符列表
    <table><tr><th>运算符</th><th>说明</th><th>举例</th></tr><tr><td>=</td><td>检测两个字符串是否相等,相等返回 true</td><td>[ a=a=b ] 返回 false</td></tr><tr><td>!=</td><td>检测两个字符串是否相等,不相等返回 true</td><td>[ a!=a!=b ] 返回 true</td></tr><tr><td>-z</td><td>检测字符串长度是否为0,为0返回 true</td><td>[ -z $a ] 返回 false</td></tr><tr><td>-n</td><td>检测字符串长度是否为0,不为0返回 true</td><td>[ -z $a ] 返回 true</td></tr><tr><td>str</td><td>检测字符串是否为空,不为空返回 true</td><td>[ $a ] 返回 true</td></tr></table>
- 在shell脚本中的应用
    ```bash
        [llllljian@llllljian-virtual-machine 20180608 22:36:00 #32]$ cat 5.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 5.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 22时34分42秒
        # 更新时间: 2018年06月08日 星期五 22时34分42秒
        # 注释:  字符串运算符
        #########################################################################

        a="abc"
        b="efg"

        if [ $a = $b ]; then
            echo "$a = $b : a is equal to b"
        else
            echo "$a = $b: a is not equal to b"
        fi

        if [ $a != $b ]; then
            echo "$a != $b : a is not equal to b"
        else
            echo "$a != $b: a is equal to b"
        fi

        if [ -z $a ]; then
            echo "-z $a : string length is zero"
        else
            echo "-z $a : string length is not zero"
        fi

        if [ -n $a ]; then
            echo "-n $a : string length is not zero"
        else
            echo "-n $a : string length is zero"
        fi

        if [ $a ]; then
            echo "$a : string is not empty"
        else
            echo "$a : string is empty"
        fi

        [llllljian@llllljian-virtual-machine 20180608 22:36:05 #33]$ sh 5.sh
        abc = efg: a is not equal to b
        abc != efg : a is not equal to b
        -z abc : string length is not zero
        -n abc : string length is not zero
        abc : string is not empty
    ```
