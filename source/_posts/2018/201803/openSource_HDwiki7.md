---
title: HDwiki_源码分析 (7)
date: 2018-03-29
tags: HDwiki
toc: true
---

### 标签tag
    HDwiki模版标签可以让用户更方便、更容易的在页面中调用HDwiki的数据

<!-- more -->

#### 标签类型
- 循环标签
    * {HDwiki:doclist...}{/HDwiki}
- 单标签获取某个数据
    * {HDwiki:docnumber /}
- 字段的扩展函数 
    * [field:time date('Y-m-d H:i:s',@me)/]

#### 常用标签使用
- docnumber
    * 说明 : 本站总共的词条数目
    * 使用 : {HDwiki:docnumber /}
- usernumber
    * 说明 : 本站总共的用户数目
    * 使用 : {HDwiki:usernumber /}
- toplist
    * 说明 : 排行榜数据调用
    * 使用
        ```php
            <!-- rows=1表示展示排行榜的前1条数据 排序方式为credit2 默认desc -->
            {HDwiki:toplist rows=1 orderby=credit2}
                <!-- 展示哪些字段见标签说明 -->
                <p>用户的站内链接是  
                    <a href="{url user-space-[field:uid/]}" >[field:username/]</a>
                </p>
				<p>用户的uid是 [field:uid/]</p>
				<p>用户的username是 [field:username/]</p>
				<p>用户最后登录的时间为 [field:lasttime date('Y-m-d H:i:s',@me)/]</p>
				<p>用户有经验 [field:credit2/]</p>
				<br />
			{/HDwiki}
        ```
- recentupdate
    * 说明 : 最近更新词条列表数据调用
    * 使用 : 
        ```php
            <!-- rows=2展示前2条 默认按最后修改时间desc排序 展示字段下边有解释 -->
            {HDwiki:recentupdate rows=2}
				<p>词条链接为<a href="{url doc-view-[field:did/]}" >[field:title/]</a></p>
				<p>词条名缩写为 [field:shorttitle/]</p>
				<p>词条名为 [field:title/]</p>
				<p>词条的最后修改时间为 [field:lastedit/]</p>
				<hr />
			{/HDwiki}
        ```
- catelist
    * 说明 : 分类的数据调用
    * 使用 
        ```php
            {HDwiki:catelist}
                <p>一级分类的链接为
                	<a href="{url category-view-[field:cid/]}" >[field:name/]</a>
                </p>
            {/HDwiki}
        ```
- commentlist
    * 说明 : 单个词条评论的数据调用
    * 使用 
        ```php
            <!-- title=词条名称 docid=5 可选填,如果都填写,则title优先级高 -->
            {HDwiki:commentlist title="" docid=19 rows=10}
			  	<p>评论链接为 
			  	<a href="{url comment-view-[field:did/]}" >[field:comment/]</a>
			  	</p>
			  	<p>评论人为 [field:author/]</p>
			  	<p>评论内容为 [field:comment/]</p>
			  	<p>评论时间为 [field:time/]</p>
			  	<hr />
			{/HDwiki}
        ```
- userlist
    * 说明 : 最新会员的数据调用
    * 使用 
        ```php
            <!-- 去user表中groupid=4的前十个用户 默认排序uid DESC-->
            {HDwiki:userlist groupid=4 rows=10}
				<p>
					用户的站内链接为 <a href="{url user-space-[field:uid/]}" >[field:username/] </a>
				</p>
				<p>用户的uid为 [field:uid/]</p>
				<p>用户的username为 [field:username/]</p>
				<p>用户的注册时间为 [field:regtime/]</p>
			{/HDwiki}
        ```
- catedoclist
    * 说明 : 指定的分类下词条调用
    * 使用 : 类似commentlist
- doclist
    * 说明 : 全站词条调用
    * 使用 : 类似toplist

#### 源码分析
- 模版操作类
    * 位置 : /lib/template.php
    * 使用方式 : 正则替换HDwiki,使用自身的hdwiki方法,调用tag中的方法
- 标签tag模型
    * 位置 : /model/tag.class.php
    * 使用方式 : 每个标签对应一个function,其中展示的字段和查询方法中查询的字段一致