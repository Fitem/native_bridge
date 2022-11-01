import 'package:native_bridge/native_bridge_impl.dart';
import 'package:native_bridge_example/utils/app_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: NativeBridge控制器
///  Created by Fitem on 2022/11/1
class NativeBridgeController implements NativeBridgeImpl {
  NativeBridgeController({required this.controller});

  final Future<WebViewController> controller;

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
  return true.toString();
  }};

  @override
  String get name => "nativeBridge";

  @override
  void runJavascript(String javaScriptString) {
    controller.then((controller) =>
        controller.runJavascript("receiveMessage($javaScriptString)"));
  }

}