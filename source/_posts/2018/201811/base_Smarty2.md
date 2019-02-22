---
title: Smarty_基础 (2)
date: 2018-11-30
tags: Smarty
toc: true
---

### Smarty基础
    Smarty的基本使用与总结

<!-- more -->

#### 基本语法
- 注释
    * 模板注释被\*星号包围,而两边的星号又被定界符包围,例如 {* this is a comment *}
    * 与html注释不同的是,html注释在页面源码中可见,而Smarty注释则不能
- 变量
    * 模板变量用美元符号$开始,可以包含数字、字母和下划线,这与php变量很像.你可以引用数组的数字或非数字索引,当然也可以引用对象属性和方法
- 函数
    * 每一个Smarty标签输出一个变量或者调用某种函数.在定界符内函数（一般定界符‘{}’包住）和其属性（同样在定界符内）将被处理和输出.例如: {funcname attr1="val" attr2="val"}.
- 属性
    * 大多数函数都带有自己的属性以便于明确说明或者修改他们的行为,Smarty函数的属性很像HTML中的属性.静态数值不需要加引号,但是字符串建议使用引号.可以使用普通Smarty变量,也可以使用带调节器的变量作为属性值,它们也不用加引号.你甚至可以使用php函数返回值和复杂表达式作为属性值.
    * 一些属性用到了布尔值(true或false),它们表明为真或为假.如果没有为这些属性赋布尔值,那么默认使用true为其值
- 双引号里嵌入变量
    * Smarty可以识别嵌入在双引号中的变量,只要此变量只包含数字、字母、下划线和中括号[],详细资料参考php命名. 
    * 对于其他的符号（句号、对象引用等等）此变量必须用两个反引号`(此符号和~'在同一个键上,一般在ESC键下面)包住. 
    * Smarty3增加了双引号对Smarty标签的支持.在需要包含调节器变量、插件、php函数返回值的情形中非常实用.
- 数学运算
    * 数学运算可以直接作用到变量值
- 忽略Smarty解析
    * 不在定界符中设置的元素将会被Smarty忽略
    * 可以通过Smarty的$left_delimiter和$right_delimiter设置相应的值.

#### 变量
- 从PHP分配的变量
    * 普通字符串
        ```php
            $smarty = new Smarty();
            $smarty->assign('firstname', 'Doug');
            $smarty->assign('lastname', 'Evans');
            $smarty->display('index.tpl');
        ```
        ```html
            Hello {$firstname} {$lastname}, glad to see you can make it.
        ```
    * 关联数组
        ```php
            $smarty = new Smarty;
            $contacts = array(
                'fax' => '555-222-9876',
                'email' => 'zaphod@slartibartfast.com',
                'phone' => array(
                    'home' => '555-444-3333',
                    'cell' => '555-111-1234'
                )
            );
            $smarty->assign('Contacts', $contacts);
            $smarty->display('index.tpl');
        ```
        ```html
            {$Contacts.fax}<br>
            {$Contacts.email}<br>
            {* you can print arrays of arrays as well *} {* 同样可以用于多维数组 *}
            {$Contacts.phone.home}<br>
            {$Contacts.phone.cell}<br>
        ```
    * 数组下标
        ```php
            $smarty->assign('Contacts', array('555-222-9876', 'zaphod@slartibartfast.example.com', array('555-444-3333', '555-111-1234')));
            $smarty->display('index.tpl');
        ```
        ```html
            {$Contacts[0]}<br />
            {$Contacts[1]}<br />
            {* you can print arrays of arrays as well *}
            {$Contacts[2][0]}<br />
            {$Contacts[2][1]}<br />
        ```
    * 对象
        ```html
            name: {$person->name}<br>
            email: {$person->email}<br>
        ```
- 从配置文件读取的变量
    ```html
        <html>
        <title>{$smarty.config.pageTitle}</title>
        <body bgcolor="{$smarty.config.bodyBgColor}">
            <table border="{$smarty.config.tableBorderSize}" bgcolor="{$smarty.config.tableBgColor"}>
                <tr bgcolor="{$smarty.config.rowBgColor}">
                    <td>First</td>
                    <td>Last</td>
                    <td>Address</td>
                </tr>
            </table>
        </body>
        </html>
    ```
- Smarty保留变量
    * Request variables
        * 页面请求变量 
    * {$smarty.now}
        * 取得当前时间戳
    * {$smarty.const}
        * 直接访问php常量
    * {$smarty.capture} 
    * {$smarty.config} 
    * {$smarty.section} 
    * {$smarty.template} 
    * {$smarty.current_dir} 
    * {$smarty.version} 
    * {$smarty.block.child} 
    * {$smarty.block.parent} 
    * {$smarty.ldelim}, {$smarty.rdelim} 




