---
title: Linux_基础 (79)
date: 2021-02-04
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 让文本飞

##### 使用sed进行文本替换
> sed是流编辑器(stream editor)的缩写
1. 替换给定文本中的字符串
    ```bash
        sed 's/pattern/replace_string/' file
        或者
        cat file | sed 's/pattern/replace_string/'
    ```
2. 将替换结果保存到源文件中
    ```bash
        sed -i 's/text/replace/' file
    ```
3. 全局替换或指定位置替换
    ```bash
        # 默认只替换第一处符合内容的地方
        [root@xxxxxx test]# echo thisthisthisthis | sed 's/this/THIS/'
        THISthisthisthis
        # 全局替换
        [root@xxxxxx test]# echo thisthisthisthis | sed 's/this/THIS/g'
        THISTHISTHISTHIS
        # 从第n处匹配开始替换
        [root@xxxxxx test]# echo thisthisthisthis | sed 's/this/THIS/2g'
        thisTHISTHISTHIS
    ```
4. 移除空白行
    ```bash
        sed '/^$/d' file
    ```
5. 已匹配字符串标记(&)
    ```bash
        # & 对应于之前所匹配到的单词
        [root@xxxxxx test]# echo this is an example | sed 's/\w\+/[&]/g'
        [this] [is] [an] [example]
    ```
6. 子串匹配标记(\1)
    ```bash
        # (pattern\)用于匹配子串.模式被包 括在使用斜线转义过的()中.对于匹配到的第一个子串,其对应的标记是 \1,匹配到的第二个 子串是 \2,往后依次类推
        [root@xxxxxx test]# echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
        this is 7 in a number

        [root@xxxxxx test]# echo seven EIGHT | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
        EIGHT seven
    ```
7. 组合多个表达式
    ```bash
        # 管道命令组合多个sed命令
        sed 'expression' | sed 'expression'
        # 等价于
        sed 'expression; expression'
        # 等价于
        sed -e 'expression' -e expression'

        [root@xxxxxx test]# echo abc | sed 's/a/A/' | sed 's/c/C/'
        AbC
        [root@xxxxxx test]# echo abc | sed 's/a/A/;s/c/C/'
        AbC
        [root@xxxxxx test]# echo abc | sed -e 's/a/A/' -e 's/c/C/'
        AbC
    ```





