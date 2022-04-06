---
title: Python_基础 (54)
date: 2020-11-18
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Django之form组件is_valid校验机制

<!-- more -->

#### 前情提要
> 登陆的时候直接用form.is_valid()就可以实现输入字段校验了？ 那它是个啥

#### 登陆实例
    ```python
        # 下面分析form组件中is_valid校验的流程
        # 在分析过程中重点关注_erroes和clean_data这两个字典
        def login(request):
            if request.method == "POST":
                form_obj = LoginForm(request.POST)
                if form_obj.is_valid():
                    #如果检验全部通过
                    print(form_obj.clean_data) #这里全部都没问题
                    return HttpResponse("你好,欢迎回来！")
                else:
                    #print(form_obj.clean_data)
                    #print(form_obj.errors)
                    return render(request, "login.html", {"form_obj": form_obj,)

            form_obj = LoginForm()
            return render(request, "login.html", {"form_obj": form_obj})
    ```

#### 钩子
    ```python
        # 钩子代码实例
        def clean_user(self):
            val1 = self.cleaned_data.get("user")
            #从正确的字段字典中取值
            #如果这个字符串全部都是由数组组成
            if not val1.isdigit():
                return val1
            else:
                # 注意这个报错信息已经确定了
                raise ValidationError("用户名不能全部是数字组成")
                #在校验的循环中except ValidationError as e:,捕捉的就是这个异常
                #所以能将错误信息添加到_errors中
    ```

#### 源码分析
    ```python
        #代码分析部分
        def is_valid(self):
            """
            Returns True if the form has no errors. Otherwise, False. If errors are
            being ignored, returns False.
            如果表单没有错误,则返回true.否则为假.如果错误是被忽略,返回false.
            """
            return self.is_bound and not self.errors
            #is_bound默认有值
            #只要self.errors中有一个值,not True = false,返回的就是false

        def errors(self):
            """
            Returns an ErrorDict for the data provided for the form
            返回一个ErrorDict在form表单存在的前提下
            """
            if self._errors is None:
                self.full_clean()
            return self._errors

        def full_clean(self):
            """
            Cleans all of self.data and populates self._errors and self.cleaned_data.
            清除所有的self.data和本地的self._errors和selif.cleaned_data
            """
            self._errors = ErrorDict()
            if not self.is_bound:  # Stop further processing.停止进一步的处理
                return
            self.cleaned_data = {}

            """
            # If the form is permitted to be empty, and none of the form data has
            # changed from the initial data, short circuit any validation.
            #如果表单允许为空,和原始数据也是空的话,允许不进行任何验证
            """

            if self.empty_permitted and not self.has_changed():
                return

            self._clean_fields()   #字面意思校验字段
            self._clean_form()
            self._post_clean()

        def _clean_fields(self):
            #每个form组件实例化的过程中都会创建一个fields.fields实质上是一个字典.
            #储存着类似{"user":"user规则","pwd":"pwd的规则对象"}
            for name, field in self.fields.items():
                #name是你调用的一个个规则字段,field是调用字段的规则
                #items是有顺序的,因为他要校验字段的一致性
                """
                # value_from_datadict() gets the data from the data dictionaries.
                # Each widget type knows how to retrieve its own data, because some
                # widgets split data over several HTML fields.
                
                value_from_datadict()从数据字典中获取数据.
                每个部件类型知道如何找回自己的数据,因为有些部件拆分数据在几个HTML字段.
                """
                #现在假设第一个字段是user
                if field.disabled:
                    value = self.get_initial_for_field(field, name)
                else:
                    value = field.widget.value_from_datadict(self.data, self.files, self.add_prefix(name))
                try:
                    if isinstance(field, FileField):  #判断是不是文件
                        #你是文件的时候怎么校验
                        initial = self.get_initial_for_field(field, name)
                        value = field.clean(value, initial)
                        #filed是一个对象,field.clean才是真正的规则校验
                    else:
                        #你不是文件的时候怎么校验
                        #实际中也是走的这一部,value是你输入的字段值
                        #如果没有问题,那么原样返回
                        value = field.clean(value)
                        #如果一旦出现问题,那么就会走except中的代码
                    self.cleaned_data[name] = value

                    # 找呀找呀找钩子
                    if hasattr(self, 'clean_%s' % name):  #这里找是否有clean_XX这个名字存在
                        value = getattr(self, 'clean_%s' % name)()  #如果有执行这个函数
                        self.cleaned_data[name] = value  #而在钩子中必须报错的返回值是确定的
                        #如果上面有问题,就又把错误添加到了_error中
                        #上面这三行代码是我们能添加钩子的原因,而且规定了钩子名的格式

                        #如果这个值是正确的话,就会给这个字典添加一个键值对
                        #刚才在full_clean中self.cleaned_data = {}已经初始化了.
                        #{”pws“: 123}
                except ValidationError as e:
                    self.add_error(name, e)
                    #如果出现错误,就会给_error这个字典添加一个键值对
                    #至于add_error这个函数如何添加这个键值对的,我们先不管
                    #键就是name,值就是错误信息e
                    #在full_clean中已经初始化self._errors = ErrorDict()
                    #假设现在user有问题,那么_error就是这样{”user“:e}
    ```

#### 归纳流程
1. 首先is_valid()起手,看seld.errors中是否值,只要有值就是flase
2. 接着分析errors.里面判断_errors是都为空,如果为空返回self.full_clean(),否则返回self._errors
3. 现在就要看full_clean(),是何方神圣了,里面设置_errors和cleaned_data这两个字典,一个存错误字段,一个存储正确字段.
4. 在full_clean最后有一句self._clean_fields(),表示校验字段
5. 在_clean_fields函数中开始循环校验每个字段,真正校验字段的是field.clean(value),怎么校验的不管
6. 在_clean_fields中可以看到,会将字段分别添加到_errors和cleaned_data这两个字典中
7. 结尾部分还设置了钩子,找clean_XX形式的,有就执行.执行错误信息也会添加到_errors中
8. 整个校验过程完成



