---
title: PHP_基础 (37)
date: 2019-11-26
tags: PHP 
toc: true
---

### PHP操作PDF
    最近需求需要在PDF上添加文字内容, 目前系统中已经在使用mpdf进行PDF的生成了, 不想再安装别的扩展了 查了一下mpdf也支持编辑PDF 所以就继续用他了(版本6.0)

<!-- more -->

#### 什么是mpdf
    mPDF是一个PHP类库, 它由UTF-8编码的HTML生成PDF文件.它基于FPDF和HTML2FPDF , 再此基础上添加了许多功能.同时对css支持能力得到了大的提升, 支持css样式的引入

#### 安装
- 通过官方composer下载类库包
- 直接下载压缩包

#### 使用
- demo1
    ```php
        Vendor('mpdf.mpdf');
        // mPDF($mode='',$format='A4',$default_font_size=0,$default_font='',$mgl=15,$mgr=15,$mgt=16,$mgb=16,$mgh=9,$mgf=9, $orientation='P')
        // $mode 语言类型
        // $format 纸张的大小, 默认A4竖版, 可以设置为A4-L变成横板
        // $default_font_size 字体大小
        // $default_font 字体样式
        // 后四个参数分别是margin-left, margin-right, margin-top, margin-bottom.它们是指每一页的内容距离页面边界的距离, 我们可以通过调节它们, 空出页眉、页脚以及一些有边框的背景图片
        // $orientation 纸张排版 P是竖版 L是横板
        $mpdf = new \mPDF('zh-CN', 'A4', '', '', 20, 20, 20, 20);

        // 设置pdf显示方式
        $mpdf->SetDisplayMode('fullpage');
        // 设置字体,解决中文乱码
        $mpdf->useAdobeCJK = true;
        // 设置pdf的尺寸为210mm*320mm
        $mpdf->WriteHTML('<pagebreak sheet-size="210mm 320mm" />');
        //设置PDF页眉内容
        $header='<table width="%" style="margin: auto;border-bottom: px solid #FBD; vertical-align: middle; font-family:
        serif; font-size: pt; color: #;"><tr>
        <td width="%"></td>
        <td width="%" align="center" style="font-size:px;color:#AAA">页眉</td>
        <td width="%" style="text-align: right;"></td>
        </tr></table>';
        //设置PDF页脚内容
        $footer='<table width="%" style=" vertical-align: bottom; font-family:
        serif; font-size: pt; color: #;"><tr style="height:px"></tr><tr>
        <td width="%"></td>
        <td width="%" align="center" style="font-size:px;color:#AAA">页脚</td>
        <td width="%" style="text-align: left;">页码: {PAGENO}/{nb}</td>
        </tr></table>';
        //添加页眉和页脚到pdf中
        $mpdf->SetHTMLHeader($header);
        $mpdf->SetHTMLFooter($footer);

        // 删除pdf第一页(由于设置pdf尺寸导致多出了一页)
        $mpdf->DeletePages(1,1);
        //创建pdf文件
        $mpdf->WriteHTML("testpdf");
        
        //文字水印
        $mpdf->SetWatermarkText('这个是测试的水印',0.1);//参数一是文字, 参数二是透明度
        $mpdf->showWatermarkText = true;

        // 输出PDF
        // $type='I'；在线预览模式
        // $type='D'；下载模式
        // $type='f'；生成后保存到服务器
        // $type='s'；返回字符串, 此模式下$filename会被忽视
        $pdf = $mpdf->Output("test.pdf", "F");
    ```
- demo2
    ```php
        $mpdf = new mPDF('zh-CN');
        $mpdf->SetDisplayMode('fullpage');
        $mpdf->useAdobeCJK = true;

        $mpdf->SetImportUse();
        // 导入需要修改的文件
        $pagecount = $mpdf->SetSourceFile("./xiazaiceshi.pdf");
        for ($pageNo = 1; $pageNo <= $pagecount; $pageNo++) {
            // 对每一页都进行操作
            $mpdf->AddPage();
            $tplId = $mpdf->ImportPage($pageNo);
            $mpdf->UseTemplate($tplId);

            $mpdf->SetWatermarkText('这个是测试的水印', 0.1);//参数一是文字, 参数二是透明度
            $mpdf->showWatermarkText = true;
            
            $mpdf->SetFont('Arial','B','12');
            $mpdf->WriteText(150, 10, date('Y-m-d H:i:s'));
        }

        $pdf = $mpdf->Output("econtract_view_2.pdf", "F");
    ```

