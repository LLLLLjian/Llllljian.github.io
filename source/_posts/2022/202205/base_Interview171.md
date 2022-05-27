---
title: Interview_总结 (171)
date: 2022-05-15
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 列一下平时算法需要用到的
- code
    ```python
        # 生成长度为n的数组
        m, n = 5, 10
        dp = [0] * n
        # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        print(dp)
        dp = [0 for _ in range(n+1)]
        # [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        print(dp)
        visited = [[False] * n for _ in range(m)]
        """
        [
            [False, False, False, False, False, False, False, False, False, False],
            [False, False, False, False, False, False, False, False, False, False],
            [False, False, False, False, False, False, False, False, False, False],
            [False, False, False, False, False, False, False, False, False, False],
            [False, False, False, False, False, False, False, False, False, False]
        ]
        """
        print(visited)
        # [list, list]排序
        envelopes = [
            [1, 1],
            [4, 5],
            [4, 1],
            [3, 2],
            [3, 5]
        ]
        envelopes.sort(key=lambda x: (x[0], -x[1]))
        """
        [
            [1, 1],
            [3, 5],
            [3, 2],
            [4, 5],
            [4, 1]
        ]
        """
        print(envelopes)
    ```




