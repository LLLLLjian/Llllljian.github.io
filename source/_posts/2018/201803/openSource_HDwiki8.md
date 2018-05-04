---
title: HDwiki_源码分析 (8)
date: 2018-03-30
tags: HDwiki
toc: true
---

### 模板[block]
    后台-模板/插件-模板管理.可视化编辑前台页面展示内容,

<!-- more -->

#### 可视化编辑
    后台-模板/插件-模板管理-编辑模板-可视化编辑
    可对首页或者其它页面进行添加或修改.

#### 自定义模板
- 步骤1
    * 在/block/对应主题内 新建一个文件夹[xxxxx]
- 步骤2
    * 添加必要文件block.php[名字固定]
        ```bash
            <?php
                // 添加版块 列表展示项
                $block['name'] = '测试模块';
                // 版块说明
                $block['description'] = 'xxx';
                // 版块作者
                $block['author'] = 'xxx';
                // 版块版本
                $block['version'] = '5.1';
                // 版块创建时间
                $block['time']='2018-03-30';
                // 版块内容
                $block['fun'] = array(
                    // function => 版块介绍
                    'test1' => '测试模块1',
                    'test2' => '测试模块2',
                    'test3' => '测试模块3',
                    'test4' => '测试模块4',
                    'test5' => '测试模块5',
                    'test6' => '测试模块6',
                    'test7' => '测试模块7',
                    'test8' => '测试模块8'
                );
            ?>
        ```
    * 添加必要文件 xxxxx.php[与文件夹名一致]
        ```bash
            <?php
                // 与文件同名
                class xxxxx{
                    
                    var $db;
                    var $base;

                    function xxxxx(&$base) {
                        $this->base = $base;
                        $this->db = $base->db;
                    }

                    // $block['func']中的每一个key对应一个方法
                    function test1($setting){
                        ....
                        $list = array(123, 456, 789);
                        ....

                        // config 中对应的是页面样式设置 
                        return array(
                            'config' => $setting, 
                            'list' => $list
                        );
                    }
                }
            ?>
        ```
    * 添加必要文件 test1.htm[对应$block('func')]
        ```bash
            <!-- 外边框div和bid="{$bid}"属性是必须的 -->
            <div  class="columns reci {$data['config']['style']}" bid="{$bid}">
                <h2 class="col-h2">测试模板1</h2>
                <ul class="col-ul font-14 ">
                    <!--{loop $data['list'] $val}-->
                        <li>$val</li>
                    <!--{/loop}-->               
                </ul>
            </div>
        ```  
    * 添加非必要文件 test1_inc.htm[对应test1.htm文件]
        ```bash
            <!-- 此模块方法的配置表单 -->
            <ul class="col-ul ul_l_s">
                <li><span>选择边框样式：</span>
                    <select name="params[style]" >
                    <option value="">默认</option>
                    <option value="style_01">样式一</option>
                    <option value="style_02">样式二</option>
                    <option value="style_03">样式三</option>
                    <option value="style_04">样式四</option>
                    <option value="style_05">样式五</option>
                    <option value="style_06">样式六</option>
                    <option value="style_07">样式七</option>
                    <option value="style_08">样式八</option>
                    </select><br />如果默认则不使用额外样式设置。
                </li>
            </ul>
        ```

