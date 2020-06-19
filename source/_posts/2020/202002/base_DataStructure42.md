---
title: DataStructure_基础 (42)
date: 2020-02-26
tags: DataStructure
toc: true
---

### 快速排序时间复杂度
    之前一直背的快排的时间复杂度为O(n×log(n), 现在看一下原因

<!-- more -->

#### 快速排序相关
> 通过一趟排序将待排记录分割成独立的两部分, 其中一部分记录的关键字均比另一部分记录的关键字小, 则可分别对这两部分记录继续进行排序, 以达到整个序列有序的目的
- 代码实现
    ```php
        function quickSort($arr)
        {
            if (!empty($arr) && is_array($arr)) {
                $temp = $arrp[0];
                $count = count($arr);
                $leftArr = $rightArr = array();

                for ($i=1;$i<$count;$i++) {
                    if ($arr[$i] > $temp) {
                        $rightArr[] = $arr[$i];
                    } else {
                        $leftArr[] = $arr[$i];
                    }
                }

                //再分别对左边和右边的数组进行相同的排序处理方式递归调用这个函数
                $rightArr= quick_sort($rightArr);
                $leftArr= quick_sort($leftArr);
                //合并
                return array_merge($leftArr, array($temp),$rightArr);
            } else {
                return array();
            }
        }
    ```

#### 快排最优情况
> 假设取到的第一个元素就是整个数组的中间元素, 每次都被划分的很均匀
由于我们的第一个关键字是50, 正好是待排序的序列的中间值, 因此递归树是平衡的, 此时性能也比较好
T(n) = 2T(n/2) + n // 需要对整个数组扫描一遍, 做n次比较.然后, 获得的枢轴将数组一分为二, 那么各自还需要T(n/2)的时间
T(n) = 2(2T(n/4) + n/2) + n = 4T(n/4) + 2n
T(n) = 4(2T(n/8) + n/4) + 2n = 8T(n/8) + 3n
....
T(1) = 0;
T(n) = nT(1) + logn * n = O(n*logn)

![快排最优情况](/img/20200226_1.png)



