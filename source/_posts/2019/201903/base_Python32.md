---
title: Python_基础 (32)
date: 2019-03-15
tags: Python
toc: true
---

### Python批量修改百度云文件名
    Python3练习
    稍微有一点强迫症想修改百度网盘中的资源名,但是目前网页端和客户端都不支持批量操作,然后就想到了自己写

<!-- more -->

#### 代码部分
    ```python
        #-*-coding:utf-8-*-
        # 百度云相关模块
        from baidupcsapi import PCS
        # 正则
        import re
        # 时间模块
        import time
        # 系统模块
        import sys
        import os

        # 获取文件后缀
        def file_extension(path): 
            return os.path.splitext(path)[1]

        # 百度网盘账号密码
        pcs = PCS("username","password")
        argvDtr = sys.argv
        keyword = argvDtr[1]
        path = '/' + argvDtr[2]
        print("关键字为: " + keyword)
        print("修改的文件路径为: " + path)
        # 查找文件目录path下的包含关键字的文件列表
        searchlist = pcs.search(path, keyword).json().get('list')

        for searchfile in searchlist:
            renamelist = []
            newname = ''
            fsid = searchfile.get('fs_id')
            # 文件路径
            fspath = searchfile.get('path')
            # 文件名
            fsname = searchfile.get('server_filename')
            # 正则匹配集数
            pattern = re.compile('[0-9]{1,2}')
            x = pattern.findall(fsname)
            newname = x[int(argvDtr[3])] + file_extension(fsname)
            renamelist.append((fspath, newname))
            print(fsname, newname)
            if argvDtr[4] == '0':
                break
            #break
            #if input("若符合修改的预期,请输入 y 以便继续执行文件名替换") == "y":
            # 修改文件名
            pcs.rename(renamelist)
            # 修改10s
            time.sleep(10)

        #python baiduwangpan.py 匹诺曹 匹诺曹 2 0 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 步步 步步惊心 2 0 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 金婚 金婚 2 0 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 1988 请回答1988 2 0 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py mkv 玩家 0 0 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 康熙王朝 康熙王朝 0 1 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 关中匪事 关中往事 0 1 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 齐天大圣孙悟空 齐天大圣孙悟空 0 1 >> E:\python\study\201903\baiduwangpanRenameLog.txt
        #python baiduwangpan.py 潜伏 潜伏 0 1 >> E:\python\study\201903\baiduwangpanRenameLog.txt
    ```

#### 代码执行前需要注意的
- 执行的环境
    * python >=3
    * requests>=2.0.0
    * pip
- 可能遇到的问题
    ```text
        ----/AppData/Local/Temp/tmp/0vlu22f0.png
        另一个程序正在使用此文件,进程无法访问.
        Input verify code > [将上面缓存中的图片地址复制到浏览器中打开,将验证码输入到这里]
        Verification Code> [首先要将百度网盘与邮箱关联起来,这里输入邮箱获取到的验证码]
    ```

#### 运行结果
    ```
        请输入关键字关键字为: 匹诺曹
        修改的文件路径为: /匹诺曹
        匹诺曹 05[超清版].mp4 05.mp4
        匹诺曹 14[超清版].mp4 14.mp4
        匹诺曹 04[超清版].mp4 04.mp4
        匹诺曹 15[超清版].mp4 15.mp4
        匹诺曹 18[超清版].mp4 18.mp4
        匹诺曹 02[超清版].mp4 02.mp4
        匹诺曹 12[超清版].mp4 12.mp4
        匹诺曹 13[超清版].mp4 13.mp4
        匹诺曹 09[超清版].mp4 09.mp4
        匹诺曹 03[超清版].mp4 03.mp4
        匹诺曹 16[超清版].mp4 16.mp4
        匹诺曹 17[超清版].mp4 17.mp4
        匹诺曹 11[超清版].mp4 11.mp4
        匹诺曹 07[超清版].mp4 07.mp4
        匹诺曹 06[超清版].mp4 06.mp4
        匹诺曹 08[超清版].mp4 08.mp4
        匹诺曹 01[超清版].mp4 01.mp4
        匹诺曹 10[超清版].mp4 10.mp4

        关键字为: 步步
        修改的文件路径为: /步步惊心丽
        [TIGO][步步京心☆丽][第15集][韩语中字][720p].mp4 15.mp4
        [TIGO][步步京心☆丽][第18集][韩语中字][720p].mp4 18.mp4
        [TIGO][步步京心☆丽][第10集][韩语中字][720p].mp4 10.mp4
        [TIGO][步步京心☆丽][第14集][韩语中字][720p].mp4 14.mp4
        [TIGO][步步京心☆丽][第11集][韩语中字][720p].mp4 11.mp4
        [TIGO][步步京心☆丽][第12集][韩语中字][720p].mkv 12.mkv
        [TIGO][步步京心☆丽][第16集][韩语中字][720p].mp4 16.mp4
        [TIGO][步步京心☆丽][第17集][韩语中字][720p].mp4 17.mp4
        [TIGO][步步京心☆丽][第13集][韩语中字][720p].mkv 13.mkv
        关键字为: 金婚
        修改的文件路径为: /金婚
        tlf.中国.2007.golden.wedding.金婚.ep47.halfcd.mkv 47.mkv
        tlf.中国.2007.golden.wedding.金婚.ep41.halfcd.mkv 41.mkv
        tlf.中国.2007.golden.wedding.金婚.ep28.halfcd.mkv 28.mkv
        tlf.中国.2007.golden.wedding.金婚.ep50.halfcd.mkv 50.mkv
        tlf.中国.2007.golden.wedding.金婚.ep34.halfcd.mkv 34.mkv
        tlf.中国.2007.golden.wedding.金婚.ep24.halfcd.mkv 24.mkv
        tlf.中国.2007.golden.wedding.金婚.ep40.halfcd.mkv 40.mkv
        tlf.中国.2007.golden.wedding.金婚.ep38.halfcd.mkv 38.mkv
        tlf.中国.2007.golden.wedding.金婚.ep16.halfcd.mkv 16.mkv
        tlf.中国.2007.golden.wedding.金婚.ep44.halfcd.mkv 44.mkv
        tlf.中国.2007.golden.wedding.金婚.ep49.halfcd.mkv 49.mkv
        tlf.中国.2007.golden.wedding.金婚.ep18.halfcd.mkv 18.mkv
        tlf.中国.2007.golden.wedding.金婚.ep31.halfcd.mkv 31.mkv
        tlf.中国.2007.golden.wedding.金婚.ep21.halfcd.mkv 21.mkv
        tlf.中国.2007.golden.wedding.金婚.ep29.halfcd.mkv 29.mkv
        tlf.中国.2007.golden.wedding.金婚.ep36.halfcd.mkv 36.mkv
        tlf.中国.2007.golden.wedding.金婚.ep19.halfcd.mkv 19.mkv
        tlf.中国.2007.golden.wedding.金婚.ep48.halfcd.mkv 48.mkv
        tlf.中国.2007.golden.wedding.金婚.ep37.halfcd.mkv 37.mkv
        tlf.中国.2007.golden.wedding.金婚.ep30.halfcd.mkv 30.mkv
        tlf.中国.2007.golden.wedding.金婚.ep25.halfcd.mkv 25.mkv
        tlf.中国.2007.golden.wedding.金婚.ep26.halfcd.mkv 26.mkv
        tlf.中国.2007.golden.wedding.金婚.ep35.halfcd.mkv 35.mkv
        tlf.中国.2007.golden.wedding.金婚.ep45.halfcd.mkv 45.mkv
        tlf.中国.2007.golden.wedding.金婚.ep39.halfcd.mkv 39.mkv
        tlf.中国.2007.golden.wedding.金婚.ep23.halfcd.mkv 23.mkv
        tlf.中国.2007.golden.wedding.金婚.ep46.halfcd.mkv 46.mkv
        tlf.中国.2007.golden.wedding.金婚.ep43.halfcd.mkv 43.mkv
        tlf.中国.2007.golden.wedding.金婚.ep32.halfcd.mkv 32.mkv
        tlf.中国.2007.golden.wedding.金婚.ep27.halfcd.mkv 27.mkv
        tlf.中国.2007.golden.wedding.金婚.ep33.halfcd.mkv 33.mkv
        tlf.中国.2007.golden.wedding.金婚.ep22.halfcd.mkv 22.mkv
        tlf.中国.2007.golden.wedding.金婚.ep17.halfcd.mkv 17.mkv
        tlf.中国.2007.golden.wedding.金婚.ep42.halfcd.mkv 42.mkv
        关键字为: 1988
        修改的文件路径为: /请回答1988
        1988E05.mp4 05.mp4
        1988E12.mp4 12.mp4
        1988E08.mkv 08.mkv
        1988E06.mkv 06.mkv
        1988E11.mkv 11.mkv
        1988E18.mkv 18.mkv
        1988E15.mkv 15.mkv
        1988E04.mkv 04.mkv
        1988E02.mkv 02.mkv
        1988E10.mkv 10.mkv
        1988E16.mkv 16.mkv
        1988E09.mkv 09.mkv
        1988E13.mkv 13.mkv
        1988E17.mkv 17.mkv
        1988E20.mkv 20.mkv
        1988E07.mkv 07.mkv
        1988E03.mkv 03.mkv
        1988E19.mkv 19.mkv
        1988E01.mkv 01.mkv
        1988E14.mp4 14.mp4
        关键字为: mkv
        修改的文件路径为: /玩家
        01【微信公众号：蓝色的雪枫】.mkv 01.mkv
        04【微信公众号：蓝色的雪枫】.mkv 04.mkv
        10【微信公众号：蓝色的雪枫】.mkv 10.mkv
        02【微信公众号：蓝色的雪枫】.mkv 02.mkv
        05【资源公众号：蓝色的雪枫】.mkv 05.mkv
        03【微信公众号：蓝色的雪枫】.mkv 03.mkv
        09【微信公众号：蓝色的雪枫】.mkv 09.mkv
        06【资源公众号：蓝色的雪枫】.mkv 06.mkv
        07【微信公众号：蓝色的雪枫】.mkv 07.mkv
        08【微信公众号：蓝色的雪枫】.mkv 08.mkv
        关键字为: 康熙王朝
        修改的文件路径为: /康熙王朝
        康熙王朝第41集[高清版].mp4 41.mp4
        康熙王朝第15集[高清版].mp4 15.mp4
        康熙王朝第40集[高清版].mp4 40.mp4
        康熙王朝第6集[高清版].mp4 6.mp4
        康熙王朝第12集[高清版].mp4 12.mp4
        康熙王朝第27集[高清版].mp4 27.mp4
        康熙王朝第1集[高清版].mp4 1.mp4
        康熙王朝第10集[高清版].mp4 10.mp4
        康熙王朝第21集[高清版].mp4 21.mp4
        康熙王朝第22集[高清版].mp4 22.mp4
        康熙王朝第28集[高清版].mp4 28.mp4
        康熙王朝第34集[高清版].mp4 34.mp4
        康熙王朝第45集[高清版].mp4 45.mp4
        康熙王朝第32集[高清版].mp4 32.mp4
        康熙王朝第42集[高清版].mp4 42.mp4
        康熙王朝第43集[高清版].mp4 43.mp4
        康熙王朝第37集[高清版].mp4 37.mp4
        康熙王朝第18集[高清版].mp4 18.mp4
        康熙王朝第3集[高清版].mp4 3.mp4
        康熙王朝第19集[高清版].mp4 19.mp4
        康熙王朝第46集[高清版].mp4 46.mp4
        康熙王朝第8集[高清版].mp4 8.mp4
        康熙王朝第13集[高清版].mp4 13.mp4
        康熙王朝第4集[高清版].mp4 4.mp4
        康熙王朝第26集[高清版].mp4 26.mp4
        康熙王朝第5集[高清版].mp4 5.mp4
        康熙王朝第36集[高清版].mp4 36.mp4
        康熙王朝第7集[高清版].mp4 7.mp4
        康熙王朝第25集[高清版].mp4 25.mp4
        康熙王朝第11集[高清版].mp4 11.mp4
        康熙王朝第31集[高清版].mp4 31.mp4
        康熙王朝第33集[高清版].mp4 33.mp4
        康熙王朝第38集[高清版].mp4 38.mp4
        康熙王朝第35集[高清版].mp4 35.mp4
        康熙王朝第20集[高清版].mp4 20.mp4
        康熙王朝第9集[高清版].mp4 9.mp4
        康熙王朝第14集[高清版].mp4 14.mp4
        康熙王朝第44集[高清版].mp4 44.mp4
        康熙王朝第23集[高清版].mp4 23.mp4
        康熙王朝第16集[高清版].mp4 16.mp4
        关键字为: 关中匪事
        修改的文件路径为: /关中往事
        关中匪事 27_高清.mp4 27.mp4
        关中匪事 09_高清.mp4 09.mp4
        关中匪事 07_高清.mp4 07.mp4
        关中匪事 15_高清.mp4 15.mp4
        关中匪事 03_高清.mp4 03.mp4
        关中匪事 06_高清.mp4 06.mp4
        关中匪事 28_高清.mp4 28.mp4
        关中匪事 24_高清.mp4 24.mp4
        关中匪事 21_高清.mp4 21.mp4
        关中匪事 26_高清.mp4 26.mp4
        关中匪事 20_高清.mp4 20.mp4
        关中匪事 13_高清.mp4 13.mp4
        关中匪事 16_高清.mp4 16.mp4
        关中匪事 02_高清.mp4 02.mp4
        关中匪事 19_高清.mp4 19.mp4
        关中匪事 08_高清.mp4 08.mp4
        关中匪事 12_高清.mp4 12.mp4
        关中匪事 11_高清.mp4 11.mp4
        关中匪事 17_高清.mp4 17.mp4
        关中匪事 23_高清.mp4 23.mp4
        关中匪事 04_高清.mp4 04.mp4
        关键字为: 齐天大圣孙悟空
        修改的文件路径为: /齐天大圣孙悟空
        齐天大圣孙悟空35.rmvb 35.rmvb
        齐天大圣孙悟空14.rmvb 14.rmvb
        齐天大圣孙悟空33.rmvb 33.rmvb
        齐天大圣孙悟空23.rmvb 23.rmvb
        齐天大圣孙悟空03.rmvb 03.rmvb
        齐天大圣孙悟空30.rmvb 30.rmvb
        齐天大圣孙悟空07.rmvb 07.rmvb
        齐天大圣孙悟空21.rmvb 21.rmvb
        齐天大圣孙悟空13.rmvb 13.rmvb
        齐天大圣孙悟空17.rmvb 17.rmvb
        齐天大圣孙悟空29.rmvb 29.rmvb
        齐天大圣孙悟空16.rmvb 16.rmvb
        齐天大圣孙悟空04.rmvb 04.rmvb
        齐天大圣孙悟空20.rmvb 20.rmvb
        齐天大圣孙悟空28.rmvb 28.rmvb
        齐天大圣孙悟空12.rmvb 12.rmvb
        齐天大圣孙悟空32.rmvb 32.rmvb
        齐天大圣孙悟空25.rmvb 25.rmvb
        齐天大圣孙悟空02.rmvb 02.rmvb
        齐天大圣孙悟空22.rmvb 22.rmvb
        齐天大圣孙悟空26.rmvb 26.rmvb
        齐天大圣孙悟空31.rmvb 31.rmvb
        齐天大圣孙悟空24.rmvb 24.rmvb
        齐天大圣孙悟空01.rmvb 01.rmvb
        齐天大圣孙悟空11.rmvb 11.rmvb
        齐天大圣孙悟空05.rmvb 05.rmvb
        齐天大圣孙悟空06.rmvb 06.rmvb
        齐天大圣孙悟空19.rmvb 19.rmvb
        齐天大圣孙悟空10.rmvb 10.rmvb
        齐天大圣孙悟空34.rmvb 34.rmvb
        齐天大圣孙悟空27.rmvb 27.rmvb
        齐天大圣孙悟空15.rmvb 15.rmvb
        齐天大圣孙悟空09.rmvb 09.rmvb
        齐天大圣孙悟空08.rmvb 08.rmvb
        齐天大圣孙悟空18.rmvb 18.rmvb
        关键字为: 潜伏
        修改的文件路径为: /潜伏
        潜伏15.flv 15.flv
        潜伏01.flv 01.flv
        潜伏16.flv 16.flv
        潜伏14.flv 14.flv
        潜伏25.flv 25.flv
        潜伏21.flv 21.flv
        潜伏11.flv 11.flv
        潜伏28.flv 28.flv
        潜伏20.flv 20.flv
        潜伏19.flv 19.flv
        潜伏04.flv 04.flv
        潜伏08.flv 08.flv
        潜伏06.flv 06.flv
        潜伏23.flv 23.flv
        潜伏02.flv 02.flv
        潜伏18.flv 18.flv
        潜伏24.flv 24.flv
        潜伏13.flv 13.flv
        潜伏17.flv 17.flv
        潜伏10.flv 10.flv
        潜伏26.flv 26.flv
        潜伏29.flv 29.flv
        潜伏30.flv 30.flv
        潜伏07.flv 07.flv
        潜伏27.flv 27.flv
        潜伏12.flv 12.flv
        潜伏09.flv 09.flv
        潜伏05.flv 05.flv
        潜伏22.flv 22.flv
        潜伏03.flv 03.flv
    ```
