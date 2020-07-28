---
title: Interview_总结 (83)
date: 2020-03-26
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列

<!-- more -->

#### 问题1
> 实现栈排序
- 解题思路
    * 用栈A和栈B两个栈实现. 第一个元素先进栈A, 第二个元素跟栈A的顶部进行比较, 比栈A顶部大就入栈, 小的话就先把栈A顶部弹出入栈B, 再取栈A顶部进行比较, 直到发现比第二个元素小的, 第二个元素入栈A, 栈B元素依次弹出入栈A
- A
    ```php
        function sortStack1($arr)
        {
            $tempArr1 = $tempArr2 = array();
            $count = count($arr);

            for ($i=0;$i<$count;$i++) {
                $tempValue = $arr[$i];

                if (empty($tempArr1)) {
                    $tempArr1[] = $tempValue;
                } else {
                    $cur = current($tempArr1);
                    if ($cur <= $tempValue) {
                        array_unshift($tempArr1, $tempValue);
                    } else {
                        while ($cur > $tempValue) {
                            array_unshift($tempArr2, array_shift($tempArr1));
                            if (empty($tempArr1)) {
                                break;
                            } else {
                                $cur = current($tempArr1);
                            }
                        }
                        
                        array_unshift($tempArr1, $tempValue);

                        while (!empty($tempArr2)) {
                            array_unshift($tempArr1, array_shift($tempArr2));
                        }
                        
                    }
                }
            }

            return $tempArr1;
        }

        function sortStack2($arr)
        {
            $sortedStack = array();
            while (!empty($arr)) {
                $curElement = array_shift($arr);
                while (!empty($sortedStack) && $curElement > current($sortedStack)) {
                    array_unshift($arr, array_shift($sortedStack));
                }
                array_unshift($sortedStack, $curElement);
            }
            while (!empty($sortedStack)) {
                array_unshift($arr, array_shift($sortedStack));
            }
            return $arr;
        }

        $arr = array(5, 3, 2, 4, 1);
        echo "<pre>";
        var_dump(sortStack1($arr));
        var_dump(sortStack2($arr));
    ```


