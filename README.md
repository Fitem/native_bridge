# NativeBridge

基于 webview_flutter 插件实现 App端 和 H5端 的 JS 互调能力的插件 NativeBridge

### NativeBridge 插件的优点

1. 支持 H5 端调用 App 端的 JSBridge 方法，并可以直接获取返回值。
2. 支持 App 端调用 H5 端的  JSBridge 方法，并可以直接获取返回值。
3. 使用简单，集成插件后实现 NativeBridgeImpl 类，即可完成 App 端的 JS 调用能力的支持。

### NativeBridge 的引入

NativeBridge 插件目前支持2种引入方式：1）本地代码引入 2）Git 依赖

1. 本地代码引入。由于插件本身只引入了 webview_flutter 插件，所以可以直接拷贝相关代码到自己的项目即可。

2. Git 依赖。目前由于插件还没有发布到 pub ，大家可以先通过 Git 依赖的方式引入。

~~~
dependencies：
  native_bridge:
    git:
      url: https://github.com/Fitem/native_bridge.git
~~~

### 详细说明

掘金：[NativeBridge：基于webivew_flutter的JSBridge插件](https://juejin.cn/post/7170557198701953038/)