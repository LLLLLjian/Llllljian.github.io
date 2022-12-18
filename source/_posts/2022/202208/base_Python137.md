---
title: Python_基础 (137)
date: 2022-08-04
tags: Python
toc: true
---

### python-dfs
    python-dfs-demo

<!-- more -->

#### python-dfs
- code
    ```python
        xmlNode = {
            "1a": {
                "name": "1a",
                "supergroups": "2a,3a,4a,5a",
                "groups": "1,2,3,4,5"
            },
            "2a": {
                "name": "2a",
                "supergroups": "4a",
                "groups": "1,2,3,7,8"
            },
            "3a": {
                "name": "3a",
                "supergroups": "2a,5a",
                "groups": "10,11,12,13"
            },
            "4a": {
                "name": "4a",
                "supergroups": "1a,10a",
                "groups": "10,11,12,13"
            },
            "5a": {
                "name": "5a",
                "supergroups": "",
                "groups": "20,22"
            }
        }

        def getAllGroups(superGroup):
            if superGroup not in xmlNode:
                return ""
            resList = []
            # 定义一个栈
            stack = []
            # 建立一个集合, 集合就是用来判断该元素是不是已经出现过
            seen = set()
            # 将任一个节点放入
            stack.append(superGroup)
            # 当队列里还有东西时
            while (len(stack)>0):
                # 取出栈顶元素
                ver =  stack.pop()
                if ver not in xmlNode:
                    continue
                # 如果该邻接点还没出现过
                if ver not in seen:
                    # 存入集合
                    seen.add(ver)
                    # 将当前超级组的groups加入结果中
                    resList.extend(xmlNode[ver]["groups"].split(","))
                    if xmlNode[ver]["supergroups"]:
                        stack.extend(xmlNode[ver]["supergroups"].split(","))
            return ",".join(resList)

        print(getAllGroups("1a"))
    ```



