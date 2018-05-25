---
title: Linux_基础 (29)
date: 2018-05-18
tags: Linux
toc: true
---

### vim的使用
    可以将vim视为vi的进阶版,vim具有程序编辑能力,可以主动地以字体颜色辨别语法的正确性,方便程序设计

<!-- more -->

#### 多窗口功能
- 场景
    ```bash
        对比两个文件中的内容或者一个大文件中的某两段的差异之处
    ```
- vim操作
    * 先打开其中一个文件 vim filename1
    * 如果对比的是另外一个文件,在一般指令模式下[:sp filename2]
    * 如果对比的是本文件,在一般指令模式下[:sp]
    * 通过按键ctrl+w+j或者向下
    * 通过按键ctrl+W+k或者向上
    <table><tr><th>按键组合</th><th>说明</th></tr><tr><td>Ctrl-w + s</td><td>横向分屏</td></tr><tr><td>Ctrl-w + v</td><td>纵向分屏</td></tr><tr><td>Ctrl-w + 箭头</td><td>在不同窗口之间切换</td></tr><tr><td>Ctrl-w + n</td><td>新打开一个窗口</td></tr><tr><td>Ctrl-w + o</td><td>关闭所以其他窗口</td></tr><tr><td>:qa</td><td>关闭所有窗口</td></tr></table>

#### 环境设定与记录
- ~/.vimrc
    * 个人目录下对vim环境的设定
    * vim ~/.vimrc 
    * "是注释
    <table><tr><td colspan="2">vim 的环境设定参数</td></tr><tr><td>:set nu<br>:set nonu</td><td>就是设定与取消行号啊！</td></tr><tr><td>:set hlsearch<br>:set nohlsearch</td><td>hlsearch 就是 high light search(高亮度搜寻)。这个就是设定是否将搜寻的字符串反白的设定值。默认值是 hlsearch</td></tr><tr><td>:set autoindent<br>:set noautoindent</td><td>是否自动缩排？autoindent 就是自动缩排。</td></tr><tr><td>:set backup</td><td>是否自动储存备份档？一般是 nobackup 的，如果设定 backup 的话，那么当你更动任何一个档案时，则源文件会被另存成一个档名为 filename~ 的档案。举例来说，我们编辑 hosts ，设定 :set backup ，那么当更动 hosts 时，在同目录下，就会产生 hosts~ 文件名的档案，记录原始的 hosts 档案内容</td></tr><tr><td>:set ruler</td><td>还记得我们提到的右下角的一些状态栏说明吗？这个 ruler 就是在显示或不显示该设定值的啦！</td></tr><tr><td>:set showmode</td><td>这个则是，是否要显示 --INSERT-- 之类的字眼在左下角的状态栏。</td></tr><tr><td>:set backspace=(012)</td><td>一般来说，如果我们按下 i 进入编辑模式后，可以利用退格键 (backspace) 来删除任意字符的。但是，某些 distribution 则不许如此。此时，我们就可以透过 backspace 来设定啰～当 backspace 为 2 时，就是可以删除任意值；0 或 1 时，仅可删除刚刚输入的字符，而无法删除原本就已经存在的文字了！</td></tr><tr><td>:set all</td><td>显示目前所有的环境参数设定值。</td></tr><tr><td>:set</td><td>显示与系统默认值不同的设定参数，一般来说就是你有自行变动过的设定参数啦！</td></tr><tr><td>:syntax on<br>:syntax off</td><td>是否依据程序相关语法显示不同颜色？举例来说，在编辑一个纯文本档时，如果开头是以 # 开始，那么该行就会变成蓝色。如果你懂得写程序，那么这个 :syntax on 还会主动的帮你除错呢！但是，如果你仅是编写纯文本档案，要避免颜色对你的屏幕产生的干扰，则可以取消这个设定 。</td></tr><tr><td>:set bg=dark<br>:set bg=light</td><td>可用以显示不同的颜色色调，预设是『 light 』。如果你常常发现批注的字体深蓝色实在很不容易看，那么这里可以设定为 dark 喔！试看看，会有不同的样式呢！</td></tr></table>
- ~/.viminfo
    * 个人目录下对vim的历史操作
