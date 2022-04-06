---
title: 剑指Offer_基础 (03)
date: 2022-02-09
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 用两个栈实现队列
- 题目描述
    * 用两个栈来实现一个队列, 完成队列的 Push 和 Pop 操作. 队列中的 元素为 int 类型.
- 思路
    * 一个栈压入元素, 而另一个栈作为缓冲, 将栈 1 的元素出栈后压入栈 2 中.也可以将栈 1 中的最后一个元素直接出栈, 而不用压入栈 2 中再出栈.
- 代码实现
    ```java
        // 入栈, 时间复杂度:O(1), 空间复杂度:O(n)
        public void push(int node) {
            stack1.push(node);
        }
        // 出栈, 时间(摊还)复杂度:O(1), 空间复杂度:O(1) 
        public int pop() throws Exception {
            if (stack1.isEmpty() && stack2.isEmpty()) {
                throw new Exception("栈为空!");
            }
            if (stack2.isEmpty()) { 
                while(!stack1.isEmpty()) {
                    stack2.push(stack1.pop());
                }
            }
            return stack2.pop();
        }
    ```

#### 求旋转数组的最小数字
- 题目描述
    * 把一个数组最开始的若干个元素搬到数组的末尾, 我们称之为数组的 旋转. 输入一个非递减排序的数组的一个旋转, 输出旋转数组的最小元素. 例如 数组{3,4,5,1,2}为{1,2,3,4,5}的一个旋转, 该数组的最小值为 1. NOTE:给出的所 有元素都大于 0, 若数组大小为 0, 请返回-1.假设数组中不存在重复元素.
- 思路
    * 利用二分法, 找到数组的中间元素 mid.如果中间元素 > 数组第一个元素,  在 mid 右边搜索变化点.如果中间元素 < 数组第一个元素, 我们需要在 mid 左边 搜索变化点.当找到变化点时停止搜索, 满足 nums[mid] > nums[mid + 1] (mid+1 是最小值)或 nums[mid - 1] > nums[mid]( mid 是最小值)即可.
- 代码实现
    * 二分查找(最左下标), 时间复杂度:O(log n), 空间复杂度:O(1)
    ```python
        class Solution:
            def minArray(self, numbers: List[int]) -> int:
                length = len(numbers)
                if (not numbers) or (length == 0):
                    return -1
                if (len(numbers) == 1) or (numbers[length - 1] > numbers[0]):
                    return numbers[0]
                left = 0
                right = length - 1
                while (left < right):
                    mid = (left + right) // 2
                    if (numbers[mid] > numbers[right]):
                        left = mid + 1
                    elif (numbers[mid] < numbers[right]):
                        right = mid
                    else:
                        # 旋转点不一定还在区间, 但是旋转点的值一定在
                        right = right - 1
                return numbers[left]
    ```




