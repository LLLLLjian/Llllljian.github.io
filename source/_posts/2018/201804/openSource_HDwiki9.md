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
    ```php
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
    ```php
        // control/admin_friendlink.php old
        if (substr($flink['url'],0,7) != "http://") {
            $flink['url'] = "http://".$flink['url']; 
        } 

        // control/admin_friendlink.php new
        if (substr($flink['url'],0,4) != "http") {
            if (substr($flink['url'],0,5) =="https") {
                $flink['url'] = "https://".$flink['url'];
            } else {
                $flink['url'] = "http://".$flink['url']; 
            }
        }

        // control/admin_channel.php old
        if (substr($channel['url'],0,7) != "http://") {
            $channel['url'] = "http://".$channel['url'];
        }

        // control/admin_channel.php new
        if (substr($channel['url'],0,4) != "http") {
            if (substr($channel['url'],0,5) =="https") {
                $channel['url'] = "https://".$channel['url'];
            } else {
                $channel['url'] = "http://".$channel['url']; 
            }
        }
    ```

#### No Aceess!注意敏感词修改
- 场景
    *  某些action可能有敏感词,会导致访问action失败
- 修改结果
    * 修改model\hdwiki.class.php中的逻辑
- 代码修改
    ```php
        // model\hdwiki.class.php\checksecurity
        // add 如果当前登录用户不是超级管理员组 才进行敏感词验证
        // 弊端:非管理员用户可能无法使用某些方法
        if ($this->user['group'] != 4) {
            ...
        }
    ```
