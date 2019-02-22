---
title: Smarty_基础 (3)
date: 2018-12-03
tags: Smarty
toc: true
---

### Smarty基础
    Smarty的基本使用与总结

<!-- more -->

#### 内置函数
- {foreach},{foreachelse}
    * 遍历数据数组,也可以用来遍历关联数组
    * index
        * 包含当前数组的下标,开始时为0
    * iteration
        * 包含当前数组的下标,开始时为1
    * first
        * 当{foreach}循环第一个时first为真
    * last
        * 当{foreach}迭代到最后时last为真
    * show
        * 检测{foreach}循环是否无数据显示,show是个布尔值(true or false)
    * total
        * total包含{foreach}循环的总数(整数), 可以用在{forach}里面或后面
- {if},{elseif},{else}
    <table border="1"><colgroup><col align="center"><col align="center"><col><col><col></colgroup><thead><tr><th align="center">运算符</th><th align="center">别名</th><th>语法示例</th><th>含义</th><th>对应PHP语法</th></tr></thead><tbody><tr><td align="center">==</td><td align="center">eq</td><td>$a eq $b</td><td>等于</td><td>==</td></tr><tr><td align="center">!=</td><td align="center">ne, neq</td><td>$a neq $b</td><td>不等于</td><td>!=</td></tr><tr><td align="center">&gt;</td><td align="center">gt</td><td>$a gt $b</td><td>大于</td><td>&gt;</td></tr><tr><td align="center">&lt;</td><td align="center">lt</td><td>$a lt $b</td><td>小于</td><td>&lt;</td></tr><tr><td align="center">&gt;=</td><td align="center">gte, ge</td><td>$a ge $b</td><td>大于等于</td><td>&gt;=</td></tr><tr><td align="center">&lt;=</td><td align="center">lte, le</td><td>$a le $b</td><td>小于等于</td><td>&lt;=</td></tr><tr><td align="center">===</td><td align="center">&nbsp;</td><td>$a === 0</td><td>绝对等于</td><td>===</td></tr><tr><td align="center">!</td><td align="center">not</td><td>not $a</td><td>非 (一元运算)</td><td>!</td></tr><tr><td align="center">%</td><td align="center">mod</td><td>$a mod $b</td><td>取模</td><td>%</td></tr><tr><td align="center">is [not] div by</td><td align="center">&nbsp;</td><td>$a is not div by 4</td><td>取模为0</td><td>$a % $b == 0</td></tr><tr><td align="center">is [not] even</td><td align="center">&nbsp;</td><td>$a is not even</td><td>[非] 取模为0 (一元运算)</td><td>$a % 2 == 0</td></tr><tr><td align="center">is [not] even by</td><td align="center">&nbsp;</td><td>$a is not even by $b</td><td>水平分组 [非] 平均</td><td>($a / $b) % 2 == 0</td></tr><tr><td align="center">is [not] odd</td><td align="center">&nbsp;</td><td>$a is not odd</td><td>[非] 奇数 (一元运算)</td><td>$a % 2 != 0</td></tr><tr><td align="center">is [not] odd by</td><td align="center">&nbsp;</td><td>$a is not odd by $b</td><td>[非] 奇数分组</td><td>($a / $b) % 2 != 0</td></tr></tbody></table>
- {include}
    * {include}标签用于在当前模板中包含其它模板.当前模板中的任何有效变量在被包含模板中同样可用

