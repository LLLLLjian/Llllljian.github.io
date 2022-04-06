---
title: Leetbook_基础 (3)
date: 2021-12-16
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 数组在内存中是如何存放的
- 对角线遍历
    * Q
        ```
            给你一个大小为 m x n 的矩阵 mat , 请以对角线遍历的顺序, 用一个数组返回这个矩阵中的所有元素
            输入：mat = [[1,2,3],[4,5,6],[7,8,9]]
            输出：[1,2,4,7,5,3,6,8,9]
            输入：mat = [[1,2],[3,4]]
            输出：[1,2,3,4]
        ```
    * T
        * 像贪吃蛇一样, 遍历只有四个动作, 向右、斜向左下、向下、斜向右上, 理清楚这四个步骤, 然后循环就可以了
    * A
        ```python
            class Solution:
                def findDiagonalOrder(self, mat: List[List[int]]) -> List[int]:
                    n = len(mat)
                    m = len(mat[0])
                    length = n * m
                    result = [0] * length
                    result[0] = mat[0][0]
                    index = 0
                    i = 0
                    j = 0
                    # d向下 r向右 j斜向左下 t斜向右上
                    # r j d t t d 
                    flag = ""
                    if m == 1:
                        flag = "d"
                    else:
                        flag = "r"
                    while (index < length -1):
                        if flag == "r":
                            index += 1
                            j += 1
                            result[index] = mat[i][j]
                            if i == 0:
                                flag = 'j'
                            else:
                                flag = 't'
                            continue
                        elif flag == "d":
                            index += 1
                            i += 1
                            result[index] = mat[i][j]
                            if ( j != m-1 ):
                                flag = 't'
                            elif ( j == m - 1 ):
                                flag = 'j'
                            continue
                        elif flag == "j":
                            while (j != 0) and (i != n - 1):
                                index += 1
                                i += 1
                                j -= 1
                                result[index] = mat[i][j]
                            if (i != n - 1):
                                flag = 'd'
                            elif (i == n - 1):
                                flag = 'r'
                            continue
                        elif flag == 't':
                            while (i != 0) and (j != m - 1):
                                index += 1
                                i -= 1
                                j += 1
                                result[index] = mat[i][j]
                            if (j == m - 1):
                                flag = 'd'
                            elif (j != m - 1):
                                flag = 'r'
                            continue
                    return result

                def findDiagonalOrder(self, mat: List[List[int]]) -> List[int]:
                    m=len(mat)
                    n=len(mat[0])
                    s=0
                    ans=[]
                    while s<m+n:
                        #第1,3,5趟
                        x1=s if s<m else m-1
                        y1=s-x1
                        while x1>=0 and y1<n:
                            ans.append(mat[x1][y1])
                            x1-=1
                            y1+=1

                        s+=1
                        if s>=m+n:
                            break
                        #第2,4,6趟
                        y2=s if s<n else n-1
                        x2=s-y2
                        while y2>=0 and x2<m:
                            ans.append(mat[x2][y2])
                            x2+=1
                            y2-=1
                        s+=1
                    return ans
        ```
