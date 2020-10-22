# 自定义 S
# 清除
alias c='clear'
alias ll='ls -al'
alias listPort='sudo netstat -anp | grep'

# 查看端口
alias listPort='sudo netstat -anp | grep'

# 修改history格式 start

#设置保存历史命令的文件大小
HISTFILESIZE=2000

#保存历史命令条数
HISTSIZE=2000

#记录每条历史命令的执行时间和执行者
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S `whoami`  "

export HISTTIMEFORMAT

# 修改history格式 end

# 设置命令提示字符 start
PS1='[\[\e[31m\]\u\[\e[32m\]@\[\e[33m\]\h \[\e[34m\]\W \[\e[35m\]\t \[\e[37m\]#\#]\$ '
# 设置命令提示字符 end