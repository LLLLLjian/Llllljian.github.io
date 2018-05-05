---
title: HDwiki_源码分析 (9)
date: 2018-04-02
tags: HDwiki
toc: true
---

### 开发遇到的问题
    写一些自己开发遇到的问题

<!-- more -->

#### 词条标签分号修改
- 场景
    * 词条编辑及修改页面,多个词条标签之间要用分号";"隔开.
- 修改结果
    * 将其设置为逗号","或者空格 可能更容易让人接受
- 代码修改
    ```bash
        doc.class.php old
        function spilttags($tag){
            $taglist=array();
            $tags=split(';',$tag) ;
            foreach ($tags as $tag){
                if(!empty($tag)){
                    $taglist[]=$tag;
                }
            }
            return $taglist;
        }

        function jointags($tags){
            $taglist=array();
            foreach ($tags as $tag){
                if(!empty($tag)){
                    $taglist[]=strip_tags(trim($tag));
                }
            }
            return implode(';',array_unique($taglist));
        }

        doc.class.php new
        function spilttags($tag){
            $taglist=array();
            
            if(strpos($tag, ';') === false){
                $tags=split(',',$tag) ;
            }else{
                $tags=split(';',$tag) ;
            }

            foreach ($tags as $tag){
                if(!empty($tag)){
                    $taglist[]=$tag;
                }
            }
            return $taglist;
        }

        function jointags($tags){
            $taglist=array();
            foreach ($tags as $tag){
                if(!empty($tag)){
                    $taglist[]=strip_tags(trim($tag));
                }
            }
            return implode(',',array_unique($taglist));
        }
    ```

#### 添加https开头的频道或友情链接
- 场景
    * 频道管理和友情链接管理页面添加url如果是以https开头的则不能正常显示
- 修改结果
    * 支持https、http
- 代码修改
    ```bash
        http://www.solves.com.cn/search-fulltext-tag-HDwiki--all-0-within-time-desc-1-2.html
    ```