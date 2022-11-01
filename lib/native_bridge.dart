import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_helper.dart';
import 'package:native_bridge/native_bridge_impl.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: iLotJsBridge
///  Created by Fitem on 2022/7/13
class NativeBridge implements JavascriptChannel {
  NativeBridge({required this.controller});

  final NativeBridgeImpl controller;

  @override
  String get name => controller.name;

  @override
  JavascriptMessageHandler get onMessageReceived => (message) async {
        // 处理H5回调的值
        NativeBridgeHelper.receiveMessage(message.message);
        // 处理H5的请求
        var item = messageFromJson(message.message);
        var callMethod = controller.callMethodMap[item.api];
        // 有相应的JS方法，则处理
        if (callMethod != null) {
          item.data = await callMethod(item.data);
          // 回调js，H5接受消息
          var json = messageToJson(item);
          controller.runJavascript("receiveMessage($json)");
        }
      };
}
