---
title: Linux_基础 (75)
date: 2021-01-29
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 命令之乐

##### rename
1. 用特定的格式重命名当前目录下的图像文件
    ```bash
        # !/bin/bash
        # 文件名: rename.sh
        # 用途: 重命名 .jpg 和 .png 文件
        count=1;
        for img in `find . -iname '*.png' -o -iname '*.jpg' -type f -maxdepth 1`
        do
            new=image-$count.${img##*.}
            echo "Renaming $img to $new" 
            mv "$img" "$new"
            let count++
        done
    ```
2. 将 *.JPG更名为 *.jpg
    ```bash
        rename *.JPG *.jpg
    ```
3. 将文件名中的空格替换成字符“_”
    ```bash
        rename 's/ /_/g' *
    ```
4. 转换文件名的大小写
    ```bash
        rename 'y/A-Z/a-z/' * $ rename 'y/a-z/A-Z/' *
    ```
5. 将所有的 .mp3文件移入给定的目录
    ```bash
        find path -type f -name "*.mp3" -exec mv {} target_dir \;
    ```
6. 将所有文件名中的空格替换为字符“_”
    ```bash
        find path -type f -exec rename 's/ /_/g' {} \;
    ```


