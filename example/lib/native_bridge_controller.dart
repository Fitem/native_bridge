import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge/native_bridge_impl.dart';
import 'package:native_bridge_example/utils/app_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: NativeBridge控制器
///  Created by Fitem on 2022/11/1
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
        // 版本名称
        "getVersionName": (data) async {
          return await AppUtil.getVersion();
        },
        //是否是App
        "isApp": (data) {
          return true;
        },
        //测试获取Web的值
        "getWebValue": (data) async {
          var isHome = await NativeBridgeHelper.sendMessage(
              Message(api: "isHome"), this)
              .future ??
              false;
          AppUtil.show("isHome:$isHome");
          return isHome;
        }
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
