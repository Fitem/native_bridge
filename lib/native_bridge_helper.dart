import 'dart:async';

import 'dart:convert';

import 'package:native_bridge/bean/message.dart';
import 'package:native_bridge/native_bridge_impl.dart';


///  Name: 原生桥帮助类
///  Created by Fitem on 2022/7/20
class NativeBridgeHelper {
  static Map<String, Completer?> callbacks = <String, Completer>{};
  static int callbackId = 1;

  /// 发送消息
  static Completer sendMessage(Message message, NativeBridgeImpl nativeBridgeImpl) {
    Completer completer = Completer();
    var callbackId = _pushCallback(message.api, completer);
    message.callbackId = callbackId;
    // H5接受消息
    final res = messageToJson(message);
    nativeBridgeImpl.runJavascript("receiveMessage($res)");
    // 增加回调异常容错机制，避免消息丢失导致一直阻塞
    Future.delayed(const Duration(milliseconds: 200), (){
      var completer = _popCallback(callbackId);
      completer?.complete(Future.value(null));
    });
    return completer;
  }

  /// 接收消息
  static void receiveMessage(String json) {
    var map = jsonDecode(json);
    var callbackId = map["callbackId"];
    var data = map["data"];
    var completer = _popCallback(callbackId);
    completer?.complete(Future.value(data));
  }

  /// 记录一个函数并返回其对应的记录id
  static String _pushCallback(String api, Completer completer) {
    int id = callbackId++;
    String key = "${api}_$id";
    callbacks[key] = completer;
    return key;
  }

  /// 删除id对应的函数
  static Completer? _popCallback(String id) {
    var completer = callbacks[id];

    if (completer != null) {
      callbacks.remove(id);
      return completer;
    }
    return null;
  }
}
