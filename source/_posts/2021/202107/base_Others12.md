---
title: 杂项_总结 (12)
date: 2021-07-29
tags: Others
toc: true
---

### 生活小妙招
    巧用python

<!-- more -->

#### B站历险记
- 背景介绍
    * 我在B站听到了很好听的翻唱, 找了半天, 还是这个视频翻唱最能听进我心里, 我就想把这个视屏转成mp3放在网抑云里
- func1
    ```bash
        pip3 install you-get
        you-get https://www.bilibili.com/video/BV1vq4y1X7yo
        import imageio
        imageio.plugins.ffmpeg.download()
        import moviepy.editor as mp

        clip = mp.AudioFileClip(r'/Users/daineko/Desktop/code/test/如燕.flv') # 替换实际路径
        clip.write_audiofile(r'/Users/daineko/Desktop/code/test/如燕.mp3')  # 替换实际路径
    ```
- 可能遇到的问题
    * imageio.plugins.ffmpeg.download()
    * mac Imageio: 'ffmpeg.osx' was not found on your computer; downloading it now
    * 解决方法
        ```bash
            # 代码中添加
            # import imageio
            # imageio.plugins.ffmpeg.download()
            # https://github.com/imageio/imageio-binaries/tree/master/ffmpeg
            cp ffmpeg.osx /Users/daineko/Library/Application\ Support/imageio/ffmpeg/
        ```
- 达到的效果
    * 我从B站上下载下来了视频内容, 下载到本地是flv格式, 把flv格式再转化成了mp3格式




