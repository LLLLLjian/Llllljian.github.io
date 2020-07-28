---
title: Interview_总结 (91)
date: 2020-04-15
tags: Interview
toc: true
---

### 算法题
    合并有序数组

<!-- more -->

#### 合并有序数组
> 把两个有序数组合并为一个
- 解题思路
    * 双指针, 同时从0出发, 如果$a[a] > $b[b], b指针加1, 一直到循环完一个数组
- A
    ```php
        <?php
            function merger($arr1, $arr2)
            {
                $key1 = $key2 = 0;
                $count1 = count($arr1);
                $count2 = count($arr2);
                $res = array();
                
                while (!empty($arr1) && !empty($arr2)) {
                    $cur1 = current($arr1);
                    $cur2 = current($arr2);
                    
                    if ($cur1 > $cur2) {
                        $res[] = array_shift($arr2);
                    }
                    if ($cur1 < $cur2) {
                        $res[] = array_shift($arr1);
                    }
                    if ($cur1 == $cur2) {
                        $res[] = array_shift($arr1);
                        $res[] = array_shift($arr2);
                    }
                }
                
                if (!empty($arr1)) {
                    $res = array_merge($res, $arr1);
                }
                if (!empty($arr2)) {
                    $res = array_merge($res, $arr2);
                }
                
                return $res;
            }

            $arr1 = array(1, 2, 3, 8);
            $arr2 = array(2, 4, 6);
            echo "<pre>";
            var_dump(merger($arr1, $arr2));
        ?>
    ```


