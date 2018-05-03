---
title: PHP_yaf框架 (2)
date: 2017-12-18
tags: YAF
toc: true
---

### 目录结构

```bash 
    + public
        |- index.php                //入口文件
        |- .htaccess                //重写规则    
        |+ css
        |+ img
        |+ js
    + conf
        |- application.ini          //配置文件   
    + application
        |+ controllers
            |- Index.php            //默认控制器
        |+ views    
        |   + index                 //控制器
                |- index.phtml      //默认视图
    |+ modules                      //其他模块
    |+ library                      //本地类库
    |+ models                       //model目录
    |+ plugins                      //插件目录
```

<!-- more -->

### Hello World

- 控制器controller

```bash 
    <?php
    class IndexController extends Yaf_Controller_Abstract 
    {
        //默认Action
        public function indexAction() 
        {
            $this->getView()->assign("content", "Hello World");
        }
    }
    ?>
```

- 视图view

```bash
    <html>
        <head>
            <title>Hello World</title>
        </head>
        <body>
            <?php echo $content;?>
        </body>
    </html>
```

### Bootstrap.php引导程序

    全局配置的入口,全局自定义

- 修改入口文件

```bash
    <?php
    define("APPLICATION_PATH",  dirname(__FILE__));
    $app  = new Yaf_Application(APPLICATION_PATH . "/conf/application.ini");
    //$app->run();
    $app->bootstrap()->run();
```

- 重写Bootstrap类

```bash 
    <?php
    class Bootstrap extends Yaf_Bootstrap_Abstract
    {
        //必须在文件中定义一个Bootstrap类, 而这个类也必须继承自Yaf_Bootstrap_Abstract.
        //所有在Bootstrap类中, 以_init开头的方法, 都会被Yaf调用,
        //这些方法, 都接受一个参数:Yaf_Dispatcher $dispatcher
        //调用的次序, 和申明的次序相同

        private $_config;
        private $_request;

        /*session*/
        public function _initSession($dispatcher) 
        {
            Yaf_Session::getInstance()->start();
            //或者 session_id()  || session_start();
        }

        /*基础配置*/
        public function _initBootstrap(Yaf_Dispatcher $dispatcher) 
        {
            //设置默认模块
            $dispatcher->setDefaultModule='default';

            $this->_config = Yaf_Application::app()->getConfig();
            Yaf_Registry::set("config", $this->_config);
            $systemConfig = new Yaf_Config_Ini(APPLICATION_PATH . '/configs/system.ini',APPLICATION_ENV);
            Yaf_Registry::set("systemConfig", $systemConfig);


            //版本信息配置文件加载处理
            $versionConfig = new Yaf_Config_Ini(APPLICATION_PATH . "/configs/version.ini",APPLICATION_ENV);
            Yaf_Registry::set('versionConfig',$versionConfig);

            //设置获取参数的方法
            $this->_request = $dispatcher->getRequest();
            $get = $this->_request->getQuery();
            $post = $this->_request->getPost();
            $params = $post + $get;
            $this->_request->setParam($params);
            //如果传递的参数是xml格式的
            if ($this->_request->isXmlHttpRequest()) {
                //改编码
                $systemConfig = Yaf_Registry::get('systemConfig');
                $charset = $systemConfig->get('system.project.charset');
                if (strtolower($charset) != "utf-8") {
                    $paramsArr = iconv_array('utf-8', $charset."//TRANSLIT", $paramsArr = $this->_request->getParams());
                    $this->_request->setParam($paramsArr);
                }
            }
            Yaf_Registry::set("request", $this->_request);
        }

        //设置本地类
        public function _initLocalName() 
        {
            $loader = Yaf_Loader::getInstance();
            //全局类目录
            $loader->setLibraryPath(APPLICATION_PATH . '/lib',true);
            //申明, 凡是以 Smarty 和 Zend 开头的类, 都是本地类
            $loader->registerLocalNamespace(array(
                    'Smarty','Zend'
            ));
        }

        //设置默认连接的数据
        public function _initDefaultDb(Yaf_Dispatcher $dispatcher)
        {
            $db = Jgb_Bean::getDb(DB_MAIN_CRM);
            Yaf_Registry::set('db',$db);
        }

        //默认加载的插件
        public function _initPlugin(Yaf_Dispatcher $dispatcher) 
        {
            $common = new CommonPlugin();
            $dispatcher->registerPlugin($common);
            //$dispatcher->setErrorHandler(array($this, 'error'));
        }

        /*自定义路由*/
        public function _initRoute(Yaf_Dispatcher $dispatcher) 
        {
            $ModuleexecPlugin = new ModuleexecPlugin();
            $dispatcher->registerPlugin($ModuleexecPlugin);
            return '';
            //echo "_initRoute call second<br/>\n";
            $router = Yaf_Dispatcher::getInstance()->getRouter();
            $request = $dispatcher->getRequest();

            $modules = Yaf_Application::app()->getModules();
            $baseUri = $request->getBaseUri();
            $requestUri = $request->getRequestUri();
            $i = 1;
            $pattern = "|^$baseUri|is";
            $requestUri = preg_replace($pattern, '', $requestUri, $i);
            $requestUri = ltrim($requestUri,DS);
            $urlExplodeArr = array();
            if ($requestUri) {
                $urlExplodeArr = explode(DS, $requestUri);
            }
            $moduleTmp = ucfirst(strtolower($urlExplodeArr[0]));
            if (! in_array($moduleTmp, $modules)) {
                $modules = 'default';
                if (empty($urlExplodeArr[0])) {
                    $controller = 'index';
                    $action = 'index';
                } else {
                    $controller = $urlExplodeArr[0];
                    unset($urlExplodeArr[0]);
                    $action = $urlExplodeArr[1];
                    if (empty($urlExplodeArr[1])) {
                        $action = 'index';
                    } else {
                        unset($urlExplodeArr[1]);
                    }
                }
                //把参数设置到request中
                $this->setParamsRoute($urlExplodeArr);
                $route1 = new Yaf_Route_Rewrite(DS . $requestUri, array("module" => $modules, "controller" => $controller, "action" => $action));
                $router->addRoute('default', $route1);
            } elseif (in_array($moduleTmp, $modules) && (empty($urlExplodeArr[1]) || empty($urlExplodeArr[2]))) {
                $modules = $urlExplodeArr[0];
                unset($urlExplodeArr[0]);
                if (empty($urlExplodeArr[1])) {
                    $controller = 'index';
                    $action = 'index';
                } else {
                    $controller = $urlExplodeArr[1];
                    unset($urlExplodeArr[1]);
                    $action = $urlExplodeArr[2];
                    if (empty($urlExplodeArr[2])) {
                        $action = 'index';
                    } else {
                        unset($urlExplodeArr[2]);
                    }
                }
                $this->setParamsRoute($urlExplodeArr);
                $route1 = new Yaf_Route_Rewrite(DS . $requestUri, array("module" => $modules, "controller" => $controller, "action" => $action));
                $router->addRoute('default', $route1);
            }
        }

        /*自定义模板引擎*/
        public function _initView(Yaf_Dispatcher $dispatcher) 
        {
                $dispatcher->disableView();
        }
       
        public function setParamsRoute($paramArr)
        {
            $request = Yaf_Dispatcher::getInstance()->getRequest();
            $oldArr = $request->getParams();
            $paramsStr = implode(DS,$paramArr);
            $newParams = explode("?",$paramsStr);
            $pattern = "#([^/]+(?:/[^/]+)?)#is";
            if(preg_match_all($pattern, $newParams[0], $matches)){
                if(is_array($matches[1])){
                    foreach($matches[1] as $val){
                        $arr = explode(DS, $val);
                        $oldArr[$arr[0]] = $arr[1];
                    }
                    $request->setParam($oldArr);
                }
            }
        }
    }
```

### 插件 钩子(Hook)

- Yaf支持的Hook

| 触发顺序 | 名称 | 触发时机 | 说明 | 
|:-----|:-----|:-----|:-----|
| 1 | routerStartup | 在路由之前触发 | 这个是7个事件中, 最早的一个. 但是一些全局自定的工作, 还是应该放在Bootstrap中去完成 |
| 2 | routerShutdown | 路由结束之后触发 | 此时路由一定正确完成, 否则这个事件不会触发 |
| 3 | dispatchLoopStartup | 分发循环开始之前被触发 | | 
| 4 | preDispatch | 分发之前触发 | 如果在一个请求处理过程中, 发生了forward, 则这个事件会被触发多次 |
| 5 | postDispatch | 分发结束之后触发 | 此时动作已经执行结束, 视图也已经渲染完成. 和preDispatch类似, 此事件也可能触发多次 |
| 6 | dispatchLoopShutdown | 分发循环结束之后触发 | 此时表示所有的业务逻辑都已经运行完成, 但是响应还没有发送 |

- 自定义插件

```bash 
    <?php
    class UserPlugin extends Yaf_Plugin_Abstract 
    {
        //插件类是用户编写的, 但是它需要继承自Yaf_Plugin_Abstract. 
        //对于自定义插件来说, 上边提到的6个Hook(钩子), 不需要全部都重写,
        //用到哪个就写哪个，和上边钩子事件同名方法即可, 那么这个方法就会在该事件触发的时候被调用.
        //而插件方法, 可以接受俩个参数, Yaf_Request_Abstract实例和Yaf_Response_Abstract实例.
        
        //这里, 插件UserPlugin只关心俩个事件. 所以就定义了俩个方法.
        public function routerStartup(Yaf_Request_Abstract $request, Yaf_Response_Abstract $response) 
        {
        
        }

        public function routerShutdown(Yaf_Request_Abstract $request, Yaf_Response_Abstract $response) 
        {

        }
    }
```

- 注册插件

```bash
    <?php
    class Bootstrap extends Yaf_Bootstrap_Abstract
    {
        //插件要生效, 还需要向Yaf_Dispatcher注册, 那么一般的插件的注册都会放在Bootstra中进行. 
        //这里是注册UserPlugin插件的例子
        public function _initPlugin(Yaf_Dispatcher $dispatcher)
        {
            $user = new UserPlugin();
            $dispatcher->registerPlugin($user);
        }
    }
```

- 插件目录

    一般的, 插件应该放置在APPLICATION_PATH下的plugins目录, 这样在自动加载的时候, 加载器通过类名, 发现这是个插件类, 就会在这个目录下查找. 当然, 插件也可以放在任何你想防止的地方, 只要你能把这个类加载进来就可以