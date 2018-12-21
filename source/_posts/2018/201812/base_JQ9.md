---
title: jQuery_基础 (9)
date: 2018-12-05
tags: JQ
toc: true
---

## jQuery_功能
    根据阿拉伯数字获取大写金额

<!-- more -->

### 根据阿拉伯数字获取大写金额
- eg
    ```javascript
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8"> 
        <title>获取金额的大写</title> 
        <script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js">
        </script>
        <script>
            $(document).ready(function(){
                $("#moneyA, #moneyB, #moneyC, #checkbox_2_1").bind("input propertychange", function(){
                    if(isNaN($(this).val()) || !(/^[1-9]+[0-9]*[\.]*[0-9]{0,2}$/.test($(this).val()))){
                        alert("金额必须为数字且最多两位小数");
                    }

                    check_money();
                    return;
                });

                $("#checkbox_1, #checkbox_2").bind("click", function(){
                    check_money();
                });
            });

            function check_money() {
                var num = 0;
                num += Number($("#moneyA").val());
                num += Number($("#moneyB").val());
                num += Number($("#moneyC").val());

                if ($("#checkbox_1").is(':checked')) {
                    num += 100;
                }

                if ($("#checkbox_2").is(':checked')) {
                    num += Number($("#checkbox_2_1").val());
                }

                if (num == 0) {
                    $("#all_money").text("");
                    $('#all_money_big_name').val("");
                } else {
                    $("#all_money").text(num);
                    $('#all_money_big_name').val(num);

                    var Num = $('#all_money_big_name').val();

                    // 验证输入的字符是否为数字
                    if (isNaN(Num)) { 
                        alert("请检查填写金额是否正确");
                        return;
                    }
                    
                    part = String(Num).split(".");
                    newchar = "";
                    //小数点前进行转化
                    for (i = part[0].length - 1; i >= 0; i--) {
                        // 若数量超过拾亿单位,提示
                        if (part[0].length > 10) { 
                            alert("位数过大,无法计算"); 
                            return ""; 
                        }

                        tmpnewchar = ""
                        perchar = part[0].charAt(i);
                        switch (perchar) {
                            case "0": 
                                tmpnewchar = "零" + tmpnewchar; 
                                break;
                            case "1": 
                                tmpnewchar = "壹" + tmpnewchar; 
                                break;
                            case "2": 
                                tmpnewchar = "贰" + tmpnewchar; 
                                break;
                            case "3": 
                                tmpnewchar = "叁" + tmpnewchar; 
                                break;
                            case "4": 
                                tmpnewchar = "肆" + tmpnewchar;
                                break;
                            case "5": 
                                tmpnewchar = "伍" + tmpnewchar; 
                                break;
                            case "6": 
                                tmpnewchar = "陆" + tmpnewchar; 
                                break;
                            case "7": 
                                tmpnewchar = "柒" + tmpnewchar; 
                                break;
                            case "8": 
                                tmpnewchar = "捌" + tmpnewchar; 
                                break;
                            case "9": 
                                tmpnewchar = "玖" + tmpnewchar; 
                                break;
                        }

                        switch (part[0].length - i - 1) {
                            case 0: 
                                tmpnewchar = tmpnewchar + "元"; 
                                break;
                            case 1: 
                                if (perchar != 0) {
                                    tmpnewchar = tmpnewchar + "拾"; 
                                }
                                break;
                            case 2: 
                                if (perchar != 0) {
                                    tmpnewchar = tmpnewchar + "佰";
                                }  
                                break;
                            case 3: 
                                if (perchar != 0) tmpnewchar = tmpnewchar + "仟"; 
                                break;
                            case 4: 
                                tmpnewchar = tmpnewchar + "万"; 
                                break;
                            case 5: 
                                if (perchar != 0) {
                                    tmpnewchar = tmpnewchar + "拾"; 
                                }
                                break;
                            case 6: 
                                if (perchar != 0) {
                                    tmpnewchar = tmpnewchar + "佰";
                                }
                                break;
                            case 7: 
                                if (perchar != 0) {
                                    tmpnewchar = tmpnewchar + "仟";
                                } 
                                break;
                            case 8: 
                                tmpnewchar = tmpnewchar + "亿"; 
                                break;
                            case 9: 
                                tmpnewchar = tmpnewchar + "拾"; 
                                break;
                        }
                        newchar = tmpnewchar + newchar;
                    }

                    // 小数点之后进行转化
                    if (Num.indexOf(".") != -1) {
                        if (part[1].length > 2) {
                            alert("小数点之后只能保留两位,系统将自动截段");
                            part[1] = part[1].substr(0, 2)
                        }
                        
                        for (i = 0; i < part[1].length; i++) {
                            tmpnewchar = ""
                            perchar = part[1].charAt(i)
                            switch (perchar) {
                                case "0": 
                                    tmpnewchar = "零" + tmpnewchar; 
                                    break;
                                case "1": 
                                    tmpnewchar = "壹" + tmpnewchar; 
                                    break;
                                case "2": 
                                    tmpnewchar = "贰" + tmpnewchar; 
                                    break;
                                case "3": 
                                    tmpnewchar = "叁" + tmpnewchar; 
                                    break;
                                case "4": 
                                    tmpnewchar = "肆" + tmpnewchar; 
                                    break;
                                case "5": 
                                    tmpnewchar = "伍" + tmpnewchar; 
                                    break;
                                case "6": 
                                    tmpnewchar = "陆" + tmpnewchar; 
                                    break;
                                case "7": 
                                    tmpnewchar = "柒" + tmpnewchar; 
                                    break;
                                case "8": 
                                    tmpnewchar = "捌" + tmpnewchar; 
                                    break;
                                case "9": 
                                    tmpnewchar = "玖" + tmpnewchar; 
                                    break;
                            }
                            if (i == 0) {
                                tmpnewchar = tmpnewchar + "角";
                            }
                            
                            if (i == 1) {
                                tmpnewchar = tmpnewchar + "分";
                            }
                            
                            newchar = newchar + tmpnewchar;
                        }
                    }

                    // 替换所有无用汉字
                    while (newchar.search("零零") != -1) {
                        newchar = newchar.replace("零零", "零");
                        newchar = newchar.replace("零亿", "亿");
                        newchar = newchar.replace("亿万", "亿");
                        newchar = newchar.replace("零万", "万");
                        newchar = newchar.replace("零元", "元");
                        newchar = newchar.replace("零角", "");
                        newchar = newchar.replace("零分", "");
                    }
                    

                    if (newchar.charAt(newchar.length - 1) == "元" || newchar.charAt(newchar.length - 1) == "角"){
                        newchar = newchar + "整"            
                    }
                    $('#all_money_big_name').val(newchar);
                }
            }
        </script>
        </head>
        <body>
            <p>
                moneyA:<input type="text" id="moneyA" />
            </p>
            <p>
                moneyB:<input type="text" id="moneyB" />
            </p>
            <p>
                moneyC:<input type="text" id="moneyC" />
            </p>
            <p>
                选择1:<input type="checkbox" 
                            id="checkbox_1" 
                            name='checkbox[]' 
                            value="1" />价值100元
            </p>
            <p>
                选择2:<input type="checkbox" 
                            id="checkbox_2" 
                            name='checkbox[]' 
                            value="2" />
                <input type="text" id="checkbox_2_1" />
            </p>
            <p>阿拉伯数字:<span id="all_money"></span></p>
            <p>大写:<input type="text" id="all_money_big_name" /></p>
        </body>
        </html>
    ```
