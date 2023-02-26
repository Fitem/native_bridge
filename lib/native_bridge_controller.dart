import 'package:native_bridge/native_bridge_impl.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: NativeBridgeController管理器，实现Bridge功能需要继承
///  Created by Fitem on 2023/2/1
abstract class NativeBridgeController with NativeBridgeImpl {
  NativeBridgeController();

  // WebView控制器
  WebViewController? controller;

  @override
  void runJavascript(String javaScriptString) {
    controller?.runJavaScript('receiveMessage($javaScriptString)');
  }
}
