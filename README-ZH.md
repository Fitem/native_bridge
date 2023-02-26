# NativeBridge

[![Pub](https://img.shields.io/pub/v/native_bridge.svg)](https://pub.dev/packages/native_bridge)

基于 [webview_flutter](https://pub.dev/packages/webview_flutter) 插件实现 **App端** 和 **H5端** 的 JS 互调能力的插件 [NativeBridge](https://pub.dev/packages/native_bridge) 。

Language: [English](README.md) | 简体中文

### NativeBridge 插件的优点

1. 支持 H5端 调用 App端 的 JSBridge 方法，并可以直接获取返回值。
2. 支持 App端 调用 H5端 的  JSBridge 方法，并可以直接获取返回值。
3. 使用简单，集成插件后继承 NativeBridgeController 类，即可完成 App端的 JavaScript 调用能力的支持。

### NativeBridge 的引入

在 pubspec.yaml 中添加依赖：

~~~yaml
dependencies：
  native_bridge: ^latest_version
~~~

### NativeBridge 的使用

1. 继承 `NativeBridgeController`

~~~dart
class AppBridgeController extends NativeBridgeController {
  AppBridgeController(WebViewController controller) : super(controller);

  /// 指定JSChannel名称
  @override
  get name => "nativeBridge";

  @override
  Map<String, Function?> get callMethodMap => <String, Function?>{
        // 版本号
        "getVersionCode": (data) async {
          return await AppUtil.getVersion();
        },
        ...
      };
}
~~~

2. 初始化 AppBridgeController

~~~dart
// 初始化WebViewController
_controller = WebViewController()
  ..enableZoom(true)
  ..loadFlutterAsset('assets/test/index.html');
// 初始化AppBridgeController
_appBridgeController = AppBridgeController(_controller);
~~~

3. 在 **H5端** 添加 `receiveMessage` 方法。
~~~javascript
function receiveMessage(jsonStr) {
    if(jsonStr != undefined && jsonStr != "") {
        let data = JSON.parse(JSON.stringify(jsonStr));
        window.jsBridgeHelper.receiveMessage(data);
    }
}
~~~

#### 一、H5端 获取 App端 的值

1. 在 App端 的 callMethodMap 中 **定义方法名称** 和 **Function调用**，比如获取 App 的版本号：

```dart
// 版本号
"getVersionCode": (data) async {
    return await AppUtil.getVersion();
}
```

2. 在 H5端 中调用对应方法：

```javascript
async function getVersionName() {
    // 获取 App 的值
    let appVersionName = await window.jsBridgeHelper.sendMessage("getVersionName", null);
}
```
#### 二、App端 获取 H5端 的值

App端获取 H5端的值有两种方法：

1. 通过 AppBridgeController 的 `sendMessage` 方法

   ~~~dart
   // 是否是首页
   bool? isHome = await _appBridgeController.sendMessage(Message(api: 'isHome'));
   ~~~

2. 调用 AppBridgeController 的 `runJavaScriptReturningResult` 方法

   ~~~dart
   // 获取UserAgent
   var userAgent = await _appBridgeController.runJavaScriptReturningResult('getUserAgent()');
   ~~~

两者的区别是，前者通过 WebViewController的 `runJavaScript` 给 H5端 发送消息并等待 H5端 回复消息，后者直接调用 WebViewController 的 `runJavaScriptReturningResult` 方法直接获取返回值。

前者的适用性更好、支持各种业务场景，后者更适合于获取 window 相关属性。

### 系列文章

使用介绍：[NativeBridge：基于webivew_flutter的JSBridge插件](https://juejin.cn/post/7170557198701953038/)

原理解析：[NativeBridge：实现原理解析](https://juejin.cn/post/7172840863234523173)

方案总结：[App实现JSBridge的最佳方案](https://juejin.cn/post/7177407635317063735)