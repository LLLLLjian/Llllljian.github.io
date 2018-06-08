---
title: HDwiki_源码分析 (6)
date: 2018-03-28
tags: HDwiki
toc: true
---

### 文字及缓存数据设置
    前边写了控制器、模型、视图中使用lang及setting的用法,接下来说一下这些的设置

<!-- more -->

#### 文字lang
- 说明
    * 5.1版本中需要在代码中进行定义,6.0可以在后台页面中进行设置
- 前台文字
    * 位置 : lang/zh/front.php
    * 使用范围 : 前台相关控制器、模型、视图.默认是前台文字
    * 设置方式 : \$this->view->setlang($this->setting['lang_name'], 'front');
    * 使用方式
        * wikiCategory 必须在front.php中
        * control : $this->view->lang['wikiCategory']; 
        * model :  $this->base->view->lang['wikiCategorys'];
        * view : {lang wikiCategory}
- 后台文字
    * 位置 : lang/zh/back.php
    * 使用范围 : 后台相关控制器、模型、视图.
    * 设置方式 : \$this->view->setlang($this->setting['lang_name'], 'back');
    * 使用方式
        * commonName 必须在back.php中
        * control : $this->view->lang['commonName']; 
        * model :  $this->base->view->lang['commonName'];
        * view : {lang commonName}

#### 缓存数据setting
- 数据库存放位置
    * 表 : 表前缀_setting
- 文件缓存位置
    * 文件 : /data/cache/setting.php
- 读取 
    * control : $this->setting['cookie_pre'];
    * model :  $this->base->setting['cookie_pre'];
    * view : {$setting[cookie_pre]}
- 写入
    * control : admin_setting.php
    * model : setting.class.php
    * view : 参照control中的视图.
    * eg : admin_listdisplay.htm : 后台-全局-内容设置-列表设置[存放一些列表展示的数量 纯数字]
        ```php
            <tr>
                <!-- 需要在后台文字文件中添加的lang -->
                <td >{lang categoryLetter}</td>
                <!-- name和value 对应换成你想要储存的key,设置之前要先去数据库中核对,重复会覆盖前者 -->
                <td ><input class="inp_txt2" size="10" name="listplay[category_letter]"  maxlength="10" value="{$listdisplay['category_letter']}" /></td>
            </tr>
        ```
    * eg ： admin_base.htm : 后台-全局-站点设置[没有限制]
        ```php
            <tr>
                <!-- 同上 -->
                <td><span>{lang closeWebsiteReason}</span>{lang closeWebsiteReasonTip}</td>
                <td>
                <textarea class="textarea" name="setting[close_website_reason]" style="width:300px" rows="3">{$setting['close_website_reason']}</textarea>
                </td>
            </tr>
        ```


