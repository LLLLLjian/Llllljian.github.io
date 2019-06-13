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
            GRAPHQL = "https://leetcode-cn.com/graphql"
            TAG_FORMAT = "https://leetcode-cn.com/tag/{}"
            h = client.get(SUBMISSIONS_FORMAT, verify=False)
            payload = {
                'query':
                '''
                query questionData($titleSlug: String!) {
                    question(titleSlug: $titleSlug) {
                        questionId
                        content
                        translatedTitle
                        translatedContent
                        similarQuestions
                        topicTags {
                            name
                            slug
                            translatedName
                        }
                        hints
                    }
                }
                ''',
                'operationName':
                'questionData',
                'variables': {
                    'titleSlug': "null"
                }
            }
            HEADERS = {
                'Origin': "https://leetcode-cn.com",
                'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134'
            }
            
            html = json.loads(h.text)
            for stat_status_pairs in enumerate((html["stat_status_pairs"])):
                queInfos = stat_status_pairs[1]
                Pid = queInfos['stat']['frontend_question_id']
                Title = queInfos['stat']['question__title_slug']
                newpath = OUTPUT_DIR + '{:0=4}'.format(Pid) + "." + Title #存放的文件夹名
                if not os.path.exists(newpath):
                    os.makedirs(newpath)

                # 问题描述requests.post
                payload['variables']['titleSlug'] = Title
                response = requests.post(GRAPHQL, json=payload, headers=HEADERS)
                dictInfo = json.loads(response.text)
                queInfo = dictInfo['data']['question']

                id = queInfo['questionId']
                content_en = formContentEN(queInfo['content'])
                title_cn = queInfo['translatedTitle']
                content_cn = formContentCN(queInfo['translatedContent'])
                similar_questions_cn, similar_questions_en = formSimilarQuestions(queInfo['similarQuestions'])
                tags_cn, tags_en = formTags(queInfo['topicTags'])
                print (title_cn)
                break
                
                # 问题详情
                filename = '{:0=4}'.format(Pid) + "-" + "EN.md" 
                totalpath = os.path.join(newpath, filename) #把文件夹和文件组合成新的地址
                if os.path.exists(totalpath):
                    # 跳过本地问题详情
                    print (filename + "存在！跳过本题") 
                    continue

                with open(totalpath, "w") as f: #开始写到本地
                    queInfo = ""
                    for key, value in queInfos.items():
                        if type(value).__name__ == "dict":
                            for key1, value1 in value.items():
                                queInfo += str(key) + "." +str(key1) + ":" + str(value1) + "\n"
                        else:
                            queInfo += str(key) + ":" + str(value) + "\n"
                    f.write(queInfo)
    ```

