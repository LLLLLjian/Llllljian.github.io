---
title: Interview_总结 (40)
date: 2019-09-29
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 算法题1
- Q
    * [1,1,2,2,3,4,4,5,5,5]找出不重复的元素
- A
    ```php
        function getResult($arr)
        {
            $count = count($arr);
            for ($i=0;$i<$count;$i++) {
                for ($j=0;$j<$count;$j++) {
                    if (($arr[$i] == $arr[$j]) && ($i != $j)) {
                        continue 2;
                    }
                }
                if ($j == $count) {
                    return $arr[$i];
                }
            }
        }

        function getResult1($arr)
        {
            $count = count($arr);
            $arr1 = array();
            for ($i=0;$i<$count;$i++) {
                if (array_key_exists($arr[$i], $arr1)) {
                    $arr1[$arr[$i]] += 1;
                } else {
                    $arr1[$arr[$i]] = 1;
                }
            }
            return array_search(1, $arr1);
        }
    ```

