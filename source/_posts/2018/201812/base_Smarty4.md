---
title: Smarty_基础 (4)
date: 2018-12-04
tags: Smarty
toc: true
---

### Smarty基础
    Smarty的基本使用与总结

<!-- more -->

#### 自定义函数
- {html_checkboxes}
    * 根据给定的数据创建复选按钮组
    * list
        <table border="1"><colgroup><col align="center"><col align="center"><col align="center"><col align="center"><col></colgroup><thead><tr><th align="center">参数名称</th><th align="center">类型</th><th align="center">必选参数</th><th align="center">默认值</th><th>说明</th></tr></thead><tbody><tr><td align="center">name</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>checkbox</em></span></td><td>多选框的名称</td></tr><tr><td align="center">values</td><td align="center">array</td><td align="center">必选,除非使用options属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>多选框的值数据</td></tr><tr><td align="center">output</td><td align="center">array</td><td align="center">必选,除非使用options属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>多选框的显示数据</td></tr><tr><td align="center">selected</td><td align="center">string/array</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>选中的项(一个或多个)</td></tr><tr><td align="center">options</td><td align="center">associative array</td><td align="center">必须, 除非使用values 和 output属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>多选框的值-显示的数组</td></tr><tr><td align="center">separator</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>字符串中分隔每项的字符</td></tr><tr><td align="center">assign</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>将多选框标签赋值到数组,而不是输出</td></tr><tr><td align="center">labels</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">TRUE</code></em></span></td><td>在输出中增加&lt;label&gt;标签</td></tr><tr><td align="center">label_ids</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">FALSE</code></em></span></td><td>给&lt;label&gt; 和 &lt;input&gt;设置ID属性</td></tr><tr><td align="center">escape</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">TRUE</code></em></span></td><td>将输出中的/转换(值总是会被转换)</td></tr></tbody></table>
    * eg
        ```php
            $smarty->assign('cust_ids', array(1000,1001,1002,1003));
            $smarty->assign('cust_names', array(
                                            'Joe Schmoe',
                                            'Jack Smith',
                                            'Jane Johnson',
                                            'Charlie Brown')
                                        );
            $smarty->assign('customer_id', 1001);
        ```
        ```html
            {html_checkboxes name='id' values=$cust_ids output=$cust_names selected=$customer_id  separator='<br />'}
        ```
- {html_image}
    * 生成HTML的&gt;img>标签
    * list
        <table border="1"><colgroup><col align="center"><col align="center"><col align="center"><col align="center"><col></colgroup><thead><tr><th align="center">参数名称</th><th align="center">类型</th><th align="center">必选参数</th><th align="center">默认值</th><th>说明</th></tr></thead><tbody><tr><td align="center">file</td><td align="center">string</td><td align="center">Yes</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>图片名称/路径</td></tr><tr><td align="center">height</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>真实图片高度</em></span></td><td>图片显示高度</td></tr><tr><td align="center">width</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>真实图片宽度</em></span></td><td>图片显示宽度</td></tr><tr><td align="center">basedir</td><td align="center">string</td><td align="center">no</td><td align="center"><span class="emphasis"><em>网站根目录</em></span></td><td>相对路径的起始目录</td></tr><tr><td align="center">alt</td><td align="center">string</td><td align="center">no</td><td align="center"><span class="emphasis"><em><span class="quote">“<span class="quote"></span>”</span></em></span></td><td>图片的说明内容</td></tr><tr><td align="center">href</td><td align="center">string</td><td align="center">no</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>图片上的链接地址</td></tr><tr><td align="center">path_prefix</td><td align="center">string</td><td align="center">no</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>显示路径的前缀</td></tr></tbody></table>
    - eg
        ```html
            {html_image file='pumpkin.jpg'}
            {html_image file='/path/from/docroot/pumpkin.jpg'}
            {html_image file='../path/relative/to/currdir/pumpkin.jpg'}
        ```
- {html_options}
    * 生成HTML的&gt;select>
    * list
        <table border="1"><colgroup><col align="center"><col align="center"><col align="center"><col align="center"><col></colgroup><thead><tr><th align="center">参数名称</th><th align="center">类型</th><th align="center">必选参数</th><th align="center">默认值</th><th>说明</th></tr></thead><tbody><tr><td align="center">values</td><td align="center">array</td><td align="center">Yes, 除非使用 options 属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>下拉框值的数组</td></tr><tr><td align="center">output</td><td align="center">array</td><td align="center">Yes, 除非使用 options 属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>下拉框显示的数组</td></tr><tr><td align="center">selected</td><td align="center">string/array</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>选中的项</td></tr><tr><td align="center">options</td><td align="center">数组</td><td align="center">Yes, 除非使用 values 和 output</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>键值对的数组,用于下拉框</td></tr><tr><td align="center">name</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>select组的名称</td></tr></tbody></table>
    * eg
        ```php
            $smarty->assign('myOptions', array(
                                1800 => 'Joe Schmoe',
                                9904 => 'Jack Smith',
                                2003 => 'Charlie Brown')
                                );
            $smarty->assign('mySelect', 9904);
        ```
        ```html
            {html_options name=foo options=$myOptions selected=$mySelect}
        ```
- {html_radios}
    * 创建HTML的单选框组和提供数据
    * list
        <table border="1"><colgroup><col align="center"><col align="center"><col align="center"><col align="center"><col></colgroup><thead><tr><th align="center">参数名称</th><th align="center">类型</th><th align="center">必选参数</th><th align="center">默认值</th><th>说明</th></tr></thead><tbody><tr><td align="center">name</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>radio</em></span></td><td>单选框的名称</td></tr><tr><td align="center">values</td><td align="center">array</td><td align="center">必选,除非使用options属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>单选框的值数据</td></tr><tr><td align="center">output</td><td align="center">array</td><td align="center">必选,除非使用options属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>单选框的显示数据</td></tr><tr><td align="center">selected</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>选中的项</td></tr><tr><td align="center">options</td><td align="center">数组</td><td align="center">必须, 除非使用values 和 output属性</td><td align="center"><span class="emphasis"><em>n/a</em></span></td><td>单选框的值-显示的数组</td></tr><tr><td align="center">separator</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>字符串中分隔每项的字符</td></tr><tr><td align="center">assign</td><td align="center">string</td><td align="center">No</td><td align="center"><span class="emphasis"><em>empty</em></span></td><td>将单选框标签赋值到数组,而不是输出</td></tr><tr><td align="center">labels</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">TRUE</code></em></span></td><td>在输出中增加&lt;label&gt;标签</td></tr><tr><td align="center">label_ids</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">FALSE</code></em></span></td><td>给&lt;label&gt; 和 &lt;input&gt;设置ID属性</td></tr><tr><td align="center">escape</td><td align="center">boolean</td><td align="center">No</td><td align="center"><span class="emphasis"><em><code class="constant">TRUE</code></em></span></td><td>将输出中的/转换(值总是会被转换)</td></tr></tbody></table>
    * eg
        ```php
            $smarty->assign('cust_ids', array(1000,1001,1002,1003));
            $smarty->assign('cust_names', array(
                                        'Joe Schmoe',
                                        'Jack Smith',
                                        'Jane Johnson',
                                        'Charlie Brown')
                                        );
            $smarty->assign('customer_id', 1001);
        ```
        ```html
            {html_radios name='id' values=$cust_ids output=$cust_names selected=$customer_id separator='<br />'}
        ```
- {html_select_date}
    * 创建一个选择日期的下拉框
    * list
        <table border="1"><colgroup><col align="center"><col align="center"><col align="center"><col align="center"><col></colgroup><thead><tr><th align="center">参数名称</th><th align="center">类型</th><th align="center">必选参数</th><th align="center">默认值</th><th>说明</th></tr></thead><tbody><tr><td align="center">prefix</td><td align="center">string</td><td align="center">No</td><td align="center">Date_</td><td>下拉框名称的前缀</td></tr><tr><td align="center">time</td><td align="center"><a class="ulink" href="http://php.net/function.time" target="_top">时间戳</a>,<a class="ulink" href="http://php.net/class.DateTime" target="_top">DateTime</a>, 	  mysql时间戳或任何<a class="ulink" href="http://php.net/strtotime" target="_top"><code class="varname">strtotime()</code></a>	  能支持的字符串,或者是数组(当设置了field_array)</td><td align="center">No</td><td align="center">当前<a class="ulink" href="http://php.net/function.time" target="_top">时间戳</a></td><td>	 默认选中的日期.如果提供了数组,那么field_array和prefix属性将单独作用在每个数组元素上,	 包括年月日.</td></tr><tr><td align="center">start_year</td><td align="center">string</td><td align="center">No</td><td align="center">当前年份</td><td>	 下拉框开始显示的年份,可以设置一个年份数字或者默认当前年份(+/- N)</td></tr><tr><td align="center">end_year</td><td align="center">string</td><td align="center">No</td><td align="center">same as start_year</td><td>	 下拉框结束显示的年份,可以设置一个年份的数字或者默认当前年份(+/- N)</td></tr><tr><td align="center">display_days</td><td align="center">boolean</td><td align="center">No</td><td align="center"><code class="constant">TRUE</code></td><td>是否显示日期</td></tr><tr><td align="center">display_months</td><td align="center">boolean</td><td align="center">No</td><td align="center"><code class="constant">TRUE</code></td><td>是否显示月份</td></tr><tr><td align="center">display_years</td><td align="center">boolean</td><td align="center">No</td><td align="center"><code class="constant">TRUE</code></td><td>是否显示年份</td></tr><tr><td align="center">month_format</td><td align="center">array</td><td align="center">No</td><td align="center">null</td><td>月份显示的字符串的数组.如 array(1 =&gt; 'Jan', …, 12 =&gt; 'Dec')</td></tr><tr><td align="center">month_names</td><td align="center">string</td><td align="center">No</td><td align="center">%B</td><td>月份显示的格式 (strftime)</td></tr><tr><td align="center">day_format</td><td align="center">string</td><td align="center">No</td><td align="center">%02d</td><td>日期显示的格式 (sprintf)</td></tr><tr><td align="center">day_value_format</td><td align="center">string</td><td align="center">No</td><td align="center">%d</td><td>日期值显示的格式 (sprintf)</td></tr><tr><td align="center">year_as_text</td><td align="center">boolean</td><td align="center">No</td><td align="center"><code class="constant">FALSE</code></td><td>是否将年份显示为文字</td></tr><tr><td align="center">reverse_years</td><td align="center">boolean</td><td align="center">No</td><td align="center"><code class="constant">FALSE</code></td><td>是否按倒序显示年份</td></tr><tr><td align="center">field_array</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>	 如果设置了field_array值,则下拉框的值发送的PHP时,将会是	 值[Day], 值[Year], 值[Month]的格式.</td></tr><tr><td align="center">day_size</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加日期select标签的size属性</td></tr><tr><td align="center">month_size</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加月份select标签的size属性</td></tr><tr><td align="center">year_size</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加年份select标签的size属性</td></tr><tr><td align="center">all_extra</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加给全部select/input标签附加的属性</td></tr><tr><td align="center">day_extra</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加给日期select/input标签附加的属性</td></tr><tr><td align="center">month_extra</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加给月份select/input标签附加的属性</td></tr><tr><td align="center">year_extra</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>附加给年份select/input标签附加的属性</td></tr><tr><td align="center">all_id</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>全部select/input标签的ID值</td></tr><tr><td align="center">day_id</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>日期select/input标签的ID值</td></tr><tr><td align="center">month_id</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>月份select/input标签的ID值</td></tr><tr><td align="center">year_id</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>年份select/input标签的ID值</td></tr><tr><td align="center">field_order</td><td align="center">string</td><td align="center">No</td><td align="center">MDY</td><td>显示各下拉框的顺序</td></tr><tr><td align="center">field_separator</td><td align="center">string</td><td align="center">No</td><td align="center">\n</td><td>显示在各字段之间间隔的字符串</td></tr><tr><td align="center">month_value_format</td><td align="center">string</td><td align="center">No</td><td align="center">%m</td><td>月份值的显示格式(按strftime())默认是 %m</td></tr><tr><td align="center">all_empty</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>该属性可以在每个下拉框的第一行显示文字,并以<span class="quote">“<span class="quote"></span>”</span>作为它的值.	 在需要让下拉框的第一行显示<span class="quote">“<span class="quote">请选择</span>”</span> 的情况下比较有用.</td></tr><tr><td align="center">year_empty</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>	 该属性可以在年份下拉框的第一行显示文字,并以<span class="quote">“<span class="quote"></span>”</span>作为它的值.	 在需要让年份下拉框的第一行显示<span class="quote">“<span class="quote">请选择年份</span>”</span> 的情况下比较有用.	 注意你可以使用如<span class="quote">“<span class="quote">-MM-DD</span>”</span>的值,作为时间属性来显示没有选中的年份.</td></tr><tr><td align="center">month_empty</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>	该属性可以在月份下拉框的第一行显示文字,并以<span class="quote">“<span class="quote"></span>”</span>作为它的值.	 注意你可以使用如<span class="quote">“<span class="quote">YYYY--DD</span>”</span>的值,作为时间属性来显示没有选中的月份.</td></tr><tr><td align="center">day_empty</td><td align="center">string</td><td align="center">No</td><td align="center">null</td><td>	该属性可以在日期下拉框的第一行显示文字,并以<span class="quote">“<span class="quote"></span>”</span>作为它的值.	 注意你可以使用如<span class="quote">“<span class="quote">YYYY-MM-</span>”</span>的值,作为时间属性来显示没有选中的日期.</td></tr></tbody></table>
    - eg
        ```html
            {html_select_date prefix='StartDate' time=$time start_year='-5' end_year='+1' display_days=false}
        ```
- {html_select_time} 
- {html_table} 
- {mailto} 
- {math} 
- {textformat} 


