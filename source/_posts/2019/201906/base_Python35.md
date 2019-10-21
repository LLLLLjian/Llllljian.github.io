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

#### 最终结果
    https://github.com/LLLLLjian/LeetCode

#### 代码部分
    ```python
        #/usr/bin/env python3

        import unicodedata
        import sys, os, time
        import requests, json
        from bs4 import BeautifulSoup
        import json
        import re
        #~~~~~~~~~~~~以下是无需修改的参数~~~~~~~~~~~~~~~~·
        requests.packages.urllib3.disable_warnings() #为了避免弹出一万个warning,which is caused by 非验证的get请求

        leetcode_url = 'https://leetcode-cn.com'
        sign_in_url = leetcode_url + '/accounts/login/'
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

        USERNAME = USERNAME
        PASSWORD = PASSWORD
        OUTPUT_DIR = OUTPUT_DIR
        TIME_CONTROL = 3600 * 24 * 1

        # 根目录下的 README 英文模板
        TEMPLATE_README_EN = '''
        | English | [简体中文](README.md) |
        <p align="center">
            <img src="https://img.shields.io/badge/User-{user_name}-blue.svg?" alt="">
            <img src="https://img.shields.io/badge/Solved-{num_solved}/{num_total}-blue.svg?" alt="">
            <img src="https://img.shields.io/badge/Easy-{ac_easy}-green.svg?" alt="">
            <img src="https://img.shields.io/badge/Medium-{ac_medium}-orange.svg?" alt="">
            <img src="https://img.shields.io/badge/Hard-{ac_hard}-red.svg?" alt="">
        </p>
        <h1 align="center">My LeetCode Solutions</h1>
        <p align="center">
            <br>
            <b>Last updated: {time}</b>
            <br>
        </p>

        | # | Title | Solutions | Acceptance | Difficulty | Tags |  
        |:--:|:-----|:---------:|:----:|:----:|:----:|  
        '''

        # 根目录下的 README 中文模板
        TEMPLATE_README_CN = '''
        | [English](README_EN.md) | 简体中文 |
        <p align="center">
            <img src="https://img.shields.io/badge/用户-{user_name}-blue.svg?" alt="">
            <img src="https://img.shields.io/badge/已解决-{num_solved}/{num_total}-blue.svg?" alt="">
            <img src="https://img.shields.io/badge/简单-{ac_easy}-green.svg?" alt="">
            <img src="https://img.shields.io/badge/中等-{ac_medium}-orange.svg?" alt="">
            <img src="https://img.shields.io/badge/困难-{ac_hard}-red.svg?" alt="">
        </p>
        <h1 align="center">LeetCode 的解答</h1>
        <p align="center">
            <br>
            <b>最近一次更新: {time}</b>
            <br>
        </p>

        | # | 题名 | 解答 | 通过率 | 难度 | 标签 |  
        |:--:|:-----|:---------:|:----:|:----:|:----:|  
        '''

        # 根目录下 README 中的题目概要信息
        TEMPLATE_README_APPEND = '|{frontend_id}|[{title}](problemList/{Pid}/{fileName})|{solutions}|{ac_rate}|{difficulty}|{tags}|  \n'

        # 题目描述 README 英文模板
        TEMPLATE_DESC_EN = '''
        | English | [简体中文](README.md) | [问题相关](QUESTION.md) |
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
        | [English](README_EN.md) | 简体中文 | [问题相关](QUESTION.md) |
        # {title_cn}
        ## 题目描述
        {content_cn}
        ## 相关话题
        {tags_cn}
        ## 相似题目
        {similar_questions_cn}
        '''

        # 题目代码模板
        TEMPLATE_CODE = '''
        {style} @Title: {title_cn} ({title_en})
        {style} @Author: {author}
        {style} @Date: {timestamp}
        {style} @Runtime: {runtime}
        {style} @Memory: {memory}
        {code}
        '''

        DIFFICULTY_CN = {0:'', 1:'简单', 2:'中等', 3:'困难'}
        DIFFICULTY_EN = {0:'', 1:'easy', 2:'medium', 3:'hard'}

        solutions_en = {}
        solutions_cn = {}
        QueList = {}
        #~~~~~~~~~~~~以上是无需修改的参数~~~~~~~~~~~~~~~~·

        #~~~~~~~~~~~~以下是可以修改的参数~~~~~~~~~~~~~~~~·
        START_PAGE = 0  # 从哪一页submission开始爬起,0是最新的一页
        sleep_time = 5  # in second,登录失败时的休眠时间
        #~~~~~~~~~~~~以上是可以修改的参数~~~~~~~~~~~~~~~~·

        def login(email, password): # 本函数copy自https://gist.github.com/fyears/487fc702ba814f0da367a17a2379e8ba,感谢@fyears
            client = requests.session()
            client.encoding = "utf-8"

            while True:
                try:
                    client.get(sign_in_url, verify=False)
                    csrftoken = client.cookies['csrftoken']
                    login_data = {'login': email, 
                        'password': password,
                        'csrfmiddlewaretoken': csrftoken
                    }
                    result = client.post(sign_in_url, data=login_data, headers=dict(Referer=sign_in_url))
                    
                    if result.ok:
                        print ("Login successfully!")
                        break
                except:
                    print ("Login failed! Wait till next round!")
                    time.sleep(sleep_time)

            return client

        def scraping(client):
            # 获取问题列表
            h = client.get(submissions_url, verify=False)
            html = json.loads(h.text)

            for stat_status_pairs in enumerate((html["stat_status_pairs"])):
                queInfos = stat_status_pairs[1]
                Pid = queInfos['stat']['frontend_question_id']
                Pid = '{:0=4}'.format(Pid)
                Title = queInfos['stat']['question__title_slug']

                # 题目
                newpath = OUTPUT_DIR + "problemList\\" + Pid #存放的文件夹名
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
                data['difficulty_cn'] = DIFFICULTY_CN[queInfos['difficulty']['level']]
                data['difficulty_en'] = DIFFICULTY_EN[queInfos['difficulty']['level']]

                # README.md S
                solutions_cn[queInfo['questionId']] = {}
                solutions_cn[queInfo['questionId']]['title'] = data['title_cn']
                solutions_cn[queInfo['questionId']]['Pid'] = Pid
                solutions_cn[queInfo['questionId']]['fileName'] = "README.md"
                solutions_cn[queInfo['questionId']]['solutions'] = 'solutions'
                solutions_cn[queInfo['questionId']]['ac_rate'] = 'ac_rate'
                solutions_cn[queInfo['questionId']]['difficulty'] = data['difficulty_cn']
                solutions_cn[queInfo['questionId']]['tags'] = "tags_cn"

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
                solutions_en[queInfo['questionId']] = {}
                solutions_en[queInfo['questionId']]['title'] = data['title_en']
                solutions_en[queInfo['questionId']]['Pid'] = Pid
                solutions_en[queInfo['questionId']]['fileName'] = "README_EN.md"
                solutions_en[queInfo['questionId']]['solutions'] = 'solutions'
                solutions_en[queInfo['questionId']]['ac_rate'] = 'ac_rate'
                solutions_en[queInfo['questionId']]['difficulty'] = data['difficulty_en']
                solutions_en[queInfo['questionId']]['tags'] = "tags_en"
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
                                    queInfo += str(key) + "." +str(key1) + ":" + str(value1) + "  \n"
                            else:
                                queInfo += str(key) + ":" + str(value) + "  \n"
                        f.write(queInfo)
                        print (Pid + Title + "[QUESTION.md]已记录完成！")
                # QUESTION.md E
            
            # 当前登录用户信息
            info = html
            cur_time = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

            # README.md S
            readme_cn_path = os.path.join(OUTPUT_DIR, 'README.md')
            with open(readme_cn_path, 'w', encoding='utf-8') as f:
                f.write(
                    TEMPLATE_README_CN.format(
                        user_name = info['user_name'],
                        num_solved = info['num_solved'],
                        num_total = info['num_total'],
                        ac_easy = info['ac_easy'],
                        ac_medium = info['ac_medium'],
                        ac_hard = info['ac_hard'],
                        time = cur_time))
                for key,values in solutions_cn.items():
                    f.write(
                        TEMPLATE_README_APPEND.format(
                            frontend_id = key,
                            title = values['title'],
                            Pid = values['Pid'],
                            fileName = values['fileName'],
                            solutions = values['solutions'],
                            ac_rate = values['ac_rate'],
                            difficulty = values['difficulty'],
                            tags = values['tags']))
            # README.md E

            # README_EN.md S
            readme_en_path = os.path.join(OUTPUT_DIR, 'README_EN.md')
            with open(readme_en_path, 'w', encoding='utf-8') as f1:
                f1.write(
                    TEMPLATE_README_EN.format(
                        user_name = info['user_name'],
                        num_solved = info['num_solved'],
                        num_total = info['num_total'],
                        ac_easy = info['ac_easy'],
                        ac_medium = info['ac_medium'],
                        ac_hard = info['ac_hard'],
                        time = cur_time))
                for key,values in solutions_en.items():
                    f1.write(
                        TEMPLATE_README_APPEND.format(
                            frontend_id = key,
                            title = values['title'],
                            Pid = values['Pid'],
                            fileName = values['fileName'],
                            solutions = values['solutions'],
                            ac_rate = values['ac_rate'],
                            difficulty = values['difficulty'],
                            tags = values['tags']))
            # README_EN.md E

        def formQueList(client): 
            # 获取问题列表
            global QueList
            h = client.get(submissions_url, verify=False)
            html = json.loads(h.text)
            queList_path = os.path.join(OUTPUT_DIR, 'QUELIST.md')
            if os.path.exists(queList_path):
                # 打开文本文件
                file = open(queList_path,'r')

                # 遍历文本文件的每一行,strip可以移除字符串头尾指定的字符(默认为空格或换行符)或字符序列
                for line in file.readlines():
                    line = line.strip()
                    k = line.split(' ')[0]
                    v = line.split(' ')[1]
                    QueList[k] = v

                # 依旧是关闭文件
                file.close()
            else :
                for stat_status_pairs in enumerate((html["stat_status_pairs"])):
                    queInfos = stat_status_pairs[1]
                    Pid = queInfos['stat']['frontend_question_id']
                    Pid = '{:0=4}'.format(Pid)
                    Title = queInfos['stat']['question__title_slug']
                    QueList[Title] = Pid\

                # 先创建并打开一个文本文件
                file = open(queList_path, 'w') 

                # 遍历字典的元素,将每项元素的key和value分拆组成字符串,注意添加分隔符和换行符
                for k,v in QueList.items():
                    file.write(str(k)+' '+str(v)+'\n')

                # 注意关闭文件
                file.close()

        def formSimilarQuestions(similar_questions):
            global QueList

            question_list = re.findall(r'{.*?}', similar_questions)
            similar_questions_cn, similar_questions_en = [], []
            if question_list:
                for q in question_list:
                    data = json.loads(q)
                    similar_questions_cn.append('- [{}](../{}/README.md)'.format(data['translatedTitle'], QueList.get(data['titleSlug'])))
                    similar_questions_en.append('- [{}](../{}/README_EN.md)'.format(data['title'], QueList.get(data['titleSlug'])))
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

        def main():
            email = USERNAME
            password = PASSWORD

            print('login')
            client = login(email, password)

            print('start scrapping')
            formQueList(client)
            scraping(client)
            print('end scrapping')

        if __name__ == '__main__':
            main()
    ```

