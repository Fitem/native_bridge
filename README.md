# NativeBridge

[![Pub](https://img.shields.io/pub/v/native_bridge.svg)](https://pub.dev/packages/native_bridge)

[NativeBridge](https://pub.dev/packages/native_bridge) is a plugin based on [webview_flutter](https://pub.dev/packages/webview_flutter) that realizes JS intermodulation capability between App and H5.

Language: English | [简体中文](README-ZH.md)

### Advantages of NativeBridge

1. Support the H5 to call the JSBridge method on the App, and can directly get the return value.
2. Support App call H5 JSBridge method, and can directly get the return value.
3. It is simple to use and extend the NativeBridgeController class after integration to support the JavaScript calling ability of App.

### NativeBridge dependency

Add dependencies in pubspec.yaml:

~~~yaml
dependencies：
  native_bridge: ^latest_version
~~~

### Use of NativeBridge

1. extend `NativeBridgeController`

~~~dart
class AppBridgeController extends NativeBridgeController {
  AppBridgeController(WebViewController controller) : super(controller);

  /// Define the JSChannel name
  @override
  get name => "nativeBridge";

  @override
  Map<String, Function?> get callMethodMap => <String, Function?>{
        // Version number
        "getVersionCode": (data) async {
          return await AppUtil.getVersion();
        },
        ...
      };
}
~~~

2. Init AppBridgeController.

~~~dart
// Init WebViewController
_controller = WebViewController()
  ..enableZoom(true)
  ..loadFlutterAsset('assets/test/index.html');
// Init AppBridgeController
_appBridgeController = AppBridgeController(_controller);
~~~

3. Add the `receiveMessage` method to **H5**.
~~~javascript
function receiveMessage(jsonStr) {
    if(jsonStr != undefined && jsonStr != "") {
        let data = JSON.parse(JSON.stringify(jsonStr));
        window.jsBridgeHelper.receiveMessage(data);
    }
}
~~~

#### 一、H5 get the value of the App

1. Define method names and Function calls in the App's callMethodMap, for example, to get the App version number:

```dart
// 版本号
"getVersionCode": (data) async {
    return await AppUtil.getVersion();
}
```

2. Call the corresponding method in H5:

```javascript
async function getVersionName() {
    // 获取 App 的值
    let appVersionName = await window.jsBridgeHelper.sendMessage("getVersionName", null);
}
```
#### 二、App gets the value of H5

There are two ways for the App to get the value of H5:

1. AppBridgeController's `sendMessage` method.

   ~~~dart
   // is home page
   bool? isHome = await _appBridgeController.sendMessage(Message(api: 'isHome'));
   ~~~

2. Call AppBridgeController ` runJavaScriptReturningResult ` method.

   ~~~dart
   // get UserAgent
   var userAgent = await _appBridgeController.runJavaScriptReturningResult('getUserAgent()');
   ~~~

The difference is the first sends a message to H5 the WebViewController's `runJavaScript`  and waits for H5 to reply to the message. The last user WebViewController ` runJavaScriptReturningResult ` method directly to obtain the return value.

The first is more applicable and supports a variety of business scenarios, the last is more suitable for obtaining Window-related properties.

### Related article


> Series 1：[NativeBridge：基于webivew_flutter的JSBridge插件](https://juejin.cn/post/7170557198701953038)  
> Series 2：[NativeBridge：实现原理解析](https://juejin.cn/post/7172840863234523173)  
> Series 3：[App实现JSBridge的最佳方案](https://juejin.cn/post/7177407635317063735)   
> Series 4：[NativeBridge：我在Pub上发布的第一个插件](https://juejin.cn/post/7204349756620210236)