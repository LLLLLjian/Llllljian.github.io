---
title: Linux_基础 (39)
date: 2018-05-31
tags: Linux
toc: true
---

### 正则表示法与通配符
    正则表示法:通过一些特殊字符的排列,以行尾单位进行字符串,用以[搜寻/取代/删除]一列或多列文字字符串
    通配符:由shell解析的,只用于文件名匹配

<!-- more -->

#### 正则表示法
- 特殊匹配模式列表
    <table><tr><td>匹配模式</td><td>含义</td></tr><tr><td>[:alnum:]</td><td>字母与数字字符,如grep[[:alnum:]] words.txt</td></tr><tr><td>[:alpha:]</td><td>字母</td></tr><tr><td>[:ascii:]</td><td>ASCII字符</td></tr><tr><td>[:blank:]</td><td>空格或制表符</td></tr><tr><td>[:cntrl:]</td><td>ASCII控制字符</td></tr><tr><td>[:digit:]</td><td>数字</td></tr><tr><td>[:graph:]</td><td>非控制、非空格字符</td></tr><tr><td>[:lower:]</td><td>小写字母</td></tr><tr><td>[:print:]</td><td>可打印字符</td></tr><tr><td>[:punct:]</td><td>标点符号字符</td></tr><tr><td>[:space:]</td><td>空白字符，包括垂直制表符</td></tr><tr><td>[:upper:]</td><td>大写字母</td></tr><tr><td>[:xdigit:]</td><td>十六进制数字</td></tr></table>
- 实例 
    ```bash
        为了排除字符编码不一致的问题,增加了特殊匹配模式
        [llllljian@llllljian-virtual-machine 20180531 17:05:50 #6]$ cat 1.txt
        1A
        a一
        2B
        b二
        3C
        c三
        4D
        d四
        5E
        e五
        6F
        f六

        [llllljian@llllljian-virtual-machine 20180531 17:05:53 #7]$ grep [:digit:] 1.txt
        grep: 字符类的语法是 [[:space:]],而非 [:space:]
        
        [llllljian@llllljian-virtual-machine 20180531 17:06:34 #9]$ grep [[:digit:]] 1.txt
        1A
        2B
        3C
        4D
        5E
        6F

        [llllljian@llllljian-virtual-machine 20180531 17:08:24 #11]$ grep [[:lower:]] 1.txt
        a一
        b二
        c三
        d四
        e五
        f六
    ```

- 特殊字符列表
    <table><tr><td>字符</td><td>含义</td></tr><tr><td>^</td><td>指向一行的开头</td></tr><tr><td>$</td><td>指向一行的结尾</td></tr><tr><td>.</td><td>任意单个字符</td></tr><tr><td>[]</td><td>字符范围。如[a-z]</td></tr></table>
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180531 19:35:57 #13]$ grep '^[a-z]' 1.txt
        a一
        b二
        c三
        d四
        e五
        f六

        [llllljian@llllljian-virtual-machine 20180531 19:43:21 #14]$ grep '[A-Z]$' 1.txt
        1A
        2B
        3C
        4D
        5E
        6F
    ```

- 扩展列表
    <table><tr><td>选项</td><td>含义</td></tr><tr><td>?</td><td>最多一次</td></tr><tr><td>*</td><td>必须匹配0次或多次</td></tr><tr><td>+</td><td>必须匹配1次或多次</td></tr><tr><td>{n}</td><td>必须匹配n次</td></tr><tr><td>{n,}</td><td>必须匹配n次或以上</td></tr><tr><td>{n,m}</td><td>匹配次数在n到m之间，包括边界</td></tr></table>
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180531 20:02:47 #37]$ cat 2.txt 
        aaa
        111
        bb
        22
        dddd
        4444

        [llllljian@llllljian-virtual-machine 20180531 20:09:10 #38]$ grep '[a-z]\{4,\}' 2.txt
        dddd
    ```

#### 通配符

- 通配符列表
    <table><tr><td><strong>通配符</strong></td><td><strong>含义</strong></td><td><strong>实例</strong></td></tr><tr><td>*</td><td>匹配 0 或多个字符</td><td>a*b a与b之间可以有任意长度的任意字符, 也可以一个也没有, 如aabcb, axyzb, a012b, ab。</td></tr><tr><td>?</td><td>匹配任意一个字符</td><td>a?b a与b之间必须也只能有一个字符, 可以是任意字符, 如aab, abb, acb, a0b。</td></tr><tr><td><td>匹配 list 中的任意单一字符</td><td>a[xyz]b &nbsp;a与b之间必须也只能有一个字符, 但只能是 x 或 y 或 z, 如: axb, ayb, azb。</td></tr><tr><td>[!list]或[^list]</td><td>匹配 除list 中的任意单一字符</td><td>a[!0-9]b a与b之间必须也只能有一个字符, 但不能是阿拉伯数字, 如axb, aab, a-b。</td></tr><tr><td>[c1-c2]</td><td>匹配 c1-c2 中的任意单一字符 如：[0-9] [a-z]</td><td>a[0-9]b 0与9之间必须也只能有一个字符 如a0b, a1b... a9b。</td></tr><tr><td>[!c1-c2]或[^c1-c2]</td><td>匹配不在c1-c2的任意字符</td><td>a[!0-9]b 如acb adb</td></tr><tr><td>{string1,string2,...}</td><td>匹配 sring1 或 string2 (或更多)其一字符串</td><td>a{abc,xyz,123}b 列出aabcb,axyzb,a123b</td></tr></table>

- Meta字符[元字符]列表
    <table><tr><td>字符</td><td>说明</td></tr><tr><td>IFS</td><td>由 &lt;space&gt; 或 &lt;tab&gt; 或 &lt;enter&gt; 三者之一组成(我们常用 space )</td></tr><tr><td>CR</td><td>由 &lt;enter&gt; 产生</td></tr><tr><td>=</td><td>设定变量</td></tr><tr><td>$</td><td>取变量值或取运算值</td></tr><tr><td>&gt;&nbsp;</td><td>重定向 stdout</td></tr><tr><td>&lt;&nbsp;</td><td>重定向 stdin</td></tr><tr><td>|</td><td>管道符号</td></tr><tr><td>&amp;</td><td>重导向 file descriptor ，或将命令置于背景执行</td></tr><tr><td>( )</td><td>将其内的命令置于 nested subshell 执行，或用于运算或命令替换</td></tr><tr><td>{ }</td><td>将其内的命令置于 non-named function 中执行，或用在变量替换的界定范围</td></tr><tr><td>;</td><td>在前一个命令结束时，而忽略其返回值，继续执行下一个命令</td></tr><tr><td>&amp;&amp;</td><td>在前一个命令结束时，若返回值为 true，继续执行下一个命令</td></tr><tr><td>||</td><td>在前一个命令结束时，若返回值为 false，继续执行下一个命令</td></tr><tr><td>!</td><td>运算意义上的非（not）的意思</td></tr><tr><td>#</td><td>注释，常用在脚本中</td></tr><tr><td>\</td><td>转移字符，去除其后紧跟的元字符或通配符的特殊意义</td></tr></table>

- 转义字符列表
    <table><tr><td>字符</td><td>说明</td></tr><tr><td>‘’(单引号)</td><td>硬转义，其内部所有的shell 元字符、通配符都会被关掉。</td></tr><tr><td>“”(双引号)</td><td>软转义，其内部只允许出现特定的shell 元字符：$用于参数替换 `(反单引号，esc键下面)用于命令替换</td></tr><tr><td>\(反斜杠)</td><td>又叫转义，去除其后紧跟的元字符或通配符的特殊意义</td></tr></table>

#### 通配符和正则表达式比较
- 通配符和正则表达式看起来有点像，不能混淆。可以简单的理解为通配符只有*,?,[],{}这4种，而正则表达式复杂多了。
- *在通配符和正则表达式中有其不一样的地方，在通配符中*可以匹配任意的0个或多个字符，而在正则表达式中他是重复之前的一个或者多个字符，不能独立使用的。比如通配符可以用*来匹配任意字符，而正则表达式不行，他只匹配任意长度的前面的字符。