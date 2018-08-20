---
title: Linux_基础 (42)
date: 2018-06-04
tags: Linux
toc: true
---

### 判断式
    主要是一些简单的判断说明

<!-- more -->

#### test
- 命令格式
    * test 参数 文件或目录
- 命令功能
    * 检测系统文件或相关的数据
- 命令参数
    * -b<文件>：如果文件为一个块特殊文件,则为真；
	* -c<文件>：如果文件为一个字符特殊文件,则为真；
	* -d<文件>：如果文件为一个目录,则为真；
	* -e<文件>：如果文件存在,则为真；
	* -f<文件>：如果文件为一个普通文件,则为真；
	* -g<文件>：如果设置了文件的SGID位,则为真；
	* -G<文件>：如果文件存在且归该组所有,则为真；
	* -k<文件>：如果设置了文件的粘着位,则为真；
	* -O<文件>：如果文件存在并且归该用户所有,则为真；
	* -p<文件>：如果文件为一个命名管道,则为真；
	* -r<文件>：如果文件可读,则为真；
	* -s<文件>：如果文件的长度不为零,则为真；
	* -S<文件>：如果文件为一个套接字特殊文件,则为真；
	* -u<文件>：如果设置了文件的SUID位,则为真；
	* -w<文件>：如果文件可写,则为真；
	* -x<文件>：如果文件可执行,则为真.
- 命令实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180604 15:41:11 #26]$ ll
        总用量 4
        -rw-rw-r-- 1 llllljian llllljian 287 6月   4 14:11 1.sh

        [llllljian@llllljian-virtual-machine 20180604 15:59:10 #27]$ test -e 1.sh

        [llllljian@llllljian-virtual-machine 20180604 15:59:49 #28]$ test -e 1.sh && echo "存在" || echo "不存在"
        存在

        [llllljian@llllljian-virtual-machine 20180604 16:00:09 #29]$ test -e 2.sh && echo "存在" || echo "不存在"
        不存在

        1. 判断表达式
        if test     #表达式为真
        if test !   #表达式为假
        test 表达式1 –a 表达式2     #两个表达式都为真
        test 表达式1 –o 表达式2     #两个表达式有一个为真
        test 表达式1 ! 表达式2       #条件求反

        2. 判断字符串
        test –n 字符串    #字符串的长度非零
        test –z 字符串    #字符串的长度是否为零
        test 字符串1＝字符串2       #字符串是否相等,若相等返回true
        test 字符串1!＝字符串2      #字符串是否不等,若不等反悔false

        3. 判断整数
        test 整数1 -eq 整数2    #整数相等
        test 整数1 -ge 整数2    #整数1大于等于整数2
        test 整数1 -gt 整数2    #整数1大于整数2
        test 整数1 -le 整数2    #整数1小于等于整数2
        test 整数1 -lt 整数2    #整数1小于整数2
        test 整数1 -ne 整数2    #整数1不等于整数2

        4. 判断文件
        test File1 –ef File2    两个文件是否为同一个文件,可用于硬连接.主要判断两个文件是否指向同一个inode.
        test File1 –nt File2    判断文件1是否比文件2新
        test File1 –ot File2    判断文件1比是否文件2旧
        test –b file   #文件是否块设备文件
        test –c File   #文件并且是字符设备文件
        test –d File   #文件并且是目录
        test –e File   #文件是否存在 (常用）
        test –f File   #文件是否为正规文件 (常用）
        test –g File   #文件是否是设置了组id
        test –G File   #文件属于的有效组ID
        test –h File   #文件是否是一个符号链接(同-L）
        test –k File   #文件是否设置了Sticky bit位
        test –b File   #文件存在并且是块设备文件
        test –L File   #文件是否是一个符号链接(同-h）
        test –o File   #文件的属于有效用户ID
        test –p File   #文件是一个命名管道
        test –r File   #文件是否可读
        test –s File   #文件是否是非空白文件
        test –t FD     #文件描述符是在一个终端打开的
        test –u File   #文件存在并且设置了它的set-user-id位
        test –w File   #文件是否存在并可写
        test –x File   #文件属否存在并可执行
    ```
- 详解
    <table><tr><td>测试的标志</td><td>代表意义</td></tr><tr><td colspan="2">1. 关于某个文件的『文件类型』判断,如 test -e filename 表示存在否</td></tr><tr><td>-e</td><td>该『文件』是否存在？(常用)</td></tr><tr><td>-f</td><td>该『文件』是否存在且为文件(file)？(常用)</td></tr><tr><td>-d</td><td>该『文件』是否存在且为目录(directory)？(常用)</td></tr><tr><td>-b</td><td>该『文件』是否存在且为一个 block device 装置？</td></tr><tr><td>-c</td><td>该『文件』是否存在且为一个 character device 装置？</td></tr><tr><td>-S</td><td>该『文件』是否存在且为一个 Socket 文件？</td></tr><tr><td>-p</td><td>该『文件』是否存在且为一个 FIFO (pipe) 文件？</td></tr><tr><td>-L</td><td>该『文件』是否存在且为一个连结档？</td></tr><tr><td colspan="2">2. 关于文件的权限侦测,如 test -r filename 表示可读否 (但 root 权限常有例外)</td></tr><tr><td>-r</td><td>侦测该文件是否存在且具有『可读』的权限？</td></tr><tr><td>-w</td><td>侦测该文件是否存在且具有『可写』的权限？</td></tr><tr><td>-x</td><td>侦测该文件是否存在且具有『可运行』的权限？</td></tr><tr><td>-u</td><td>侦测该文件是否存在且具有『SUID』的属性？</td></tr><tr><td>-g</td><td>侦测该文件是否存在且具有『SGID』的属性？</td></tr><tr><td>-k</td><td>侦测该文件是否存在且具有『Sticky bit』的属性？</td></tr><tr><td>-s</td><td>侦测该文件是否存在且为『非空白文件』？</td></tr><tr><td colspan="2">3. 两个文件之间的比较,如： test file1 -nt file2</td></tr><tr><td>-nt</td><td>(newer than)判断 file1 是否比 file2 新</td></tr><tr><td>-ot</td><td>(older than)判断 file1 是否比 file2 旧</td></tr><tr><td>-ef</td><td>判断 file1 与 file2 是否为同一文件,可用在判断 hard link 的判定上. 主要意义在判定,两个文件是否均指向同一个 inode 哩！</td></tr><tr><td colspan="2">4. 关于两个整数之间的判定,例如 test n1 -eq n2</td></tr><tr><td>-eq</td><td>两数值相等 (equal)</td></tr><tr><td>-ne</td><td>两数值不等 (not equal)</td></tr><tr><td>-gt</td><td>n1 大于 n2 (greater than)</td></tr><tr><td>-lt</td><td>n1 小于 n2 (less than)</td></tr><tr><td>-ge</td><td>n1 大于等于 n2 (greater than or equal)</td></tr><tr><td>-le</td><td>n1 小于等于 n2 (less than or equal)</td></tr><tr><td colspan="2">5. 判定字串的数据</td></tr><tr><td>test -z string</td><td>判定字串是否为 0 ？若 string 为空字串,则为 true</td></tr><tr><td>test -n string</td><td>判定字串是否非为 0 ？若 string 为空字串,则为 false.<br>注： -n 亦可省略</td></tr><tr><td>test str1 = str2</td><td>判定 str1 是否等于 str2 ,若相等,则回传 true</td></tr><tr><td>test str1 != str2</td><td>判定 str1 是否不等于 str2 ,若相等,则回传 false</td></tr><tr><td colspan="2">6. 多重条件判定,例如： test -r filename -a -x filename</td></tr><tr><td>-a</td><td>(and)两状况同时成立！例如 test -r file -a -x file,则 file 同时具有 r 与 x 权限时,才回传 true.</td></tr><tr><td>-o</td><td>(or)两状况任何一个成立！例如 test -r file -o -x file,则 file 具有 r 或 x 权限时,就可回传 true.</td></tr><tr><td>!</td><td>反相状态,如 test ! -x file ,当 file 不具有 x 时,回传 true</td></tr></table>
- 与shell脚本结合
    ```bash
        [llllljian@llllljian-virtual-machine 20180604 16:32:46 #15]$ cat 2.sh
        #!/bin/bash
        #########################################################################
        # File Name: 2.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月04日 星期一 16时06分08秒
        #########################################################################

        read -p "请输入一个文件名以检测文件类型和权限" filename

        # 1. 
        test -z $filename && echo "你必须输入一个文件名." && exit 0
        # 2. 判断文件是否存在？若不存在则显示信息并结束脚本
        test ! -e $filename && echo "文件'${filename}'不存在" && exit 0
        # 3. 开始判断文件类型与属性
        test -f $filename && filetype="文件"
        test -d $filename && filetype="目录"
        test -r $filename && perm="可读"
        test -w $filename && perm="$perm 可写"
        test -x $filename && perm="$perm 可执行"
        # 4. 开始输出文件相关信息！
        echo "你输入的: $filename 是一个  $filetype"
        echo "它的权限是 : $perm"

        [llllljian@llllljian-virtual-machine 20180604 16:34:21 #20]$ ll
        总用量 8
        -rw-rw-r-- 1 llllljian llllljian 287 6月   4 14:11 1.sh
        -rw-rw-r-- 1 llllljian llllljian 941 6月   4 16:23 2.sh

        [llllljian@llllljian-virtual-machine 20180604 16:34:23 #21]$ sh 2.sh
        请输入一个文件名以检测文件类型和权限
        你必须输入一个文件名.

        [llllljian@llllljian-virtual-machine 20180604 16:34:32 #22]$ sh 2.sh
        请输入一个文件名以检测文件类型和权限1
        文件'1'不存在

        [llllljian@llllljian-virtual-machine 20180604 16:34:35 #23]$ sh 2.sh
        请输入一个文件名以检测文件类型和权限1.sh
        你输入的: 1.sh 是一个  文件
        它的权限是 : 可读 可写
    ```

#### 利用判断符号
- 判断符号
    * [ ]中括号
- 注意事项
    * 在中括号 [] 内的每个组件都需要有空白键来分隔
    * 在中括号内的变量,最好都以双引号括号起来
    * 在中括号内的常数,最好都以单或双引号括号起来
- 应用实例1
    ```bash
        vim ~/.bashrc

        ... 配合伪删除使用
        dOne=$(date --date='1 days ago' +%Y%m%d)
        dTwo=$(date --date='2 days ago' +%Y%m%d)
        dThree=$(date --date='3 days ago' +%Y%m%d)
        
        #echo /tmp/$(date +%Y%m)/$dOne/
        
        if [ -d /tmp/$dOne/ ];then
            #echo "${dOne} 存在";   
                /bin/rm -rf /tmp/$dOne/;
        fi
        
        if [ -d /tmp/$dTwo/ ];then
            #echo "${dTwo} 存在";
                /bin/rm -rf /tmp/$dTwo;
        fi
        
        if [ -d /tmp/$dThree/ ];then
                #echo "${dThree} 存在";
                /bin/rm -rf /tmp/$dThree;
        fi
        ...
    ```
- 应用实例2
    ```bash
        [llllljian@llllljian-virtual-machine 20180604 19:10:20 #24]$ cat 3.sh
        #!/bin/bash
        #########################################################################
        # File Name: 3.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月04日 星期一 17时18分33秒
        #########################################################################

        read -p "请确认你的操作(y/n)" confirm

        if [ "$confirm" == "Y" -o "$confirm" == "y" ];then
            echo -e "你输出的是y/Y\n"
        fi

        if [ "$confirm" == "N" -o "$confirm" == "n" ];then
                echo -e "你输出的是n/N\n"
        fi

        [ "$confirm" == "Y" -o "$confirm" == "y" ] && echo "你输入的是y/Y" && exit 0
        [ "$confirm" == "N" -o "$confirm" == "n" ] && echo "你输入的是n/N" && exit 0

        echo "你输入的不是y/Y/n/N中的一个" && exit 0

        [llllljian@llllljian-virtual-machine 20180604 19:08:45 #25]$ sh 3.sh
        请确认你的操作(y/n)
        你输入的不是y/Y/n/N中的一个

        [llllljian@llllljian-virtual-machine 20180604 19:09:49 #26]$ sh 3.sh
        请确认你的操作(y/n)y
        你输出的是y/Y

        你输入的是y/Y

        [llllljian@llllljian-virtual-machine 20180604 19:09:53 #27]$ sh 3.sh
        请确认你的操作(y/n)Y
        你输出的是y/Y

        你输入的是y/Y

        [llllljian@llllljian-virtual-machine 20180604 19:10:09 #28]$ sh 3.sh
        请确认你的操作(y/n)n
        你输入的是n/N

        你输入的是n/N

        [llllljian@llllljian-virtual-machine 20180604 19:10:17 #29]$ sh 3.sh
        请确认你的操作(y/n)N
        你输入的是n/N
        
        你输入的是n/N
    ```

#### Shell script的默认变数
- 参数解析
    * \$0 : 运行的文件名  
    * \$# ：代表后接的参数『个数』,以上表为例这里显示为『 4 』；
    * \$@ ：代表『 "$1" "$2" "$3" "$4" 』之意,每个变量是独立的(用双引号括起来)；
    * \$* ：代表『 "$1c$2c$3c$4" 』,其中 c 为分隔字节,默认为空白键, 所以本例中代表『 "$1 $2 $3 $4" 』之意.
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180604 19:50:14 #62]$ cat 4.sh
        #!/bin/bash
        #########################################################################
        # File Name: 4.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月04日 星期一 19时49分26秒
        #########################################################################

        echo "文件名是: $0"
        echo "第1个参数是: $1"
        echo "第2个参数是: $2"
        echo "所有的参数是: "\"$@\"
        echo "所有的参数是: "\"$*\"
        echo "参数的数量为: $#"
        [ "$#" -lt 4 ] && echo "参数少于4个." \
            && exit 0

        [llllljian@llllljian-virtual-machine 20180604 19:49:57 #60]$ sh 4.sh 1 2 3 4 5 6
        文件名是: 4.sh
        第1个参数是: 1
        第2个参数是: 2
        所有的参数是: "1 2 3 4 5 6"
        所有的参数是: "1 2 3 4 5 6"
        参数的数量为: 6
        [llllljian@llllljian-virtual-machine 20180604 19:50:08 #61]$ sh 4.sh 1 2 3
        文件名是: 4.sh
        第1个参数是: 1
        第2个参数是: 2
        所有的参数是: "1 2 3"
        所有的参数是: "1 2 3"
        参数的数量为: 3
        参数少于4个.
    ```
- shift : 造成参数变量号码偏移
    ```bash
        [llllljian@llllljian-virtual-machine 20180604 19:55:27 #66]$ cat 5.sh
        #!/bin/bash
        #########################################################################
        # File Name: 5.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月04日 星期一 19时55分17秒
        #########################################################################

        while [ $# != 0 ];do  
            echo "第一个参数为：$1,参数个数为：$#"  
            shift  
        done  
        [llllljian@llllljian-virtual-machine 20180604 19:57:07 #67]$ sh 5.sh 1 2 3 4 5 6
        第一个参数为：1,参数个数为：6
        第一个参数为：2,参数个数为：5
        第一个参数为：3,参数个数为：4
        第一个参数为：4,参数个数为：3
        第一个参数为：5,参数个数为：2
        第一个参数为：6,参数个数为：1

        [llllljian@llllljian-virtual-machine 20180604 19:59:01 #68]$ cat 6.sh
        #!/bin/bash
        #########################################################################
        # File Name: 6.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月04日 星期一 19时58分42秒
        #########################################################################

        echo "参数个数为：$#,其中："  
        for i in $(seq 1 $#)  
        do  
            eval j=\$$i  
            echo "第$i个参数($"$i")：$j"  
        done  
        
        shift 3  
        
        echo "执行shift 3操作后："  
        echo "参数个数为：$#,其中："  
        for i in $(seq 1 $#)  
        do  
            #通过eval把i变量的值($i)作为变量j的名字  
            eval j=\$$i  
            echo "第$i个参数($"$i")：$j"  
        done

        [llllljian@llllljian-virtual-machine 20180604 19:59:24 #69]$ sh 6.sh 1 2 3 4 5 6
        参数个数为：6,其中：
        第1个参数($1)：1
        第2个参数($2)：2
        第3个参数($3)：3
        第4个参数($4)：4
        第5个参数($5)：5
        第6个参数($6)：6
        执行shift 3操作后：
        参数个数为：3,其中：
        第1个参数($1)：4
        第2个参数($2)：5
        第3个参数($3)：6
    ```

