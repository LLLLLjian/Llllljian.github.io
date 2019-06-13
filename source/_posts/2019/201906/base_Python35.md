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
        leetcode_url = 'https://leetcode-cn.com'
        sign_in_url = leetcode_url + '/accounts/login/'
        submissions_url = leetcode_url + 'submissions/'
        tag_url = leetcode_url + "/tag/{}"
        submissions_url = leetcode_url + "/api/problems/all/"
        graphql_url = leetcode_url + "/graphql"
        problem_url = leetcode_url + "/problems/{}/"
        atricle_url = leetcode_url + "/articles/{}/"
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
            'Origin': leetcode_url,
            'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/17.17134'
        }
        # 题目描述 README 英文模板
        TEMPLATE_DESC_EN = '''
        | English | [简体中文](README.md) |
        # {title_en}
        ## Description
        {content_en}
        ## Related Topics
        {tags_en}
        ## Similar Questions
        {similar_questions_en}
        '''

        # 题目描述 README 中文模板
        TEMPLATE_DESC_CN = '''
        | [English](README_EN.md) | 简体中文 |
        # {title_cn}
        ## 题目描述
        {content_cn}
        ## 相关话题
        {tags_cn}
        ## 相似题目
        {similar_questions_cn}
        '''

        def scraping(client):
            # 获取问题列表
            h = client.get(submissions_url, verify=False)
            html = json.loads(h.text)
            for stat_status_pairs in enumerate((html["stat_status_pairs"])):
                queInfos = stat_status_pairs[1]

                Pid = queInfos['stat']['frontend_question_id']
                Pid = '{:0=4}'.format(Pid)
                Title = queInfos['stat']['question__title_slug']
                newpath = OUTPUT_DIR + Pid + "." + Title #存放的文件夹名
                if not os.path.exists(newpath):
                    os.makedirs(newpath)

                # 问题描述
                payload['variables']['titleSlug'] = Title
                response = requests.post(graphql_url, json=payload, headers=HEADERS)
                dictInfo = json.loads(response.text)
                queInfo = dictInfo['data']['question']

                data = {}
                data['id'] = queInfo['questionId']
                data['title_cn'] = queInfo['translatedTitle']
                data['title_en'] = queInfos['stat']['question__title']
                data['content_cn'] = formContentCN(queInfo['translatedContent'])
                data['content_en'] = formContentEN(queInfo['content'])
                data['similar_questions_cn'], data['similar_questions_en'] = formSimilarQuestions(queInfo['similarQuestions'])
                data['tags_cn'], data['tags_en'] = formTags(queInfo['topicTags'])

                # README.md S
                readme_cn_path = os.path.join(newpath, 'README.md')
                if os.path.exists(readme_cn_path):
                    print (Pid + Title + "[README.md]存在！跳过")
                else :
                    title_cn = '[{}. {}]({})'.format(Pid, data['title_cn'], problem_url.format(Title))
                    with open(readme_cn_path, 'w', encoding='utf-8') as f:
                        f.write(TEMPLATE_DESC_CN.format(title_cn=title_cn, content_cn=data['content_cn'], tags_cn=data['tags_cn'], similar_questions_cn=data['similar_questions_cn']))
                    print (Pid + Title + "[README.md]已记录完成！")
                # README.md E
                
                # README_EN.md S
                readme_en_path = os.path.join(newpath, 'README_EN.md')
                if os.path.exists(readme_en_path):
                    print (Pid + Title + "[README_EN.md]存在！跳过")
                else :
                    title_en = '[{}. {}]({})'.format(Pid, data['title_en'], problem_url.format(Title))
                    with open(readme_en_path, 'w', encoding='utf-8') as f:
                        f.write(TEMPLATE_DESC_EN.format(title_en=title_en, content_en=data['content_en'], tags_en=data['tags_en'], similar_questions_en=data['similar_questions_en']))
                    print (Pid + Title + "[README_EN.md]已记录完成！")
                # README_EN.md E
                
                # QUESTION.md S
                totalpath = os.path.join(newpath, "QUESTION.md") #把文件夹和文件组合成新的地址
                if os.path.exists(totalpath):
                    print (Pid + Title + "[QUESTION.md]存在！跳过")
                else :
                    with open(totalpath, "w") as f: #开始写到本地
                        queInfo = ""
                        for key, value in queInfos.items():
                            if type(value).__name__ == "dict":
                                for key1, value1 in value.items():
                                    queInfo += str(key) + "." +str(key1) + ":" + str(value1) + "\n"
                            else:
                                queInfo += str(key) + ":" + str(value) + "\n"
                        f.write(queInfo)
                        print (Pid + Title + "[QUESTION.md]已记录完成！")
                # QUESTION.md E

        def formSimilarQuestions(similar_questions):
            question_list = re.findall(r'{.*?}', similar_questions)
            similar_questions_cn, similar_questions_en = [], []
            if question_list:
                for q in question_list:
                    data = json.loads(q)
                    similar_questions_cn.append('- [{}](../{}/README.md)'.format(data['translatedTitle'], data['titleSlug']))
                    similar_questions_en.append('- [{}](../{}/README_EN.md)'.format(data['title'], data['titleSlug']))
            return '\n'.join(similar_questions_cn), '\n'.join(similar_questions_en)

        def formTags(tags):
            tags_cn, tags_en = [], []
            for tag in tags:
                tags_cn.append(f'- [{tag["translatedName"]}]({tag_url.format(tag["slug"])})')
                tags_en.append(f'- [{tag["name"]}]({tag_url.format(tag["slug"])})')
            return '\n'.join(tags_cn), '\n'.join(tags_en)

        def formContentCN(content):
            if content is None:
                return None
            return content.replace('↵↵', '').replace('↵', '\n')

        def formContentEN(content):
            if content is None:
                return None
            return content.replace('↵', '').replace('\r\n', '\n')
    ```

