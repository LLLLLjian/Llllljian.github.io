---
title: Python_基础 (53)
date: 2020-11-17
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    ORM是操作完了 接下来是JWT了呀 还是得学呀

<!-- more -->

#### 前情提要
> 为什么我的token认证失败返回403 JWT又是个啥

#### JWT
> 在用户注册或者登陆完成之后，记录用户状态，或者为用户创建身份凭证（功能类似于session的作用）

#### 什么是JWT
> Json web token (JWT), 是为了在网络应用环境间传递声明而执行的一种基于JSON的开放标准（(RFC 7519).该token被设计为紧凑且安全的，特别适用于分布式站点的单点登录（SSO）场景。JWT的声明一般被用来在身份提供者和服务提供者间传递被认证的用户身份信息，以便于从资源服务器获取资源，也可以增加一些额外的其它业务逻辑所必须的声明信息，该token也可直接被用于认证，也可被加密

#### 传统的session认证
> 我们知道，http协议本身是一种无状态的协议，而这就意味着如果用户向我们的应用提供了用户名和密码来进行用户认证，那么下一次请求时，用户还要再一次进行用户认证才行，因为根据http协议，我们并不能知道是哪个用户发出的请求，所以为了让我们的应用能识别是哪个用户发出的请求，我们只能在服务器存储一份用户登录的信息，这份登录信息会在响应时传递给浏览器，告诉其保存为cookie,以便下次请求时发送给我们的应用，这样我们的应用就能识别请求来自哪个用户了,这就是传统的基于session认证。但是这种基于session的认证使应用本身很难得到扩展，随着不同客户端用户的增加，独立的服务器已无法承载更多的用户，而这时候基于session认证应用的问题就会暴露出来.

#### 基于session认证所显露的问题
- Session
    * 每个用户经过我们的应用认证之后，我们的应用都要在服务端做一次记录，以方便用户下次请求的鉴别，通常而言session都是保存在内存中，而随着认证用户的增多，服务端的开销会明显增大。
- 扩展性
    * 用户认证之后，服务端做认证记录，如果认证的记录被保存在内存中的话，这意味着用户下次请求还必须要请求在这台服务器上,这样才能拿到授权的资源，这样在分布式的应用上，相应的限制了负载均衡器的能力。这也意味着限制了应用的扩展能力。
- CSRF
    * 因为是基于cookie来进行用户识别的, cookie如果被截获，用户就会很容易受到跨站请求伪造的攻击。

#### 基于token的鉴权机制
> 基于token的鉴权机制类似于http协议也是无状态的，它不需要在服务端去保留用户的认证信息或者会话信息。这就意味着基于token认证机制的应用不需要去考虑用户在哪一台服务器登录了，这就为应用的扩展提供了便利。
- 流程上是这样的：
    1. 用户使用用户名密码来请求服务器
    2. 服务器进行验证用户的信息
    3. 服务器通过验证发送给用户一个token
    4. 客户端存储token，并在每次请求时附送上这个token值
    5. 服务端验证token值，并返回数据(这个token必须要在每次请求时传递给服务端，它应该保存在请求头里， 另外，服务端要支持CORS(跨来源资源共享)策略，一般我们在服务端这么做就可以了Access-Control-Allow-Origin: *。)
    ![token验证流程](/img/20201117_1.png)
- 如何应用
    ```bash
        # 一般是在请求头里加入Authorization，并加上Bearer标注：

        fetch('api/user/1', {
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
    ```
- 优点
    * 因为json的通用性，所以JWT是可以进行跨语言支持的，像JAVA,JavaScript,NodeJS,PHP等很多语言都可以使用。
    * 因为有了payload部分，所以JWT可以在自身存储一些其他业务逻辑所必要的非敏感信息。
    * 便于传输，jwt的构成非常简单，字节占用很小，所以它是非常便于传输的。
    * 它不需要在服务端保存会话信息, 所以它易于应用的扩展
- 安全相关
    * 不应该在jwt的payload部分存放敏感信息，因为该部分是客户端可解密的部分。
    * 保护好secret私钥，该私钥非常重要。
    * 如果可以，请使用https协议

#### 在Django REST framework JWT中的应用
- 安装
    ```bash
        pip install djangorestframework-jwt
    ```
- 配置
    ```python
        REST_FRAMEWORK = {
            'DEFAULT_AUTHENTICATION_CLASSES': (
                'rest_framework_jwt.authentication.JSONWebTokenAuthentication',
                'rest_framework.authentication.SessionAuthentication',
                'rest_framework.authentication.BasicAuthentication',
            ),
        }

        JWT_AUTH = {
            'JWT_EXPIRATION_DELTA': datetime.timedelta(days=1),
        }
    ```
- 路由注册-源码解析
    ```python
        # urls.py
        from rest_framework_jwt.views import obtain_jwt_token

        urlpatterns = [
            url(r'^authorizations/$', obtain_jwt_token),
        ]
    ```
    * obtain_jwt_token
        * ![obtain_jwt_token](/img/20201117_2.png)
    * ObtainJSONWebToken
        * 使用用户的用户名和密码接收POST的API视图。
        * 返回可用于经过身份验证的请求的JSON Web令牌
        * ![ObtainJSONWebToken](/img/20201117_3.png)
    * JSONWebTokenSerializer
        * 那肯定看的是post方法呀
        * if serializer.is_valid()这个是在序列化器的验证完成并返回True的情况下可以进行下面的操作
        * ![JSONWebTokenSerializer](/img/20201117_4.png)
        * 先是获取user,token值，然后将进行response_data = jwt_response_payload_handler(token, user, request)
        * ![JSONWebTokenSerializer](/img/20201117_5.png)
        * ![JSONWebTokenSerializer](/img/20201117_6.png)
        * jwt_response_payload_handler中就是返回的数据
- 自定义返回数据
    ```python
        # user/utils.py
        def jwt_response_payload_handler(token, user=None, request=None):
            return {
                'token': token,
                'user_id': user.id,
                'username': user.username
            }

        # settings.py
        JWT_AUTH = {
            """设置处理时使用的函数，就是上一步我们自己定义的那一个"""
            'JWT_RESPONSE_PAYLOAD_HANDLER': 'users.utils.jwt_response_payload_handler',
        }
    ```
- 手动生成token
    ```python
        from rest_framework_jwt.serializers import jwt_payload_handler,jwt_encode_handler
        def d():
            ...
            payload = jwt_payload_handler(user)
            token = jwt_encode_handler(payload)
            ...
    ```

#### 最后说说403 401的问题
> 我判断token验证不通过或者不存在的时候 抛出的异常是AuthenticationFailed, 默认code码为401, 但前端展示的是403
网上查了之后发现 django rest framework中AuthenticationFailed有可能返回401 也有可能返回403
于是我就对AuthenticationFailed进行了重写 自定义了异常
