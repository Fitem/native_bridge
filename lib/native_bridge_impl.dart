import 'package:webview_flutter/webview_flutter.dart';

import 'native_bridge.dart';

///  Name: Native Bridge实现类
///  Created by Fitem on 2022/10/31
mixin NativeBridgeImpl {
  /// javascript channel name
  get name;

  /// call method map
  Map<String, Function?> get callMethodMap;

  /// 执行JS
  void runJavascript(String javaScriptString);

  /// 执行JS并返回结果
  Future<Object> runJavaScriptReturningResult(String javaScriptString);

  /// 发送JS消息
  Future sendMessage(Message message);

  /// 接收JS消息
  void onMessageReceived(JavaScriptMessage message);
}
