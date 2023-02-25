# NativeBridge

[![Pub](https://img.shields.io/pub/v/native_bridge.svg)](https://pub.dev/packages/native_bridge)

基于 [webview_flutter](https://pub.dev/packages/webview_flutter) 插件实现 **App端** 和 **H5端** 的 JS 互调能力的插件 [NativeBridge](https://pub.dev/packages/native_bridge) 。

### NativeBridge 插件的优点

1. 支持 H5 端调用 App 端的 JSBridge 方法，并可以直接获取返回值。
2. 支持 App 端调用 H5 端的  JSBridge 方法，并可以直接获取返回值。
3. 使用简单，集成插件后实现 NativeBridgeImpl 类，即可完成 App 端的 JS 调用能力的支持。

### NativeBridge 的引入

在 pubspec.yaml 中添加依赖：

~~~yaml
dependencies：
  native_bridge: ^latest_version
~~~

### NativeBridge 的集成

1. 实现 NativeBridgeImpl 类

~~~dart
class NativeBridgeController implements NativeBridgeImpl {
  NativeBridgeController({required this.controller});

  // WebView控制器
  final Future<WebViewController> controller;

  /// 对应JS调用Function集合
  @override
  Map<String, Function?> get callMethodMap => {
        // 版本号
        "getVersionCode": (data) async {
          return await AppUtil.getVersion();
        },
        ...
    // 添加更多调用方法
      };

  /// 指定JSChannel名称
  @override
  String get name => "nativeBridge";

  /// 执行JS
  @override
  void runJavascript(String javaScriptString) {
    controller.then((controller) =>
        controller.runJavascript("receiveMessage($javaScriptString)"));
  }
}
~~~

2. 在 WebView 组件中添加 **NativeBridge**。

~~~dart
//JS执行模式 是否允许JS执行
javascriptMode: JavascriptMode.unrestricted,
javascriptChannels: <JavascriptChannel>{
    NativeBridge(
        controller: _nativeBridgeController =
             NativeBridgeController(controller: _controller.future),
    )
}
~~~

3. 在 H5 端添加 `receiveMessage` 方法。
~~~javascript
function receiveMessage(jsonStr) {
    if(jsonStr != undefined && jsonStr != "") {
        let data = JSON.parse(JSON.stringify(jsonStr));
        window.jsBridgeHelper.receiveMessage(data);
    }
}
~~~

### NativeBridge 的使用

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
    // 显示
    document.getElementById("app_version_name").innerHTML = "app version name : " + appVersionName.toString();
}
```

### 系列文章

使用介绍：[NativeBridge：基于webivew_flutter的JSBridge插件](https://juejin.cn/post/7170557198701953038/)

原理解析：[NativeBridge：实现原理解析](https://juejin.cn/post/7172840863234523173)

方案总结：[App实现JSBridge的最佳方案](https://juejin.cn/post/7177407635317063735)