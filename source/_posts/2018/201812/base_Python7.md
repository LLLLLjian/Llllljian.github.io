---
title: Python_基础 (7)
date: 2018-12-14
tags: Python
toc: true
---

### Python3数字
    Python 数字数据类型用于存储数值
    数据类型是不允许改变的,这就意味着如果改变数字数据类型的值,将重新分配内存空间

<!-- more -->

#### Python3数值类型
- 整型(Int) 
    * 通常被称为是整型或整数,是正或负整数,不带小数点.Python3 整型是没有限制大小的,可以当作 Long 类型使用,所以 Python3 没有 Python2 的 Long 类型
- 浮点型(float) 
    * 浮点型由整数部分与小数部分组成,浮点型也可以使用科学计数法表示(2.5e2 = 2.5 x 102 = 250)
- 复数( (complex))
    * 复数由实数部分和虚数部分构成,可以用a + bj,或者complex(a,b)表示, 复数的实部a和虚部b都是浮点型

#### Python3数值创建
    var1 = 1
    var2 = 10

#### Python3数值删除
    del var
    del var_a, var_b

#### Python3数字类型转换
- int(x) 
    * 将x转换为一个整数
- float(x) 
    * 将x转换到一个浮点数
- complex(x) 
    * 将x转换到一个复数,实数部分为x,虚数部分为 0
- complex(x, y)
    * 将x和y转换到一个复数,实数部分为x,虚数部分为y

#### Python3数字
    交互模式中,最后被输出的表达式结果被赋值给变量 _

#### 数学函数
- list
    <table class="reference"><tbody><tr><th>函数</th><th>返回值 ( 描述 )</th></tr><tr><td>abs(x)</td><td>返回数字的绝对值,如abs(-10) 返回 10</td></tr><tr><td>ceil(x)</td><td>返回数字的上入整数,如math.ceil(4.1) 返回 5</td></tr><tr><td><p>cmp(x, y)</p></td><td>如果 x &lt; y 返回 -1, 如果 x == y 返回 0, 如果 x &gt; y 返回 1.<strong>Python 3 已废弃</strong> .使用<strong> 使用 (x&gt;y)-(x&lt;y)</strong> 替换.</td></tr><tr><td>exp(x)</td><td>返回e的x次幂(e<sup>x</sup>),如math.exp(1) 返回2.718281828459045</td></tr><tr><td>fabs(x)</td><td>返回数字的绝对值,如math.fabs(-10) 返回10.0</td></tr><tr><td>floor(x)</td><td>返回数字的下舍整数,如math.floor(4.9)返回 4</td></tr><tr><td>log(x)</td><td>如math.log(math.e)返回1.0,math.log(100,10)返回2.0</td></tr><tr><td>log10(x)</td><td>返回以10为基数的x的对数,如math.log10(100)返回 2.0</td></tr><tr><td>max(x1, x2,...)</td><td>返回给定参数的最大值,参数可以为序列.</td></tr><tr><td>min(x1, x2,...)</td><td>返回给定参数的最小值,参数可以为序列.</td></tr><tr><td>modf(x)</td><td>返回x的整数部分与小数部分,两部分的数值符号与x相同,整数部分以浮点型表示.</td></tr><tr><td>pow(x, y)</td><td> x**y 运算后的值.</td></tr><tr><td>round(x [,n])</td><td>返回浮点数x的四舍五入值,如给出n值,则代表舍入到小数点后的位数.</td></tr><tr><td>sqrt(x)</td><td>返回数字x的平方根.</td></tr></tbody></table>

#### 随机数函数
- list
    <table class="reference"><tbody><tr><th>函数</th><th>描述</th></tr><tr><td>choice(seq)</td><td>从序列的元素中随机挑选一个元素,比如random.choice(range(10)),从0到9中随机挑选一个整数.</td></tr><tr><td>randrange ([start,] stop [,step])</td><td>从指定范围内,按指定基数递增的集合中获取一个随机数,基数缺省值为1</td></tr><tr><td>random()</td><td> 随机生成下一个实数,它在[0,1)范围内.</td></tr><tr><td>seed([x])</td><td>改变随机数生成器的种子seed.如果你不了解其原理,你不必特别去设定seed,Python会帮你选择seed.</td></tr><tr><td>shuffle(lst)</td><td>将序列的所有元素随机排序</td></tr><tr><td>uniform(x, y)</td><td>随机生成下一个实数,它在[x,y]范围内.</td></tr></tbody></table>

#### 三角函数
- list
    <table class="reference"><tbody><tr><th>函数</th><th>描述</th></tr><tr><td>acos(x)</td><td>返回x的反余弦弧度值.</td></tr><tr><td>asin(x)</td><td>返回x的反正弦弧度值.</td></tr><tr><td>atan(x)</td><td>返回x的反正切弧度值.</td></tr><tr><td>atan2(y, x)</td><td>返回给定的 X 及 Y 坐标值的反正切值.</td></tr><tr><td>cos(x)</td><td>返回x的弧度的余弦值.</td></tr><tr><td>hypot(x, y)</td><td>返回欧几里德范数 sqrt(x*x + y*y).</td></tr><tr><td>sin(x)</td><td>返回的x弧度的正弦值.</td></tr><tr><td>tan(x)</td><td>返回x弧度的正切值.</td></tr><tr><td>degrees(x)</td><td>将弧度转换为角度,如degrees(math.pi/2) ,  返回90.0</td></tr><tr><td>radians(x)</td><td>将角度转换为弧度</td></tr></tbody></table>


