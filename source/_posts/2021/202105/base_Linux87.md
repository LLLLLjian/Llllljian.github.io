---
title: Linux_基础 (87)
date: 2021-05-28
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### sed命令
- 语法
    * sed [-hnV][-e&lt;script>][-f<script文件>][文本文件]
- 参数说明
    * -n : 使用安静(silent)模式.在一般 sed 的用法中, 所有来自 STDIN 的数据一般都会被列出到终端上.但如果加上 -n 参数后, 则只有经过sed特殊处理的那一行(或者动作)才会被列出来.
    * -e : 直接在命令列模式上进行 sed 的动作编辑；
    * -f : 直接将 sed 的动作写在一个文件内,  -f filename 则可以运行 filename 内的 sed 动作；
    * -r : sed 的动作支持的是延伸型正规表示法的语法.(默认是基础正规表示法语法)
    * -i : 直接修改读取的文件内容, 而不是输出到终端.
- 动作说明
    * [n1[,n2]]function
    * n1, n2 : 不见得会存在, 一般代表『选择进行动作的行数』, 举例来说, 如果我的动作是需要在 10 到 20 行之间进行的, 则『 10,20[动作行为] 』
 - function
    * a : 新增,  a 的后面可以接字串, 而这些字串会在新的一行出现(目前的下一行)～
    * c : 取代,  c 的后面可以接字串, 这些字串可以取代 n1,n2 之间的行！
    * d : 删除, 因为是删除啊, 所以 d 后面通常不接任何咚咚；
    * i : 插入,  i 的后面可以接字串, 而这些字串会在新的一行出现(目前的上一行)；
    * p : 列印, 亦即将某个选择的数据印出.通常 p 会与参数 sed -n 一起运行～
    * s : 取代, 可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 就是啦
- eg
    ```bash
        # 每一行替换一次
        [ubuntu@llllljian-cloud-tencent test 15:42:10 #16]$ cat 1.txt
        d
        ddd
        #ff
        [ubuntu@llllljian-cloud-tencent test 15:42:19 #17]$ sed -i 's/d/7523/' ./1.txt
        [ubuntu@llllljian-cloud-tencent test 15:42:35 #18]$ cat 1.txt
        7523
        7523dd
        #ff

        # 每一行匹配到的全部替换掉
        [ubuntu@llllljian-cloud-tencent test 15:42:37 #19]$ cat 2.txt
        d
        ddd
        #ff
        [ubuntu@llllljian-cloud-tencent test 15:42:54 #20]$ sed -i 's/d/7523/g' ./2.txt
        [ubuntu@llllljian-cloud-tencent test 15:43:11 #21]$ cat 2.txt
        7523
        752375237523

        # 去除每一行开头的@
        [ubuntu@llllljian-cloud-tencent test 15:44:33 #25]$ cat 3.txt
        @123
        1@23
        12@3
        @@123
        [ubuntu@llllljian-cloud-tencent test 15:45:10 #26]$ sed -i 's/^@//' ./3.txt
        [ubuntu@llllljian-cloud-tencent test 15:45:12 #27]$ cat 3.txt
        123
        1@23
        12@3
        @123
        #ff

        # 指定行前后添加内容
        [ubuntu@llllljian-cloud-tencent test 15:52:00 #42]$ cat 4.txt
        1
        2
        3
        4
        llllljian
        q
        w
        e
        r
        [ubuntu@llllljian-cloud-tencent test 15:52:02 #43]$ sed -i '/llllljian/i beforeLine' ./4.txt
        [ubuntu@llllljian-cloud-tencent test 15:52:22 #45]$ sed -i '/llllljian/a afterLine' ./4.txt
        [ubuntu@llllljian-cloud-tencent test 15:52:39 #46]$ cat 4.txt
        1
        2
        3
        4
        beforeLine
        llllljian
        afterLine
        q
        w
        e
        r

        # 删除某个字符串
        [ubuntu@llllljian-cloud-tencent test 15:58:17 #51]$ cat 4.txt
        1
        2
        3
        4
        beforeLine
        llllljian
        afterLine
        q
        w
        e
        r
        [ubuntu@llllljian-cloud-tencent test 15:58:19 #52]$ sed -i '/1/d' ./4.txt
        [ubuntu@llllljian-cloud-tencent test 15:58:31 #53]$ cat 4.txt
        2
        3
        4
        beforeLine
        llllljian
        afterLine
        q
        w
        e
        r
    ```
- eg
    ```bash
        # 实例1: 删除文件每行的第二个字符.
        sed -r 's/(.*)(.)$/\1/'

        # 实例2: 删除文件每行的最后一个字符.
        sed -r 's/(.*)(.)$/\1/'

        # 实例3: 删除文件每行的倒数第2个单词.
        sed -r ‘s/(.*)([^a-Z]+)([a-Z]+)([^a-Z]+)([a-Z]+)([^a-Z]*$)/\1\2\4\5/’ /etc/passwd

        # 实例4: 交换每行的第一个字符和第二个字符.
        sed -r ‘s/(.)(.)(.*)/\2\1\3/’ /etc/passwd

        # 实例5: 交换每行的第一个单词和最后一个单词.
        sed -r ‘s/([a-Z]+)([^a-Z]+)(.*)([^a-Z]+)([a-Z]+)([^a-Z]*$)/\5\2\3\4\1\6/’ /etc/passwd

        # 实例6: 删除一个文件中所有的数字.
        sed ‘s/[0-9]//g’ /etc/passwd

        # 实例7: 用制表符替换文件中出现的所有空格.
        sed -r ‘s/ +/\t/g’ /etc/passwd

        # 实例8: 把所有大写字母用括号()括起来.
        sed -r ‘s/([A-Z])/(\1)/g’ /etc/passwd

        # 实例9: 打印每行3次.
        sed ‘p;p’ /etc/passwd

        # 实例10: 隔行删除
        sed ‘0~2{=;d}’ /etc/passwd

        # 实例11: 把文件从第22行到第33行复制到56行后面.
        sed ‘22h;23,33H;56G’ /etc/passwd

        # 实例12: 把文件从第22行到第33行移动到第56行后面.
        sed ‘22{h;d};23,33{H;d};56g’ /etc/passwd

        # 实例13: 只显示每行的第一个单词.
        sed -r ‘s/([a-Z]+)([^a-Z]+)(.*)/\1/’ /etc/passwd

        # 实例14: 打印每行的第一个单词和第三个单词.
        sed -r ‘s/([a-Z]+)([^a-Z]+)([a-Z]+)([^a-Z]+)([a-Z]+)([^a-Z]+)(.*)/\1\t\5/’ /etc/passwd

        # 实例15: 将格式为mm/yy/dd的日期格式换成 mm;yy;dd
        date '+%m/%y/%d' | sed 's/\//;/g'
    ```

