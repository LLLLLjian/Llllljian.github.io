---
title: Linux_基础 (32)
date: 2018-05-22
tags: Linux
toc: true
---

### 环境变量的功能
    环境变量可以帮我们达到很多功能[包括家目录的变换,提示字符的显示,执行文件搜索的路径]

<!-- more -->

#### env
- 命令格式
    * env(选项)(参数)
- 命令功能
    * 显示系统中已存在的环境变量,以及在定义的环境中执行指令
- 命令参数
    * -i：开始一个新的空的环境；
    * -u<变量名>：从当前环境中删除指定的变量.
- 命令实例
    ```bash
        env

        ...
        HOME=/home/llllljian
        SHELL=/bin/bash
        HISTSIZE=2000
        MAIL=/var/spool/mail/llllljian
        PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/local/bin:/usr/local//mysql-5.5.38/bin:/home/llllljian/.local/bin:/home/llllljian/bin
        LANG=zh_CN.UTF-8
        ...
    ```
- 解析变量
    * HOME 代表用户的家目录
    * SHELL 告知我们当前环境使用的SHELl是哪个程序,默认使用
    * HISTSIZE 记录的历史命令的条数
    * MAIL 当使用mail指令收信的时候,系统会去读取的邮件信箱文件
    * PATH 执行文件搜寻的路径,目录与目录之间用:隔开
    * LANG 语言类型
    * RANDOM 随机数
        * 生成10以内的随机数 declare -i number=${RANDOM}*10/32768;echo ${number}

#### set
- 命令格式
    * set(选项)(参数)
- 命令功能
    * 显示系统中已经存在的shell变量,以及设置shell变量的新变量值
- 命令参数
    * -a：标示已修改的变量,以供输出至环境变量.
	* -b：使被中止的后台程序立刻回报执行状态.
	* -C：转向所产生的文件无法覆盖已存在的文件.
	* -d：Shell预设会用杂凑表记忆使用过的指令,以加速指令的执行.使用-d参数可取消.
	* -e：若指令传回值不等于0,则立即退出shell.
	* -f：取消使用通配符.
	* -h：自动记录函数的所在位置.
	* -H Shell：可利用"!"加<指令编号>的方式来执行history中记录的指令.
	* -k：指令所给的参数都会被视为此指令的环境变量.
	* -l：记录for循环的变量名称.
	* -m：使用监视模式.
	* -n：只读取指令,而不实际执行.
	* -p：启动优先顺序模式.
	* -P：启动-P参数后,执行指令时,会以实际的文件或目录来取代符号连接.
	* -t：执行完随后的指令,即退出shell.
	* -u：当执行时使用到未定义过的变量,则显示错误信息.
	* -v：显示shell所读取的输入值.
	* -x：执行指令后,会先显示该指令及所下的参数.
- 命令实例
    ```bash
        set 

        ...
        PS1='[\u@\h \W]\$ '
        PPID=5527
        ...
    ```
- 解析变量
    * PS1 命令提示符的设定
        * PS1='[\[\e[31m\]\u\[\e[32m\]@\[\e[33m\]\h \[\e[34m\]\W \[\e[35m\]\t \[\e[37m\]#\#]\$ '
        * \d ：代表日期,格式为weekday month date,例如："Mon Aug 1"
        * \H ：完整的主机名称.例如：我的机器名称为：fc4.linux,则这个名称就是fc4.linux
        * \h ：仅取主机的第一个名字,如上例,则为fc4,.linux则被省略
        * \t ：显示时间为24小时格式,如：HH：MM：SS
        * \T ：显示时间为12小时格式
        * \A ：显示时间为24小时格式：HH：MM
        * \u ：当前用户的账号名称
        * \v ：BASH的版本信息
        * \w ：完整的工作目录名称.家目录会以 ~代替
        * \W ：利用basename取得工作目录名称,所以只会列出最后一个目录
        * \# ：下达的第几个命令
        * \$ ：提示字符,如果是root时,提示符为：# ,普通用户则为：$
        * \[\e[F;Bm\] ：设置颜色
        <table><tr><th>f</th><th>b</th><th>颜色</th></tr><tr><td>30</td><td>40</td><td>黑色</td></tr><tr><td>31</td><td>41</td><td>红色</td></tr><tr><td>32</td><td>42</td><td>绿色</td></tr><tr><td>33</td><td>43</td><td>黄色</td></tr><tr><td>34</td><td>44</td><td>蓝色</td></tr><tr><td>35</td><td>45</td><td>紫红色</td></tr><tr><td>36</td><td>46</td><td>青蓝色</td></tr><tr><td>37</td><td>47</td><td>白色</td></tr></table>
    * PID 目前这个shell的线程代号

#### export
- 命令格式
    * export [-fnp][变量名称]=[变量设置值]
- 命令功能
    * 设置或显示环境变量
- 命令参数
    * -f 　代表[变量名称]中为函数名称
    * -n 　删除指定的变量.变量实际上并未删除,只是不会输出到后续指令的执行环境中
    * -p 　列出所有的shell赋予程序的环境变量

#### 三者区别
- set命令显示当前shell的变量,包括当前用户的变量
- env命令显示当前用户的变量
- export命令显示当前导出成用户变量的shell变量