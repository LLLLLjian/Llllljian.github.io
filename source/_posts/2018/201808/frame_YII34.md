---
title: PHP_Yii框架 (34)
date: 2018-08-03 08:00:00
tags: Yii
toc: true
---

### YII2之小部件
    再列一些新看到的小部件的使用

<!-- more -->

#### DetailView小部件
- eg
    ```php
        <?= DetailView::widget([
            // 模型对象,如：AR类findOne()返回
            'model' => $user,
            // 所有需要展示的模型属性
            'attributes' => [
                'realname',
                'username',
                [
                    'attribute' => 'sex',
                    // 使用匿名函数格式化(参数为当前模型对象）,也可以在模型类中定义该方法
                    'value' => function($model) {
                        $sex = ['保密', '男', '女'];
                        return $sex[$model->sex];
                    }
                ],
                'phone',
                'email',
                'classctime:datetime',
                'classmtime:datetime',
                [
                    'attribute' => 'attach',
                    // 如果备注中有html代码并且要展示的话,一定要将format设置为raw
                    'format' => 'raw',
                    'value' => ‘attach’
                ]
            ],
            // 自定义表格样式
            'template' => '<tr><th style="text-align:right">{label}：</th><td>{value}</td></tr>',
            // 为表格添加样式类
            'options' => ['class' => 'table table-striped']
        ]) ?>
    ```

#### ListView小部件
    类似GridView
- eg
    ```php
        view/test/index.php
        <?= ListView::widget([
            // 数据提供器
            'dataProvider' => $dataProvider,
            // 指定item视图(该视图文件与当前视图在同一个目录下)
            'itemView' => '_diary',
            'viewParams' => [
                // 传参数给每一个item
                'moodCfg' => Mood::getAll()
            ],
            // 整个ListView布局
            'layout' => '{items}<div class="col-lg-12 sum-pager">{summary}{pager}</div>',
            'itemOptions' => [
                // 针对渲染的单个item
                'tag' => 'div',
                'class' => 'col-lg-3'
            ],

            'pager' => [
                //'options' => ['class' => 'hidden'],//关闭分页(默认开启）
                /* 分页按钮设置 */
                'maxButtonCount' => 5,//最多显示几个分页按钮
                'firstPageLabel' => '首页',
                'prevPageLabel' => '上一页',
                'nextPageLabel' => '下一页',
                'lastPageLabel' => '尾页'
            ]
        ]);?>


        view/test/_diary.php
        <div class="item">
            <h4 style="font-weight:bold"><?= Html::encode($model->title ? $model->title : '(无题）') ?></h4>
        
            <p style="font-size:13px">
                <span style="color:orangered"><?= date('Y.m.d', $model->day) ?></span><br>
                <span style="color:#999">心情：<?= $moodCfg[$model->mood] ?></span>//这里访问ListView的'viewParams'参数传过来的参数$moodCfg
            </p>
        
            <div style="margin:15px 0">    
                <?php echo HtmlPurifier::process(mb_substr($model->content, 0, 25).'......'); ?>
            </div>
        
            <p class="info">
                添加：<?= date('Y-m-d H:i:s', $model->created_at) ?><br>
                最后修改：<?= date('Y-m-d H:i:s', $model->updated_at) ?>
            </p>
        
            <div style="text-align:right">
                <?= Html::a('<span class="glyphicon glyphicon-eye-open"></span>', ['view', 'id' => $model->id], ['title' => '查看']) ?>
                <?= Html::a('<span class="glyphicon glyphicon-pencil"></span>', ['upcreate', 'id' => $model->id], ['title' => '修改']) ?>
                <?= Html::a('<span class="glyphicon glyphicon-trash"></span>', ['delete', 'id' => $model->id], [
                    'title' => '删除',
                    'data' => [
                        'confirm' => '您确定真的要删除 '.date('Y年m月d日', $model->day).' 的日记吗？',
                        'method' => 'post',
                    ]
                ]) ?>
            </div>
        </div>
    ```

#### GridView小部件
- eg
    ```php
        <?= GridView::widget([
            // 数据提供器
            'dataProvider' => $dataProvider,
            // 搜索模型
            'filterModel' => $searchModel,
            // 数据列
            'columns' => [
                [
                    // 显示复选框(每个复选框的值为当前记录的数据库主键值,名称为selection[])
                    'class' => 'yii\grid\CheckboxColumn',
                    // 该列底部占8格
                    'footerOptions' => ['colspan' => 8],
                    // 设置该列底部内容
                    'footer' => '<a class="btn btn-danger" onclick=delall("'.Yii::$app->urlManager->createUrl(['life/delall']).'")>删除所有选中数据</a>'
                    // 通过yii中封装的方法获取选中项
                    //'footer' => '<a class="btn btn-danger delAll")>删除所有选中数据</a>'
                ],
                [
                    'attribute' => 'day',
                    // 是否显示搜索框
                    'filter' => true,
                    // 设置属性标签
                    'label' => '日期',
                    // 设置日期格式
                    //'format' => ['date', 'php:Y.m.d'],
                    // 设置宽度
                    //'options' => ['width' => '150'],
                    
                    // 数据列有链接：不想让html原样输出就要设置类型format=>raw
                    'format' => 'raw',
                    // 设置该列显示内容
                    'value' => function($model, $key, $index, $column) {
                        return Html::a(date('Y.m.d', $model->day),
                            ['life/view', 'id' => $key], ['title' => '查看详情']);
                    },
                    // 隐藏最后一列
                    'footerOptions' => ['class' => 'hide'],
                    /* *
                    * 隐藏最后一列也可以这样写
                    'footerOptions' => ['style' => 'display:none'],
                    */
                ],
                [
                    'attribute' => 'mood',
                    'value' => function($model) {
                        $moods = ['没什么好说的', '很糟糕', '略沉重', '有点郁闷', '还好吧', '小窃喜', '欢愉', '嗨森'];
                        return $moods[$model->mood];
                    },
                    // 设置下拉框搜索
                    'filter' => ['没什么好说的', '很糟糕', '略沉重', '有点郁闷', '还好吧', '小窃喜', '欢愉', '嗨森'],
                    /* *
                    * 下拉框搜索也可以这样写
                    'filter' => Html::activeDropDownList($searchModel,
                        'mood', ['没什么好说的', '很糟糕', '略沉重', '有点郁闷', '还好吧', '小窃喜', '欢愉', '嗨森'],
                        ['prompt' => '全部'])
                    */
                    'footerOptions' => ['class' => 'hide']
                ],
                [
                    'attribute' => 'con_morning',
                    'footerOptions' => ['class' => 'hide']
                ],
                [
                    'attribute' => 'con_afternoon',
                    'footerOptions' => ['class' => 'hide']
                ],
                [
                    'attribute' => 'con_night',
                    'footerOptions' => ['class' => 'hide']
                ],
                [
                    'attribute' => 'note',
                    // 设置是否开启排序功能
                    'enableSorting' => false,
                    // 设置该列内容是否可见
                    'visible' => true,
                    'footerOptions' => ['class' => 'hide']
                ],
        
                // 显示查看、编辑、删除等按钮(默认）
                //['class' => 'yii\grid\ActionColumn'],
                [
                    // 自定义设置操作按钮
                    'class' => 'yii\grid\ActionColumn',
                    // 设置当前列标题
                    'header' => '操作',
                    // 展示按钮
                    'template' => '{view} {update} {delete}',
                    // 该列宽度设置
                    'headerOptions' => ['width' => 100],
                    'buttons' => [
                        // 自定义删除按钮
                        'delete' => function($url, $model, $key) {
                            return Html::a('<i class="fa fa-ban"></i> 删除',
                                // 设置删除按钮请求方法和参数,这里设置请求方法为del,默认为delete,$key是当前记录的数据表主键值
                                ['delete', 'id' => $key],
                                [
                                    'class' => 'btn btn-danger btn-xs',
                                    'title' => '删除',
                                    'data-method' => 'post',
                                    // 设置删除确认信息
                                    'data' => ['confirm' => '您确定要删除'.date('Y.m.d', $model->day).'的生活记录吗？']
                                ]);
                        }
                    ],
                    'footerOptions' => ['class' => 'hide']
                ]
            ],
            // 整体布局与样式设置
            'layout' => "{items}\n{summary}\n{pager}",
            // 设置表格样式
            'tableOptions' => [
                'class' => 'table table-striped table-bordered',
                'style' => 'overflow:auto',
                'id' => 'grid'
            ],
            // 是否显示表格头部
            'showHeader' => true,
            // 是否显示表格尾部
            'showFooter' => true,
            // 给每一行设置id
            'rowOptions' => function($model) {
                return ['id' => 'tr_'.$model->id];
            },
            // 没有数据时显示的信息
            'emptyText' => '暂时没有任何生活记录！',
            // 没有数据时显示信息的样式设置
            'emptyTextOptions' => ['style' => 'color:red;font-weight:bold'],
            // 没有数据时是否显示表格
            'showOnEmpty' => true,
            'pager' => [
                // 关闭分页(默认开启）
                //'options' => ['class' => 'hidden']
                /* 默认不显示的按钮设置 */
                'firstPageLabel' => '首页',
                'prevPageLabel' => '上一页',
                'nextPageLabel' => '下一页',
                'lastPageLabel' => '尾页'
            ]
        ]); ?>

        <style>
            .tr_selected{background-color:pink}
        </style>

        <script>
            //点击复选框改变当前行背景色
            $('input[name="selection[]"]').click(function() {
                var tr = $('#tr_'+this.value);
                this.checked ? tr.addClass('tr_selected') : tr.removeClass('tr_selected');
            });

            //删除选中的所有记录
            function delall(url) {
                var ckbox = $('input[name="selection[]"]:checked'), ids = [];

                $.each(ckbox, function(i, o) {
                    ids.push(o.value);
                });
                if(ids.length <= 0) return alert('请至少选择一条数据！');
                
                var okay = confirm('此操作将删除所有选中的数据,是否确认操作？');
                if(!okay) return;
                
                ids = ids.join(',');
                $.post(url, {'ids': ids}, function(ret) {
                    if(ret.ok) {
                        alert('恭喜你,操作成功！');
                        window.location.reload();
                    } else {
                        alert(ret.msg ? ret.msg : '对不起,操作失败！');
                    }
                }, 'json');
            }

            // 使用yii封装的方法
            $('.gridview').click(function() {
                var url = '<?= Url::to(['life/delall']) ?>';
                var param = $("#grid").yiiGridView("getSelectedRows");

                if(param.length > 0) {
                    if(confirm("确定要删除？")) {
                            $.ajax({
                            url: url,
                            data: {'id[]':param},
                            dataType: 'json',
                            success: function (result) {
                                var ret = $.parseJSON(result);

                                if(ret.success == true) {
                                    location.reload();
                                }else {
                                    alert("删除失败,请重新操作");
                                }
                            }
                        });
                    }
                }else {
                    alert("请至少选择一项纪录！");
                }

            });
        </script>
    ```
- config
    ```php
        'dataProvider' => $dataProvider,//数据提供器,即yii\data\ActiveDataProvider类实例
        'filterModel' => $searchModel,//搜索模型,即AR类实例(不配置则搜索行消失）
        'columns' => [//数据列
            [
                'class' => 'yii\grid\DataColumn’,
                /**
                  * DataColumn：显示数据,默认值.
                  * ActionColumn：显示操作按钮等
                  * CheckboxColumn：显示操复选框(复选框值为数据表主键值）
                  * RadioButtonColumn：显示单选按钮(单选框值为数据表主键值）
                  * SerialColumn：显示行号
                  **/
                'attribute' => 'day',//AR模型属性名称,即要显示的数据表字段名称
                'label' => '日期',//设置属性标签
                'header' => '日期',//设置该列标题(和label类似,区别是使用header设置之后该列无法使用排序功能）
                'format' => ['date', 'php:Y.m.d'],//设置日期格式
                'enableSorting' => false,//是否开启排序功能,默认为true
                'visible' => true,//设置该列内容是否可见,默认为true
                'filter' => true,//是否显示搜索框,默认为true

                /* 设置下拉框搜索 */
                'filter' => [],//键值对数组
                //也可以这样写：
                'filter' => Html::activeDropDownList($searchModel,
                'mood', [],//键值对数组
                ['prompt' => '全部']),

                /* 在数据列设置链接 */
                'format' => 'raw',
                'value' => function($model, $key, $index, $column) {//设置当前列显示内容
                return Html::a(date('Y.m.d', $model->day),
                ['life/view', 'id' => $key], ['title' => '查看详情']);
                },

                ‘headerOptions’ => [],//设置当前列头部样式
                'footerOptions' => [],//设置当前列底部样式
                'footer' => ''//设置当前列底部内容
                'options' => ['width' => '150'],//设置当前列样式,如宽度等　　　　　　　　　　 'contentOptions' => ['class' => 'bg-danger'],//设置当前列内容样式,如背景色等
                　　　　　　　　　　　　
                /* 自定义设置操作按钮 */
                'class' => 'yii\grid\ActionColumn',
                'template' => '{view} {update} {delete}',//展示按钮(默认{view} {update} {delete})
                'buttons' => [//没有在这里自定义设置的按钮使用默认设置
                    'delete' => function($url, $model, $key) {//自定义删除按钮
                        return Html::a('<i class="fa fa-ban"></i> 删除',
                            ['delete', 'id' => $key],//设置删除按钮请求方法和参数,这里设置请求方法为del,默认为delete,$key是当前记录的数据表主键值
                            [
                                'class' => 'btn btn-danger btn-xs',
                                'title' => '删除',
                                'data-method' => 'post',
                                'data' => ['confirm' => '您确定要删除'.date('Y.m.d', $model->day).'的生活记录吗？']//设置删除确认信息
                            ]
                        );
                    }
                ]
            ],
            
            'layout' => "{items}\n{summary}\n{pager}",//整体布局与样式设置,由上而下分别为：表格、简介、分页(默认为：{summary}\n{items}\n{pager})
            'tableOptions' => ['class' => 'table table-striped table-bordered'],//设置表格样式(默认设置）
            'showHeader' => true,//是否显示表格头部(默认为true,为false则表格标题行和搜索行都消失）
            'showFooter' => true,//是否显示表格底部部(默认为false,为true时底部多一空行）
            'rowOptions' => function($model) {//每一行自定义样式(这里设置每一行id)
                eturn ['id' => 'tr_'.$model->id];
            },

            'emptyText' => '暂时没有任何生活记录！',//设置没有数据时显示的信息
            'emptyTextOptions' => ['style' => 'color:red;font-weight:bold'],//没有数据时显示信息的样式设置
            'showOnEmpty' => true,//没有数据时是否显示表格(默认为true）
            'pager' => [
                //'options' => ['class' => 'hidden']//关闭分页(默认开启）
                /* 分页按钮设置 */
                'firstPageLabel' => '首页',
                'prevPageLabel' => '上一页',
                'nextPageLabel' => '下一页',
                'lastPageLabel' => '尾页'
            ]
        ]
    ```
