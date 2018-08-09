---
title: PHP_基础 (9)
date: 2018-08-09
tags: PHP 
toc: true
---

### 函数执行时间及消耗内存
    检查Function运行时长及消耗详情

<!-- more -->

#### 代码示例
    ```php
        class Fuce 
        {
            public $print = 0;

            public function funcStartRecord($funcName) 
            {
                $ram = memory_get_usage();
                list($usec, $sec) = explode(" ", microtime());
                $time = date("Y-m-d H:i:s");

                if ($this->print == 1) {
                    printf("------------Function:[%s]------------<br />", $funcName);
                    printf("[%s]开始运行<br />", $time);
                }

                $timeuse = (float)$usec + (float)$sec;
                return $timeuse.",".$ram;
            }

            public function funcEndRecord()
            {
                $ram = memory_get_usage();
                list($usec, $sec) = explode(" ", microtime());
                $time = date("Y-m-d H:i:s");

                if ($this->print == 1) {
                    printf("[%s]运行结束<br />", $time);
                }

                $timeuse = (float)$usec + (float)$sec;
                return $timeuse.",".$ram;
            }

            /*
             * $typeArr['showTime']     是否展示运行耗时
             * $typeArr['showRam']      是否展示消耗内存
             * $funcParam['name']       方法名
             * $funcParam['args']       参数值
             */
            public function run($typeArr, $funcParam)
            {
                if(!is_array($typeArr) || !is_array($funcParam)) {
                    return "参数不符合要求";
                }

                $showTime = !isset($typeArr['showTime']) ? 0 : $typeArr['showTime'];
                $showRam = !isset($typeArr['showRam']) ? 0 : $typeArr['showRam'];
                $showRet = !isset($typeArr['showRet']) ? 0 : $typeArr['showRet'];

                if (empty($funcParam['name'])) {
                    return "没有传方法名";
                } else {
                    $funcName = $funcParam['name'];
                }

                list($timeS, $ramS) = explode(',', $this->funcStartRecord($funcName));

                if (empty($funcParam['args'])) {
                    call_user_func($funcName);
                } else {
                    $funcArgs = $funcParam['args'];
                    call_user_func_array($funcName, [$funcArgs]);
                }

                list($timeE, $ramE) = explode(',', $this->funcEndRecord($funcName));

                $retArr = array();

                if ($showTime) {
                    $timeDiff = $timeE - $timeS;
                    $retArr['useTime'] = round($timeDiff, 6);

                    if ($this->print == 1) {
                        printf("运行耗时:[%.03f]秒<br />", $timeDiff);
                    }
                }

                if ($showRam) {
                    $ramDiff = $this->formatRam($ramE - $ramS);
                    $retArr['useRam'] = $ramDiff;

                    if ($this->print == 1) {
                        printf("消耗内存:%s<br />", $ramDiff);
                    }
                }
                                            
                return $retArr;
            }

            /*
             * $param   要判断类型的参数
             * $descType    要判断的参数类型
             */
            public function checkParamType($param, $descType) 
            {
                $func = 'is_'.$descType;
                return $func($param);
            }

            public function formatRam($ram)
            {
                if ($ram >= 1024) {
                    $ram = round($ram / 1024, 2);
                    if ($ram >= 1024) {
                        $ram = round($ram / 1024, 2);
                        return "{$ram}MB";
                    }
                    return "{$ram}KB";
                }
                return "{$ram}B";
            }
        }
                                                    
        function hideAccount($account)
        {
            $account_hide = '';
            if (empty($account)) {
                return $account_hide;
            }

            $len = mb_strlen($account, 'utf-8');
            if ($len <= 2) {
                $account_hide = str_repeat("*", $len);
            } elseif($len <= 5) {
                $account_hide = mb_substr($account,0,1,'utf-8').str_repeat("*", $len-2).mb_substr($account,-1,1,'utf-8');
            } elseif($len < 9) {
                $account_hide =  mb_substr($account,0,2,'utf-8').str_repeat("*", $len-4).mb_substr($account,-2,2,'utf-8');
            } elseif($len >= 9) {
                $account_hide = mb_substr($account,0,3,'utf-8').str_repeat("*", $len-6).mb_substr($account,-3,3,'utf-8');
            }
            return $account_hide;
        }
                    
        $typeArr['showTime'] = 1;
        $typeArr['showRam'] = 1;     
        $funcParam['name'] = 'hideAccount';
        $funcParam['args'] = 'llllljian';                         

        $a = new Fuce();
        $a->print = 1;
        var_dump($a->run($typeArr, $funcParam)); 
    ```
