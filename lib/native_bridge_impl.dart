import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: Native Bridge实现类
///  Created by Fitem on 2022/10/31
mixin NativeBridgeImpl {
  /// javascript channel name
  get name;

  /// call method map
  Map<String, Function?> get callMethodMap;

  /// 执行JS
  void runJavascript(String javaScriptString);

  /// 接收JS消息
  Future<void> onMessageReceived(JavaScriptMessage message) async {
    String? messageJson = message.message;
    Message messageItem = messageFromJson(messageJson);
    bool isResponseFlag = messageItem.isResponseFlag ?? false;
    if (isResponseFlag) {
      // 是返回的请求消息，则处理H5回调的值
      NativeBridgeHelper.receiveMessage(messageJson);
    } else {
      // 不是返回的请求消息，处理H5端的请求
      var callMethod = callMethodMap[messageItem.api];
      if (callMethod != null) {
        // 有相应的JS方法，则处理
        var data = await callMethod(messageItem.data);
        messageItem.data = data.toString();
      } else {
        // 若没有对应方法，则返回null，避免低版本未支持Api阻塞H5
        messageItem.data = null;
      }
      // 回调js，类型为回复消息
      messageItem.isResponseFlag = true;
      var json = messageToJson(messageItem);
      runJavascript("receiveMessage($json)");
    }
  }
}
