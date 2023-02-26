import 'dart:async';

import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge/native_bridge_impl.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: NativeBridgeController管理器，实现Bridge功能需要继承
///  Created by Fitem on 2023/2/1
abstract class NativeBridgeController with NativeBridgeImpl {
  // 构造方法添加 WebViewController
  NativeBridgeController(this.controller) {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        name,
        onMessageReceived: onMessageReceived,
      );
  }

  // WebView控制器
  final WebViewController controller;

  @override
  void runJavascript(String javaScriptString) {
    controller.runJavaScript(javaScriptString);
  }

  @override
  Future<Object> runJavaScriptReturningResult(String javaScriptString) async {
    return await controller.runJavaScriptReturningResult(javaScriptString);
  }

  @override
  Future sendMessage(Message message) {
    return NativeBridgeHelper.sendMessage(message, this).future;
  }

  @override
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
