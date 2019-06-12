---
title: Python_基础 (35)
date: 2019-06-11 21:00:00
tags: Python
toc: true
---

### Python获取LeetCode提交记录
    Python3练习

<!-- more -->

#### 参考源
    https://github.com/JiayangWu/LeetCodeCN-Submissions-Crawler
    获取全部问题文件夹

#### 代码部分
    ```python
        def scraping(client):
            SUBMISSIONS_FORMAT = "https://leetcode-cn.com/api/problems/all/"
            h = client.get(SUBMISSIONS_FORMAT, verify=False)
            print ("当前请求地址为:", SUBMISSIONS_FORMAT)
            
            html = json.loads(h.text)
            for stat_status_pairs in enumerate((html["stat_status_pairs"])):
                Pid = stat_status_pairs[1]['stat']['frontend_question_id']
                Title = stat_status_pairs[1]['stat']['question__title_slug']
                newpath = OUTPUT_DIR + '{:0=4}'.format(Pid) + "." + Title #存放的文件夹名
                if not os.path.exists(newpath):
                    os.makedirs(newpath)
    ```

